import dparsergen.core.dynamictree;
import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.parseexception;
import std.algorithm;
import std.array;
import std.conv;
import std.encoding;
import std.exception;
import std.file;
import std.path;
import std.range;
import std.regex;
import std.stdio;
import std.string;
import std.typecons;

static import grammard_lexer;

/**
Wrapper around the lexer for D, which handles special tokens.
*/
struct LexerWrapper
{
    grammard_lexer.Lexer!LocationAll lexer;

    alias Location = LocationAll;
    alias LocationDiff = typeof(Location.init - Location.init);

    this(string input, Location startLocation = Location.init)
    {
        lexer = grammard_lexer.Lexer!LocationAll(input, startLocation);

        filterTokens();
    }

    enum tokenID(string tok) = lexer.tokenID!(tok);

    string tokenName(size_t id)
    {
        return lexer.tokenName(id);
    }

    ref front()
    {
        return lexer.front;
    }

    bool empty()
    {
        return lexer.empty;
    }

    void popFront()
    {
        lexer.popFront();
        filterTokens();
    }

    void filterTokens()
    {
        if (front.content == "__EOF__")
        {
            lexer.empty = true;
            return;
        }
    }
}

alias Tree = DynamicParseTree!(LocationAll, LocationRangeStartLength);

/**
Read a D source file and convert it to UTF-8.
*/
string readSourceFile(string filename)
{
    auto input = cast(ubyte[]) read(filename);
    auto bom = getBOM(input);
    input = input[bom.sequence.length .. $];
    string inputText;
    version (BigEndian)
        enum IsBigEndian = 1;
    else
        enum IsBigEndian = 0;
    switch (bom.schema)
    {
    case BOM.utf32be:
    case BOM.utf32le:
        if (IsBigEndian != (bom.schema == BOM.utf32be))
        {
            for (size_t j = 0; j + 3 < input.length; j++)
            {
                auto tmp = input[j];
                input[j] = input[j + 3];
                input[j + 3] = tmp;
                tmp = input[j + 1];
                input[j + 1] = input[j + 2];
                input[j + 2] = tmp;
            }
        }
        transcode(cast(dstring) input, inputText);
        break;
    case BOM.utf16be:
    case BOM.utf16le:
        if (IsBigEndian != (bom.schema == BOM.utf16be))
        {
            for (size_t j = 0; j + 1 < input.length; j++)
            {
                auto tmp = input[j];
                input[j] = input[j + 1];
                input[j + 1] = tmp;
            }
        }
        transcode(cast(wstring) input, inputText);
        break;
    default:
        inputText = cast(string) input;
        break;
    }
    return inputText;
}

immutable string[] syntaxErrorExceptions = [
    "arguments for",
    "constant expression expected",
    "expected return type of",
    "is expected to return a value",
    "boolean expression expected for",
    "end of instruction expected",
    "cannot infer argument types",
    "function expected before",
    "symbol expected as second argument",
    "opcode expected", // TODO: parse ASM
    //"expression expected not", // TODO: parse ASM
    "operands found for", // TODO: parse ASM
    "struct / class type expected as argument",
    "symbol or expression expected as first argument",
    "expression expected as second argument of",
    "type expected as second argument of __traits",
    "expected for __traits",
    "string expected as argument of __traits",
    "`return` expression expected",
    "single type expected for trait",
    "pragma(`inline`, `true` or `false`) expected,",
    "expected for mangled name",
    "expected valid identifier",
    "compile time string constant (or sequence) expected, not",
    "expected as third argument of",
    "at least one argument expected",
    "`string` expected for pragma mangle argument, not",
];

immutable string[] syntaxErrorExtra = [
    "cannot declare",
    "no identifier for declarator",
    "variadic parameter cannot have",
    "template constraints only allowed for templates",
    "attributes are only valid for non-static member functions",
    "isn't a valid integer literal",
    "is a keyword",
    "is not a valid attribute",
    "for member lookup, not",
    "Invalid trailing code unit",
    "lower case integer suffix",
    "found end of file",
    "not a valid token",
    "unmatched closing brace",
    "multiple ! arguments are not allowed",
    "missing `do { ... }` for function literal",
    "empty attribute list is not allowed",
    "cannot be placed after a template constraint",
    "template constraints appear both before and after BaseClassList, put them before",
    "named arguments not allowed here",
    "invalid filename for `#line` directive",
    "terminating `;` required after do-while statement",
    "missing `do { ... }` after",
    "attributes are not allowed on `asm` blocks",
    "function literal cannot",
    "found `else` without a corresponding",
    "C style cast illegal",
    "instead of `long ",
    "instead of C-style syntax, use D-style",
    "only parameters, functions and `foreach` declarations can be `ref`",
    "function cannot have enum storage class",
    "token is not allowed in postfix position",
];

