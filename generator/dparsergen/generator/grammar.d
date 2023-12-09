
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.grammar;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
import dparsergen.generator.ebnf;
import dparsergen.generator.grammarebnf;
import dparsergen.generator.ids;
import dparsergen.generator.nfa;
import dparsergen.generator.production;
import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.stdio;
import std.string;
import std.typecons;

class SymbolInfo
{
    string name;
    const(Declaration)[] declarations;

    bool isToken;
    bool isIgnoreToken;

    bool reachableFromStart;
    bool reachableFromToken;
    bool reachableFromStartNoToken;
}

struct StartNonterminal
{
    NonterminalID nonterminal;
    bool needsEmptyProduction;
}

string escapeName(string s)
{
    if (s.endsWith("?"))
    {
        return escapeName(s[0 .. $ - 1]) ~ "?";
    }
    if (s.startsWith("\"") && s.endsWith("\""))
        return s;

    string r;
    foreach (char c; s)
    {
        if (c.inCharSet!"a-zA-Z0-9")
            r ~= c;
        else
            r ~= format("_%02X", c);
    }
    return r;
}

bool tagsSorted(immutable(TagUsage)[] tags)
{
    foreach (i, t; tags)
    {
        if (i)
            if (t.tag <= tags[i - 1].tag)
                return false;
    }
    return true;
}

struct Constraint
{
    immutable(Symbol)[] negLookaheads;
    immutable(TagUsage)[] tags;
    bool disabled;
}

struct NonterminalWithConstraint
{
    NonterminalID nonterminalID;
    Constraint constraint;
    bool hasLookaheadAnnotation;
}

struct SymbolWithConstraint
{
    Symbol symbol;
    Constraint constraint;
    enum invalid = SymbolWithConstraint(Symbol.invalid, Constraint.init);
}

class EBNFGrammar
{
    const SymbolInfo[string] symbolInfos;
    bool isLexerGrammar;

    IDMap!(TokenID, Token) tokens;
    IDMap!(NonterminalID, Nonterminal) nonterminals;
    IDMap!(TagID, Tag) tags;
    const(Production*)[] productionsData;
    immutable(TokenID)[] inContextOnlyTokens;

    StartNonterminal[] startNonterminals;
    TokenID[2][] matchingTokens;

    bool allowTokenNonterminals;

    EBNFGrammar origGrammar_;

    bool[Symbol] symbolsInMultiplePaths;

    size_t startTokenID;
    size_t startNonterminalID;
    size_t startProductionID;

    this(const SymbolInfo[string] symbolInfos, EBNFGrammar origGrammar_ = null)
    {
        this.symbolInfos = symbolInfos;
        this.origGrammar_ = origGrammar_;
    }

    string getSymbolName(const Symbol s) const
    {
        if (s.isToken)
        {
            if (s.id >= tokens.vals.length)
                return "??????";
            return tokens[s.toTokenID].name;
        }
        else
        {
            if (s.id >= nonterminals.vals.length)
                return "??????";
            return nonterminals[s.toNonterminalID].name;
        }
    }

    bool isValid(const Symbol s) const
    {
        if (s.isToken)
            return s.id < tokens.vals.length;
        else
            return s.id < nonterminals.vals.length;
    }

    EBNFGrammar origGrammar()
    {
        if (origGrammar_ is null)
            return this;
        else
            return origGrammar_.origGrammar();
    }

    string symbolInstanceToString(const SymbolInstance s, bool includeAll = true, bool escape = false) const
    {
        Appender!string app;
        symbolInstanceToString(app, s, includeAll, escape);
        return app.data;
    }

    string symbolInstanceToString(const SymbolInstance[] symbols,
            bool includeAll = true, bool escape = false) const
    {
        Appender!string app;
        foreach (i, s; symbols)
        {
            if (i)
                app.put(" ");
            symbolInstanceToString(app, s, includeAll, escape);
        }
        return app.data;
    }

    void symbolInstanceToString(ref Appender!string app, const SymbolInstance s,
            bool includeAll = true, bool escape = false) const
    {
        if (includeAll)
            s.annotations.toStringCode(app, true);
        foreach (l; s.negLookaheads)
        {
            app.put("!");
            app.put(getSymbolName(l));
            app.put(" ");
        }
        if (includeAll)
        {
            if (s.unwrapProduction)
                app.put("<");
            if (s.dropNode)
                app.put("^");
            if (s.symbolInstanceName.length)
            {
                app.put(s.symbolInstanceName);
                app.put(":");
            }
        }
        if (escape && !s.isToken)
            app.put(getSymbolName(s).escapeName);
        else
            app.put(getSymbolName(s));
        if (s.subToken.length)
        {
            app.put(">>");
            app.put(s.subToken);
        }
    }

    string productionStringRhs(const Production* p) const
    {
        Appender!string app;
        foreach (s; p.symbols)
        {
            app.put(" ");
            symbolInstanceToString(app, s);
        }
        foreach (l; p.negLookaheads)
        {
            app.put(" !");
            app.put(getSymbolName(l));
        }
        if (p.negLookaheadsAnytoken)
            app.put(" !anytoken");
        p.annotations.toStringCode(app);
        return app.data;
    }

    string productionString(const Production* p) const
    {
        Appender!string app;
        app.put(nonterminals[p.nonterminalID].name);
        nonterminals[p.nonterminalID].annotations.toStringCode(app);
        app.put(" =");
        app.put(productionStringRhs(p));
        if (p.isVirtual)
            app.put(" [virtual]");
        return app.data;
    }

    override string toString() const
    {
        Appender!string app;
        app.put("EBNFGrammar\n");
        foreach (p; productions)
        {
            app.put("   ");
            app.put(productionString(p));
            app.put("\n");
        }
        return app.data;
    }

    auto productions() const
    {
        return productionsData.filter!(p => p !is null);
    }

    void addProduction(Production* p)
    {
        enforce(productionsData.length < ProductionID.max);
        p.productionID = cast(ProductionID) productionsData.length;
        productionsData ~= p;
    }

    private const(Production*)[][] productionsForNonterminal;
    void fillProductionsForNonterminal()
    {
        assert(productionsForNonterminal.length == 0);
        productionsForNonterminal.length = nonterminals.vals.length;
        foreach (p; productions)
        {
            productionsForNonterminal[p.nonterminalID.id] ~= p;
        }
    }

    const(Production*)[] getProductions(const NonterminalID symbol) const
    in
    {
        assert(!symbol.isToken);
    }
    do
    {
        assert(productionsForNonterminal.length == nonterminals.vals.length);
        return productionsForNonterminal[symbol.id];
    }

    private BitSet!NonterminalID nonterminalCanBeEmpty;
    private BitSet!NonterminalID nonterminalCanBeNonEmpty;

    bool canBeEmpty(const Symbol symbol) const
    {
        if (symbol.isToken)
            return false;
        return nonterminalCanBeEmpty[symbol.toNonterminalID];
    }

    bool canBeNonEmpty(const Symbol symbol) const
    {
        if (symbol.isToken)
            return true;
        return nonterminalCanBeNonEmpty[symbol.toNonterminalID];
    }

    void calcNonterminalCanBeEmpty()
    {
        calcNonterminalCanBeEmpty(nonterminalCanBeEmpty, nonterminalCanBeNonEmpty, false);
    }

    void calcNonterminalCanBeEmpty(ref BitSet!NonterminalID nonterminalCanBeEmpty,
            ref BitSet!NonterminalID nonterminalCanBeNonEmpty, bool checkNoOptEmpty) const
    {
        bool changed;
        nonterminalCanBeEmpty.length = nonterminals.vals.length;
        nonterminalCanBeNonEmpty.length = nonterminals.vals.length;
        do
        {
            changed = false;
            foreach (p; productions)
            {
                if (nonterminalCanBeEmpty[p.nonterminalID] == true)
                    continue;
                if (nonterminals[p.nonterminalID].annotations.contains!"noOptEmpty")
                    continue;

                bool allSymbolsCanBeEmpty = true;
                foreach (s; p.symbols)
                    if (s.isToken || !nonterminalCanBeEmpty[s.toNonterminalID])
                        allSymbolsCanBeEmpty = false;

                if (allSymbolsCanBeEmpty)
                {
                    nonterminalCanBeEmpty[p.nonterminalID] = true;
                    changed = true;
                }
            }
        }
        while (changed);
        do
        {
            changed = false;
            foreach (p; productions)
            {
                if (nonterminalCanBeNonEmpty[p.nonterminalID] == true)
                    continue;

                bool anySymbolCanBeNonEmpty = false;
                foreach (s; p.symbols)
                    if (s.isToken || nonterminalCanBeNonEmpty[s.toNonterminalID])
                        anySymbolCanBeNonEmpty = true;

                if (anySymbolCanBeNonEmpty
                        || nonterminals[p.nonterminalID].annotations.contains!"noOptEmpty")
                {
                    nonterminalCanBeNonEmpty[p.nonterminalID] = true;
                    changed = true;
                }
            }
        }
        while (changed);
    }

    struct FirstSetsKey
    {
        NonterminalID nonterminalID;
        immutable(Symbol)[] negLookaheads;
        immutable(TagUsage)[] tags;
    }
    struct FirstSetsValue
    {
        BitSet!TokenID tokens;
        ubyte state;
    }

