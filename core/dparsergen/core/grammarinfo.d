
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.grammarinfo;

/**
Type used for IDs of nonterminals and tokens. The IDs can overlap. Use
[Symbol] for also distinguishing between nonterminals and tokens.
*/
alias SymbolID = ushort;

/**
Type used for IDs of productions.
*/
alias ProductionID = ushort;

/**
ID for nonterminal or token.
*/
struct Symbol
{
    /**
    Is this a token. It is a nonterminal otherwise. Use [NonterminalID]
    or [TokenID] if the type is known at compile time.
    */
    bool isToken;

    /**
    ID of the nonterminal or token as integer. Can be SymbolID.max if invalid.
    */
    SymbolID id = SymbolID.max;

    /**
    Convert to [NonterminalID] if it is a nonterminal.
    */
    NonterminalID toNonterminalID() const
    in (!isToken)
    {
        return NonterminalID(id);
    }

    /**
    Convert to [TokenID] if it is a token.
    */
    TokenID toTokenID() const
    in (isToken)
    {
        return TokenID(id);
    }

    /**
    Constant for invalid symbol.
    */
    enum invalid = Symbol(false, SymbolID.max);

    /**
    Compare symbols.
    */
    int opCmp(Symbol other) const pure nothrow
    {
        if (isToken < other.isToken)
            return -1;
        if (isToken > other.isToken)
            return 1;
        if (id < other.id)
            return -1;
        if (id > other.id)
            return 1;
        return 0;
    }
}

/**
ID for nonterminal.
*/
struct NonterminalID
{
    enum isToken = false;

    /**
    ID of the nonterminal as integer. Can be SymbolID.max if invalid.
    */
    SymbolID id = SymbolID.max;

    /**
    Convert to [Symbol].
    */
    Symbol toSymbol() const pure nothrow
    {
        return Symbol(isToken, id);
    }

    alias toSymbol this;

    /**
    Constant for invalid symbol.
    */
    enum invalid = NonterminalID(SymbolID.max);

    /**
    Compare nonterminal IDs.
    */
    int opCmp(NonterminalID other) const pure nothrow
    {
        if (id < other.id)
            return -1;
        if (id > other.id)
            return 1;
        return 0;
    }
}

/**
ID for token.
*/
struct TokenID
{
    enum isToken = true;

    /**
    ID of the token as integer. Can be SymbolID.max if invalid.
    */
    SymbolID id = SymbolID.max;

    /**
    Convert to [Symbol].
    */
    Symbol toSymbol() const pure nothrow
    {
        return Symbol(isToken, id);
    }

    alias toSymbol this;

    /**
    Constant for invalid symbol.
    */
    enum invalid = TokenID(SymbolID.max);

    /**
    Compare token IDs.
    */
    int opCmp(TokenID other) const pure nothrow
    {
        if (id < other.id)
            return -1;
        if (id > other.id)
            return 1;
        return 0;
    }
}

/**
Flags with information about nonterminals.
*/
enum NonterminalFlags
{
    /// No flags.
    none = 0,

    /// The nonterminal can be empty.
    empty = 0x01,
    /// This is a normal nonterminal and not a string or array.
    nonterminal = 0x02,
    /// This nonterminal should be stored as string.
    string = 0x04,
    /// This nonterminal can be a normal nonterminal or a string.
    anySingle = nonterminal | string,

    /// This nonterminal is an array.
    array = 0x10,
    /// The array can contain normal nonterminals.
    arrayOfNonterminal = 0x20,
    /// The array can contain strings.
    arrayOfString = 0x40,
    /// The array can contain normal nonterminals and strings.
    anyArray = array | arrayOfNonterminal | arrayOfString
}

/**
Metadata about a token.
*/
struct Token
{
    /**
    Name of the token.
    */
    string name;

    /**
    Annotations for the token from the grammar file.
    */
    string[] annotations;
}

/**
Metadata about a nonterminal.
*/
struct Nonterminal
{
    /**
    Name of the nonterminal
    */
    string name;

    /**
    Flags with informations about the nonterminal.
    */
    NonterminalFlags flags;

    /**
    Annotations for the nonterminal from the grammar file.
    */
    string[] annotations;

    /**
    Nonterminals reachable through unwrap productions, which can be created.
    */
    immutable(SymbolID)[] buildNonterminals;

    /**
    ID of first production for this nonterminal.
    */
    ProductionID firstProduction;

    /**
    Number of productions for this nonterminal.
    */
    ProductionID numProductions;
}

/**
Metadata about a symbol inside a production.
*/
struct SymbolInstance
{
    /**
    ID of the symbol.
    */
    Symbol symbol;
    alias symbol this;

    /**
    Expected content for tokens with only one allowed value.
    */
    string subToken;

    /**
    Optional name for this symbol inside the production.
    */
    string symbolInstanceName;

    /**
    The production should be replaced with this symbol in the parse tree.
    */
    bool unwrapProduction;

    /**
    This symbol should not be represented as a node in the parse tree.
    */
    bool dropNode;

    /**
    Annotations for the symbol from the grammar file.
    */
    string[] annotations;

    /**
    Negative lookahead for this symbol.
    */
    immutable(Symbol)[] negLookaheads;
}

/**
Metadata about production.
*/
struct Production
{
    /**
    Nonterminal production by this production.
    */
    NonterminalID nonterminalID = NonterminalID(SymbolID.max);

    /**
    List of symbols needed for this production.
    */
    immutable(SymbolInstance)[] symbols;

    /**
    Annotations for the production from the grammar file.
    */
    string[] annotations;

    /**
    Negative lookahead at the end of this production.
    */
    Symbol[] negLookaheads;

    /**
    Only end of file allowed after this production.
    */
    bool negLookaheadsAnytoken;

    /**
    The production was automatically generated.
    */
    bool isVirtual;
}

/**
Information about the grammar for use at runtime.
*/
struct GrammarInfo
{
    /**
    Offset for IDs of all tokens in allTokens.
    */
    SymbolID startTokenID;

    /**
    Offset for IDs of all nonterminals in allNonterminals.
    */
    SymbolID startNonterminalID;

    /**
    Offset for IDs of all productions in allProductions.
    */
    ProductionID startProductionID;

    /**
    Information about all tokens from the grammar.
    */
    Token[] allTokens;

    /**
    Information about all nonterminals from the grammar.
    */
    Nonterminal[] allNonterminals;

    /**
    Information about all productions from the grammar.
    */
    Production[] allProductions;
}
