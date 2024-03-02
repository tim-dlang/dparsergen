// Generated with DParserGen.
module dparsergen.generator.grammarebnf_lexer;
import dparsergen.core.grammarinfo;
import dparsergen.core.parseexception;
import dparsergen.core.utils;
import std.conv;
import std.string;
import std.typecons;

enum SymbolID startTokenID = 0;
static assert(allNonterminalTokens.length < SymbolID.max - startTokenID);
enum SymbolID endTokenID = startTokenID + allNonterminalTokens.length;

SymbolID getTokenID(string tok)
{
    foreach (i; 0 .. allNonterminalTokens.length)
        if (allNonterminalTokens[i].name == tok)
            return cast(SymbolID)(startTokenID + i);
    return SymbolID.max;
}

struct Lexer(Location, bool includeIgnoredTokens = false)
{
    alias LocationDiff = typeof(Location.init - Location.init);
    string input;
    this(string input, Location startLocation = Location.init)
    {
        this.input = input;
        this.front.currentLocation = startLocation;
        popFront;
    }

    template tokenID(string tok) if (getTokenID(tok) != SymbolID.max)
    {
        enum tokenID = getTokenID(tok);
    }
    string tokenName(size_t id)
    {
        return allNonterminalTokens[id - startTokenID].name;
    }

    static struct Front
    {
        string content;
        SymbolID symbol;
        Location currentLocation;
        static if (includeIgnoredTokens)
            bool isIgnoreToken;

        Location currentTokenEnd()
        {
            return currentLocation + LocationDiff.fromStr(content);
        }
    }

    Front front;
    bool empty;

    void popFront()
    {
        input = input[front.content.length .. $];
        front.currentLocation = front.currentLocation + LocationDiff.fromStr(front.content);

        popFrontImpl();
    }