    FirstSetsValue[FirstSetsKey] firstSetsCache;
    BitSet!TokenID firstSetImpl(const(Symbol) x,
            immutable(Symbol)[] negLookaheads, immutable(TagUsage)[] tags)
    {
        if (x.isToken)
        {
            BitSet!TokenID result;
            result.length = tokens.vals.length;
            if (!negLookaheads.canFind(x))
            {
                result[x.toTokenID] = true;
            }
            return result;
        }

        auto entry = FirstSetsKey(x.toNonterminalID, negLookaheads, tags) in firstSetsCache;
        if (entry && (entry.state == 0 || entry.state > 1))
            return entry.tokens;

        BitSet!TokenID result;
        result.length = tokens.vals.length;

        if (entry)
            entry.state++;
        else
            firstSetsCache[FirstSetsKey(x.toNonterminalID, negLookaheads, tags)] = FirstSetsValue(result, 1);

        foreach (p; getProductions(x.toNonterminalID))
        {
            if (!isProductionAllowed(NonterminalWithConstraint(x.toNonterminalID,
                    Constraint(negLookaheads, tags)), p))
                continue;
            if (p.symbols.length)
            {
                const(SymbolInstance)[] symbols = p.symbols[];
                BitSet!TokenID f;
                f.length = tokens.vals.length;
                bool lastEmpty = true;
                bool first = true;
                do
                {
                    f[tokens.getID("$end")] = false;

                    auto next = nextSymbolWithConstraint(Constraint(negLookaheads,
                            tags), symbols[0], first);

                    auto inner = firstSetImpl(symbols[0],
                            next.constraint.negLookaheads, next.constraint.tags);
                    if (lastEmpty)
                        f |= inner;
                    lastEmpty = lastEmpty && inner[tokens.getID("$end")];
                    symbols = symbols[1 .. $];
                    first = false;
                }
                while (symbols.length && lastEmpty);
                result |= f;
            }
            else
            {
                result[tokens.getID("$end")] = true;
            }
        }

        entry = FirstSetsKey(x.toNonterminalID, negLookaheads, tags) in firstSetsCache;
        entry.tokens = result;
        entry.state--;
        return result;
    }

    BitSet!TokenID firstSet(const SymbolInstance[] symbols,
            Constraint extraConstraint = Constraint.init, bool isFirst = false)
    {
        BitSet!TokenID r;
        r.length = tokens.vals.length;
        r[tokens.getID("$end")] = true;
        const(SymbolInstance)[] x = symbols;

        bool lastEmpty = true;
        while (x.length && lastEmpty)
        {
            BitSet!NonterminalID done;
            done.length = nonterminals.vals.length;

            r[tokens.getID("$end")] = false;

            if (x[0].isToken)
            {
                if (lastEmpty)
                {
                    r[x[0].toTokenID] = true;
                }

                lastEmpty = false;
            }
            else
            {
                auto next = nextNonterminalWithConstraint(extraConstraint, x[0], isFirst);
                const BitSet!TokenID nextFirstSet = firstSetImpl(next.nonterminalID,
                        next.constraint.negLookaheads, next.constraint.tags);
                if (lastEmpty)
                {
                    foreach (t; nextFirstSet.bitsSet)
                        r[t] = true;
                    lastEmpty = nextFirstSet[tokens.getID("$end")];
                }
            }

            x = x[1 .. $];
            isFirst = false;
        }

        return r;
    }

    bool firstSetContains(const SymbolInstance[] symbols, TokenID t)
    {
        const(SymbolInstance)[] x = symbols;

        while (x.length)
        {
            if (x[0].isToken)
            {
                return t == x[0].toTokenID;
            }
            else
            {
                const BitSet!TokenID nextFirstSet = firstSetImpl(x[0].toNonterminalID,
                        x[0].negLookaheads, x[0].tags);
                if (nextFirstSet[t])
                    return true;
                if (!nextFirstSet[tokens.getID("$end")])
                    return false;
            }

            x = x[1 .. $];
        }

        return false;
    }

    BitSet!NonterminalID[FirstSetsKey] firstSetsNonterminalCache;
    private BitSet!NonterminalID firstSetNonterminal(const(NonterminalID) x,
            immutable(Symbol)[] negLookaheads)
    {
        if (FirstSetsKey(x.toNonterminalID, negLookaheads) in firstSetsNonterminalCache)
            return firstSetsNonterminalCache[FirstSetsKey(x.toNonterminalID, negLookaheads)];

        BitSet!NonterminalID result;
        result.length = nonterminals.vals.length;

        firstSetsNonterminalCache[FirstSetsKey(x, negLookaheads)] = result;

        foreach (p; getProductions(x.toNonterminalID))
        {
            if (p.symbols.length)
            {
                immutable(Symbol)[] nextNegLookaheads = negLookaheads;
                const(SymbolInstance)[] symbols = p.symbols[];
                if (negLookaheads.canFind(symbols[0].symbol))
                    continue;
                if (symbols[0].isToken)
                    continue;

                nextNegLookaheads.addOnce(symbols[0].negLookaheads);
                result |= firstSetNonterminal(symbols[0].toNonterminalID, nextNegLookaheads);
            }
        }

        firstSetsNonterminalCache[FirstSetsKey(x, negLookaheads)] = result;
        return result;
    }

    bool[NonterminalID][TokenID] hasExactTokenCache;
    bool hasExactToken(Symbol symbol, TokenID currentToken)
    {
        if (symbol.isToken)
            return symbol.toTokenID == currentToken;

        bool[NonterminalID]* hasExactTokenCacheHere = currentToken in hasExactTokenCache;
        if (hasExactTokenCacheHere is null)
        {
            hasExactTokenCache[currentToken] = null;
            hasExactTokenCacheHere = currentToken in hasExactTokenCache;
        }
        if (symbol.toNonterminalID in *hasExactTokenCacheHere)
            return (*hasExactTokenCacheHere)[symbol.toNonterminalID];

        (*hasExactTokenCacheHere)[symbol.toNonterminalID] = false;

        bool r;

        foreach (p; getProductions(symbol.toNonterminalID))
        {
            bool nextExactMatch = false;
            bool beforeToken = true;
            foreach (pos; 0 .. p.symbols.length)
            {
                bool exactMatch2;
                if (beforeToken)
                {
                    exactMatch2 = hasExactToken(p.symbols[pos], currentToken);
                }
                if (!canBeEmpty(p.symbols[pos]))
                {
                    nextExactMatch = false;
                    beforeToken = false;
                }
                if (exactMatch2)
                    nextExactMatch = true;
            }
            if (nextExactMatch)
                r = true;
        }

        (*hasExactTokenCacheHere)[symbol.toNonterminalID] = r;
        return r;
    }

    void calcNonterminalTypes()
    {
        BitSet!NonterminalID done;
        done.length = nonterminals.vals.length;
        Tuple!(NonterminalFlags, SymbolID[]) handleNonterminal(NonterminalID n,
                ref TagID[] possibleTags)
        {
            if (done[n])
                return tuple!(NonterminalFlags, SymbolID[])(NonterminalFlags.none, null);
            done[n] = true;
            scope (success)
                done[n] = false;
            NonterminalFlags r;
            SymbolID[] buildNonterminals;
            foreach (p; getProductions(n))
            {
                foreach (tag; p.tags)
                    possibleTags.addOnce(tag);
                foreach (s; p.symbols)
                    foreach (tagUsage; s.tags)
                        if (tagUsage.inherit && !tagUsage.reject)
                            possibleTags.addOnce(tagUsage.tag);
                if (nonterminals[n].annotations.contains!"array"())
                {
                    r |= NonterminalFlags.array;
                    if (p.symbols.length == 0)
                        r |= NonterminalFlags.empty;
                    else
                    {
                        foreach (s; p.symbols)
                        {
                            if (s.dropNode)
                                continue;
                            if (s.isToken)
                                r |= NonterminalFlags.arrayOfString;
                            else
                            {
                                TagID[] unusedPossibleTags;
                                auto x = handleNonterminal(s.toNonterminalID, unusedPossibleTags);
                                r |= (x[0] & NonterminalFlags.anyArray);
                                if (x[0] & NonterminalFlags.nonterminal)
                                    r |= NonterminalFlags.arrayOfNonterminal;
                                if (x[0] & NonterminalFlags.string)
                                    r |= NonterminalFlags.arrayOfString;
                                buildNonterminals.addOnce(x[1]);
                            }
                        }
                    }
                }
                else
                {
                    if (nonterminals[n].annotations.contains!"string"())
                        r |= NonterminalFlags.string;

                    if (p.symbols.length == 0)
                        r |= NonterminalFlags.empty;
                    else if (isSimpleProduction(*p))
                    {
                        foreach (s; p.symbols)
                        {
                            if (s.dropNode)
                                continue;
                            if (s.isToken)
                                r |= NonterminalFlags.string;
                            else
                            {
                                auto x = handleNonterminal(s.toNonterminalID, possibleTags);
                                r |= x[0];
                                buildNonterminals.addOnce(x[1]);
                            }
                        }
                    }
                    else if (nonterminals[n].annotations.contains!"string"())
                        r |= NonterminalFlags.string;
                    else
                    {
                        r |= NonterminalFlags.nonterminal;
                        buildNonterminals.addOnce(n.id);
                    }
                }
            }
            return tuple!(NonterminalFlags, SymbolID[])(r, buildNonterminals);
        }

        foreach (n; nonterminals.allIDs)
        {
            TagID[] possibleTags;
            auto r = handleNonterminal(n, possibleTags);
            if (r[0] & NonterminalFlags.anyArray)
                enforce(!(r[0] & NonterminalFlags.anySingle), text(getSymbolName(n), " can be both array an not array"));
            nonterminals[n].flags = r[0];
            r[1].sort();
            nonterminals[n].buildNonterminals = r[1].idup;
            possibleTags.sort();
            nonterminals[n].possibleTags = possibleTags.idup;
        }
    }

    const(RewriteRule)[] getRewriteRules(const Production* p) const
    {
        if (p.rewriteRules.length > 0)
            return p.rewriteRules;
        RewriteRule r = RewriteRule(p);
        foreach (i, s; p.symbols)
        {
            if (!s.dropNode)
            {
                r.parameters ~= i;
            }
        }
        return [r];
    }

    bool hasNonTrivialRewriteRule(const Production* p) const
    {
        if (p.rewriteRules.length == 0)
        {
            foreach (i, s; p.symbols)
            {
                if (s.dropNode)
                    return true;
            }
            return false;
        }
        if (p.rewriteRules.length > 1)
            return true;
        if (p.symbols.length == p.rewriteRules[0].parameters.length)
        {
            foreach (i; 0 .. p.symbols.length)
                if (p.rewriteRules[0].parameters[i] != i)
                    return true;
            return false;
        }
        return true;
    }

    bool canForward(const Production* p, size_t symbolNr)
    {
        foreach (i2; 0 .. p.symbols.length)
        {
            if (i2 == symbolNr)
                continue;
            if (p.symbols[i2].isToken)
                return false;
            if (!canBeEmpty(p.symbols[i2]))
                return false;
        }
        return true;
    }

    bool canForwardPrefix(const Production* p, size_t symbolNr)
    {
        foreach (i2; 0 .. symbolNr)
        {
            if (i2 == symbolNr)
                continue;
            if (p.symbols[i2].isToken)
                return false;
            if (!canBeEmpty(p.symbols[i2]))
                return false;
        }
        return true;
    }

