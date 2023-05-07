public import dparsergen.core.charlexer;
public import dparsergen.core.dynamictree;
public import dparsergen.core.location;
public import dparsergen.core.parseexception;
public import dparsergen.core.utils;
import std.array;
import std.conv;
public import std.stdio;
public import std.typetuple;

immutable IGNORE_VALUE = "ignore";

void assertEqual(string got, string expected, lazy string t)
{
    assert(got == expected,
        text(t, " expected: q{", expected, "}\ngot: q{", got, "}"));
}

void testOnce(alias M, alias Lexer, alias Creator = DynamicParseTreeCreator)
        (string input, string expected, string expectedError = "", string file = __FILE__, size_t line = __LINE__)
{
    alias Location = typeof(Lexer.init.front.currentLocation);
    alias LocationDiff = typeof(Location.init - Location.init);

    alias CreatorInstance = Creator!(M, Location, LocationRangeStartDiffLength);
    auto creator = new CreatorInstance;

    bool hasException;
    typeof(M.parse!(CreatorInstance, Lexer)("", creator)) tree;
    try
    {
        tree = M.parse!(CreatorInstance, Lexer)(input, creator);
        if (expectedError !is IGNORE_VALUE)
            assert(expectedError.length == 0, text(file, ":", line));
    }
    catch (ParseException e)
    {
        if (expectedError !is IGNORE_VALUE)
        {
            auto maxEndException = e.maxEndException();
            assertEqual((maxEndException is null ? e : maxEndException).simpleMsg,
                    expectedError, text("for text \"", input, "\" at ", file, ":", line));
            if (expectedError.length == 0)
                stderr.writeln(e);
        }
        hasException = true;
    }
    catch (Exception e)
    {
        if (expectedError !is IGNORE_VALUE)
        {
            assertEqual(e.msg, expectedError, text("for text \"", input,
                    "\" at ", file, ":", line));
            if (expectedError.length == 0)
                stderr.writeln(e);
        }
        hasException = true;
    }
    if (expectedError.length)
        assert(hasException, text("unexpected success for text \"", input,
                "\" at ", file, ":", line));
    string parsed = tree.treeToString();
    if (expected !is IGNORE_VALUE)
    {
        string expectedText = expected;
        version (glr)
        {
            if (expectedError.length)
                return;
        }
        assertEqual(parsed, expectedText, text("for text \"", input, "\" at ",
                file, ":", line, " with ", Creator.stringof));
    }
}

struct Token
{
    string str;
    size_t id;
    size_t currentPosition = size_t.max;
    size_t currentTokenEnd = size_t.max;
}

void testLexer(alias L, bool printCode)(string input, Token[] expected,
        string expectedError = null, string file = __FILE__, size_t line = __LINE__)
{
    string gotError;
    string[] tokenCodes;
    try
    {
        auto lexer = L(input);
        size_t i;
        while (!lexer.empty)
        {
            static if (printCode)
            {
                tokenCodes ~= text("Token(\"", lexer.front.content.escapeD, "\", L.tokenID!\"",
                        lexer.tokenName(lexer.front.symbol).escapeD, "\", ",
                        lexer.front.currentLocation.bytePos, ", ",
                        lexer.front.currentTokenEnd.bytePos, ")");
            }
            else
            {
                assert(i < expected.length, text(file, ":", line));
                assert(lexer.front.content == expected[i].str, text(file, ":", line));
                assert(lexer.front.symbol == expected[i].id, text(file, ":", line));
                assert(lexer.front.currentLocation.bytePos == expected[i].currentPosition,
                        text(file, ":", line));
                assert(lexer.front.currentTokenEnd.bytePos == expected[i].currentTokenEnd,
                        text(file, ":", line));
            }
            lexer.popFront;
            i++;
        }
    }
    catch (Exception e)
    {
        gotError = e.msg;
    }

    static if (printCode)
    {
        stderr.write("\ttest(\"", input.escapeD, "\", [");

        if (tokenCodes.length == 1)
            stderr.write(tokenCodes[0]);
        else if (tokenCodes.length > 1)
        {
            stderr.writeln();
            foreach (c; tokenCodes)
                stderr.writeln("\t\t", c, ",");
            stderr.write("\t\t");
        }
        stderr.write("]");
        if (gotError.length > 0)
            stderr.write(", \"", gotError.escapeD, "\"");
        stderr.writeln(");");
    }
    else
    {
        assert(gotError == expectedError, text(file, ":", line, " ",
                gotError, " ", expectedError));
    }
}