    void popFrontImpl()
    {
        size_t foundLength;
        SymbolID foundSymbol = SymbolID.max;
        bool foundIsIgnore;

        string inputCopy = input;

        size_t storedStart = size_t.max;
        string storedString;

        goto start;

    state0:
        // ("!") ("(") (")") ("*") ("+") (",") ("-") ("...") (":") (";") ("<") ("<<") ("=") (">") (">>") ("?") ("@") ("^") ("anytoken") ("fragment") ("import") ("match") ("option") ("t(") ("token") ("{") ("|") ("}") (CharacterSetLiteral) (Identifier) (IntegerLiteral) (StringLiteral) (Space) (LineComment) (BlockComment) (NestingBlockComment)
        // path:
    start:
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[\\t-\\n\\r -\\\"(-\\[\\^-_a-}]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '!')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state9;
                }
                else if (currentChar == '\"')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state96;
                }
                else if (currentChar == '(')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state10;
                }
                else if (currentChar == ')')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state11;
                }
                else if (currentChar == '*')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state12;
                }
                else if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state13;
                }
                else if (currentChar == ',')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state14;
                }
                else if (currentChar == '-')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state15;
                }
                else if (currentChar == '.')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state16;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state2;
                }
                else if (currentChar == '0')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state95;
                }
                else if (currentChar == ':')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state19;
                }
                else if (currentChar == ';')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state20;
                }
                else if (currentChar == '<')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state21;
                }
                else if (currentChar == '=')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state23;
                }
                else if (currentChar == '>')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state24;
                }
                else if (currentChar == '?')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state26;
                }
                else if (currentChar == '@')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state27;
                }
                else if (currentChar == '[')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state72;
                }
                else if (currentChar == '^')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state28;
                }
                else if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state29;
                }
                else if (currentChar == 'f')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state38;
                }
                else if (currentChar == 'i')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state46;
                }
                else if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state52;
                }
                else if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state57;
                }
                else if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state63;
                }
                else if (currentChar == '{')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state69;
                }
                else if (currentChar == '|')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state70;
                }
                else if (currentChar == '}')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state71;
                }
                else if ((currentChar >= '1' && currentChar <= '9'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state94;
                }
                else if ((currentChar >= '\t' && currentChar <= '\n') || currentChar == '\r' || currentChar == ' ')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state1;
                }
                else if ((currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[\\t-\\n\\r -\\\"(-\\[\\^-_a-}]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[\\t-\\n\\r -\\\"(-\\[\\^-_a-}]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state1:
        // Space
        // path: [\t-\n\r ]
        {
            if (inputCopy.length == 0)
                goto endstate1;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '\t' && currentChar <= '\n') || currentChar == '\r' || currentChar == ' ')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state1;
                }
                else
                {
                    goto endstate1;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate1;
                }
            }
        }
        endstate1:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Space";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = true;
            goto lexerend;
        }

    state2:
        // (LineComment) (BlockComment) (NestingBlockComment)
        // path: [/]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[*-+/]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '*')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state4;
                }
                else if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state7;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state3;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[*-+/]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[*-+/]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state3:
        // LineComment
        // path: [/] [/]
        {
            if (inputCopy.length == 0)
                goto endstate3;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '\n' || currentChar == '\r')
                {
                    goto endstate3;
                }

                {
                    inputCopy = inputCopy[1 .. $];
                    goto state3;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state3;
                }
            }
        }
        endstate3:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"LineComment";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = true;
            goto lexerend;
        }

    state4:
        // (BlockComment)
        // path: [/] [*]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '*')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state5;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state4;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state4;
                }
            }
        }

    state5:
        // (BlockComment)
        // path: [/] [*] [*]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '*')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state5;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state6;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state4;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state4;
                }
            }
        }

    state6:
        // BlockComment
        // path: [/] [*] [*] [/]
        {
            if (inputCopy.length == 0)
                goto endstate6;
            goto endstate6;
        }
        endstate6:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"BlockComment";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = true;
            goto lexerend;
        }

    state7:
        // (NestingBlockComment)
        // path: [/] [+]
        {
            // RecursiveLexer
            if (lexPart0(inputCopy, foundSymbol != SymbolID.max))
                goto state8;
            else
                goto lexerend;
        }

    state8:
        // NestingBlockComment
        // path: [/] [+] []
        {
            if (inputCopy.length == 0)
                goto endstate8;
            goto endstate8;
        }
        endstate8:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"NestingBlockComment";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = true;
            goto lexerend;
        }

    state9:
        // "!"
        // path: [!]
        {
            if (inputCopy.length == 0)
                goto endstate9;
            goto endstate9;
        }
        endstate9:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"!\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state10:
        // "("
        // path: [(]
        {
            if (inputCopy.length == 0)
                goto endstate10;
            goto endstate10;
        }
        endstate10:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"(\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state11:
        // ")"
        // path: [)]
        {
            if (inputCopy.length == 0)
                goto endstate11;
            goto endstate11;
        }
        endstate11:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\")\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state12:
        // "*"
        // path: [*]
        {
            if (inputCopy.length == 0)
                goto endstate12;
            goto endstate12;
        }
        endstate12:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"*\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state13:
        // "+"
        // path: [+]
        {
            if (inputCopy.length == 0)
                goto endstate13;
            goto endstate13;
        }
        endstate13:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"+\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state14:
        // ","
        // path: [,]
        {
            if (inputCopy.length == 0)
                goto endstate14;
            goto endstate14;
        }
        endstate14:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\",\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state15:
        // "-"
        // path: [\-]
        {
            if (inputCopy.length == 0)
                goto endstate15;
            goto endstate15;
        }
        endstate15:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"-\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state16:
        // ("...")
        // path: [.]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[.]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '.')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state17:
        // ("...")
        // path: [.] [.]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[.]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '.')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state18;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state18:
        // "..."
        // path: [.] [.] [.]
        {
            if (inputCopy.length == 0)
                goto endstate18;
            goto endstate18;
        }
        endstate18:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"...\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state19:
        // ":"
        // path: [:]
        {
            if (inputCopy.length == 0)
                goto endstate19;
            goto endstate19;
        }
        endstate19:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\":\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state20:
        // ";"
        // path: [;]
        {
            if (inputCopy.length == 0)
                goto endstate20;
            goto endstate20;
        }
        endstate20:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\";\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state21:
        // "<" ("<<")
        // path: [<]
        {
            if (inputCopy.length == 0)
                goto endstate21;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '<')
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"<\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state22;
                }
                else
                {
                    goto endstate21;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate21;
                }
            }
        }
        endstate21:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"<\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state22:
        // "<<"
        // path: [<] [<]
        {
            if (inputCopy.length == 0)
                goto endstate22;
            goto endstate22;
        }
        endstate22:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"<<\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state23:
        // "="
        // path: [=]
        {
            if (inputCopy.length == 0)
                goto endstate23;
            goto endstate23;
        }
        endstate23:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"=\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state24:
        // ">" (">>")
        // path: [>]
        {
            if (inputCopy.length == 0)
                goto endstate24;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '>')
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\">\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state25;
                }
                else
                {
                    goto endstate24;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate24;
                }
            }
        }
        endstate24:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\">\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state25:
        // ">>"
        // path: [>] [>]
        {
            if (inputCopy.length == 0)
                goto endstate25;
            goto endstate25;
        }
        endstate25:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\">>\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state26:
        // "?"
        // path: [?]
        {
            if (inputCopy.length == 0)
                goto endstate26;
            goto endstate26;
        }
        endstate26:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"?\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state27:
        // "@"
        // path: [@]
        {
            if (inputCopy.length == 0)
                goto endstate27;
            goto endstate27;
        }
        endstate27:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"@\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state28:
        // "^"
        // path: [\^]
        {
            if (inputCopy.length == 0)
                goto endstate28;
            goto endstate28;
        }
        endstate28:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"^\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state29:
        // Identifier ("anytoken")
        // path: [a]
        {
            if (inputCopy.length == 0)
                goto endstate29;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state30;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate29;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate29;
                }
            }
        }
        endstate29:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state30:
        // Identifier ("anytoken")
        // path: [a] [n]
        {
            if (inputCopy.length == 0)
                goto endstate30;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'y')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state31;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate30;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate30;
                }
            }
        }
        endstate30:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state31:
        // Identifier ("anytoken")
        // path: [a] [n] [y]
        {
            if (inputCopy.length == 0)
                goto endstate31;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state32;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate31;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate31;
                }
            }
        }
        endstate31:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state32:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t]
        {
            if (inputCopy.length == 0)
                goto endstate32;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state33;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate32;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate32;
                }
            }
        }
        endstate32:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state33:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o]
        {
            if (inputCopy.length == 0)
                goto endstate33;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'k')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state34;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate33;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate33;
                }
            }
        }
        endstate33:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state34:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o] [k]
        {
            if (inputCopy.length == 0)
                goto endstate34;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state35;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate34;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate34;
                }
            }
        }
        endstate34:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state35:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o] [k] [e]
        {
            if (inputCopy.length == 0)
                goto endstate35;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state36;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate35;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate35;
                }
            }
        }
        endstate35:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state36:
        // "anytoken" Identifier
        // path: [a] [n] [y] [t] [o] [k] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate36;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"anytoken\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate36;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate36;
                }
            }
        }
        endstate36:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"anytoken\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state37:
        // Identifier
        // path: [A-Z_b-eg-hj-lnp-su-z]
        {
            if (inputCopy.length == 0)
                goto endstate37;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate37;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate37;
                }
            }
        }
        endstate37:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state38:
        // Identifier ("fragment")
        // path: [f]
        {
            if (inputCopy.length == 0)
                goto endstate38;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'r')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state39;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate38;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate38;
                }
            }
        }
        endstate38:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state39:
        // Identifier ("fragment")
        // path: [f] [r]
        {
            if (inputCopy.length == 0)
                goto endstate39;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state40;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate39;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate39;
                }
            }
        }
        endstate39:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state40:
        // Identifier ("fragment")
        // path: [f] [r] [a]
        {
            if (inputCopy.length == 0)
                goto endstate40;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'g')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state41;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate40;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate40;
                }
            }
        }
        endstate40:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state41:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g]
        {
            if (inputCopy.length == 0)
                goto endstate41;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state42;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate41;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate41;
                }
            }
        }
        endstate41:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state42:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m]
        {
            if (inputCopy.length == 0)
                goto endstate42;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state43;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate42;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate42;
                }
            }
        }
        endstate42:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state43:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m] [e]
        {
            if (inputCopy.length == 0)
                goto endstate43;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state44;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate43;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate43;
                }
            }
        }
        endstate43:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state44:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate44;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state45;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate44;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate44;
                }
            }
        }
        endstate44:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state45:
        // "fragment" Identifier
        // path: [f] [r] [a] [g] [m] [e] [n] [t]
        {
            if (inputCopy.length == 0)
                goto endstate45;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"fragment\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate45;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate45;
                }
            }
        }
        endstate45:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"fragment\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state46:
        // Identifier ("import")
        // path: [i]
        {
            if (inputCopy.length == 0)
                goto endstate46;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state47;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate46;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate46;
                }
            }
        }
        endstate46:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state47:
        // Identifier ("import")
        // path: [i] [m]
        {
            if (inputCopy.length == 0)
                goto endstate47;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'p')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state48;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate47;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate47;
                }
            }
        }
        endstate47:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state48:
        // Identifier ("import")
        // path: [i] [m] [p]
        {
            if (inputCopy.length == 0)
                goto endstate48;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state49;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate48;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate48;
                }
            }
        }
        endstate48:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state49:
        // Identifier ("import")
        // path: [i] [m] [p] [o]
        {
            if (inputCopy.length == 0)
                goto endstate49;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'r')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state50;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate49;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate49;
                }
            }
        }
        endstate49:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state50:
        // Identifier ("import")
        // path: [i] [m] [p] [o] [r]
        {
            if (inputCopy.length == 0)
                goto endstate50;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state51;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate50;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate50;
                }
            }
        }
        endstate50:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state51:
        // "import" Identifier
        // path: [i] [m] [p] [o] [r] [t]
        {
            if (inputCopy.length == 0)
                goto endstate51;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"import\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate51;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate51;
                }
            }
        }
        endstate51:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"import\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state52:
        // Identifier ("match")
        // path: [m]
        {
            if (inputCopy.length == 0)
                goto endstate52;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state53;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate52;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate52;
                }
            }
        }
        endstate52:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state53:
        // Identifier ("match")
        // path: [m] [a]
        {
            if (inputCopy.length == 0)
                goto endstate53;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state54;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate53;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate53;
                }
            }
        }
        endstate53:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state54:
        // Identifier ("match")
        // path: [m] [a] [t]
        {
            if (inputCopy.length == 0)
                goto endstate54;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'c')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state55;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate54;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate54;
                }
            }
        }
        endstate54:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state55:
        // Identifier ("match")
        // path: [m] [a] [t] [c]
        {
            if (inputCopy.length == 0)
                goto endstate55;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'h')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state56;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate55;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate55;
                }
            }
        }
        endstate55:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state56:
        // "match" Identifier
        // path: [m] [a] [t] [c] [h]
        {
            if (inputCopy.length == 0)
                goto endstate56;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"match\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate56;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate56;
                }
            }
        }
        endstate56:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"match\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state57:
        // Identifier ("option")
        // path: [o]
        {
            if (inputCopy.length == 0)
                goto endstate57;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'p')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state58;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate57;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate57;
                }
            }
        }
        endstate57:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state58:
        // Identifier ("option")
        // path: [o] [p]
        {
            if (inputCopy.length == 0)
                goto endstate58;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state59;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate58;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate58;
                }
            }
        }
        endstate58:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state59:
        // Identifier ("option")
        // path: [o] [p] [t]
        {
            if (inputCopy.length == 0)
                goto endstate59;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'i')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state60;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate59;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate59;
                }
            }
        }
        endstate59:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state60:
        // Identifier ("option")
        // path: [o] [p] [t] [i]
        {
            if (inputCopy.length == 0)
                goto endstate60;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state61;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate60;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate60;
                }
            }
        }
        endstate60:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state61:
        // Identifier ("option")
        // path: [o] [p] [t] [i] [o]
        {
            if (inputCopy.length == 0)
                goto endstate61;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state62;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate61;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate61;
                }
            }
        }
        endstate61:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state62:
        // "option" Identifier
        // path: [o] [p] [t] [i] [o] [n]
        {
            if (inputCopy.length == 0)
                goto endstate62;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"option\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate62;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate62;
                }
            }
        }
        endstate62:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"option\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state63:
        // Identifier ("t(") ("token")
        // path: [t]
        {
            if (inputCopy.length == 0)
                goto endstate63;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '(')
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"Identifier";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state64;
                }
                else if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state65;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate63;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate63;
                }
            }
        }
        endstate63:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state64:
        // "t("
        // path: [t] [(]
        {
            if (inputCopy.length == 0)
                goto endstate64;
            goto endstate64;
        }
        endstate64:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"t(\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state65:
        // Identifier ("token")
        // path: [t] [o]
        {
            if (inputCopy.length == 0)
                goto endstate65;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'k')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state66;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate65;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate65;
                }
            }
        }
        endstate65:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state66:
        // Identifier ("token")
        // path: [t] [o] [k]
        {
            if (inputCopy.length == 0)
                goto endstate66;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state67;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate66;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate66;
                }
            }
        }
        endstate66:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state67:
        // Identifier ("token")
        // path: [t] [o] [k] [e]
        {
            if (inputCopy.length == 0)
                goto endstate67;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state68;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate67;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate67;
                }
            }
        }
        endstate67:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state68:
        // "token" Identifier
        // path: [t] [o] [k] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate68;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    assert(inputCopy.ptr >= input.ptr);
                    foundSymbol = tokenID!"\"token\"";
                    foundLength = inputCopy.ptr - input.ptr;
                    foundIsIgnore = false;
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else
                {
                    goto endstate68;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate68;
                }
            }
        }
        endstate68:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"token\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state69:
        // "{"
        // path: [{]
        {
            if (inputCopy.length == 0)
                goto endstate69;
            goto endstate69;
        }
        endstate69:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"{\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state70:
        // "|"
        // path: [|]
        {
            if (inputCopy.length == 0)
                goto endstate70;
            goto endstate70;
        }
        endstate70:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"|\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state71:
        // "}"
        // path: [}]
        {
            if (inputCopy.length == 0)
                goto endstate71;
            goto endstate71;
        }
        endstate71:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"}\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state72:
        // (CharacterSetLiteral)
        // path: [\[]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^\\-\\[]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state75;
                }
                else if (currentChar == ']')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state74;
                }
                else if (currentChar == '-' || currentChar == '[')
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[^\\-\\[]", inputCopy.ptr - input.ptr);
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state73;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state73;
                }
            }
        }

    state73:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^\\[]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '-')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state76;
                }
                else if (currentChar == '[')
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[^\\[]", inputCopy.ptr - input.ptr);
                }
                else if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state75;
                }
                else if (currentChar == ']')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state74;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state73;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state73;
                }
            }
        }

    state74:
        // CharacterSetLiteral
        // path: [\[] [\]]
        {
            if (inputCopy.length == 0)
                goto endstate74;
            goto endstate74;
        }
        endstate74:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"CharacterSetLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state75:
        // (CharacterSetLiteral)
        // path: [\[] [\\]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'U')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state90;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state88;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state86;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state73;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state76:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^\\-\\[\\]]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state77;
                }
                else if (currentChar == '-' || (currentChar >= '[' && currentChar <= ']'))
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[^\\-\\[\\]]", inputCopy.ptr - input.ptr);
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state72;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state72;
                }
            }
        }

    state77:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'U')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state82;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state80;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state78;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state72;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state78:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [x]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state79;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state79:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [x] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state72;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state80:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [u]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state81;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state81:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [u] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state78;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state82:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [U]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state83;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state83:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [U] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state84;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state84:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state85;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state85:
        // (CharacterSetLiteral)
        // path: [\[] [^\-\[-\]] [\-] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state80;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state86:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [x]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state87;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state87:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [x] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state73;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state88:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [u]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state89;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state89:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [u] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state86;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state90:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [U]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state91;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state91:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [U] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state92;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state92:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state93;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state93:
        // (CharacterSetLiteral)
        // path: [\[] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state88;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state94:
        // IntegerLiteral
        // path: [1-9]
        {
            if (inputCopy.length == 0)
                goto endstate94;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state94;
                }
                else
                {
                    goto endstate94;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate94;
                }
            }
        }
        endstate94:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"IntegerLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state95:
        // IntegerLiteral
        // path: [0]
        {
            if (inputCopy.length == 0)
                goto endstate95;
            goto endstate95;
        }
        endstate95:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"IntegerLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state96:
        // (StringLiteral)
        // path: [\"]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[^\\n\\r]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '\"')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state97;
                }
                else if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state98;
                }
                else if (currentChar == '\n' || currentChar == '\r')
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[^\\n\\r]", inputCopy.ptr - input.ptr);
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state96;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state96;
                }
            }
        }

    state97:
        // StringLiteral
        // path: [\"] [\"]
        {
            if (inputCopy.length == 0)
                goto endstate97;
            goto endstate97;
        }
        endstate97:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"StringLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state98:
        // (StringLiteral)
        // path: [\"] [\\]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'U')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state103;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state101;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state99;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state96;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state99:
        // (StringLiteral)
        // path: [\"] [\\] [x]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state100;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state100:
        // (StringLiteral)
        // path: [\"] [\\] [x] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state96;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state101:
        // (StringLiteral)
        // path: [\"] [\\] [u]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state102;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state102:
        // (StringLiteral)
        // path: [\"] [\\] [u] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state99;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state103:
        // (StringLiteral)
        // path: [\"] [\\] [U]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state104;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state104:
        // (StringLiteral)
        // path: [\"] [\\] [U] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state105;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state105:
        // (StringLiteral)
        // path: [\"] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state106;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state106:
        // (StringLiteral)
        // path: [\"] [\\] [U] [0-9A-Fa-f] [0-9A-Fa-f] [0-9A-Fa-f]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    goto lexerend;
                else if (foundSymbol != SymbolID.max)
                    goto lexerend;
                else
                    throw lexerException("EOF", "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'F') || (currentChar >= 'a' && currentChar <= 'f'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state101;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentDchar.escapeChar(false), "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

        lexerend:

        if (foundSymbol != SymbolID.max)
        {
            if (foundLength == 0)
            {
                if (!inputCopy.empty)
                    throw lexerException("no token", null, inputCopy.ptr + 1 - input.ptr);
                else
                {
                    front.content = "";
                    front.symbol = SymbolID(0);
                    static if (includeIgnoredTokens)
                        front.isIgnoreToken = false;
                    empty = true;
                    return;
                }
            }
            static if (!includeIgnoredTokens)
            {
                if (foundIsIgnore)
                {
                    front.currentLocation = front.currentLocation + LocationDiff.fromStr(input[0 .. foundLength]);
                    input = input[foundLength .. $];
                    inputCopy = input;
                    foundLength = 0;
                    foundIsIgnore = false;
                    foundSymbol = SymbolID.max;
                    storedStart = size_t.max;
                    storedString = null;
                    goto start;
                }
            }
            front.content = input[0 .. foundLength];
            front.symbol = foundSymbol;
            static if (includeIgnoredTokens)
                front.isIgnoreToken = foundIsIgnore;
            empty = false;
            return;
        }
        else if (input.length == 0)
        {
            front.content = "";
            front.symbol = SymbolID(0);
            static if (includeIgnoredTokens)
                front.isIgnoreToken = false;
            empty = true;
            return;
        }
        else
            throw lexerException("no token", null, 1);
    }

    // NestingBlockCommentPart* "+"* "+/"
    private bool lexPart0(ref string inputCopy, bool hasPreviousSymbol)
    {
    state0:
        // ($m_0)
        // path:
    start:
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    return false;
                else if (hasPreviousSymbol)
                    return false;
                else
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state1;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state3;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state0;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state0;
                }
            }
        }

    state1:
        // ($m_0)
        // path: [+]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    return false;
                else if (hasPreviousSymbol)
                    return false;
                else
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state1;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state2;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state0;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state0;
                }
            }
        }

    state2:
        // $m_0
        // path: [+] [/]
        {
            if (inputCopy.length == 0)
                return true;
            return true;
        }
        endstate2:

    state3:
        // ($m_0)
        // path: [/]
        {
            if (inputCopy.length == 0)
            {
                if (input.ptr == inputCopy.ptr)
                    return false;
                else if (hasPreviousSymbol)
                    return false;
                else
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state4;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state3;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state0;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state0;
                }
            }
        }

    state4:
        // ($m_0)
        // path: [/] [+]
        {
            // RecursiveLexer
            if (lexPart0(inputCopy, hasPreviousSymbol))
                goto state0;
            else
                return false;
        }

        assert(false);
    }

    SingleParseException!Location lexerException(string errorText, string expected, size_t len,
            string file = __FILE__, size_t line = __LINE__)
    {
        string str = errorText;
        if (expected.length)
            str ~= ", expected " ~ expected;
        return new SingleParseException!Location(str, front.currentLocation, front.currentLocation, file, line);
    }
}