    bool isSimpleProduction(const Production production) const
    {
        static Appender!(size_t[]) notDropped;
        notDropped.clear();
        foreach (i, s; production.symbols)
            if (!s.dropNode)
                notDropped.put(i);

        return (notDropped.data.length == 1
                && production.symbols[notDropped.data[0]].unwrapProduction)
            || (production.isVirtual && production.symbols.length == 1
                    && !production.symbols[0].isToken
                    && !nonterminals[production.nonterminalID].annotations.contains!"array")
            || (production.isVirtual && production.symbols.length == 0);
    }

    bool isDirectUnwrapProduction(const Production production) const
    {
        if (!nonterminals[production.nonterminalID].annotations.contains!"directUnwrap"()
                && !nonterminals[production.nonterminalID].name.endsWith("?"))
            return false;
        return (!production.isVirtual && production.symbols.length == 1
                && production.symbols[0].unwrapProduction && !production.symbols[0].isToken)
            || (production.isVirtual && production.symbols.length == 1
                    && !production.symbols[0].isToken
                    && !nonterminals[production.nonterminalID].annotations.contains!"array");
    }

    immutable(NonterminalWithConstraint)[][NonterminalWithConstraint] directUnwrapClosureCacheFull;
    immutable(NonterminalWithConstraint)[] directUnwrapClosureFull(NonterminalID s,
            immutable(Symbol)[] negLookaheads, immutable(TagUsage)[] tags)
    {
        if (NonterminalWithConstraint(s, Constraint(negLookaheads, tags)) in directUnwrapClosureCacheFull)
        {
            auto r = directUnwrapClosureCacheFull[NonterminalWithConstraint(s,
                        Constraint(negLookaheads, tags))];
            enforce(r.length, getSymbolName(s));
            return r;
        }

        if (getProductions(s).length == 0)
        {
            return [];
        }

        if (negLookaheads.canFind(s))
        {
            return [];
        }

        foreach (t; tags)
        {
            if (t.needed && !nonterminals[s].possibleTags.canFind(t.tag))
                return [];
        }

        directUnwrapClosureCacheFull[NonterminalWithConstraint(s, Constraint(negLookaheads, tags))] = [
        ];

        NonterminalWithConstraint[] r;
        void addNonterminal(NonterminalWithConstraint n)
        {
            foreach (t; n.constraint.tags)
            {
                if (t.needed && !nonterminals[n.nonterminalID].possibleTags.canFind(t.tag))
                    return;
            }

            foreach (i, ref m2; r)
            {
                if (m2.nonterminalID == n.nonterminalID)
                {
                    m2.constraint = orConstraint(m2.constraint, n.constraint);
                    return;
                }
            }
            r ~= n;
        }

        addNonterminal(NonterminalWithConstraint(s, Constraint(negLookaheads, tags)));

        foreach (p; getProductions(s))
        {
            if (isDirectUnwrapProduction(*p))
            {
                if (negLookaheads.canFind(p.symbols[0]))
                    continue;
                immutable(Symbol)[] nextNegLookaheads = negLookaheads;
                nextNegLookaheads.addOnce(p.symbols[0].negLookaheads);
                auto nextTags = tags;
                foreach (n; directUnwrapClosureFull(p.symbols[0].symbol.toNonterminalID,
                        nextNegLookaheads, nextTags))
                {
                    Constraint constraint = n.constraint;
                    if (p.symbols[0].annotations.contains!"excludeDirectUnwrap" && n.nonterminalID != p.symbols[0].symbol.toNonterminalID)
                        constraint.disabled = true;
                    addNonterminal(NonterminalWithConstraint(n.nonterminalID, constraint,
                            n.hasLookaheadAnnotation
                            || p.symbols[0].annotations.contains!"lookahead"));
                }
            }
        }

        enforce(r.length, getSymbolName(s));

        auto r2 = r.idup;

        directUnwrapClosureCacheFull[NonterminalWithConstraint(s, Constraint(negLookaheads, tags))] = r2;

        return r2;
    }

    auto directUnwrapClosure(NonterminalID s,
            immutable(Symbol)[] negLookaheads, immutable(TagUsage)[] tags)
    {
        bool needsNonterminal(NonterminalWithConstraint n)
        {
            return !n.constraint.disabled && directUnwrapClosureHasSelf(n);
        }
        return directUnwrapClosureFull(s, negLookaheads, tags).filter!needsNonterminal;
    }

    auto directUnwrapClosure(const SymbolInstance s)
    {
        return directUnwrapClosure(s.toNonterminalID, s.negLookaheads, s.tags);
    }

    auto directUnwrapClosure(NonterminalWithConstraint n)
    {
        return directUnwrapClosure(n.nonterminalID, n.constraint.negLookaheads, n.constraint.tags);
    }

    immutable(Symbol)[][NonterminalID][NonterminalWithConstraint] directUnwrapClosureMapCache;
    immutable(Symbol)[][NonterminalID] directUnwrapClosureMap(NonterminalID s,
            immutable(Symbol)[] negLookaheads, immutable(TagUsage)[] tags)
    {
        if (NonterminalWithConstraint(s, Constraint(negLookaheads,
                tags)) in directUnwrapClosureMapCache)
        {
            return directUnwrapClosureMapCache[NonterminalWithConstraint(s,
                        Constraint(negLookaheads, tags))];
        }

        auto r = directUnwrapClosure(s, negLookaheads, tags);
        if (r.empty)
            return null;

        immutable(Symbol)[][NonterminalID] n;
        foreach (x; r)
            n[x.nonterminalID] = x.constraint.negLookaheads;

        directUnwrapClosureMapCache[NonterminalWithConstraint(s, Constraint(negLookaheads, tags))] = n;

        return n;
    }

    immutable(Symbol)[][NonterminalID] directUnwrapClosureMap(NonterminalWithConstraint n)
    {
        return directUnwrapClosureMap(n.nonterminalID,
                n.constraint.negLookaheads, n.constraint.tags);
    }

    bool directUnwrapClosureHasSelf(NonterminalID s,
            immutable(Symbol)[] negLookaheads, immutable(TagUsage)[] tags)
    {
        if (negLookaheads.canFind(s))
            return false;

        bool needsNonterminal;
        foreach (p; getProductions(s))
        {
            if (!isProductionAllowed(NonterminalWithConstraint(s,
                    Constraint(negLookaheads, tags)), p))
                continue;
            if (!isDirectUnwrapProduction(*p))
                needsNonterminal = true;
        }
        return needsNonterminal;
    }

    bool directUnwrapClosureHasSelf(NonterminalWithConstraint n)
    {
        return directUnwrapClosureHasSelf(n.nonterminalID,
                n.constraint.negLookaheads, n.constraint.tags);
    }

    bool isProductionAllowed(NonterminalWithConstraint n, const Production* p)
    {
        assert(p.nonterminalID == n.nonterminalID);
        if (p.symbols.length && n.constraint.negLookaheads.canFind(p.symbols[0]))
            return false;
        foreach (t; n.constraint.tags)
        {
            if (t.reject && p.tags.canFind(t.tag))
                return false;
            if (t.needed && !nonterminals[n.nonterminalID].possibleTags.canFind(t.tag))
                return false;
        }
        return true;
    }

    SymbolWithConstraint nextSymbolWithConstraint(Constraint c, SymbolInstance s, bool first)
    {
        immutable(Symbol)[] nextNegLookaheads;
        if (first)
            nextNegLookaheads = c.negLookaheads;
        nextNegLookaheads.addOnce(s.negLookaheads);

        TagUsage[] nextTags;
        ref TagUsage findTag(TagID tag)
        {
            foreach (ref t; nextTags)
                if (t.tag == tag)
                    return t;
            nextTags ~= TagUsage(tag);
            return nextTags[$ - 1];
        }

        if (s.unwrapProduction || s.annotations.contains!"inheritAnyTag")
        {
            foreach (t; c.tags)
            {
                if (t.reject)
                    findTag(t.tag).reject = true;
                if (t.needed)
                    findTag(t.tag).needed = true;
            }
        }
        foreach (t; s.tags)
        {
            if (t.reject)
                findTag(t.tag).reject = true;
            if (t.needed)
                findTag(t.tag).needed = true;
            if (t.inherit)
            {
                foreach (t2; c.tags)
                {
                    if (t2.tag == t.tag)
                    {
                        if (t2.reject)
                            findTag(t.tag).reject = true;
                        if (t2.needed)
                            findTag(t.tag).needed = true;
                    }
                }
            }
        }
        nextTags.sort();

        return SymbolWithConstraint(s, Constraint(nextNegLookaheads, nextTags.idup, c.disabled));
    }

    NonterminalWithConstraint nextNonterminalWithConstraint(Constraint c,
            SymbolInstance s, bool first)
    in (!s.isToken)
    {
        auto r = nextSymbolWithConstraint(c, s, first);
        return NonterminalWithConstraint(r.symbol.toNonterminalID, r.constraint);
    }

    Constraint orConstraint(Constraint a, Constraint b)
    {
        assert(tagsSorted(a.tags));
        assert(tagsSorted(b.tags));

        if (a.disabled)
            return b;
        if (b.disabled)
            return a;

        immutable(Symbol)[] newNegLookahead;
        foreach (l; a.negLookaheads)
            if (b.negLookaheads.canFind(l))
                newNegLookahead ~= l;

        immutable(TagUsage)[] nextTags;
        immutable(TagUsage)[] aTags = a.tags;
        immutable(TagUsage)[] bTags = b.tags;
        while (aTags.length && bTags.length)
        {
            if (aTags.length >= 2)
                assert(aTags[0].tag < aTags[1].tag);
            if (bTags.length >= 2)
                assert(bTags[0].tag < bTags[1].tag);

            if (aTags[0].tag < bTags[0].tag)
                aTags = aTags[1 .. $];
            else if (bTags[0].tag < aTags[0].tag)
                bTags = bTags[1 .. $];
            else
            {
                TagUsage t;
                t.tag = aTags[0].tag;
                if (aTags[0].reject && bTags[0].reject)
                    t.reject = true;
                if (aTags[0].needed && bTags[0].needed)
                    t.needed = true;
                if (t.reject || t.needed)
                    nextTags ~= t;

                aTags = aTags[1 .. $];
                bTags = bTags[1 .. $];
            }
        }

        return Constraint(newNegLookahead, nextTags, a.disabled && b.disabled);
    }

