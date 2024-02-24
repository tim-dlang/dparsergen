import core.sync.mutex;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.file;
import std.parallelism;
import std.path;
import std.process;
import std.range;
import std.regex;
import std.stdio;
import std.string;
static import std.system;

version (Windows)
{
    enum os = "win";
    enum exeExt = ".exe";
}
else
{
    enum os = text(std.system.os);
    enum exeExt = "";
}

enum Verbosity
{
    none,
    outputOnError = 1,
    outputCommandAlways = 2,
    outputAlways = 4,
    showTime = 8,
    expectFailue = 16,
    github = 32,
}

version (linux)
{
    import core.stdc.errno;
    import core.sys.posix.sys.wait;
    import core.sys.posix.sys.resource;

    extern (C) pid_t wait4(pid_t, int*, int, rusage*);
    int waitMem(Pid pid, ref long maxrss)
    {
        auto processID = pid.processID;
        int exitCode;
        rusage usage;
        while (true)
        {
            int status;
            auto check = wait4(processID, &status, 0, &usage);
            if (check == -1)
            {
                if (errno == ECHILD)
                {
                    throw new ProcessException("Process does not exist or is not a child process.");
                }
                else
                {
                    assert(errno == EINTR);
                    continue;
                }
            }
            if (WIFEXITED(status))
            {
                exitCode = WEXITSTATUS(status);
                break;
            }
            else if (WIFSIGNALED(status))
            {
                exitCode = -WTERMSIG(status);
                break;
            }
        }
        maxrss = usage.ru_maxrss;
        return exitCode;
    }
}

immutable IGNORE_OUTPUT = "IGNORE_OUTPUT";

bool runCommand(string[] args, string desc, Verbosity verbosity, Mutex outputMutex,
        string* output = null, string expectedOutput = IGNORE_OUTPUT, string input = "")
{
    auto sw = StopWatch(AutoStart.yes);

    auto pipes = pipeProcess(args, Redirect.stdin | Redirect.stdout | Redirect.stderrToStdout);
    pipes.stdin.write(input);
    pipes.stdin.close();
    Appender!string app;
    foreach (ubyte[] chunk; pipes.stdout.byChunk(4096))
        app.put(chunk);
    auto processId = pipes.pid.processID;
    string memText;
    version (linux)
    {
        long maxrss;
        auto status = waitMem(pipes.pid, maxrss);
        memText = format(", %d MB", (maxrss + 512) / 1024);
    }
    else
        auto status = pipes.pid.wait();
    if (output !is null)
        *output = app.data;
    sw.stop();
    string extraText;
    bool r = true;
    bool wrongOutput;
    if (status && (verbosity & Verbosity.expectFailue) == 0)
    {
        extraText = "Failure: ";
        r = false;
    }
    else if (expectedOutput != IGNORE_OUTPUT && app.data.replace("\r", "")
            .strip() != expectedOutput.replace("\r", ""))
    {
        extraText = "Wrong output: ";
        r = false;
        wrongOutput = true;
    }

    bool hasOutput;
    if ((verbosity & Verbosity.outputCommandAlways) || (!r && (verbosity & Verbosity.outputOnError)))
        hasOutput = true;
    if ((verbosity & Verbosity.outputAlways) || (!r && (verbosity & Verbosity.outputOnError)))
        hasOutput = true;

    bool anyOutput;
    if (verbosity & Verbosity.showTime)
        anyOutput = true;
    if (hasOutput)
        anyOutput = true;

    outputMutex.lock();

    if (anyOutput)
    {
        stderr.writefln("%s[%d.%03d s%s] %s%s", (hasOutput && (verbosity & Verbosity.github))
                ? "::group::" : "", sw.peek.total!"msecs" / 1000,
                sw.peek.total!"msecs" % 1000, memText, extraText, desc);
    }
    if ((verbosity & Verbosity.outputCommandAlways) || (!r && (verbosity & Verbosity.outputOnError)))
    {
        stderr.writeln(escapeShellCommand(args));
    }
    if ((verbosity & Verbosity.outputAlways) || (!r && (verbosity & Verbosity.outputOnError)))
    {
        if (app.data.length)
            stderr.writeln(app.data.replace("\r", "").strip());
        if (wrongOutput)
        {
            stderr.writeln((verbosity & Verbosity.github)
                    ? "::endgroup::\n::group::" : "", "Expected:");
            stderr.writeln(expectedOutput.stripRight);
        }
    }
    if (hasOutput && (verbosity & Verbosity.github))
        stderr.writeln("::endgroup::");

    if (anyOutput && !r && (verbosity & Verbosity.github))
        stderr.writeln("::error::", extraText, desc);

    outputMutex.unlock();

    return r;
}