size_t[syntaxErrorExceptions.length] syntaxErrorExceptionsUsed;
size_t[syntaxErrorExtra.length] syntaxErrorExtraUsed;

/**
Determine if an error message from DMD is likely a syntax error.
*/
bool isSyntaxErrorMessage(string message)
{
    if (message.canFind("expect"))
    {
        foreach (i, m; syntaxErrorExceptions)
            if (message.canFind(m))
            {
                syntaxErrorExceptionsUsed[i]++;
                return false;
            }
        return true;
    }

    foreach (i, m; syntaxErrorExtra)
        if (message.canFind(m))
        {
            syntaxErrorExtraUsed[i]++;
            return true;
        }

    return false;
}

/**
Determine if comment with expected output of DMD in test file contains
syntax error.
*/
bool hasExpectedSyntaxError(string file, ref string failureText)
{
    auto testOutputRegex = regex(r"TEST_OUTPUT(\([^()]*\))?: *\r?\n?----*\r?\n(([^-]|--?[^-])*)-?-?\n----*");
    auto errorRegex = regex(r".*\.d\([0-9]+\): ((Error|Deprecation): .*)");

    bool hasSyntaxError;

    foreach (c; matchAll(file, testOutputRegex))
    {
        //stderr.writeln(c);
        foreach (line; c.captures[2].splitter("\n"))
        {
            auto c2 = matchFirst(line, errorRegex);
            if (!c2.empty)
            {
                //stderr.writeln(c2);
                string message = c2.captures[1];
                if (isSyntaxErrorMessage(message))
                {
                    if (!hasSyntaxError)
                        failureText = message;
                    hasSyntaxError = true;
                }
            }
        }
    }

    return hasSyntaxError;
}

immutable help = q"EOS
Usage: testgrammard [OPTIONS] filename
    -v Verbose output
    --test-dir Check D files in this directory
    --test-dir-fail Check D files with syntax errors in this directory
    --test-dir-fail-dmd Check D files in this directory from DMD fail_compilation test
    -h Show this help
EOS";

enum TestDirType
{
    normal,
    fail,
    failDmd
}

struct TestDir
{
    TestDirType type;
    string dir;
}