    bool[NonterminalID] isMutuallyLeftRecursiveCache;
    bool isMutuallyLeftRecursive(NonterminalID nonterminalID)
    {
        auto entry = nonterminalID in isMutuallyLeftRecursiveCache;
        if (entry)
            return *entry;
        bool[NonterminalID] visited;
        bool findLeftRecursion(NonterminalID n)
        {
            if (n in visited)
                return false;
            visited[n] = true;
            if (n == nonterminalID)
                return true;
            foreach (p; getProductions(n))
            {
                foreach (s; p.symbols)
                {
                    if (!s.isToken)
                    {
                        if (findLeftRecursion(s.toNonterminalID))
                            return true;
                    }
                    if (!canBeEmpty(s))
                        break;
                }
            }
            return false;
        }

        foreach (p; getProductions(nonterminalID))
        {
            foreach (s; p.symbols)
            {
                if (!s.isToken && s.toNonterminalID != nonterminalID)
                {
                    if (findLeftRecursion(s.toNonterminalID))
                    {
                        isMutuallyLeftRecursiveCache[nonterminalID] = true;
                        return true;
                    }
                }
                if (!canBeEmpty(s))
                    break;
            }
        }
        isMutuallyLeftRecursiveCache[nonterminalID] = false;
        return false;
    }
}

SymbolInfo[string] generateSymbolInfos(EBNF ebnf)
{
    SymbolInfo[string] symbolInfos;

    SymbolInfo info(string name)
    {
        auto s = name in symbolInfos;
        if (s is null)
        {
            symbolInfos[name] = new SymbolInfo();
            s = name in symbolInfos;
            s.name = name;
        }
        assert(s !is null);
        assert(s.name == name);
        return *s;
    }

    void visitExprs(SymbolInfo parent, const Tree expr, const string[] excludeNames,
            bool delegate(SymbolInfo parent, const Tree childExpr, SymbolInfo child) dg)
    {
        if (expr is null || expr.isToken)
            return;

        if (expr.nonterminalID.among(nonterminalIDFor!"Token",
                nonterminalIDFor!"Name", nonterminalIDFor!"MacroInstance"))
        {
            foreach (excludeName; excludeNames)
            {
                if (expr.childs[0].content == excludeName)
                    return;
            }

            auto s = info(expr.childs[0].content);
            bool changed = dg(parent, expr, s);

            if (changed)
            {
                foreach (d; s.declarations)
                    visitExprs(s, d.exprTree, d.parameters, dg);
            }
        }
        if (expr.nonterminalID == nonterminalIDFor!"AnnotatedExpression")
        {
            visitExprs(parent, expr.childs[$ - 1], excludeNames, dg);
        }
        else if (expr.nonterminalID == nonterminalIDFor!"Concatenation")
        {
            foreach (c; expr.childs[0 .. $ - 1])
            {
                visitExprs(parent, c, excludeNames, dg);
            }
        }
        else
        {
            foreach (c; expr.childs)
            {
                visitExprs(parent, c, excludeNames, dg);
            }
        }
    }

    foreach (i, d; ebnf.symbols)
    {
        auto s = info(d.name);
        s.declarations ~= d;
    }

    foreach (i, d; ebnf.symbols)
    {
        auto s = info(d.name);
        visitExprs(s, d.exprTree, d.parameters, (parent, childExpr, child) {
            if (childExpr.nonterminalID.among(nonterminalIDFor!"Name",
                nonterminalIDFor!"MacroInstance") && child.declarations.length == 0)
            {
                stderr.writeln("Warning: Using undefined symbol ", child.name);
            }
            return false;
        });
    }

    foreach (i, d; ebnf.symbols)
    {
        auto s = info(d.name);
        if (d.type == DeclarationType.token)
        {
            s.isToken = true;
            s.reachableFromToken = true;
        }
        if (d.annotations.canFind("ignoreToken"))
        {
            enforce(d.type == DeclarationType.token);
            s.isToken = true;
            s.isIgnoreToken = true;
            s.reachableFromToken = true;
        }
        visitExprs(s, d.exprTree, d.parameters, (parent, childExpr, child) {
            if (parent.reachableFromToken && !child.reachableFromToken)
            {
                child.reachableFromToken = true;
                return true;
            }
            return false;
        });
    }

    foreach (i, d; ebnf.symbols)
    {
        if (i != 0 && !d.annotations.canFind("start") && !d.annotations.canFind("ignoreToken"))
            continue;
        auto s = info(d.name);
        s.reachableFromStart = true;
        foreach (d2; s.declarations)
            visitExprs(s, d2.exprTree, d2.parameters, (parent, childExpr, child) {
                if (parent.reachableFromStart && !child.reachableFromStart)
                {
                    child.reachableFromStart = true;
                    return true;
                }
                return false;
            });
    }

    foreach (i, d; ebnf.symbols)
    {
        if (i != 0 && !d.annotations.canFind("start"))
            continue;
        auto s = info(d.name);
        if (!s.isToken)
            s.reachableFromStartNoToken = true;
        foreach (d2; s.declarations)
            visitExprs(s, d2.exprTree, d2.parameters, (parent, childExpr, child) {
                if (parent.reachableFromStartNoToken
                    && !child.reachableFromStartNoToken && !child.isToken)
                {
                    child.reachableFromStartNoToken = true;
                    return true;
                }
                return false;
            });
    }

    foreach (i, d; ebnf.symbols)
    {
        auto s = info(d.name);
        if (!s.reachableFromStart)
        {
            stderr.writeln("Warning: Unused symbol ", d.name);
        }
        else if (d.type == DeclarationType.fragment && d.parameters.length == 0
                && s.reachableFromStartNoToken)
        {
            stderr.writeln("Warning: Fragment ", d.name, " used in nonterminal");
        }
        else if (d.type == DeclarationType.auto_ && d.parameters.length == 0 && s.reachableFromToken)
        {
            stderr.writeln("Warning: Nonterminal ", d.name, " used in token");
        }
    }

    return symbolInfos;
}

Symbol getSymbolByName(EBNFGrammar grammar, string name)
{
    Symbol ls;
    if (name.startsWith("\"") || (grammar.allowTokenNonterminals
            && grammar.symbolInfos[name].isToken))
    {
        if (name !in grammar.symbolInfos || !grammar.symbolInfos[name].isIgnoreToken)
            ls = grammar.tokens.id(name);
        else
            throw new Exception("IgnoreTokens cannot be used");
    }
    else
        ls = grammar.nonterminals.id(name);
    return ls;
}

void addAnnotation(ref Annotations annotations, Tree tree)
in (tree.nonterminalID == nonterminalIDFor!"Annotation")
{
    assert(tree.childs.length == 3);
    assert(tree.childs[0].content == "@");
    string name = tree.childs[1].content;
    if (tree.childs[2] !is null)
    {
        name ~= "(" ~ concatTree(tree.childs[2].childs[1]).strip() ~ ")";
    }
    annotations.add(name);
}

