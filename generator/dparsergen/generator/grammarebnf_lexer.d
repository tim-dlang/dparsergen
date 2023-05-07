// Generated with DParserGen.
module dparsergen.generator.grammarebnf_lexer;
import dparsergen.core.grammarinfo;
import dparsergen.core.parseexception;
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

    enum tokenID(string tok) = getTokenID(tok);
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
        // (Identifier) (StringLiteral) (CharacterSetLiteral) (IntegerLiteral) (";") ("=") ("fragment") ("token") ("(") (")") (",") ("...") ("option") ("import") ("match") ("@") (":") ("{") ("}") ("?") ("!") ("<") (">") ("*") (">>") ("<<") ("-") ("anytoken") ("|") ("^") ("+") ("t(") (Space) (LineComment) (BlockComment) (NestingBlockComment)
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
                    goto state97;
                }
                else if (currentChar == '\"')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state49;
                }
                else if (currentChar == '(')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state86;
                }
                else if (currentChar == ')')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state87;
                }
                else if (currentChar == '*')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state102;
                }
                else if (currentChar == '+')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state106;
                }
                else if (currentChar == ',')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state88;
                }
                else if (currentChar == '-')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state103;
                }
                else if (currentChar == '.')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state89;
                }
                else if (currentChar == '/')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state2;
                }
                else if (currentChar == '0')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state83;
                }
                else if (currentChar == ':')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state93;
                }
                else if (currentChar == ';')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state84;
                }
                else if (currentChar == '<')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state98;
                }
                else if (currentChar == '=')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state85;
                }
                else if (currentChar == '>')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state100;
                }
                else if (currentChar == '?')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state96;
                }
                else if (currentChar == '@')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state92;
                }
                else if (currentChar == '[')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state60;
                }
                else if (currentChar == '^')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state105;
                }
                else if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state18;
                }
                else if (currentChar == 'f')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state9;
                }
                else if (currentChar == 'i')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state43;
                }
                else if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state26;
                }
                else if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state37;
                }
                else if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state31;
                }
                else if (currentChar == '{')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state94;
                }
                else if (currentChar == '|')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state104;
                }
                else if (currentChar == '}')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state95;
                }
                else if ((currentChar >= '1' && currentChar <= '9'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state82;
                }
                else if ((currentChar >= '\t' && currentChar <= '\n') || currentChar == '\r' || currentChar == ' ')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state1;
                }
                else if ((currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[\\t-\\n\\r -\\\"(-\\[\\^-_a-}]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[\\t-\\n\\r -\\\"(-\\[\\^-_a-}]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[*-+/]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[*-+/]", inputCopy.ptr - input.ptr);
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
        // Identifier ("fragment")
        // path: [f]
        {
            if (inputCopy.length == 0)
                goto endstate9;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'r')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state10;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate9;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate9;
                }
            }
        }
        endstate9:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state10:
        // Identifier ("fragment")
        // path: [f] [r]
        {
            if (inputCopy.length == 0)
                goto endstate10;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state11;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate10;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate10;
                }
            }
        }
        endstate10:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state11:
        // Identifier ("fragment")
        // path: [f] [r] [a]
        {
            if (inputCopy.length == 0)
                goto endstate11;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'g')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state12;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate11;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate11;
                }
            }
        }
        endstate11:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state12:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g]
        {
            if (inputCopy.length == 0)
                goto endstate12;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state13;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate12;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate12;
                }
            }
        }
        endstate12:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state13:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m]
        {
            if (inputCopy.length == 0)
                goto endstate13;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state14;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate13;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate13;
                }
            }
        }
        endstate13:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state14:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m] [e]
        {
            if (inputCopy.length == 0)
                goto endstate14;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state15;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate14;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate14;
                }
            }
        }
        endstate14:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state15:
        // Identifier ("fragment")
        // path: [f] [r] [a] [g] [m] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate15;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state16;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate15;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate15;
                }
            }
        }
        endstate15:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state16:
        // "fragment" Identifier
        // path: [f] [r] [a] [g] [m] [e] [n] [t]
        {
            if (inputCopy.length == 0)
                goto endstate16;
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
                    goto state17;
                }
                else
                {
                    goto endstate16;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate16;
                }
            }
        }
        endstate16:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"fragment\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state17:
        // Identifier
        // path: [A-Z_b-eg-hj-lnp-su-z]
        {
            if (inputCopy.length == 0)
                goto endstate17;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate17;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate17;
                }
            }
        }
        endstate17:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state18:
        // Identifier ("anytoken")
        // path: [a]
        {
            if (inputCopy.length == 0)
                goto endstate18;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state19;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate18;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate18;
                }
            }
        }
        endstate18:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state19:
        // Identifier ("anytoken")
        // path: [a] [n]
        {
            if (inputCopy.length == 0)
                goto endstate19;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'y')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state20;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate19;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate19;
                }
            }
        }
        endstate19:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state20:
        // Identifier ("anytoken")
        // path: [a] [n] [y]
        {
            if (inputCopy.length == 0)
                goto endstate20;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state21;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate20;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate20;
                }
            }
        }
        endstate20:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state21:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t]
        {
            if (inputCopy.length == 0)
                goto endstate21;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state22;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state22:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o]
        {
            if (inputCopy.length == 0)
                goto endstate22;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'k')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state23;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate22;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate22;
                }
            }
        }
        endstate22:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state23:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o] [k]
        {
            if (inputCopy.length == 0)
                goto endstate23;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state24;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate23;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate23;
                }
            }
        }
        endstate23:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state24:
        // Identifier ("anytoken")
        // path: [a] [n] [y] [t] [o] [k] [e]
        {
            if (inputCopy.length == 0)
                goto endstate24;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state25;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state25:
        // "anytoken" Identifier
        // path: [a] [n] [y] [t] [o] [k] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate25;
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
                    goto state17;
                }
                else
                {
                    goto endstate25;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate25;
                }
            }
        }
        endstate25:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"anytoken\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state26:
        // Identifier ("match")
        // path: [m]
        {
            if (inputCopy.length == 0)
                goto endstate26;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'a')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state27;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'b' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate26;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate26;
                }
            }
        }
        endstate26:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state27:
        // Identifier ("match")
        // path: [m] [a]
        {
            if (inputCopy.length == 0)
                goto endstate27;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state28;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate27;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate27;
                }
            }
        }
        endstate27:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state28:
        // Identifier ("match")
        // path: [m] [a] [t]
        {
            if (inputCopy.length == 0)
                goto endstate28;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'c')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state29;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
                }
                else
                {
                    goto endstate28;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate28;
                }
            }
        }
        endstate28:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state29:
        // Identifier ("match")
        // path: [m] [a] [t] [c]
        {
            if (inputCopy.length == 0)
                goto endstate29;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'h')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state30;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // "match" Identifier
        // path: [m] [a] [t] [c] [h]
        {
            if (inputCopy.length == 0)
                goto endstate30;
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
                    goto state17;
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
            foundSymbol = tokenID!"\"match\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state31:
        // Identifier ("token") ("t(")
        // path: [t]
        {
            if (inputCopy.length == 0)
                goto endstate31;
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
                    goto state36;
                }
                else if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state32;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("token")
        // path: [t] [o]
        {
            if (inputCopy.length == 0)
                goto endstate32;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'k')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state33;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("token")
        // path: [t] [o] [k]
        {
            if (inputCopy.length == 0)
                goto endstate33;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'e')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state34;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("token")
        // path: [t] [o] [k] [e]
        {
            if (inputCopy.length == 0)
                goto endstate34;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state35;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // "token" Identifier
        // path: [t] [o] [k] [e] [n]
        {
            if (inputCopy.length == 0)
                goto endstate35;
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
                    goto state17;
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
            foundSymbol = tokenID!"\"token\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state36:
        // "t("
        // path: [t] [(]
        {
            if (inputCopy.length == 0)
                goto endstate36;
            goto endstate36;
        }
        endstate36:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"t(\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state37:
        // Identifier ("option")
        // path: [o]
        {
            if (inputCopy.length == 0)
                goto endstate37;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'p')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state38;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("option")
        // path: [o] [p]
        {
            if (inputCopy.length == 0)
                goto endstate38;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state39;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("option")
        // path: [o] [p] [t]
        {
            if (inputCopy.length == 0)
                goto endstate39;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'i')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state40;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("option")
        // path: [o] [p] [t] [i]
        {
            if (inputCopy.length == 0)
                goto endstate40;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state41;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("option")
        // path: [o] [p] [t] [i] [o]
        {
            if (inputCopy.length == 0)
                goto endstate41;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'n')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state42;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // "option" Identifier
        // path: [o] [p] [t] [i] [o] [n]
        {
            if (inputCopy.length == 0)
                goto endstate42;
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
                    goto state17;
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
            foundSymbol = tokenID!"\"option\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state43:
        // Identifier ("import")
        // path: [i]
        {
            if (inputCopy.length == 0)
                goto endstate43;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'm')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state44;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("import")
        // path: [i] [m]
        {
            if (inputCopy.length == 0)
                goto endstate44;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'p')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state45;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // Identifier ("import")
        // path: [i] [m] [p]
        {
            if (inputCopy.length == 0)
                goto endstate45;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'o')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state46;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
            foundSymbol = tokenID!"Identifier";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state46:
        // Identifier ("import")
        // path: [i] [m] [p] [o]
        {
            if (inputCopy.length == 0)
                goto endstate46;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 'r')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state47;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // path: [i] [m] [p] [o] [r]
        {
            if (inputCopy.length == 0)
                goto endstate47;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == 't')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state48;
                }
                else if ((currentChar >= '0' && currentChar <= '9') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_' || (currentChar >= 'a' && currentChar <= 'z'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state17;
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
        // "import" Identifier
        // path: [i] [m] [p] [o] [r] [t]
        {
            if (inputCopy.length == 0)
                goto endstate48;
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
                    goto state17;
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
            foundSymbol = tokenID!"\"import\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state49:
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
                    throw lexerException("EOF", "[^]", inputCopy.ptr - input.ptr);
            }
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if (currentChar == '\"')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state50;
                }
                else if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state51;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state49;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state49;
                }
            }
        }

    state50:
        // StringLiteral
        // path: [\"] [\"]
        {
            if (inputCopy.length == 0)
                goto endstate50;
            goto endstate50;
        }
        endstate50:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"StringLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state51:
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
                    goto state56;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state54;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state52;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state49;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state52:
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
                    goto state53;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state53:
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
                    goto state49;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state54:
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
                    goto state55;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state55:
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
                    goto state52;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state56:
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
                    goto state57;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state57:
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
                    goto state58;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state58:
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
                    goto state59;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state59:
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
                    goto state54;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state60:
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
                    goto state63;
                }
                else if (currentChar == ']')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state62;
                }
                else if (currentChar == '-' || currentChar == '[')
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[^\\-\\[]", inputCopy.ptr - input.ptr);
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state61;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state61;
                }
            }
        }

    state61:
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
                    goto state64;
                }
                else if (currentChar == '[')
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[^\\[]", inputCopy.ptr - input.ptr);
                }
                else if (currentChar == '\\')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state63;
                }
                else if (currentChar == ']')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state62;
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state61;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state61;
                }
            }
        }

    state62:
        // CharacterSetLiteral
        // path: [\[] [\]]
        {
            if (inputCopy.length == 0)
                goto endstate62;
            goto endstate62;
        }
        endstate62:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"CharacterSetLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state63:
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
                    goto state78;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state76;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state74;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state61;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state64:
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
                    goto state65;
                }
                else if (currentChar == '-' || (currentChar >= '[' && currentChar <= ']'))
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[^\\-\\[\\]]", inputCopy.ptr - input.ptr);
                }
                else
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state60;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    inputCopy = inputCopyNext;
                    goto state60;
                }
            }
        }

    state65:
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
                    goto state70;
                }
                else if (currentChar == 'u')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state68;
                }
                else if (currentChar == 'x')
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state66;
                }
                else if (currentChar == '\"' || currentChar == '\'' || currentChar == '-' || currentChar == '0' || (currentChar >= '[' && currentChar <= ']') || (currentChar >= 'a' && currentChar <= 'b') || currentChar == 'f' || currentChar == 'n' || currentChar == 'r' || (currentChar >= 't' && currentChar <= 'v'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state60;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[\\\"\\\'\\-0U\\[-\\]a-bfnrt-vx]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state66:
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
                    goto state67;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state67:
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
                    goto state60;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state68:
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
                    goto state69;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state69:
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
                    goto state66;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state70:
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
                    goto state71;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state71:
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
                    goto state72;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state72:
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
                    goto state73;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state73:
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
                    goto state68;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state74:
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
                    goto state75;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state75:
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
                    goto state61;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state76:
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
                    goto state77;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state77:
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
                    goto state74;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state78:
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
                    goto state79;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state79:
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
                    goto state80;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state80:
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
                    goto state81;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state81:
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
                    goto state76;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[0-9A-Fa-f]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state82:
        // IntegerLiteral
        // path: [1-9]
        {
            if (inputCopy.length == 0)
                goto endstate82;
            char currentChar = inputCopy[0];
            if (currentChar < 0x80)
            {
                if ((currentChar >= '0' && currentChar <= '9'))
                {
                    inputCopy = inputCopy[1 .. $];
                    goto state82;
                }
                else
                {
                    goto endstate82;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate82;
                }
            }
        }
        endstate82:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"IntegerLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state83:
        // IntegerLiteral
        // path: [0]
        {
            if (inputCopy.length == 0)
                goto endstate83;
            goto endstate83;
        }
        endstate83:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"IntegerLiteral";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state84:
        // ";"
        // path: [;]
        {
            if (inputCopy.length == 0)
                goto endstate84;
            goto endstate84;
        }
        endstate84:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\";\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state85:
        // "="
        // path: [=]
        {
            if (inputCopy.length == 0)
                goto endstate85;
            goto endstate85;
        }
        endstate85:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"=\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state86:
        // "("
        // path: [(]
        {
            if (inputCopy.length == 0)
                goto endstate86;
            goto endstate86;
        }
        endstate86:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"(\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state87:
        // ")"
        // path: [)]
        {
            if (inputCopy.length == 0)
                goto endstate87;
            goto endstate87;
        }
        endstate87:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\")\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state88:
        // ","
        // path: [,]
        {
            if (inputCopy.length == 0)
                goto endstate88;
            goto endstate88;
        }
        endstate88:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\",\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state89:
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
                    goto state90;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[.]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state90:
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
                    goto state91;
                }
                else
                {
                    if (foundSymbol != SymbolID.max)
                        goto lexerend;
                    else
                        throw lexerException(text("Error unexpected \'", currentChar, "\'"), "[.]", inputCopy.ptr - input.ptr);
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
                        throw lexerException(text("Error unexpected \'", currentDchar, "\'"), "[.]", inputCopy.ptr - input.ptr);
                }
            }
        }

    state91:
        // "..."
        // path: [.] [.] [.]
        {
            if (inputCopy.length == 0)
                goto endstate91;
            goto endstate91;
        }
        endstate91:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"...\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state92:
        // "@"
        // path: [@]
        {
            if (inputCopy.length == 0)
                goto endstate92;
            goto endstate92;
        }
        endstate92:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"@\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state93:
        // ":"
        // path: [:]
        {
            if (inputCopy.length == 0)
                goto endstate93;
            goto endstate93;
        }
        endstate93:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\":\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state94:
        // "{"
        // path: [{]
        {
            if (inputCopy.length == 0)
                goto endstate94;
            goto endstate94;
        }
        endstate94:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"{\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state95:
        // "}"
        // path: [}]
        {
            if (inputCopy.length == 0)
                goto endstate95;
            goto endstate95;
        }
        endstate95:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"}\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state96:
        // "?"
        // path: [?]
        {
            if (inputCopy.length == 0)
                goto endstate96;
            goto endstate96;
        }
        endstate96:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"?\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state97:
        // "!"
        // path: [!]
        {
            if (inputCopy.length == 0)
                goto endstate97;
            goto endstate97;
        }
        endstate97:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"!\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state98:
        // "<" ("<<")
        // path: [<]
        {
            if (inputCopy.length == 0)
                goto endstate98;
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
                    goto state99;
                }
                else
                {
                    goto endstate98;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate98;
                }
            }
        }
        endstate98:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"<\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state99:
        // "<<"
        // path: [<] [<]
        {
            if (inputCopy.length == 0)
                goto endstate99;
            goto endstate99;
        }
        endstate99:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"<<\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state100:
        // ">" (">>")
        // path: [>]
        {
            if (inputCopy.length == 0)
                goto endstate100;
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
                    goto state101;
                }
                else
                {
                    goto endstate100;
                }
            }
            else
            {
                string inputCopyNext = inputCopy;
                import std.utf;

                dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);

                {
                    goto endstate100;
                }
            }
        }
        endstate100:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\">\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state101:
        // ">>"
        // path: [>] [>]
        {
            if (inputCopy.length == 0)
                goto endstate101;
            goto endstate101;
        }
        endstate101:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\">>\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state102:
        // "*"
        // path: [*]
        {
            if (inputCopy.length == 0)
                goto endstate102;
            goto endstate102;
        }
        endstate102:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"*\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state103:
        // "-"
        // path: [\-]
        {
            if (inputCopy.length == 0)
                goto endstate103;
            goto endstate103;
        }
        endstate103:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"-\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state104:
        // "|"
        // path: [|]
        {
            if (inputCopy.length == 0)
                goto endstate104;
            goto endstate104;
        }
        endstate104:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"|\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state105:
        // "^"
        // path: [\^]
        {
            if (inputCopy.length == 0)
                goto endstate105;
            goto endstate105;
        }
        endstate105:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"^\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
        }

    state106:
        // "+"
        // path: [+]
        {
            if (inputCopy.length == 0)
                goto endstate106;
            goto endstate106;
        }
        endstate106:
        {
            assert(inputCopy.ptr >= input.ptr);
            foundSymbol = tokenID!"\"+\"";
            foundLength = inputCopy.ptr - input.ptr;
            foundIsIgnore = false;
            goto lexerend;
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
    /* 1: */ immutable(Nonterminal)("Identifier", NonterminalFlags.none, ["lowPrio"], []),
    /* 2: */ immutable(Nonterminal)("StringLiteral", NonterminalFlags.none, [], []),
    /* 3: */ immutable(Nonterminal)("CharacterSetLiteral", NonterminalFlags.none, [], []),
    /* 4: */ immutable(Nonterminal)("IntegerLiteral", NonterminalFlags.none, [], []),
    /* 5: */ immutable(Nonterminal)("\";\"", NonterminalFlags.none, [], []),
    /* 6: */ immutable(Nonterminal)("\"=\"", NonterminalFlags.none, [], []),
    /* 7: */ immutable(Nonterminal)("\"fragment\"", NonterminalFlags.none, [], []),
    /* 8: */ immutable(Nonterminal)("\"token\"", NonterminalFlags.none, [], []),
    /* 9: */ immutable(Nonterminal)("\"(\"", NonterminalFlags.none, [], []),
    /* 10: */ immutable(Nonterminal)("\")\"", NonterminalFlags.none, [], []),
    /* 11: */ immutable(Nonterminal)("\",\"", NonterminalFlags.none, [], []),
    /* 12: */ immutable(Nonterminal)("\"...\"", NonterminalFlags.none, [], []),
    /* 13: */ immutable(Nonterminal)("\"option\"", NonterminalFlags.none, [], []),
    /* 14: */ immutable(Nonterminal)("\"import\"", NonterminalFlags.none, [], []),
    /* 15: */ immutable(Nonterminal)("\"match\"", NonterminalFlags.none, [], []),
    /* 16: */ immutable(Nonterminal)("\"@\"", NonterminalFlags.none, [], []),
    /* 17: */ immutable(Nonterminal)("\":\"", NonterminalFlags.none, [], []),
    /* 18: */ immutable(Nonterminal)("\"{\"", NonterminalFlags.none, [], []),
    /* 19: */ immutable(Nonterminal)("\"}\"", NonterminalFlags.none, [], []),
    /* 20: */ immutable(Nonterminal)("\"?\"", NonterminalFlags.none, [], []),
    /* 21: */ immutable(Nonterminal)("\"!\"", NonterminalFlags.none, [], []),
    /* 22: */ immutable(Nonterminal)("\"<\"", NonterminalFlags.none, [], []),
    /* 23: */ immutable(Nonterminal)("\">\"", NonterminalFlags.none, [], []),
    /* 24: */ immutable(Nonterminal)("\"*\"", NonterminalFlags.none, [], []),
    /* 25: */ immutable(Nonterminal)("\">>\"", NonterminalFlags.none, [], []),
    /* 26: */ immutable(Nonterminal)("\"<<\"", NonterminalFlags.none, [], []),
    /* 27: */ immutable(Nonterminal)("\"-\"", NonterminalFlags.none, [], []),
    /* 28: */ immutable(Nonterminal)("\"anytoken\"", NonterminalFlags.none, [], []),
    /* 29: */ immutable(Nonterminal)("\"|\"", NonterminalFlags.none, [], []),
    /* 30: */ immutable(Nonterminal)("\"^\"", NonterminalFlags.none, [], []),
    /* 31: */ immutable(Nonterminal)("\"+\"", NonterminalFlags.none, [], []),
    /* 32: */ immutable(Nonterminal)("\"t(\"", NonterminalFlags.none, [], []),
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
