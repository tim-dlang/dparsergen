import dparsergen.core.dynamictree;
import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
static import grammarpython;
static import grammarpython_lexer;
import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.file;
import std.path;
import std.stdio;

alias Location = LocationAll;
alias Tree = DynamicParseTree!(Location, LocationRangeStartLength);
alias Creator = DynamicParseTreeCreator!(grammarpython, Location, LocationRangeStartLength);

struct LexerWrapper
{
    grammarpython_lexer.Lexer!(LocationAll, true) lexer;

    alias Location = LocationAll;
    alias LocationDiff = typeof(Location.init - Location.init);

    this(string input, Location startLocation = Location.init)
    {
        lexer = grammarpython_lexer.Lexer!(LocationAll, true)(input, startLocation);
        skipIgnoredTokens();
    }

    enum tokenID(string tok) = lexer.tokenID!(tok);

    string tokenName(size_t id)
    {
        return lexer.tokenName(id);
    }

    ref front()
    {
        if (hasIndentDedentToken)
            return indentDedentToken;
        return lexer.front;
    }

    bool empty()
    {
        return !hasIndentDedentToken && lexer.empty;
    }

    void popFront()
    {
        if (hasIndentDedentToken)
        {
            hasIndentDedentToken = false;
            if (currentSpace.length < indentStack.data[$ - 1].length)
            {
                indentStack.shrinkTo(indentStack.data.length - 1);
                string lastSpace = indentStack.data.length ? indentStack.data[$ - 1] : "";
                if (currentSpace.length < lastSpace.length)
                {
                    enforce(lastSpace.startsWith(currentSpace));
                    hasIndentDedentToken = true;
                    indentDedentToken = typeof(lexer.front)("", lexer.tokenID!"Dedent", lexer.front.currentLocation);
                }
                else
                    enforce(lastSpace == currentSpace, text("lastSpace=\"", lastSpace, "\" currentSpace=\"", currentSpace, "\""));
            }
            return;
        }
        if (lexer.front.symbol.among(lexer.tokenID!"\"(\"", lexer.tokenID!"\"[\"", lexer.tokenID!"\"{\""))
        {
            parenDepth++;
        }
        else if (lexer.front.symbol.among(lexer.tokenID!"\")\"", lexer.tokenID!"\"]\"", lexer.tokenID!"\"}\""))
        {
            enforce(parenDepth);
            parenDepth--;
        }
        lexer.popFront();
        skipIgnoredTokens();
    }

    bool isLineStart = true;

    bool hasIndentDedentToken;
    typeof(lexer.front) indentDedentToken;
    string lastSpace;
    string currentSpace;
    Appender!(string[]) indentStack;
    size_t parenDepth;

    this(this)
    {
        auto origInputStack = indentStack;
        indentStack = Appender!(string[]).init;
        indentStack.put(origInputStack.data);
    }

    void skipIgnoredTokens()
    {
        while (!lexer.empty)
        {
            if (lexer.front.symbol == lexer.tokenID!"Newline")
            {
                if (parenDepth || isLineStart)
                {
                    currentSpace = "";
                    lexer.popFront;
                    continue;
                }
                isLineStart = true;
                currentSpace = "";
            }
            else if (lexer.front.symbol == lexer.tokenID!"Space")
            {
                currentSpace = lexer.front.content;
            }
            else if (!lexer.front.isIgnoreToken)
            {
                if (isLineStart)
                {
                    string lastSpace = indentStack.data.length ? indentStack.data[$ - 1] : "";
                    if (currentSpace.length > lastSpace.length)
                    {
                        enforce(currentSpace.startsWith(lastSpace));
                        hasIndentDedentToken = true;
                        indentDedentToken = typeof(lexer.front)("", lexer.tokenID!"Indent", lexer.front.currentLocation);
                        indentStack.put(currentSpace);
                    }
                    else if (currentSpace.length < lastSpace.length)
                    {
                        enforce(lastSpace.startsWith(currentSpace));
                        hasIndentDedentToken = true;
                        indentDedentToken = typeof(lexer.front)("", lexer.tokenID!"Dedent", lexer.front.currentLocation);
                    }
                    else
                        enforce(currentSpace == lastSpace);
                }
                isLineStart = false;
            }

            if (lexer.front.isIgnoreToken)
            {
                lexer.popFront;
            }
            else
            {
                break;
            }
        }
        if (lexer.empty)
        {
            currentSpace = "";
            if (indentStack.data.length)
            {
                hasIndentDedentToken = true;
                indentDedentToken = typeof(lexer.front)("", lexer.tokenID!"Dedent", lexer.front.currentLocation);
            }
        }
    }
}

int runTests(string dir)
{
    int r = 0;

    size_t testCount;
    foreach (filename; dirEntries(dir, "*.py", SpanMode.breadth))
    {
        string f = baseName(filename);
        if (f.startsWith("bad"))
            continue;

        string inText = cast(string) read(filename);
        auto creator = new Creator;

        try
        {
            auto tree = grammarpython.parse!(Creator,
                    LexerWrapper)(inText, creator,
                    LocationAll.init);
            assert(tree.inputLength.bytePos <= inText.length);
        }
        catch (Exception e)
        {
            stderr.writeln(f, "\n", e);
            r = 1;
        }

        testCount++;
    }
    if (testCount < 902)
    {
        stderr.writeln("Less tests than expected: ", testCount);
        r = 1;
    }
    return r;
}

immutable help = q"EOS
Usage: testpython [OPTIONS] filename.py
    -v Verbose output
    --test-dir Check test directory from cpython
    -h Show this help
EOS";

int main(string[] args)
{
    string filename;
    string testDir;
    bool verbose;

    for (size_t i = 1; i < args.length; i++)
    {
        string arg = args[i];
        if (arg.startsWith("-"))
        {
            if (arg == "-v")
                verbose = true;
            else if (arg == "--test-dir")
            {
                if (i + 1 >= args.length)
                {
                    stderr.writeln("Missing argument for ", arg);
                    return 1;
                }
                if (filename.length || testDir.length)
                {
                    stderr.writeln("Too many arguments");
                    return 1;
                }
                i++;
                testDir = args[i];
            }
            else if (arg == "-h")
            {
                stderr.write(help);
                return 0;
            }
            else
            {
                stderr.writeln("Unknown option ", arg);
            }
        }
        else
        {
            if (filename.length || testDir.length)
            {
                stderr.writeln("Too many arguments");
                return 1;
            }
            filename = arg;
        }
    }

    if (filename.length == 0 && testDir.length == 0)
    {
        stderr.write(help);
        return 0;
    }

    if (testDir.length)
    {
        return runTests(testDir);
    }
    else
    {
        string inText = cast(string) read(filename);

        Tree tree;
        try
        {
            auto creator = new Creator;
            tree = grammarpython.parse!(Creator,
                    LexerWrapper)(inText, creator,
                    LocationAll.init);
            assert(tree.inputLength.bytePos <= inText.length);
        }
        catch (Exception e)
        {
            stderr.writeln(e);
            return 1;
        }

        printTree(stdout, tree, verbose);
    }

    return 0;
}