SymbolInstance createSymbol(EBNFGrammar grammar, Tree tree, EBNF ebnf)
{
    SymbolInstance symbol;

    if (tree.nonterminalID == nonterminalIDFor!"AnnotatedExpression")
    {
        if (tree.childs[1] !is null)
            symbol.symbolInstanceName = tree.childs[1].childs[0].content;
        foreach (c; tree.childs[2].memberOrDefault!"childs")
        {
            if (c.childs[0].content == "<")
                symbol.unwrapProduction = true;
            else if (c.childs[0].content == "^")
                symbol.dropNode = true;
            else
                assert(false, c.childs[0].content);
        }
    }
    Tree realTree = tree;
    while (realTree.nonterminalID == nonterminalIDFor!"AnnotatedExpression")
    {
        foreach (c; realTree.childs[0].memberOrDefault!"childs")
        {
            if (c.nonterminalID == nonterminalIDFor!"Annotation")
                addAnnotation(symbol.annotations, c);
            else if (c.nonterminalID == nonterminalIDFor!"NegativeLookahead")
            {
                assert(c.childs.length == 2);
                assert(c.childs[0].content == "!");
                if (c.childs[1].nodeType == NodeType.nonterminal
                        && c.childs[1].nonterminalID.among(nonterminalIDFor!"Token",
                            nonterminalIDFor!"Name"))
                {
                    assert(c.childs[1].childs.length == 1);
                    symbol.negLookaheads ~= getSymbolByName(grammar, c.childs[1].childs[0].content);
                }
                else if (c.childs[1].nodeType == NodeType.token && c.childs[1].content == "anytoken")
                {
                    throw new Exception("anytoken not implemented here");
                }
                else
                    assert(false, c.childs[1].name);
            }
            else
                assert(false, c.name);
        }
        realTree = realTree.childs[$ - 1];
    }

    TagUsage[] tags;
    foreach (a; symbol.annotations.otherAnnotations)
    {
        ref TagUsage findTag(TagID tag)
        {
            foreach (ref t; tags)
                if (t.tag == tag)
                    return t;
            tags ~= TagUsage(tag);
            return tags[$ - 1];
        }

        if (a.startsWith("inheritTag("))
        {
            assert(a.endsWith(")"));
            foreach (t; a[11 .. $ - 1].split(", "))
            {
                t = t.strip();
                findTag(grammar.tags.id(t)).inherit = true;
            }
        }
        else if (a.startsWith("needTag("))
        {
            assert(a.endsWith(")"));
            foreach (t; a[8 .. $ - 1].split(", "))
            {
                t = t.strip();
                findTag(grammar.tags.id(t)).needed = true;
            }
        }
        else if (a.startsWith("rejectTag("))
        {
            assert(a.endsWith(")"));
            foreach (t; a[10 .. $ - 1].split(", "))
            {
                t = t.strip();
                findTag(grammar.tags.id(t)).reject = true;
            }
        }
    }
    tags.sort();
    symbol.tags = tags.idup;

    string name = ebnfTreeToString(realTree);

    if (symbol.annotations.contains!"regArray" && realTree.nonterminalID.among(
            nonterminalIDFor!"Repetition", nonterminalIDFor!"RepetitionPlus"))
        name = "@regArray " ~ name;

    if (realTree.nonterminalID != nonterminalIDFor!"MacroInstance")
        name = name.replace(" ", "_");

    bool alreadyDone = (name in grammar.nonterminals.ids) !is null;
    if (alreadyDone && realTree.nonterminalID != nonterminalIDFor!"Token"
            && realTree.nonterminalID != nonterminalIDFor!"SubToken")
    {
        symbol.symbol = grammar.nonterminals.id(name);
        return symbol;
    }

    if (realTree.nonterminalID == nonterminalIDFor!"Token")
    {
        symbol.symbol = grammar.tokens.id(realTree.childs[0].content);
        grammar.tokens[symbol.toTokenID].annotations.add(symbol.annotations);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"Name")
    {
        if (grammar.allowTokenNonterminals
                && grammar.symbolInfos[realTree.childs[0].content].isToken)
        {
            if (!grammar.symbolInfos[realTree.childs[0].content].isIgnoreToken)
                symbol.symbol = grammar.tokens.id(realTree.childs[0].content);
            else
                throw new Exception("IgnoreTokens cannot be used");
        }
        else
            symbol.symbol = grammar.nonterminals.id(realTree.childs[0].content);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"Optional")
    {
        assert(realTree.childs.length == 2);
        auto innerSymbol = createSymbol(grammar, realTree.childs[0], ebnf);

        Production* production = new Production;
        production.nonterminalID = grammar.nonterminals.id(name);
        production.isVirtual = true;
        innerSymbol.unwrapProduction = true;
        production.symbols = [innerSymbol];
        grammar.addProduction(production);

        Production* production2 = new Production;
        production2.nonterminalID = grammar.nonterminals.id(name);
        production2.isVirtual = true;
        production2.symbols = [];
        grammar.addProduction(production2);

        symbol.symbol = grammar.nonterminals.id(name);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"Repetition")
    {
        assert(realTree.childs.length == 2);
        /* Repetition reuses RepetitionPlus, so parser conflicts are avoided. */
        Tree tree2 = realTree;
        tree2 = new TreeNonterminal(nonterminalIDFor!"RepetitionPlus", ProductionID.max,
                [tree2.childs[0], new TreeToken("+", &grammarInfo)], &grammarInfo);
        auto innerSymbol = createSymbol(grammar, tree2, ebnf);

        Production* production = new Production;
        production.nonterminalID = grammar.nonterminals.id(name);
        production.isVirtual = true;
        grammar.addProduction(production);

        Production* production2 = new Production;
        production2.nonterminalID = grammar.nonterminals.id(name);
        production2.isVirtual = true;
        production2.symbols = [innerSymbol];
        grammar.addProduction(production2);

        grammar.nonterminals[grammar.nonterminals.id(name)].annotations.add("array");
        if (symbol.annotations.contains!"regArray")
            grammar.nonterminals[grammar.nonterminals.id(name)].annotations.add("regArray");
        symbol.symbol = grammar.nonterminals.id(name);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"RepetitionPlus")
    {
        assert(realTree.childs.length == 2);
        auto innerSymbol = createSymbol(grammar, realTree.childs[0], ebnf);

        Production* production = new Production;
        production.nonterminalID = grammar.nonterminals.id(name);
        production.isVirtual = true;
        production.symbols = [innerSymbol];
        grammar.addProduction(production);

        Production* production2 = new Production;
        production2.nonterminalID = grammar.nonterminals.id(name);
        production2.isVirtual = true;
        production2.symbols = [
            immutable(SymbolInstance)(grammar.nonterminals.id(name)), innerSymbol
        ];
        grammar.addProduction(production2);

        grammar.nonterminals[grammar.nonterminals.id(name)].annotations.add("array");
        if (symbol.annotations.contains!"regArray")
            grammar.nonterminals[grammar.nonterminals.id(name)].annotations.add("regArray");
        symbol.symbol = grammar.nonterminals.id(name);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"MacroInstance")
    {
        if (grammar.allowTokenNonterminals
                && grammar.symbolInfos[realTree.childs[0].content].isToken)
        {
            if (!grammar.symbolInfos[realTree.childs[0].content].isIgnoreToken)
                symbol.symbol = grammar.tokens.id(name);
            else
                throw new Exception("IgnoreTokens cannot be used");
        }
        else
        {
            symbol.symbol = grammar.nonterminals.id(name);

            Tree[] macroParameters;
            foreach (c; realTree.childs[2].memberOrDefault!"childs")
                if (!c.isToken)
                    macroParameters ~= c;
            foreach (d; ebnf.symbols)
            {
                if (d.name == realTree.childs[0].content
                        && (d.parameters.length == macroParameters.length || (d.variadicParameterIndex != size_t.max
                            && macroParameters.length >= d.parameters.length - 1)))
                {
                    Tree[string] table;
                    Tree[] parametersHere = macroParameters;
                    if (d.variadicParameterIndex != size_t.max)
                    {
                        Tree[] parametersBeforeVariadic = macroParameters[0
                            .. d.variadicParameterIndex];
                        size_t numAfterVariadic = d.parameters.length - 1 - d
                            .variadicParameterIndex;
                        Tree[] parametersVariadic = macroParameters[d.variadicParameterIndex
                            .. $ - numAfterVariadic];
                        Tree[] parametersAfterVariadic = macroParameters[$ - numAfterVariadic .. $];
                        Tree variadicTuple = new TreeNonterminal(nonterminalIDFor!"Tuple",
                                ProductionID.max, [
                                    new TreeToken("t(", &grammarInfo),
                                    new TreeArray(parametersVariadic, &grammarInfo),
                                    new TreeToken(")", &grammarInfo)
                                ], &grammarInfo);
                        parametersHere = parametersBeforeVariadic
                            ~ variadicTuple ~ parametersAfterVariadic;
                    }
                    foreach (i, c; parametersHere)
                    {
                        table[d.parameters[i]] = c;
                    }
                    NonterminalID id2 = createGrammar(grammar, name,
                            replaceNames(table, d.exprTree), ebnf);

                    grammar.nonterminals[id2].annotations = Annotations(d.annotations);

                    assert(id2 == symbol, text(realTree.childs[0].content, " ", symbol, " ", id2));
                }
            }
        }
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"Concatenation")
    {
        symbol.symbol = createGrammar(grammar, name, realTree, ebnf);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"Alternation")
    {
        symbol.symbol = createGrammar(grammar, name, realTree, ebnf);
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"SubToken")
    {
        symbol = createSymbol(grammar, realTree.childs[0], ebnf);
        if (realTree.childs[2].nonterminalID == nonterminalIDFor!"Token")
        {
            symbol.subToken = realTree.childs[2].childs[0].content;
        }
        else
            throw new Exception("subterminal only for strings implemented");
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"TokenMinus")
    {
        if (grammar.isLexerGrammar)
        {
            symbol.symbol = grammar.nonterminals.id("$tokenminus" ~ name);

            auto innerSymbol1 = createSymbol(grammar, realTree.childs[0], ebnf);
            auto innerSymbol2 = createSymbol(grammar, realTree.childs[2], ebnf);

            foreach (p; grammar.productions)
            {
                if (p.nonterminalID == symbol.toNonterminalID)
                {
                    assert(p.symbols[0] == innerSymbol1);
                    assert(p.symbols[1] == innerSymbol2);
                    return symbol;
                }
            }

            Production* production = new Production;
            production.nonterminalID = grammar.nonterminals.id("$tokenminus" ~ name);
            production.isVirtual = true;
            production.symbols = [innerSymbol1, innerSymbol2];
            grammar.addProduction(production);
        }
        else
        {
            enforce(false, "Using token minus outside token or fragment: " ~ name);
        }
    }
    else if (realTree.nonterminalID == nonterminalIDFor!"ParenExpression")
    {
        symbol.symbol = createSymbol(grammar, realTree.childs[1], ebnf);
    }
    else
        enforce(0, text("Unexpected expression ", realTree.name));

    return symbol;
}

NonterminalID createGrammar(EBNFGrammar grammar, string name, Tree tree, EBNF ebnf,
        bool isVirtual = false)
{
    if (name.length == 0)
    {
        name = ebnfTreeToString(tree);
    }

    Production* production = new Production;
    production.nonterminalID = grammar.nonterminals.id(name);
    production.isVirtual = isVirtual;

    while (tree.nonterminalID == nonterminalIDFor!"AnnotatedExpression"
            && tree.childs[0].memberOrDefault!"childs".length == 0
            && tree.childs[1] is null && tree.childs[2].memberOrDefault!"childs".length == 0)
        tree = tree.childs[$ - 1];

    if (tree.name == "Concatenation")
    {
        assert(tree.nonterminalID == nonterminalIDFor!"Concatenation");
        foreach (c; tree.childs[$ - 1].memberOrDefault!"childs")
        {
            if (c.nonterminalID == nonterminalIDFor!"Annotation")
                addAnnotation(production.annotations, c);
            else if (c.nonterminalID == nonterminalIDFor!"NegativeLookahead")
            {
                assert(c.childs.length == 2);
                assert(c.childs[0].content == "!");
                if (c.childs[1].nodeType == NodeType.nonterminal
                        && c.childs[1].nonterminalID.among(nonterminalIDFor!"Token",
                            nonterminalIDFor!"Name"))
                {
                    assert(c.childs[1].childs.length == 1);
                    auto negLookaheadSymbol = getSymbolByName(grammar,
                            c.childs[1].childs[0].content);
                    if (!grammar.isLexerGrammar && !negLookaheadSymbol.isToken)
                        throw new Exception(text("Error: Nonterminal ", c.childs[1].childs[0].content,
                                " used as negative lookahead for production"));
                    production.negLookaheads ~= negLookaheadSymbol;
                }
                else if (c.childs[1].nodeType == NodeType.token && c.childs[1].content == "anytoken")
                {
                    production.negLookaheadsAnytoken = true;
                }
                else
                    assert(false, c.childs[1].name);
            }
        }

        TagID[] tags;
        foreach (a; production.annotations.otherAnnotations)
        {
            if (a.startsWith("tag("))
            {
                assert(a.endsWith(")"));
                foreach (t; a[4 .. $ - 1].split(", "))
                {
                    t = t.strip();
                    tags.addOnce(grammar.tags.id(t));
                }
            }
        }
        tags.sort();
        production.tags = tags.idup;

        if (tree.childs.length >= 2)
            production.symbols ~= createSymbol(grammar, tree.childs[0], ebnf);
        if (tree.childs.length == 3)
            foreach (c; tree.childs[1].memberOrDefault!"childs")
            {
                if (!c.isToken)
                    production.symbols ~= createSymbol(grammar, c, ebnf);
            }

        if (production.symbols.length == 0 && !production.annotations.canFind("empty"))
            throw new Exception("Empty concatenation missing @empty.");
    }
    else if (tree.nonterminalID == nonterminalIDFor!"Alternation")
    {
        foreach (c; tree.childs)
        {
            if (!c.isToken)
                createGrammar(grammar, name, c, ebnf);
        }
        return grammar.nonterminals.id(name);
    }
    else if (tree.nonterminalID == nonterminalIDFor!"UnpackVariadicList")
    {
        throw new Exception(text("Error: Can't use variadic parameter here ", tree));
    }
    else
        production.symbols ~= createSymbol(grammar, tree, ebnf);

    grammar.addProduction(production);
    return grammar.nonterminals.id(name);
}