/**
Check if all D files in a directory can be parsed or fail as expected.
*/
bool runTests(TestDirType testDirType, string testDir)
{
    import P = grammard;

    alias L = LexerWrapper;
    alias Creator = DynamicParseTreeCreator!(P, LocationAll, LocationRangeStartLength);
    Creator creator = new Creator;

    testDir = absolutePath(testDir);

    bool result = true;

    auto entries = dirEntries(testDir, "*.d", SpanMode.depth).array;
    size_t count;
    foreach (i, filename; entries)
    {
        string f = baseName(filename);
        string relative = relativePath(filename, testDir);

        if (testDirType == TestDirType.failDmd)
        {
            if (relative.startsWith("protection"))
                continue;
            if (relative == "mixintype2.d")
                continue;
            if (relative.startsWith("imports"))
                continue;
        }

        //stderr.writeln("====== ", i, "/", entries.length, ": ", filename, " ======");

        string inputText = readSourceFile(filename);

        bool expectFailure;
        string failureText;

        if (testDirType == TestDirType.failDmd)
        {
            if (inputText.canFind("EXTRA_FILES:") || inputText.canFind("import imports."))
            {
                // Test files with imports don't have syntax errors, but the imported files could have them.
                expectFailure = false;
            }
            else
                expectFailure = hasExpectedSyntaxError(inputText, failureText);
        }
        if (testDirType == TestDirType.fail)
        {
            expectFailure = true;
        }

        if (testDirType == TestDirType.failDmd && relative.among(
                "fail18228.d",
                "test12228.d",
                "fail_typeof.d",
                "fail19912d.d",
                "fail54.d",
                ))
        {
            if (expectFailure)
                stderr.writeln("Redundant special case for ", filename);
            expectFailure = true;
        }

        // TODO: Produce errors for the following files.
        if (testDirType == TestDirType.failDmd && relative.among(
            "fail11751.d",
            "t1252.d",
            "fail14009.d"
            ))
        {
            if (!expectFailure)
                stderr.writeln("Redundant special case for ", filename);
            expectFailure = false;
        }

        try
        {
            auto tree = P.parse!(Creator, L)(inputText, creator, LocationAll.init);
            assert(tree is null || tree.inputLength.bytePos <= inputText.length);
            if (expectFailure)
            {
                stderr.writeln("====== ", i, "/", entries.length, ": ", filename, " ======");
                stderr.writeln("Unexpected success");
                stderr.writeln(failureText);
                printTree(stderr, tree);
                result = false;
            }
        }
        catch (ParseException e)
        {
            if (!expectFailure)
            {
                stdout.flush();
                stderr.writeln("====== ", i, "/", entries.length, ": ", filename, " ======");
                auto e2 = cast(SingleParseException!LocationAll) e.maxEndException;
                if (e2 !is null)
                    stderr.writeln(filename, ":", e2.markStart.toPrettyString, ": ", e2.msg);
                else
                    e.toString(inputText, (data) { stderr.write(data); });
                result = false;
                if (testDirType != TestDirType.failDmd)
                    return false;
            }
        }
        count++;
    }
    stderr.writeln("Done ", count, " ", testDir);

    if (testDirType == TestDirType.failDmd)
    {
        foreach (i, m; syntaxErrorExceptions)
            if (syntaxErrorExceptionsUsed[i] == 0)
                stderr.writeln("Syntax error exception \"", m, "\" not seen");
        foreach (i, m; syntaxErrorExtra)
            if (syntaxErrorExtraUsed[i] == 0)
                stderr.writeln("Syntax error \"", m, "\" not seen");
    }
    return result;
}

int main(string[] args)
{
    TestDir[] testDirs;
    string filename;

    for (size_t i = 1; i < args.length; i++)
    {
        string arg = args[i];
        if (arg.startsWith("-"))
        {
            if (arg == "-h")
            {
                stderr.write(help);
                return 0;
            }
            else if (arg == "--test-dir")
            {
                if (i + 1 >= args.length)
                {
                    stderr.writeln("Missing argument for ", arg);
                    return 1;
                }
                i++;
                testDirs ~= TestDir(TestDirType.normal, args[i]);
            }
            else if (arg == "--test-dir-fail")
            {
                if (i + 1 >= args.length)
                {
                    stderr.writeln("Missing argument for ", arg);
                    return 1;
                }
                i++;
                testDirs ~= TestDir(TestDirType.fail, args[i]);
            }
            else if (arg == "--test-dir-fail-dmd")
            {
                if (i + 1 >= args.length)
                {
                    stderr.writeln("Missing argument for ", arg);
                    return 1;
                }
                i++;
                testDirs ~= TestDir(TestDirType.failDmd, args[i]);
            }
            else
            {
                stderr.writeln("Unknown option ", arg);
                return 1;
            }
        }
        else
        {
            if (filename.length)
            {
                stderr.writeln("Too many arguments");
                return 1;
            }
            filename = arg;
        }
    }

    if (filename.length && testDirs.length)
    {
        stderr.writeln("Too many arguments");
        return 1;
    }

    if (filename.length == 0 && testDirs.length == 0)
    {
        stderr.write(help);
        return 0;
    }

    foreach (testDir; testDirs)
        if (!runTests(testDir.type, testDir.dir))
            return 1;

    if (filename.length)
    {
        import P = grammard;

        alias L = LexerWrapper;
        alias Creator = DynamicParseTreeCreator!(P, LocationAll, LocationRangeStartLength);
        Creator creator = new Creator;
        string inputText = readSourceFile(filename);
        try
        {
            auto tree = P.parse!(Creator, L)(inputText, creator, LocationAll.init);
            assert(tree is null || tree.inputLength.bytePos <= inputText.length);
            printTree(stdout, tree);
        }
        catch (ParseException e)
        {
            stderr.write("error ");
            e.toString(inputText, (data) { stderr.write(data); });
            return 1;
        }
    }

    return 0;
}
