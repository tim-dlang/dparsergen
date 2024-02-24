
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.generator;
import dparsergen.core.dynamictree;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.parseexception;
import dparsergen.core.utils;
import dparsergen.generator.ebnf;
import dparsergen.generator.globaloptions;
import dparsergen.generator.grammar;
import dparsergen.generator.grammarebnf;
import dparsergen.generator.grammarebnf_lexer;
import dparsergen.generator.parser;
import dparsergen.generator.parsercodegen;
import dparsergen.generator.production;
import dparsergen.generator.glrparsercodegen;
import std.algorithm;
import std.conv;
import std.getopt;
import std.exception;
import std.file;
import std.path;
import std.stdio;
import std.string;

void toAnnotations(Tree)(Tree tree, ref Declaration d)
{
    if (tree !is null)
    {
        foreach (i, p; tree.childs)
        {
            assert(p.name == "Annotation");
            assert(p.childs.length == 3);
            if (p.childs[0].content == "@")
            {
                string name = p.childs[1].content;
                if (p.childs[2]!is null)
                {
                    name ~= "(" ~ concatTree(p.childs[2].childs[1]).strip() ~ ")";
                }
                d.annotations ~= name;
            }
            else
                assert(false);
        }
    }
}

Declaration toDeclaration(Tree)(Tree tree)
{
    if (tree.name == "SymbolDeclaration")
    {
        Declaration r;
        auto childs = tree.childs;
        assert(childs.length.among(5, 7));
        if (childs[0]!is null)
        {
            assert(childs[0].name == "DeclarationType");
            if (childs[0].childs[0].content == "token")
                r.type = DeclarationType.token;
            if (childs[0].childs[0].content == "fragment")
                r.type = DeclarationType.fragment;
        }
        r.name = childs[1].content;
        if (childs[2]!is null)
        {
            foreach (i, p; childs[2].childs[1].childs)
            {
                if (i % 2 == 0)
                {
                    assert(p.name == "MacroParameter");
                    if (p.childs.length >= 2)
                    {
                        if (r.variadicParameterIndex != size_t.max)
                            throw new Exception("too many variadic parameters");
                        r.variadicParameterIndex = r.parameters.length;
                    }
                    r.parameters ~= p.childs[0].content;
                }
                else
                    assert(p.content == ",");
            }
        }
        childs[3].toAnnotations(r);
        if (childs.length == 7)
            r.exprTree = childs[$ - 2];
        return r;
    }
    else
        assert(0, tree.toString);
}

typeof(next(Tree.init))[] toArray(alias next, Tree)(Tree tree, string listName)
{
    if (tree is null)
        return [];
    if (tree.name == listName || tree.nodeType == NodeType.array)
    {
        typeof(next(tree))[] r;
        foreach (c; tree.childs)
        {
            if (!c.isToken)
                r ~= toArray!next(c, listName);
        }
        return r;
    }
    if (tree.name != listName)
        return [next(tree)];
    assert(0);
}

EBNF toEBNF(Tree)(Tree tree, DocComment[] docComments)
{
    EBNF r;
    assert(tree.name == "EBNF");
    assert(tree.childs.length == 1);

    size_t numGlobalDocumentation;
    while (docComments.length && docComments[numGlobalDocumentation].end.line <= tree.start.line)
        numGlobalDocumentation++;
    if (numGlobalDocumentation
            && docComments[numGlobalDocumentation - 1].end.line >= tree.start.line - 1)
    {
        numGlobalDocumentation--;
        while (numGlobalDocumentation
                && docComments[numGlobalDocumentation - 1].end.line
                >= docComments[numGlobalDocumentation].start.line - 1)
            numGlobalDocumentation--;
    }
    foreach (comment; docComments[0 .. numGlobalDocumentation])
    {
        if (r.globalDocumentation.length)
            r.globalDocumentation ~= "\n";
        r.globalDocumentation ~= comment.content;
    }
    docComments = docComments[numGlobalDocumentation .. $];

    void convertTree(Tree tree)
    {
        if (tree.nodeType == NodeType.array)
        {
            foreach (c; tree.childs)
            {
                convertTree(c);
            }
            return;
        }

        if (tree.name == "SymbolDeclaration")
        {
            string documentation;
            while (docComments.length && docComments[0].end.line <= tree.end.line)
            {
                if (documentation.length)
                    documentation ~= "\n";
                documentation ~= docComments[0].content;
                docComments = docComments[1 .. $];
            }

            r.symbols ~= toDeclaration(tree);
            r.symbols[$ - 1].documentation = documentation;
        }
        else if (tree.name == "MatchDeclaration")
        {
            assert(tree.childs.length == 4);
            r.matchingTokens ~= [
                tree.childs[1].childs[0].content, tree.childs[2].childs[0].content
            ];
        }
        else if (tree.name == "Import")
        {
            assert(tree.childs.length == 3);
            r.imports ~= tree.childs[1].content;
        }
        else if (tree.name == "OptionDeclaration")
        {
            assert(tree.childs.length == 2);

            bool found = false;
            static foreach (name; [
                    "startTokenID", "startNonterminalID", "startProductionID"
                ])
            {
                if (tree.childs[0].content == name)
                {
                    assert(!found);
                    found = true;
                    mixin("r." ~ name ~ " = to!size_t(tree.childs[1].content);");
                }
            }
            assert(found);
        }
        else
            assert(false, tree.name);
    }

    convertTree(tree.childs[0]);
    return r;
}