EBNFGrammar createGrammar(EBNF ebnf)
{
    EBNFGrammar grammar = new EBNFGrammar(generateSymbolInfos(ebnf));
    grammar.tokens.id("$end");
    assert(grammar.tokens.getID("$end") == TokenID(0));

    grammar.startTokenID = ebnf.startTokenID;
    grammar.startNonterminalID = ebnf.startNonterminalID;
    grammar.startProductionID = ebnf.startProductionID;

    grammar.allowTokenNonterminals = true;

    foreach (i, d; ebnf.symbols)
    {
        if (d.parameters.length)
            continue;

        if (!grammar.symbolInfos[d.name].reachableFromStartNoToken)
            continue;

        NonterminalID id = grammar.nonterminals.id(d.name);
        if (i == 0 || d.annotations.canFind("start"))
            grammar.startNonterminals ~= StartNonterminal(id);

        grammar.nonterminals[grammar.nonterminals.id(d.name)].annotations = Annotations(
                d.annotations);
    }
    foreach (i, d; ebnf.symbols)
    {
        if (!grammar.symbolInfos[d.name].isToken || grammar.symbolInfos[d.name].isIgnoreToken)
            continue;
        grammar.tokens.id(d.name);
    }

    foreach (i, d; ebnf.symbols)
    {
        if (d.parameters.length)
            continue;

        if (!grammar.symbolInfos[d.name].reachableFromStartNoToken)
            continue;

        createGrammar(grammar, d.name, d.exprTree, ebnf);
    }

    foreach (s; grammar.symbolInfos)
    {
        if (s.isToken && !s.isIgnoreToken && s.reachableFromStart)
        {
            auto id = grammar.tokens.id(s.name);
            foreach (d; s.declarations)
                grammar.tokens[id.toTokenID].annotations.add(d.annotations);
        }
    }

    grammar.calcNonterminalCanBeEmpty();

    grammar.fillProductionsForNonterminal();
    grammar.calcNonterminalTypes();

    foreach (i, m; ebnf.matchingTokens)
    {
        TokenID t1 = grammar.tokens.id(m[0]);
        TokenID t2 = grammar.tokens.id(m[1]);
        grammar.matchingTokens ~= [t1, t2];
    }
    checkGrammar(grammar);

    foreach (t; grammar.tokens.allIDs)
    {
        if (grammar.tokens[t].annotations.contains!"inContextOnly"())
            grammar.inContextOnlyTokens.addOnce(t);
    }
    return grammar;
}

void checkGrammar(EBNFGrammar grammar)
{
    foreach (p; grammar.productions)
    {
        if (p is null)
            continue;
    }

    Appender!(NonterminalID[]) path;
    bool[NonterminalID] inPath;
    void checkCycles2(NonterminalID nonterminalID)
    {
        if (nonterminalID in inPath)
            throw new Exception(text("cycle ", path.data.map!(n => grammar.getSymbolName(n))
                    .array, grammar.getSymbolName(nonterminalID)));
        foreach (p; grammar.getProductions(nonterminalID))
        {
            foreach (i; 0 .. p.symbols.length)
            {
                if (p.symbols[i].isToken)
                    continue;
                if (!grammar.canForward(p, i))
                    continue;
                path.put(nonterminalID);
                inPath[nonterminalID] = true;
                checkCycles2(p.symbols[i].toNonterminalID);
                inPath.remove(nonterminalID);
                path.shrinkTo(path.data.length - 1);
            }
        }
    }

    foreach (i, ref nonterminal; grammar.nonterminals.vals)
    {
        checkCycles2(NonterminalID(i.to!SymbolID));
    }

    void checkCycles3(NonterminalID nonterminalID, bool hasDirectProd)
    {
        if (nonterminalID in inPath)
        {
            if (path.data[0] == nonterminalID && hasDirectProd)
                throw new Exception(text("cycle3 ", path.data.map!(n => grammar.getSymbolName(n))
                        .array, grammar.getSymbolName(nonterminalID)));
            else
                return;
        }
        foreach (p; grammar.getProductions(nonterminalID))
        {
            foreach (i; 0 .. p.symbols.length)
            {
                if (p.symbols[i].isToken)
                    continue;
                if (!grammar.canForwardPrefix(p, i))
                    continue;
                path.put(nonterminalID);
                inPath[nonterminalID] = true;
                checkCycles3(p.symbols[i].toNonterminalID, hasDirectProd || i > 0);
                inPath.remove(nonterminalID);
                path.shrinkTo(path.data.length - 1);
            }
        }
    }

    foreach (i, ref nonterminal; grammar.nonterminals.vals)
    {
        checkCycles3(NonterminalID(i.to!SymbolID), false);
    }

    struct SymbolKey
    {
        Symbol symbol;
        string subToken;
        immutable(TagUsage)[] tags;
    }

    struct ProductionKey
    {
        NonterminalID nonterminalID;
        SymbolKey[] symbols;
    }

    const(Production)*[ProductionKey] productionsDone;
    foreach (p; grammar.productions)
    {
        auto key = ProductionKey(p.nonterminalID,
                p.symbols.map!(s => SymbolKey(s.symbol, s.subToken, s.tags)).array);
        if (key in productionsDone)
        {
            throw new Exception(text("Error: Duplicate production:\n  ",
                    grammar.productionString(p), "\n  ",
                    grammar.productionString(productionsDone[key])));
        }
        productionsDone[key] = p;
    }
}

void optimizeLexerGrammarCharSets(EBNFGrammar lexerGrammar)
{
    size_t[][NonterminalID] combinableProductions;
    foreach (i, p; lexerGrammar.productionsData)
    {
        if (p is null)
            continue;
        if (p.symbols.length == 1 && p.symbols[0].isToken
            && p.negLookaheads.length == 0
            && p.negLookaheadsAnytoken == 0
            && p.annotations.empty
            && p.symbols[0].negLookaheads.length == 0
            && p.symbols[0].annotations.empty)
        {
            string name = lexerGrammar.getSymbolName(p.symbols[0]);
            if (name in lexerGrammar.nonterminals.ids)
                continue;
            if (name.endsWith("]") && !name.startsWith("[^")
                && !name.startsWith("[-") && !name.endsWith("-]"))
            {
                assert(name.startsWith("["));
                combinableProductions[p.nonterminalID] ~= i;
            }
        }
    }

    const(Production)*[] newProductionData = lexerGrammar.productionsData.dup;
    foreach (nonterminal, productionIDs; combinableProductions)
    {
        if (productionIDs.length <= 1)
            continue;
        foreach (i; productionIDs)
            newProductionData[i] = null;

        string newContent = "[";
        foreach (i; productionIDs)
        {
            newContent ~= lexerGrammar.getSymbolName(lexerGrammar.productionsData[i].symbols[0])[1 .. $ - 1];
        }
        newContent ~= "]";

        Production* p2 = new Production();
        p2.nonterminalID = nonterminal;
        p2.symbols = [SymbolInstance(lexerGrammar.tokens.id(newContent))];
        enforce(newProductionData.length < ProductionID.max);
        p2.productionID = cast(ProductionID) newProductionData.length;
        newProductionData ~= p2;
    }
    lexerGrammar.productionsData = newProductionData;
}

EBNFGrammar createLexerGrammar(EBNF ebnf, EBNFGrammar realGrammar)
{
    EBNFGrammar lexerGrammar = new EBNFGrammar(realGrammar.symbolInfos);
    lexerGrammar.isLexerGrammar = true;
    lexerGrammar.tokens.id("$end");
    assert(lexerGrammar.tokens.getID("$end") == TokenID(0));

    lexerGrammar.startTokenID = ebnf.startTokenID;
    lexerGrammar.startNonterminalID = ebnf.startNonterminalID;
    lexerGrammar.startProductionID = ebnf.startProductionID;

    foreach (token; realGrammar.tokens.allIDs)
    {
        string name = realGrammar.tokens[token].name;
        if (name == "$end")
            name = "$null";
        auto nonterminal = lexerGrammar.nonterminals.id(name);
        assert(nonterminal.id == token.id);
        if (name != "$null")
            lexerGrammar.startNonterminals ~= StartNonterminal(nonterminal);
        lexerGrammar.nonterminals[nonterminal].annotations.add(
                realGrammar.tokens[token].annotations);
    }

    foreach (i, d; ebnf.symbols)
    {
        if (d.parameters.length)
            continue;

        if (!lexerGrammar.symbolInfos[d.name].reachableFromToken)
            continue;

        NonterminalID id = lexerGrammar.nonterminals.id(d.name);

        lexerGrammar.nonterminals[id].annotations.add(d.annotations);
    }
    foreach (i, d; ebnf.symbols)
    {
        if (d.parameters.length)
            continue;

        if (!lexerGrammar.symbolInfos[d.name].reachableFromToken)
            continue;

        if (d.exprTree !is null)
            createGrammar(lexerGrammar, d.name, d.exprTree, ebnf);
    }

    optimizeLexerGrammarCharSets(lexerGrammar);

    lexerGrammar.fillProductionsForNonterminal();

    return lexerGrammar;
}

