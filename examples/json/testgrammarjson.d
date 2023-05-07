import dparsergen.core.dynamictree;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
import std.algorithm;
import std.array;
import std.file;
import std.path;
import std.stdio;

import P = grammarjson;
static import grammarjson_lexer;

alias Location = LocationAll;
alias L = grammarjson_lexer.Lexer!Location;
alias Creator = DynamicParseTreeCreator!(P, Location, LocationRangeStartLength);
alias Tree = DynamicParseTree!(Location, LocationRangeStartLength);

int runTests(string dir)
{
    int r = 0;

    size_t testCount;
    foreach (filename; dirEntries(dir, "*.json", SpanMode.shallow))
    {
        string f = baseName(filename);

        // TODO: implement depth limit
        if (f == "n_structure_100000_opening_arrays.json")
            continue;
        if (f == "n_structure_open_array_object.json")
            continue;
        if (f == "i_structure_500_nested_arrays.json")
            continue;

        string inText = cast(string) read(filename);

        auto creator = new Creator;

        bool result;
        try
        {
            auto tree = P.parse!(Creator, L)(inText, creator);
            assert(tree.inputLength.bytePos <= inText.length);
            result = true;
        }
        catch (Exception e)
        {
            //stderr.writeln("error");
            if (f[0] == 'y')
                stderr.writeln(f, "\n", e);
            result = false;
        }
        if ((f[0] == 'y' && !result) || (f[0] == 'n' && result))
        {
            stderr.writeln(result, " ", f);
            r = 1;
        }
        testCount++;
    }
    if (testCount < 315)
    {
        stderr.writeln("Less tests than expected: ", testCount);
        r = 1;
    }
    return r;
}

immutable help = q"EOS
Usage: testgrammarjson [OPTIONS] filename
    -v Verbose output
    --test-dir Check JSON files in directory
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
        string inText = readText(filename);

        auto creator = new Creator;

        try
        {
            auto tree = P.parse!(Creator, L)(inText, creator);
            assert(tree.inputLength.bytePos <= inText.length);
            printTree(stdout, tree, verbose);
            return 0;
        }
        catch (Exception e)
        {
            stderr.writeln(e);
            return 1;
        }
    }
}