struct DocComment
{
    string content;
    LocationAll start;
    LocationAll end;
}

struct LexerWrapper
{
    Lexer!(LocationAll, true) lexer;

    alias Location = LocationAll;
    alias LocationDiff = typeof(Location.init - Location.init);

    this(string input, Location startLocation = Location.init)
    {
        lexer = Lexer!(LocationAll, true)(input, startLocation);
        skipIgnoredTokens();
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
        skipIgnoredTokens();
    }

    DocComment[] docComments;

    string cleanDocComment(string ignoredChars)(string content)
    {
        while (content.length && content[0].inCharSet!(ignoredChars))
            content = content[1 .. $];
        if (content.startsWith("\r\n"))
            content = content[2 .. $];
        else if (content.startsWith("\n"))
            content = content[1 .. $];
        while (content.length && content[$ - 1].inCharSet!ignoredChars)
            content = content[0 .. $ - 1];
        bool first = true;
        string commonPrefix;
        foreach (line; content.lineSplitter)
        {
            line = line.stripRight;
            size_t i;
            if (first)
            {
                while (i < line.length && line[i].inCharSet!ignoredChars)
                    i++;
            }
            else
            {
                while (i < line.length && i < commonPrefix.length && line[i] == commonPrefix[i])
                    i++;
                if (i >= line.length)
                    continue;
            }
            commonPrefix = line[0 .. i];
            first = false;
        }
        string content2;
        foreach (line; content.lineSplitter)
        {
            if (line.length > commonPrefix.length)
                content2 ~= line[commonPrefix.length .. $].stripRight ~ "\n";
            else
                content2 ~= "\n";
        }
        return content2;
    }

    void skipIgnoredTokens()
    {
        while (!lexer.empty && lexer.front.isIgnoreToken)
        {
            if (lexer.front.symbol == lexer.tokenID!"LineComment"
                    && lexer.front.content.startsWith("///"))
            {
                docComments ~= DocComment(lexer.front.content[3 .. $].strip() ~ "\n",
                        lexer.front.currentLocation, lexer.front.currentTokenEnd);
            }
            if (lexer.front.symbol == lexer.tokenID!"BlockComment"
                    && lexer.front.content.startsWith("/**"))
            {
                string content = cleanDocComment!"* \t"(lexer.front.content[3 .. $ - 2]);
                docComments ~= DocComment(content, lexer.front.currentLocation,
                        lexer.front.currentTokenEnd);
            }
            if (lexer.front.symbol == lexer.tokenID!"NestingBlockComment"
                    && lexer.front.content.startsWith("/++"))
            {
                string content = cleanDocComment!"+ \t"(lexer.front.content[3 .. $ - 2]);
                docComments ~= DocComment(content, lexer.front.currentLocation,
                        lexer.front.currentTokenEnd);
            }
            lexer.popFront;
        }
    }
}

EBNF parseEBNF2(string str, string filename)
{
    alias Creator = DynamicParseTreeCreator!(dparsergen.generator.grammarebnf,
            LocationAll, LocationRangeStartEnd);
    auto creator = new Creator;
    EBNF ebnf;
    try
    {
        LexerWrapper lexer = LexerWrapper(str, LocationAll.init);
        Tree tree = parse!(Creator, LexerWrapper)(lexer, creator);
        ebnf = toEBNF(tree, lexer.docComments);
        if (!lexer.empty)
        {
            throw new SingleParseException!LocationAll("input left after parse",
                    lexer.front.currentLocation, lexer.front.currentTokenEnd);
        }
    }
    catch (ParseException e)
    {
        string message;
        auto e2 = cast(SingleParseException!LocationAll) e.maxEndException();
        message ~= filename ~ ":";
        if (e2 !is null)
        {
            message ~= text(e2.markStart.line + 1, ":", e2.markStart.offset, ":");
        }
        message ~= " ";
        e2.toString(str, (data) { message ~= data; },
                ExceptionStringFlags.noBacktrace | ExceptionStringFlags.noLocation);
        message = message.strip();
        stderr.writeln(message);
        throw e;
    }

    return ebnf;
}