EBNFGrammar createOptEmptyGrammar(EBNF ebnf, EBNFGrammar realGrammar)
{
    EBNFGrammar newGrammar = new EBNFGrammar(realGrammar.symbolInfos, realGrammar);
    newGrammar.tokens = realGrammar.tokens;
    newGrammar.nonterminals = realGrammar.nonterminals;
    newGrammar.tags = realGrammar.tags;
    newGrammar.startNonterminals = realGrammar.startNonterminals;
    newGrammar.allowTokenNonterminals = realGrammar.allowTokenNonterminals;
    newGrammar.matchingTokens = realGrammar.matchingTokens;
    newGrammar.inContextOnlyTokens = realGrammar.inContextOnlyTokens;

    newGrammar.startTokenID = ebnf.startTokenID;
    newGrammar.startNonterminalID = ebnf.startNonterminalID;
    newGrammar.startProductionID = ebnf.startProductionID;

    BitSet!NonterminalID nonterminalCanBeEmpty;
    BitSet!NonterminalID nonterminalCanBeNonEmpty;
    realGrammar.calcNonterminalCanBeEmpty(nonterminalCanBeEmpty, nonterminalCanBeNonEmpty, true);

    bool canBeEmpty(const Symbol symbol)
    {
        if (symbol.isToken)
            return false;
        return nonterminalCanBeEmpty[symbol.toNonterminalID];
    }

    bool canBeNonEmpty(const Symbol symbol)
    {
        if (symbol.isToken)
            return true;
        return nonterminalCanBeNonEmpty[symbol.toNonterminalID];
    }

    foreach (i, n; realGrammar.startNonterminals)
        if (canBeEmpty(n.nonterminal))
            newGrammar.startNonterminals[i].needsEmptyProduction = true;

    foreach (i, p; realGrammar.productionsData)
    {
        if (p is null)
        {
            newGrammar.productionsData ~= null;
            continue;
        }
        assert(p.productionID == i);
        assert(newGrammar.productionsData.length == i);

        bool anyCanBeEmpty, anyCanBeNonEmpty;
        foreach (s; p.symbols)
        {
            if (canBeEmpty(s))
                anyCanBeEmpty = true;
            if (canBeNonEmpty(s))
                anyCanBeNonEmpty = true;
        }

        if ((anyCanBeEmpty || !anyCanBeNonEmpty || p.symbols.length == 0)
                && !(p.symbols.length == 0
                    && realGrammar.nonterminals[p.nonterminalID].annotations.contains!"noOptEmpty"))
            newGrammar.productionsData ~= null;
        else
            newGrammar.productionsData ~= p;
    }

    foreach (i, p; realGrammar.productionsData)
    {
        if (p is null)
            continue;
        if (p.symbols.length == 0)
            continue;
        if (newGrammar.productionsData[i]!is null)
            continue; // cant be empty

        void buildGraph(immutable(SymbolInstance)[] symbolsAvailable, size_t[] symbolPositions,
                immutable(SymbolInstance)[] symbolsSelected, bool afterSkippedEager)
        {
            if (symbolsAvailable.length == 0)
            {
                if (symbolsSelected.length == 0)
                    return;
                Production* p2 = new Production();
                p2.nonterminalID = p.nonterminalID;
                p2.symbols = symbolsSelected;
                p2.annotations = p.annotations;
                p2.negLookaheads = p.negLookaheads.dup;
                p2.negLookaheadsAnytoken = p.negLookaheadsAnytoken;
                p2.rewriteRules = [RewriteRule(p, symbolPositions, 0)];
                p2.tags = p.tags;
                if (afterSkippedEager)
                    p2.annotations.add("eagerEnd");
                newGrammar.addProduction(p2);
            }
            else
            {
                auto s = symbolsAvailable[0];
                if (canBeEmpty(p.symbols[symbolPositions.length]))
                    buildGraph(symbolsAvailable[1 .. $], s.dropNode ? symbolPositions : (symbolPositions ~ [
                                size_t.max
                            ]), symbolsSelected, afterSkippedEager
                            || symbolsAvailable[0].annotations.contains!"eager");
                if (canBeNonEmpty(p.symbols[symbolPositions.length]))
                    buildGraph(symbolsAvailable[1 .. $], s.dropNode ? symbolPositions
                            : (symbolPositions ~ [symbolsSelected.length]),
                            symbolsSelected ~ symbolsAvailable[0], false);
            }
        }

        buildGraph(p.symbols, [], [], false);
    }

    newGrammar.calcNonterminalCanBeEmpty();
    newGrammar.fillProductionsForNonterminal();
    newGrammar.calcNonterminalTypes();

    checkGrammar(newGrammar);

    return newGrammar;
}

EBNFGrammar createGrammarWithoutDeactivatedProductions(EBNFGrammar realGrammar)
{
    EBNFGrammar newGrammar = new EBNFGrammar(realGrammar.symbolInfos, realGrammar);
    newGrammar.tokens = realGrammar.tokens;
    newGrammar.nonterminals = realGrammar.nonterminals;
    newGrammar.tags = realGrammar.tags;
    newGrammar.startNonterminals = realGrammar.startNonterminals;
    newGrammar.allowTokenNonterminals = realGrammar.allowTokenNonterminals;
    newGrammar.matchingTokens = realGrammar.matchingTokens;
    newGrammar.inContextOnlyTokens = realGrammar.inContextOnlyTokens;

    newGrammar.startTokenID = realGrammar.startTokenID;
    newGrammar.startNonterminalID = realGrammar.startNonterminalID;
    newGrammar.startProductionID = realGrammar.startProductionID;

    foreach (i, p; realGrammar.productionsData)
    {
        if (p is null)
        {
            newGrammar.productionsData ~= null;
            continue;
        }

        assert(p.productionID == i);
        assert(newGrammar.productionsData.length == i);

        if (p.annotations.contains!"deactivated"())
            newGrammar.productionsData ~= null;
        else
            newGrammar.productionsData ~= p;
    }

    newGrammar.calcNonterminalCanBeEmpty();
    newGrammar.fillProductionsForNonterminal();
    newGrammar.calcNonterminalTypes();

    checkGrammar(newGrammar);

    return newGrammar;
}

Graph!(SymbolWithConstraint, NonterminalID) buildRegArrayGraph(EBNFGrammar grammar,
        ref NonterminalID[] regArrayNonterminals)
{
    alias G = Graph!(SymbolWithConstraint, NonterminalID);
    alias NodeID = G.NodeID;

    bool[NonterminalWithConstraint] done;
    regArrayNonterminals = [];

    G g = new G();
    g.start = g.addNode("start");

    void buildGraph(NonterminalWithConstraint n, string indent)
    {
        assert(!n.constraint.negLookaheads.canFind(n.nonterminalID));
        if (n in done)
            return;
        done[n] = true;
        if (grammar.nonterminals[n.nonterminalID].annotations.contains!"array"()
                && grammar.nonterminals[n.nonterminalID].annotations.contains!"regArray"())
        {
            regArrayNonterminals ~= n.nonterminalID;

            bool[NonterminalWithConstraint] inProgress;
            void buildGraphPart(NonterminalWithConstraint n, NodeID start, NodeID end, string indent)
            {
                assert(!n.constraint.negLookaheads.canFind(n.nonterminalID));
                if (n in inProgress) {
                    throw new Exception(text("Error: Unsupported recursion for symbol ", grammar.getSymbolName(n.nonterminalID), " with @regArray"));
                }
                inProgress[n] = true;
                scope (success)
                    inProgress.remove(n);
                if (!grammar.nonterminals[n.nonterminalID].annotations.contains!"array"()
                        && !grammar.nonterminals[n.nonterminalID].name.endsWith("?"))
                {
                    foreach (m2; grammar.directUnwrapClosure(n))
                    {
                        SymbolWithConstraint s = SymbolWithConstraint(m2.nonterminalID);
                        bool edgeNeeded;
                        foreach (p; grammar.getProductions(m2.nonterminalID))
                        {
                            if (grammar.isProductionAllowed(m2, p))
                                edgeNeeded = true;
                        }
                        if (!edgeNeeded)
                            continue;
                        foreach (x; m2.constraint.negLookaheads)
                        {
                            s.constraint.negLookaheads.addOnce(x);
                        }
                        g.addEdge(start, end, s, EdgeFlags.none);
                    }
                    buildGraph(n, indent ~ " ");
                    return;
                }

                bool needsNonterminalEdge;

                bool hasLeftRec, hasRightRec, hasNonRec;

                foreach (p; grammar.getProductions(n.nonterminalID))
                {
                    if (!grammar.isProductionAllowed(n, p))
                        continue;
                    if (p.symbols.length == 0)
                    {
                        hasNonRec = true;
                        continue;
                    }
                    if (p.symbols[0].symbol == n.nonterminalID)
                        hasLeftRec = true;
                    if (p.symbols[$ - 1].symbol == n.nonterminalID)
                        hasRightRec = true;
                    if (p.symbols[0].symbol != n.nonterminalID
                            && p.symbols[$ - 1].symbol != n.nonterminalID)
                        hasNonRec = true;
                }

                NodeID loopStart;
                if (hasLeftRec)
                    loopStart = g.addNode("loopStart");
                else if (hasRightRec)
                    loopStart = start;

                foreach (p; grammar.getProductions(n.nonterminalID))
                {
                    if (!grammar.isProductionAllowed(n, p))
                        continue;

                    immutable(SymbolInstance)[] symbols = p.symbols;
                    bool thisIsRightRec;
                    bool thisIsLeftRec;
                    bool first = true;
                    // use only left recursion.
                    // using both left and right recursion would turn S=@empty|S a| b S; into S=(a|b)*;
                    if (symbols.length && symbols[0].symbol == n.nonterminalID)
                    {
                        thisIsLeftRec = true;
                        symbols = symbols[1 .. $];
                        first = false;
                    }
                    if (symbols.length && symbols[$ - 1].symbol == n.nonterminalID)
                    {
                        thisIsRightRec = true;
                        symbols = symbols[0 .. $ - 1];
                    }
                    enforce(!thisIsLeftRec || !thisIsRightRec);

                    NodeID node;
                    if (!thisIsLeftRec)
                    {
                        node = g.addNode("start p");
                        g.addEdge(start, node, SymbolWithConstraint.invalid);
                    }
                    else
                        node = loopStart;

                    foreach (s; symbols)
                    {
                        NodeID node2 = g.addNode("");
                        if (s.isToken)
                        {
                            g.addEdge(node, node2, SymbolWithConstraint(s));
                        }
                        else
                        {
                            buildGraphPart(grammar.nextNonterminalWithConstraint(n.constraint,
                                    s, first), node, node2, indent ~ "  ");
                        }
                        node = node2;
                        first = false;
                    }

                    if (!thisIsRightRec)
                    {
                        g.addEdge(node, end, SymbolWithConstraint.invalid);
                    }
                    else
                    {
                        g.addEdge(node, start, SymbolWithConstraint.invalid);
                    }
                    if (hasLeftRec && !thisIsRightRec)
                    {
                        g.addEdge(node, loopStart, SymbolWithConstraint.invalid);
                    }
                }
            }

            string name = grammar.nonterminals[n.nonterminalID].name;
            NodeID startM = g.addNode("start " ~ name);
            g.addEdge(g.start, startM, SymbolWithConstraint.invalid);
            NodeID endM = g.addNode("end");
            g.get(endM).results = [n.nonterminalID];
            buildGraphPart(n, startM, endM, indent ~ "  ");
        }
        else
        {
            foreach (p; grammar.getProductions(n.nonterminalID))
            {
                if (!grammar.isProductionAllowed(n, p))
                    continue;
                bool first = true;
                foreach (s; p.symbols)
                {
                    if (!s.isToken)
                        buildGraph(NonterminalWithConstraint(s.toNonterminalID), indent);
                    first = false;
                }
            }
        }
    }

    foreach (n; grammar.startNonterminals)
        buildGraph(NonterminalWithConstraint(n.nonterminal), "");

    return g;
}