immutable variants = ["normal", "optdescent", "glr"];

enum TestType
{
    all,
    compileOnly,
    generateOnly
}

struct Test
{
    string name;
    TestType testType;
    string[] excludedVariants;
    string testName;
    string[] generatorOpts;
    string[] extraDmdArgs;
    string[] runtimeArgs;
    string runtimeInput;
    string runtimeOutput;
    string[variants.length] expectedOutput;
    string expectedOutputLexer;
}

struct TestInstance
{
    size_t index;
    string variant;
    bool failed;
    bool shouldExclude;
}

void parseGrammarComments(ref Test test, string filename)
{
    string inputText = readText(filename);
    foreach (line; inputText.splitter("\n"))
    {
        if (line.startsWith("//"))
            line = line[2 .. $];
        else if (line.startsWith("/*"))
            line = line[2 .. $];
        line = line.strip();
        if (line.startsWith("GENPARSER_OPTS:"))
        {
            test.generatorOpts ~= line["GENPARSER_OPTS:".length .. $].splitter()
                .filter!(m => m.length)
                .map!(m => m.idup)
                .array;
        }
        else if (line.startsWith("EXCLUDE_VARIANT:"))
        {
            test.excludedVariants ~= line["EXCLUDE_VARIANT:".length .. $].splitter()
                .filter!(m => m.length)
                .map!(m => m.idup)
                .array;
        }
    }

    auto testOutputRegex = regex(
            r"GENERATOR_OUTPUT(\(([^()]*)\))?: *\r?\n?----*\r?\n(([^-]|--?[^-])*)-?-?\n----*");

    foreach (c; matchAll(inputText, testOutputRegex))
    {
        auto filters = c.captures[2].split(",").map!(s => s.strip)
            .filter!(s => s.length != 0)
            .array;
        foreach (filter; filters)
        {
            if (filter != "lexer" && !variants.canFind(filter))
                stderr.writeln("Unknown filter \"", filter, "\" in file ", filename);
        }

        foreach (i, variant; variants)
        {
            if (filters.length == 0 || filters.canFind(variant))
            {
                if (test.expectedOutput[i].length)
                    test.expectedOutput[i] ~= "\n";
                test.expectedOutput[i] ~= c.captures[3].strip();
            }
        }
        if (filters.length == 0 || filters.canFind("lexer"))
        {
            if (test.expectedOutputLexer.length)
                test.expectedOutputLexer ~= "\n";
            test.expectedOutputLexer ~= c.captures[3].strip();
        }
    }
}

bool compareFiles(string file1, string file2, Verbosity verbosity, Mutex outputMutex)
{
    string text1 = readText(file1).replace("\r", "");
    string text2 = readText(file2).replace("\r", "");
    if (text1 != text2)
    {
        string diff;
        runCommand(["diff", file1, file2], "", Verbosity.expectFailue, outputMutex, &diff);
        stderr.writeln((verbosity & Verbosity.github) ? "::group::" : "",
                "Files differ: ", file1, " ", file2);
        stderr.writeln(diff.stripRight);
        if (verbosity & Verbosity.github)
            stderr.writeln("::endgroup::");
        if (verbosity & Verbosity.github)
            stderr.writeln("::error::", "Files differ: ", file1, " ", file2);
        return false;
    }
    return true;
}