EBNF[] readEBNFFiles(string firstfilename)
{
    string input = readText(firstfilename);

    EBNF[] ebnfs = [input.parseEBNF2(firstfilename)];

    auto imports = new TodoList!string;
    void addImports(string currentFilename, string[] importDecls)
    {
        foreach (filename; importDecls)
        {
            assert(filename[0] == '"');
            assert(filename[$ - 1] == '"');
            filename = filename[1 .. $ - 1];
            filename = absolutePath(filename, dirName(absolutePath(currentFilename)));
            imports.put(filename);
        }
    }

    addImports(firstfilename, ebnfs[0].imports);
    foreach (filename; imports.keys)
    {
        string input2 = readText(filename);
        EBNF ebnf2 = input2.parseEBNF2(filename);
        ebnfs ~= ebnf2;
        addImports(filename, ebnf2.imports);
    }
    return ebnfs;
}

int main(string[] args)
{
    GlobalOptions globalOptions = new GlobalOptions;
    string packagename;
    string parsermodule;
    string lexermodule;
    bool optimizationEmpty;
    bool regexlookahead;
    string outfilename;
    string dotfilename;
    string lexerfilename;
    string lexerdfafilename;
    string finalgrammarfilename;
    string docfilenamehtml;
    string docfilenamemd;
    bool glrGlobalCache;

    auto helpInformation = getopt(
        args,
        "o|parser", "Output filename for parser", &outfilename,
        "module", "Set module name for parser", &parsermodule,
        "lexer-module", "Set module name for lexer", &lexermodule,
        "package", "Set package for parser and lexer", &packagename,
        "lexer", "Generate lexer in this file", &lexerfilename,
        "glr", "Generate parser with GLR instead of LALR", &globalOptions.glrParser,
        "combinedreduce", "Allows to resolve some conflicts", () { globalOptions.delayedReduce = DelayedReduce.combined; },
        "mergesimilarstates", "Reduce number of parser states by combining some states", &globalOptions.mergeSimilarStates,
        "lexer-dfa", "Generate graph for lexer", &lexerdfafilename,
        "graph", "Generate graph for parser", &dotfilename,
        "finalgrammar", "Generate grammar file after all grammar rewritings", &finalgrammarfilename,
        "doc-html", "Generate documentation in HTML format", &docfilenamehtml,
        "doc-md", "Generate documentation in Markdown format", &docfilenamemd,
        "optdescent", "Try to make decisions in the parser earlier", &globalOptions.optimizationDescent,
        "optempty", "Rewrite grammar to remove empty productions", &optimizationEmpty,
        "regexlookahead", "Try to resolve conflicts with arbitrary lookahead", &regexlookahead,
        "glr-global-cache", "Use a global cache for the GLR parser (normally not needed)", &glrGlobalCache,
        );

    if (helpInformation.helpWanted || args.length != 2)
    {
        if (helpInformation.options[$ - 1].optShort == "-h")
            helpInformation.options[$ - 1].help = "Print this help and exit";

        size_t ls, ll;
        foreach (it; helpInformation.options)
        {
            ls = max(ls, it.optShort.length);
            ll = max(ll, it.optLong.length);
        }

        writeln("dparsergen grammar.ebnf [OPTIONS]");
        foreach (it; helpInformation.options)
        {
            writefln("%*s %s%*s%s%s", ls, it.optShort,
                it.optLong, ll - it.optLong.length, "",
                it.help.length ? " " : "", it.help);
        }

        return 0;
    }

    string grammarfilename = args[1];

    if (parsermodule.length == 0)
    {
        parsermodule = baseName(outfilename, ".d");
    }

    if (lexermodule.length == 0)
    {
        lexermodule = baseName(lexerfilename, ".d");
    }

    if (packagename.length)
    {
        parsermodule = packagename ~ "." ~ parsermodule;
        lexermodule = packagename ~ "." ~ lexermodule;
    }

    if (globalOptions.glrParser)
    {
        globalOptions.delayedReduce = DelayedReduce.none;
    }

    EBNF[] ebnfs;
    try
    {
        ebnfs = readEBNFFiles(grammarfilename);
    }
    catch (ParseException e)
    {
        /* Already printed in parseEBNF2. */
        return 1;
    }
    catch (Exception e)
    {
        if (e.msg == "Enforcement failed")
            stderr.writeln(e);
        else
            stderr.writeln(e.msg);
        return 1;
    }

    EBNF ebnf = ebnfs[0];
    foreach (ebnf2; ebnfs[1 .. $])
    {
        ebnf.symbols ~= ebnf2.symbols;
        ebnf.matchingTokens ~= ebnf2.matchingTokens;
    }

    if (docfilenamehtml.length)
    {
        import dparsergen.generator.doc;

        genDoc(ebnfs[0], docfilenamehtml, DocType.html);
    }
    if (docfilenamemd.length)
    {
        import dparsergen.generator.doc;

        genDoc(ebnfs[0], docfilenamemd, DocType.markdown);
    }

    EBNFGrammar grammar;
    try
    {
        grammar = ebnf.createGrammar();
    }
    catch (Exception e)
    {
        if (e.msg == "Enforcement failed")
            stderr.writeln(e);
        else
            stderr.writeln(e.msg);
        return 1;
    }
    if (globalOptions.glrParser)
        grammar.tokens.id("$flushreduces");

    bool hasRegArray;
    bool hasDeactivated;
    void checkAnnotations(Annotations annotations)
    {
        if (annotations.contains!"regArray")
            hasRegArray = true;
        if (annotations.contains!"deactivated")
            hasDeactivated = true;
        if (annotations.contains!"directUnwrap")
            globalOptions.directUnwrap = true;
    }

    foreach (i; grammar.nonterminals.allIDs)
        checkAnnotations(grammar.nonterminals[i].annotations);
    foreach (i; grammar.tokens.allIDs)
        checkAnnotations(grammar.tokens[i].annotations);
    foreach (p; grammar.productions)
    {
        checkAnnotations(p.annotations);
        foreach (s; p.symbols)
            checkAnnotations(s.annotations);
    }

    string symbolName(Symbol n)
    {
        if (n.id == size_t.max)
            return "";
        return grammar.getSymbolName(n);
    }

    enforce(!hasRegArray || !hasDeactivated);

    try
    {
        if (hasRegArray)
            grammar = createRegArrayGrammar(ebnf, grammar);

        grammar = createSortedGrammar(grammar);

        if (optimizationEmpty)
            grammar = createOptEmptyGrammar(ebnf, grammar);

        if (hasDeactivated)
            grammar = createGrammarWithoutDeactivatedProductions(grammar);
    }
    catch (Exception e)
    {
        if (e.msg == "Enforcement failed")
            stderr.writeln(e);
        else
            stderr.writeln(e.msg);
        return 1;
    }

    EBNFGrammar lexerGrammar;
    if (lexerfilename.length || finalgrammarfilename)
        lexerGrammar = createLexerGrammar(ebnf, grammar);

    if (finalgrammarfilename.length)
    {
        writeFinalGrammarFile(finalgrammarfilename, grammar, lexerGrammar);
    }

    if (outfilename.length)
    {
        LRGraph graphWithDeactivated = null;
        if (hasDeactivated)
            graphWithDeactivated = makeLRGraph(grammar.origGrammar, globalOptions);
        auto graph = makeLRGraph(grammar, globalOptions, graphWithDeactivated);
        foreach (i, ref s; graph.states)
        {
            bool deactivated;
            foreach (element; s.elements)
                if (element.production.annotations.contains!"deactivated"())
                    deactivated = true;
            if (deactivated)
                graph.states[i] = new LRGraphNode();
        }

        const(char)[] output;
        if (globalOptions.glrParser)
            output = dparsergen.generator.glrparsercodegen.createParserModule(graph, parsermodule, glrGlobalCache);
        else
            output = dparsergen.generator.parsercodegen.createParserModule(graph,
                    parsermodule, regexlookahead);
        std.file.write(outfilename, output);
    }

    if (lexerfilename.length)
    {
        import dparsergen.generator.lexergenerator;

        try
        {
            const(char)[] output = createLexerCode(lexerGrammar, lexermodule, lexerdfafilename);
            std.file.write(lexerfilename, output);
        }
        catch (Exception e)
        {
            if (e.msg == "Enforcement failed")
                stderr.writeln(e);
            else
                stderr.writeln(e.msg);
            return 1;
        }
    }

    return 0;
}