EBNFGrammar createRegArrayGrammar(EBNF ebnf, EBNFGrammar realGrammar)
{
    EBNFGrammar newGrammar = new EBNFGrammar(realGrammar.symbolInfos /*, realGrammar*/ );
    newGrammar.tokens = realGrammar.tokens;
    newGrammar.nonterminals = realGrammar.nonterminals;
    newGrammar.tags = realGrammar.tags;
    newGrammar.startNonterminals = realGrammar.startNonterminals;
    newGrammar.allowTokenNonterminals = realGrammar.allowTokenNonterminals;
    newGrammar.matchingTokens = realGrammar.matchingTokens;
    newGrammar.inContextOnlyTokens = realGrammar.inContextOnlyTokens;

    newGrammar.startTokenID = ebnf.startTokenID;
    newGrammar.startNonterminalID = ebnf.startNonterminalID;
    newGrammar.startProductionID = ebnf.startProductionID;

    NonterminalID[] regArrayNonterminals;
    Graph!(SymbolWithConstraint, NonterminalID) g = buildRegArrayGraph(realGrammar,
            regArrayNonterminals);
    g = g.makeDeterministic(g.start, false).minimizeDFA;

    foreach (i, p; realGrammar.productionsData)
    {
        if (p is null)
        {
            newGrammar.productionsData ~= null;
            continue;
        }

        assert(p.productionID == i);
        assert(newGrammar.productionsData.length == i);

        if (regArrayNonterminals.canFind(p.nonterminalID))
            newGrammar.productionsData ~= null;
        else
            newGrammar.productionsData ~= p;
    }

    NonterminalID[size_t] regarrayNonterminals;
    SymbolWithConstraint[][Tuple!(size_t, size_t)] regarrayEdgeSymbols;
    NonterminalID[Tuple!(size_t, size_t)] regarrayEdgeNonterminals;

    bool isFirstStateDest;
    foreach (id; g.nodeIDs)
    {
        auto n = g.get(id);
        foreach (i, e; g.getEdges(id))
        {
            if (e.next.id == g.start.id)
                isFirstStateDest = true;
            auto fromTo = tuple!(size_t, size_t)(id.id, e.next.id);
            if (fromTo !in regarrayEdgeSymbols)
                regarrayEdgeSymbols[fromTo] = [];
            regarrayEdgeSymbols[fromTo].addOnce(e.symbol);
        }
    }
    bool needsFirstState = isFirstStateDest || g.get(g.start).results.length > 0;

    foreach (id; g.nodeIDs)
    {
        if (id == g.start && !needsFirstState)
            continue;
        string name;
        auto results = g.get(id).results;
        if (results.length == 1)
            name = text("$regarray_", realGrammar.nonterminals[results[0]].name, "_", id.id);
        else
            name = text("$regarray_", id.id);
        NonterminalID n = newGrammar.nonterminals.id(name);
        regarrayNonterminals[id.id] = n;
        newGrammar.nonterminals[n].annotations.add("array");
        newGrammar.nonterminals[n].annotations.add("directUnwrap");
    }

    foreach (fromTo; regarrayEdgeSymbols.sortedKeys)
    {
        auto symbols = regarrayEdgeSymbols[fromTo];
        SymbolInstance s;
        if (symbols.length == 1)
        {
            s = SymbolInstance(symbols[0].symbol);
            s.annotations.add("excludeDirectUnwrap");
            s.negLookaheads = symbols[0].constraint.negLookaheads;
        }
        else
        {
            string name;
            name = text("$regarrayedge_", fromTo[0], "_", fromTo[1]);
            NonterminalID n = newGrammar.nonterminals.id(name);
            newGrammar.nonterminals[n].annotations.add("directUnwrap");
            s = SymbolInstance(n);
            regarrayEdgeNonterminals[fromTo] = n;
        }

        Production* p2 = new Production();
        p2.nonterminalID = regarrayNonterminals[fromTo[1]];
        if (!isFirstStateDest && fromTo[0] == 0)
            continue;
        else
        {
            SymbolInstance s0 = SymbolInstance(regarrayNonterminals[fromTo[0]]);
            s0.annotations.add("inheritAnyTag");
            p2.symbols = [s0, s];
        }
        p2.annotations = Annotations();
        newGrammar.addProduction(p2);
    }

    foreach (fromTo; regarrayEdgeSymbols.sortedKeys)
    {
        auto symbols = regarrayEdgeSymbols[fromTo];
        if (symbols.length == 1)
            continue;
        foreach (symbol; symbols)
        {
            Production* p2 = new Production();
            p2.nonterminalID = regarrayEdgeNonterminals[fromTo];
            SymbolInstance si = SymbolInstance(symbol.symbol, "", "", true);
            si.annotations.add("excludeDirectUnwrap");
            si.negLookaheads = symbol.constraint.negLookaheads;
            p2.symbols = [si];
            p2.annotations = Annotations();
            newGrammar.addProduction(p2);
        }
    }

    bool[size_t] startEdgeDone;
    foreach (e; g.getEdges(g.start))
    {
        if (e.next.id in startEdgeDone)
            continue;
        startEdgeDone[e.next.id] = true;

        auto fromTo = tuple!(size_t, size_t)(g.start.id, e.next.id);
        SymbolInstance s;
        if (regarrayEdgeSymbols[fromTo].length == 1)
        {
            s = SymbolInstance(regarrayEdgeSymbols[fromTo][0].symbol);
            s.annotations.add("excludeDirectUnwrap");
            s.negLookaheads = regarrayEdgeSymbols[fromTo][0].constraint.negLookaheads;
        }
        else
        {
            s = SymbolInstance(regarrayEdgeNonterminals[fromTo]);
            s.annotations.add("inheritAnyTag");
        }

        Production* p2 = new Production();
        p2.nonterminalID = regarrayNonterminals[e.next.id];
        p2.symbols = [s];
        p2.annotations = Annotations();
        newGrammar.addProduction(p2);
    }

    foreach (r; g.get(g.start).results)
    {
        Production* p2 = new Production();
        p2.nonterminalID = r;
        p2.symbols = [];
        p2.annotations = Annotations();
        newGrammar.addProduction(p2);
    }

    foreach (id; g.nodeIDs)
    {
        if (id == g.start && !isFirstStateDest)
            continue;
        auto n = g.get(id);
        foreach (r; n.results)
        {
            Production* p2 = new Production();
            p2.nonterminalID = r;
            SymbolInstance s0 = SymbolInstance(regarrayNonterminals[id.id], "", "", true);
            s0.annotations.add("inheritAnyTag");
            p2.symbols = [s0];
            p2.annotations = Annotations();
            newGrammar.addProduction(p2);
            newGrammar.nonterminals[r].annotations.add("directUnwrap");
        }
    }

    newGrammar.calcNonterminalCanBeEmpty();
    newGrammar.fillProductionsForNonterminal();
    newGrammar.calcNonterminalTypes();

    checkGrammar(newGrammar);

    return newGrammar;
}

void writeFinalGrammarFile(string finalgrammarfilename, const EBNFGrammar grammar,
        const EBNFGrammar lexerGrammar)
{
    if (finalgrammarfilename.length)
    {
        File f = File(finalgrammarfilename, "w");

        foreach (n; grammar.nonterminals.allIDs)
        {
            f.writeln(grammar.getSymbolName(n), grammar.nonterminals[n].annotations.toStringCode());
            foreach (i, p; grammar.getProductions(n))
            {
                f.write("\t", i ? "|" : "=", grammar.productionStringRhs(p));
                if (p.symbols.length == 0)
                    f.write(" @empty");
                if (p.isVirtual)
                    f.write(" [virtual]");
                f.writeln();
            }
            f.writeln("\t;");
        }
        f.writeln("\n// Lexer grammar:\n");
        bool[NonterminalID] startNonterminals;
        foreach (n; lexerGrammar.startNonterminals)
            startNonterminals[n.nonterminal] = true;
        foreach (n; lexerGrammar.nonterminals.allIDs)
        {
            if (lexerGrammar.getProductions(n).length == 0)
                continue;
            if (n in startNonterminals)
                f.write("token ");
            else
                f.write("fragment ");
            f.writeln(lexerGrammar.getSymbolName(n),
                    lexerGrammar.nonterminals[n].annotations.toStringCode());
            foreach (i, p; lexerGrammar.getProductions(n))
            {
                f.write("\t", i ? "|" : "=", lexerGrammar.productionStringRhs(p));
                if (p.symbols.length == 0)
                    f.write(" @empty");
                if (p.isVirtual)
                    f.write(" [virtual]");
                f.writeln();
            }
            f.writeln("\t;");
        }
    }
}