immutable allNonterminalTokens = [
    /* 0: */ immutable(Nonterminal)("$null", NonterminalFlags.none, [], []),
    /* 1: */ immutable(Nonterminal)("\"!\"", NonterminalFlags.none, [], []),
    /* 2: */ immutable(Nonterminal)("\"(\"", NonterminalFlags.none, [], []),
    /* 3: */ immutable(Nonterminal)("\")\"", NonterminalFlags.none, [], []),
    /* 4: */ immutable(Nonterminal)("\"*\"", NonterminalFlags.none, [], []),
    /* 5: */ immutable(Nonterminal)("\"+\"", NonterminalFlags.none, [], []),
    /* 6: */ immutable(Nonterminal)("\",\"", NonterminalFlags.none, [], []),
    /* 7: */ immutable(Nonterminal)("\"-\"", NonterminalFlags.none, [], []),
    /* 8: */ immutable(Nonterminal)("\"...\"", NonterminalFlags.none, [], []),
    /* 9: */ immutable(Nonterminal)("\":\"", NonterminalFlags.none, [], []),
    /* 10: */ immutable(Nonterminal)("\";\"", NonterminalFlags.none, [], []),
    /* 11: */ immutable(Nonterminal)("\"<\"", NonterminalFlags.none, [], []),
    /* 12: */ immutable(Nonterminal)("\"<<\"", NonterminalFlags.none, [], []),
    /* 13: */ immutable(Nonterminal)("\"=\"", NonterminalFlags.none, [], []),
    /* 14: */ immutable(Nonterminal)("\">\"", NonterminalFlags.none, [], []),
    /* 15: */ immutable(Nonterminal)("\">>\"", NonterminalFlags.none, [], []),
    /* 16: */ immutable(Nonterminal)("\"?\"", NonterminalFlags.none, [], []),
    /* 17: */ immutable(Nonterminal)("\"@\"", NonterminalFlags.none, [], []),
    /* 18: */ immutable(Nonterminal)("\"^\"", NonterminalFlags.none, [], []),
    /* 19: */ immutable(Nonterminal)("\"anytoken\"", NonterminalFlags.none, [], []),
    /* 20: */ immutable(Nonterminal)("\"fragment\"", NonterminalFlags.none, [], []),
    /* 21: */ immutable(Nonterminal)("\"import\"", NonterminalFlags.none, [], []),
    /* 22: */ immutable(Nonterminal)("\"match\"", NonterminalFlags.none, [], []),
    /* 23: */ immutable(Nonterminal)("\"option\"", NonterminalFlags.none, [], []),
    /* 24: */ immutable(Nonterminal)("\"t(\"", NonterminalFlags.none, [], []),
    /* 25: */ immutable(Nonterminal)("\"token\"", NonterminalFlags.none, [], []),
    /* 26: */ immutable(Nonterminal)("\"{\"", NonterminalFlags.none, [], []),
    /* 27: */ immutable(Nonterminal)("\"|\"", NonterminalFlags.none, [], []),
    /* 28: */ immutable(Nonterminal)("\"}\"", NonterminalFlags.none, [], []),
    /* 29: */ immutable(Nonterminal)("CharacterSetLiteral", NonterminalFlags.none, [], []),
    /* 30: */ immutable(Nonterminal)("Identifier", NonterminalFlags.none, ["lowPrio"], []),
    /* 31: */ immutable(Nonterminal)("IntegerLiteral", NonterminalFlags.none, [], []),
    /* 32: */ immutable(Nonterminal)("StringLiteral", NonterminalFlags.none, [], []),
    /* 33: */ immutable(Nonterminal)("StringPart", NonterminalFlags.none, [], []),
    /* 34: */ immutable(Nonterminal)("CharacterSetPart", NonterminalFlags.none, [], []),
    /* 35: */ immutable(Nonterminal)("CharacterSetPart2", NonterminalFlags.none, [], []),
    /* 36: */ immutable(Nonterminal)("EscapeSequence", NonterminalFlags.none, [], []),
    /* 37: */ immutable(Nonterminal)("Hex", NonterminalFlags.none, [], []),
    /* 38: */ immutable(Nonterminal)("Space", NonterminalFlags.none, ["ignoreToken"], []),
    /* 39: */ immutable(Nonterminal)("LineComment", NonterminalFlags.none, ["ignoreToken"], []),
    /* 40: */ immutable(Nonterminal)("BlockComment", NonterminalFlags.none, ["ignoreToken"], []),
    /* 41: */ immutable(Nonterminal)("BlockCommentPart", NonterminalFlags.none, [], []),
    /* 42: */ immutable(Nonterminal)("NestingBlockComment", NonterminalFlags.none, ["ignoreToken"], []),
    /* 43: */ immutable(Nonterminal)("NestingBlockCommentPart", NonterminalFlags.none, [], []),
    /* 44: */ immutable(Nonterminal)("[a-zA-Z0-9_]+", NonterminalFlags.none, ["array"], []),
    /* 45: */ immutable(Nonterminal)("[a-zA-Z0-9_]*", NonterminalFlags.none, ["array"], []),
    /* 46: */ immutable(Nonterminal)("StringPart+", NonterminalFlags.none, ["array"], []),
    /* 47: */ immutable(Nonterminal)("StringPart*", NonterminalFlags.none, ["array"], []),
    /* 48: */ immutable(Nonterminal)("\"^\"?", NonterminalFlags.none, [], []),
    /* 49: */ immutable(Nonterminal)("CharacterSetPart+", NonterminalFlags.none, ["array"], []),
    /* 50: */ immutable(Nonterminal)("CharacterSetPart*", NonterminalFlags.none, ["array"], []),
    /* 51: */ immutable(Nonterminal)("[0-9]+", NonterminalFlags.none, ["array"], []),
    /* 52: */ immutable(Nonterminal)("[0-9]*", NonterminalFlags.none, ["array"], []),
    /* 53: */ immutable(Nonterminal)("[_\\n\\r\\t]+", NonterminalFlags.none, ["array"], []),
    /* 54: */ immutable(Nonterminal)("[^\\n\\r]+", NonterminalFlags.none, ["array"], []),
    /* 55: */ immutable(Nonterminal)("[^\\n\\r]*", NonterminalFlags.none, ["array"], []),
    /* 56: */ immutable(Nonterminal)("BlockCommentPart+", NonterminalFlags.none, ["array"], []),
    /* 57: */ immutable(Nonterminal)("BlockCommentPart*", NonterminalFlags.none, ["array"], []),
    /* 58: */ immutable(Nonterminal)("\"*\"+", NonterminalFlags.none, ["array"], []),
    /* 59: */ immutable(Nonterminal)("\"*\"*", NonterminalFlags.none, ["array"], []),
    /* 60: */ immutable(Nonterminal)("NestingBlockCommentPart+", NonterminalFlags.none, ["array"], []),
    /* 61: */ immutable(Nonterminal)("NestingBlockCommentPart*", NonterminalFlags.none, ["array"], []),
    /* 62: */ immutable(Nonterminal)("\"+\"+", NonterminalFlags.none, ["array"], []),
    /* 63: */ immutable(Nonterminal)("\"+\"*", NonterminalFlags.none, ["array"], []),
    /* 64: */ immutable(Nonterminal)("\"/\"+", NonterminalFlags.none, ["array"], []),
    /* 65: */ immutable(Nonterminal)("\"/\"*", NonterminalFlags.none, ["array"], []),
];