bool runGrammarTests(Test[] tests, string model, Verbosity verbosity,
        string compiler, string generator, bool parallelCompiling, Mutex outputMutex)
{
    immutable variantArgs = [
        "normal": [], "optdescent": ["--optdescent"], "glr": ["--glr"]
    ];
    bool anyFailure;
    TestInstance[] testInstances;

    foreach (i, ref test; tests)
    {
        const dir = buildPath("test_results", os ~ model, dirName(test.name));
        mkdirRecurse(dir);

        Verbosity verbosity2 = verbosity;
        if (test.testType == TestType.generateOnly)
        {
            verbosity2 &= ~(Verbosity.outputAlways | Verbosity.outputCommandAlways);
            verbosity2 |= Verbosity.expectFailue;
        }

        bool lexerFailed;
        if (!runCommand([
                generator, test.name ~ ".ebnf", "--lexer",
                buildPath("test_results", os ~ model, test.name ~ "_lexer.d")
            ], "Generating lexer for " ~ test.name, verbosity2, outputMutex,
                null, test.expectedOutputLexer))
        {
            lexerFailed = true;
            anyFailure = true;
        }
        foreach (variant; variants)
        {
            if (test.excludedVariants.canFind(variant))
                continue;

            testInstances ~= TestInstance(i, variant);
            if (lexerFailed)
                testInstances[$ - 1].failed = true;
        }
    }

    foreach (ref instance; parallel(testInstances, 1))
    {
        auto test = tests[instance.index];
        auto variant = instance.variant;

        Verbosity verbosity2 = verbosity;
        if (test.testType == TestType.generateOnly)
        {
            verbosity2 &= ~(Verbosity.outputAlways | Verbosity.outputCommandAlways);
            verbosity2 |= Verbosity.expectFailue;
        }

        string output;
        if (!runCommand([
                generator, test.name ~ ".ebnf",
                "-o", buildPath("test_results", os ~ model, test.name ~ "_" ~ variant ~ ".d"),
                "--module", baseName(test.name),
            ] ~ variantArgs[variant] ~ test.generatorOpts, "Generating parser for " ~ test.name ~ " variant " ~ variant,
                verbosity2, outputMutex, null, test.expectedOutput[variants.countUntil(variant)]))
        {
            instance.shouldExclude = true;
            instance.failed = true;
        }
    }
    foreach (ref instance; testInstances)
    {
        if (instance.failed)
            anyFailure = true;
        if (instance.shouldExclude)
            tests[instance.index].excludedVariants ~= instance.variant;
    }

    size_t maxTestBundleSize = 20;
    struct TestBundle
    {
        string[] dmdArgs;
        string[] tests;
        string[] runtimeArgs;
        string runtimeInput;
        string runtimeOutput;
        TestType testType;
        string filename;
        bool failed;
    }

    string versionArg = "-version";
    if (compiler.endsWith("ldc2"))
        versionArg = "--d-version";

    TestBundle[] testBundles;
    foreach (variant; variants)
    {
        TestBundle testBundle;

        foreach (ref test; tests)
        {
            if (test.testType == TestType.generateOnly)
                continue;
            if (test.excludedVariants.canFind(variant))
                continue;

            bool needsOwnBundle = test.name.startsWith("examples")
                || test.runtimeArgs.length || test.runtimeInput.length;

            if (testBundle.tests.length >= maxTestBundleSize
                    || (testBundle.tests.length && needsOwnBundle))
            {
                testBundles ~= testBundle;
                testBundle = TestBundle.init;
            }
            if (testBundle.tests.length == 0)
            {
                string name;
                if (test.name.startsWith("examples"))
                    name = text(test.testName, "_", variant);
                else
                    name = text("tests", testBundles.length, "_", variant);
                testBundle.filename = buildPath("test_results", os ~ model, text(name, exeExt));
                testBundle.dmdArgs = [
                    compiler, "-g", "-w", "-m" ~ model, "-i=dparsergen", "-Icore",
                    versionArg ~ "=" ~ variant, "-I" ~ dirName(test.name),
                    "-of" ~ testBundle.filename,
                ] ~ test.extraDmdArgs;
                testBundle.runtimeArgs = test.runtimeArgs;
                testBundle.runtimeInput = test.runtimeInput;
                testBundle.runtimeOutput = test.runtimeOutput;
                testBundle.testType = test.testType;
            }

            testBundle.dmdArgs ~= test.testName ~ ".d";
            testBundle.dmdArgs ~= buildPath("test_results", os ~ model,
                    test.name ~ "_" ~ variant ~ ".d");
            testBundle.dmdArgs ~= buildPath("test_results", os ~ model, test.name ~ "_lexer.d");
            if (test.name == "examples/cpp/grammarcpp")
            {
                testBundle.dmdArgs ~= buildPath("test_results", os ~ model,
                        "examples/cpp/grammarcpreproc_normal.d");
                testBundle.dmdArgs ~= buildPath("test_results", os ~ model,
                        "examples/cpp/grammarcpreproc_lexer.d");
            }
            testBundle.tests ~= test.name;
            if (needsOwnBundle)
            {
                testBundles ~= testBundle;
                testBundle = TestBundle.init;
            }
        }
        if (testBundle.tests.length)
        {
            testBundles ~= testBundle;
        }
    }

    testBundles.sort!((a, b) => a.filename < b.filename);

    if (parallelCompiling)
    {
        foreach (ref testBundle; parallel(testBundles, 1))
        {
            if (!runCommand(testBundle.dmdArgs,
                    "Compiling " ~ testBundle.filename, verbosity, outputMutex))
                testBundle.failed = true;
        }
    }
    else
    {
        foreach (ref testBundle; testBundles)
        {
            if (!runCommand(testBundle.dmdArgs,
                    "Compiling " ~ testBundle.filename, verbosity, outputMutex))
                testBundle.failed = true;
        }
    }

    foreach (ref testBundle; testBundles)
    {
        if (testBundle.failed)
        {
            anyFailure = true;
            continue;
        }
        if (testBundle.testType == TestType.compileOnly)
            continue;

        Verbosity verbosity2 = verbosity;
        if (testBundle.runtimeOutput.length == 0)
            verbosity2 |= Verbosity.outputAlways;

        string output;
        if (!runCommand([testBundle.filename] ~ testBundle.runtimeArgs, "Running " ~ testBundle.filename,
                verbosity2, outputMutex, null, testBundle.runtimeOutput.length
                ? testBundle.runtimeOutput : IGNORE_OUTPUT, testBundle.runtimeInput))
        {
            anyFailure = true;
        }
    }

    return anyFailure;
}

int main(string[] args)
{
    bool anyFailure;
    Verbosity verbosity = Verbosity.showTime | Verbosity.outputOnError;

    string model;
    static if (size_t.sizeof == 8)
        model = "64";
    else static if (size_t.sizeof == 4)
        model = "32";
    else
        static assert("Unknown size of size_t");

    string compiler = "dmd";
    string jsonTestDir = absolutePath("examples/json/JSONTestSuite/test_parsing");
    string dmdDir = absolutePath("dmd");
    string pythonTestDir = absolutePath("cpython/Lib/test/");
    bool skipSlowExamples;
    bool avoidParallelMemoryUsage;
    Mutex outputMutex = new Mutex();

    for (size_t i = 1; i < args.length; i++)
    {
        auto arg = args[i];
        if (arg.startsWith("-m"))
        {
            model = arg[2 .. $];
        }
        else if (arg == "--compiler")
        {
            if (i + 1 >= args.length)
            {
                stderr.writeln("Missing argument for ", arg);
                return 1;
            }
            i++;
            compiler = args[i];
        }
        else if (arg == "--json-test-dir")
        {
            if (i + 1 >= args.length)
            {
                stderr.writeln("Missing argument for ", arg);
                return 1;
            }
            i++;
            jsonTestDir = absolutePath(args[i]);
        }
        else if (arg == "--dmd-dir")
        {
            if (i + 1 >= args.length)
            {
                stderr.writeln("Missing argument for ", arg);
                return 1;
            }
            i++;
            dmdDir = absolutePath(args[i]);
        }
        else if (arg == "--python-test-dir")
        {
            if (i + 1 >= args.length)
            {
                stderr.writeln("Missing argument for ", arg);
                return 1;
            }
            i++;
            pythonTestDir = absolutePath(args[i]);
        }
        else if (arg == "--skip-slow-examples")
        {
            skipSlowExamples = true;
        }
        else if (arg == "--avoid-parallel-memory-usage")
        {
            avoidParallelMemoryUsage = true;
        }
        else if (arg == "-v")
        {
            verbosity |= Verbosity.outputAlways | Verbosity.outputCommandAlways;
        }
        else if (arg == "--github")
        {
            verbosity |= Verbosity.github;
        }
        else
        {
            stderr.writeln("Unknown argument ", arg);
            return 1;
        }
    }

    version (Windows)
    {
        import core.sys.windows.winbase : SetErrorMode, SEM_NOGPFAULTERRORBOX;

        uint dwMode = SetErrorMode(SEM_NOGPFAULTERRORBOX);
        SetErrorMode(dwMode | SEM_NOGPFAULTERRORBOX);
    }

    const string generator = buildPath("test_results", os ~ model, "dparsergen" ~ exeExt);
    const string generatortests = buildPath("test_results", os ~ model, "generatortests" ~ exeExt);

    Test[] tests;
    Test[] testsLate;
    foreach (DirEntry e; dirEntries("tests/grammars", "*.ebnf", SpanMode.shallow))
    {
        tests ~= Test(e.name[0 .. $ - 5].replace("\\", "/"), TestType.all);
        tests[$ - 1].testName = tests[$ - 1].name ~ "_test";
        tests[$ - 1].extraDmdArgs = [
            "-unittest", "-main", "tests/grammars/testhelpers.d"
        ];
        parseGrammarComments(tests[$ - 1], e.name);
    }
    foreach (DirEntry e; dirEntries("tests/fail_grammars", "*.ebnf", SpanMode.shallow))
    {
        tests ~= Test(e.name[0 .. $ - 5].replace("\\", "/"), TestType.generateOnly);
        parseGrammarComments(tests[$ - 1], e.name);
    }
    tests ~= Test("examples/calc/grammarcalc", TestType.all, ["glr"],
            "examples/calc/testgrammarcalc", [], [], [], "1+2\n", ">>> 3\n>>>");
    tests ~= Test("examples/json/grammarjson", skipSlowExamples ? TestType.compileOnly : TestType.all, [], "examples/json/testgrammarjson",
            ["--mergesimilarstates"], [], ["--test-dir", jsonTestDir]);
    if (!skipSlowExamples)
    {
        testsLate ~= Test("examples/d/grammard", TestType.all, ["glr"],
                "examples/d/testgrammard", [
                    "--optempty", "--mergesimilarstates", "--combinedreduce"
                ], ["-lowmem"], [
                    "--test-dir", absolutePath("examples/d/testgrammard-extra"),
                    "--test-dir-fail",
                    absolutePath("examples/d/testgrammard-extra-failure"),
                    "--test-dir", buildPath(dmdDir, "compiler/test/compilable"),
                    "--test-dir", buildPath(dmdDir, "compiler/test/runnable"),
                    "--test-dir", buildPath(dmdDir, "compiler/test/runnable_cxx"),
                    "--test-dir-fail-dmd",
                    buildPath(dmdDir, "compiler/test/fail_compilation"),
                ]);
        version (Windows)
        {
            testsLate[$ - 1].extraDmdArgs ~= "-L/STACK:8388608";
        }
    }
    tests ~= Test("examples/d/grammarddoc", TestType.compileOnly, [], "examples/d/grammardgen");
    if (!skipSlowExamples)
    {
        testsLate ~= Test("examples/cpp/grammarcpp", TestType.all, [
                "normal", "optdescent"
                ], "examples/cpp/testcpp", [
                "--mergesimilarstates", "--optempty"
                ], [], ["examples/cpp/test.cpp"], "",
                readText("examples/cpp/test-output.txt").strip());
    }
    tests ~= Test("examples/cpp/grammarcpreproc", TestType.generateOnly);
    tests ~= Test("examples/python/grammarpeg", TestType.compileOnly, [], "examples/python/grammarpythongen");
    if (!skipSlowExamples)
    {
        testsLate ~= Test("examples/python/grammarpython", TestType.all, ["glr"],
                "examples/python/testpython", [], [], ["--test-dir", pythonTestDir]);
        version (Windows)
        {
            testsLate[$ - 1].extraDmdArgs ~= "-L/STACK:10485760";
        }
    }

    tests.sort!((a, b) => a.name < b.name);

    if (!runCommand([
            compiler, "-g", "-w", "-m" ~ model, "-i=dparsergen", "-Icore",
            "-Igenerator", "generator/dparsergen/generator/generator.d",
            "-of" ~ generator
        ], "Compiling dparsergen", verbosity, outputMutex))
        return 1;

    if (!runCommand([
            generator, "generator/dparsergen/generator/grammarebnf.ebnf",
            "-o", buildPath("test_results", os ~ model, "grammarebnf.d"),
            "--module", "dparsergen.generator.grammarebnf"
        ], "Generating parser for grammarebnf", verbosity, outputMutex))
        return 1;

    if (!runCommand([
            generator, "generator/dparsergen/generator/grammarebnf.ebnf",
            "--package", "dparsergen.generator", "--lexer",
            buildPath("test_results", os ~ model, "grammarebnf_lexer.d")
        ], "Generating lexer for grammarebnf", verbosity, outputMutex))
        return 1;

    if (!compareFiles(buildPath("test_results", os ~ model, "grammarebnf.d"),
            "generator/dparsergen/generator/grammarebnf.d", verbosity, outputMutex))
        anyFailure = true;
    if (!compareFiles(buildPath("test_results", os ~ model, "grammarebnf_lexer.d"),
            "generator/dparsergen/generator/grammarebnf_lexer.d", verbosity, outputMutex))
        anyFailure = true;

    {
        string generatorHelp;
        if (!runCommand([generator, "--help"], "Generating help for generator",
                verbosity, outputMutex, &generatorHelp))
            anyFailure = true;
        std.file.write(buildPath("test_results", os ~ model, "help.txt"), generatorHelp);

        string helpExpected = readText("docs/generator.md").replace("\r", "")
            .findSplit("```\n")[2].findSplit("```\n")[0];
        std.file.write(buildPath("test_results", os ~ model, "help-expected.txt"), helpExpected);

        if (!compareFiles(buildPath("test_results", os ~ model, "help.txt"),
                buildPath("test_results", os ~ model, "help-expected.txt"), verbosity, outputMutex))
            anyFailure = true;
    }

    if (!runCommand([
            generator, "generator/dparsergen/generator/grammarebnf.ebnf",
            "--doc-html", buildPath("test_results", os ~ model, "grammarebnf.html"),
            "--doc-md", buildPath("test_results", os ~ model, "grammarebnf.md")
        ], "Generating documentation for generator", verbosity, outputMutex))
        anyFailure = true;

    if (!compareFiles(buildPath("test_results", os ~ model, "grammarebnf.md"),
            "docs/syntax.md", verbosity, outputMutex))
        anyFailure = true;

    string[] dmdArgsGeneratortests = [
        compiler, "-g", "-w", "-m" ~ model, "-unittest", "-main", "-Icore",
        "-Igenerator", "-of" ~ generatortests, "tests/generator/generatortests.d"
    ];
    foreach (DirEntry e; dirEntries("core/dparsergen", "*.d", SpanMode.depth))
    {
        dmdArgsGeneratortests ~= e.name;
    }
    foreach (DirEntry e; dirEntries("generator/dparsergen", "*.d", SpanMode.depth))
    {
        dmdArgsGeneratortests ~= e.name;
    }
    if (!runCommand(dmdArgsGeneratortests, "Compiling generatortests", verbosity, outputMutex))
    {
        anyFailure = true;
    }
    else
    {
        if (!runCommand([generatortests], "Running generatortests",
                verbosity | Verbosity.outputAlways, outputMutex))
        {
            anyFailure = true;
        }
    }

    if (runGrammarTests(tests, model, verbosity, compiler, generator, true, outputMutex))
        anyFailure = true;

    if (!anyFailure && runGrammarTests(testsLate, model, verbosity, compiler,
            generator, !avoidParallelMemoryUsage, outputMutex))
        anyFailure = true;

    return anyFailure;
}
