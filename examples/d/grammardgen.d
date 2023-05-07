module grammardgen;
import dparsergen.core.dynamictree;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
import std.algorithm;
import std.array;
import std.conv;
import std.process;
import std.stdio;
import std.string;

static import grammarddoc_lexer;

alias Tree = DynamicParseTree!(LocationAll, LocationRangeStartEnd);

void printTree(Tree tree, ref string output)
{
    if (tree is null)
        return;
    if (tree.isToken)
        output ~= tree.content;

    foreach (c; tree.childs)
        printTree(c, output);
}

struct Symbol
{
    string name;
    bool isToken;
    bool hasOpt;
}

void printSymbol(Tree tree, ref Symbol[] output)
{
    if (tree.name == "WS")
    {
        if (output[$ - 1].name.length)
        {
            output.length++;
            output[$ - 1].isToken = output[$ - 2].isToken;
        }
    }
    else if (tree.name == "Macro")
    {
        Tree[] content = tree.childs[2].childs;
        while (content.length && content[0].name == "WS")
            content = content[1 .. $];
        if (tree.childs[1].content == "D")
        {
            output[$ - 1].isToken = true;
            foreach (c; content)
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "B")
        {
            output[$ - 1].isToken = true;
            foreach (c; content)
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "D].")
        {
            output[$ - 1].isToken = true;
            output[$ - 1].name ~= "]";
            output.length++;
            output[$ - 1].isToken = true;
            output[$ - 1].name ~= ".";
        }
        else if (tree.childs[1].content == "I")
        {
            foreach (c; content)
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "RELATIVE_LINK2")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                    break;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "GLINK2")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                    break;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "LINK2")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                    break;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "GLINK")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                    break;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "GSELF")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                    break;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "DDSUBLINK")
        {
            size_t paramStart = 0;
            foreach (i, c; content)
                if (c.name == "Comma")
                {
                    paramStart = i + 1;
                }
            foreach (c; content[paramStart .. $])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "GLINK_LEX")
        {
            foreach (c; content[0 .. 1])
                printSymbol(c, output);
        }
        else if (tree.childs[1].content == "LPAREN")
        {
            output[$ - 1].name ~= "(";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "RPAREN")
        {
            output[$ - 1].name ~= ")";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "CODE_LCURL")
        {
            output[$ - 1].name ~= "{";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "CODE_RCURL")
        {
            output[$ - 1].name ~= "}";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "CODE_PERCENT")
        {
            output[$ - 1].name ~= "%";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "BACKTICK")
        {
            output[$ - 1].name ~= "`";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "CODE_AMP")
        {
            output[$ - 1].name ~= "&";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "AMP")
        {
            output[$ - 1].name ~= "&";
            output[$ - 1].isToken = true;
        }
        else if (tree.childs[1].content == "IDENTIFIER")
        {
            output[$ - 1].name ~= "Identifier";
        }
        else if (tree.childs[1].content == "EXPRESSION")
        {
            output[$ - 1].name ~= "Expression";
        }
        else if (tree.childs[1].content == "ASSIGNEXPRESSION")
        {
            output[$ - 1].name ~= "AssignExpression";
        }
        else if (tree.childs[1].content == "PSCURLYSCOPE")
        {
            output[$ - 1].name ~= "NonEmptyOrScopeBlockStatement";
        }
        else if (tree.childs[1].content == "PSSCOPE")
        {
            output[$ - 1].name ~= "ScopeStatement";
        }
        else if (tree.childs[1].content == "PSSEMI_PSCURLYSCOPE_LIST")
        {
            output[$ - 1].name ~= "ScopeStatementList";
        }
        else if (tree.childs[1].content == "PS0")
        {
            output[$ - 1].name ~= "NoScopeNonEmptyStatement";
        }
        else if (tree.childs[1].content == "PSSEMI")
        {
            output[$ - 1].name ~= "NoScopeStatement";
        }
        else if (tree.childs[1].content == "PSSEMI_PSCURLYSCOPE")
        {
            output[$ - 1].name ~= "Statement";
        }
        else
        {
            output[$ - 1].name ~= "$(" ~ tree.childs[1].content;
            foreach (c; content)
                printSymbol(c, output);
            output[$ - 1].name ~= ")";
        }
    }
    else
    {
        string names;
        printTree(tree, names);
        foreach (i, name; names.split())
        {
            if (name.length >= 3 && name[0] == '`' && name[$ - 1] == '`')
            {
                if (output[$ - 1].name.length)
                {
                    output.length++;
                }
                output[$ - 1].isToken = true;
                name = name[1 .. $ - 1];
            }
            else if (i)
            {
                output.length++;
                output[$ - 1].isToken = output[$ - 2].isToken;
            }
            output[$ - 1].name ~= name;
        }
    }
}

class Context
{
    string[string] nonterminals;
    string[] nonterminalsOrder;
    bool[string] tokens;
    bool isLexer;
}

void analyzeNonterminal(Tree[] trees, Context context, bool isToken)
{
    string name;
    assert(trees[0].name == "Macro");
    assert(trees[0].childs[1].content == "GNAME");
    foreach (c; trees[0].childs[2].childs)
        if (c.name == "Text")
            name = c.childs[0].content;
    trees = trees[1 .. $];
    while (true)
    {
        assert(trees.length);
        if (trees[0].name == "Text" && trees[0].childs[0].content == ":")
        {
            trees = trees[1 .. $];
        }
        else if (trees[0].name == "Macro" && trees[0].childs[1].content == "LEGACY_LNAME2")
        {
            trees = trees[1 .. $];
        }
        else if (trees[0].name == "NL")
        {
            trees = trees[1 .. $];
            break;
        }
        else
        {
            assert(false, text(trees[0]));
        }
    }

    Symbol[][] symbols = [[Symbol()]];

    void findSymbols(Tree[] trees)
    {
        foreach (i, c; trees)
        {
            if (c.name == "NL")
            {
                if (symbols[$ - 1].length > 1 || symbols[$ - 1][0].name.length)
                {
                    symbols ~= [Symbol()];
                }
            }
            else if (c.name == "WS")
            {
                if (symbols[$ - 1][$ - 1].name.length)
                    symbols[$ - 1].length++;
            }
            else if (c.name == "Macro" && c.childs[1].content == "OPT")
            {
                symbols[$ - 1][$ - 1].hasOpt = true;
            }
            else if (c.name == "Macro" && c.childs[1].content == "LEGACY_LNAME2")
            {
            }
            else if (c.name == "Macro" && c.childs[1].content == "MULTICOLS")
            {
                Tree[] trees2 = c.childs[2].childs;
                while (trees2.length)
                {
                    if (trees2[0].name == "Comma")
                    {
                        trees2 = trees2[1 .. $];
                        break;
                    }
                    trees2 = trees2[1 .. $];
                }
                findSymbols(trees2);
            }
            else
            {
                printSymbol(c, symbols[$ - 1]);
            }
        }
    }

    findSymbols(trees);

    foreach (ref output; symbols)
    {
        if (output[$ - 1].name.length == 0)
            output.length--;
        if (output.length && output[$ - 1].name.startsWith("(") && output[$ - 1].name.endsWith(")"))
            output.length--;
    }
    if (symbols[$ - 1].length == 0)
        symbols.length--;

    if (name == "Register" || name == "Register64")
    {
        Symbol[][] symbolsBak = symbols;
        symbols = [];
        foreach (output; symbolsBak)
        {
            foreach (s; output)
                symbols ~= [s];
        }
    }

    string[][string] tokensToSplit = [
        "ST(0)": ["ST", "(", "0", ")"],
        "ST(1)": ["ST", "(", "1", ")"],
        "ST(2)": ["ST", "(", "2", ")"],
        "ST(3)": ["ST", "(", "3", ")"],
        "ST(4)": ["ST", "(", "4", ")"],
        "ST(5)": ["ST", "(", "5", ")"],
        "ST(6)": ["ST", "(", "6", ")"],
        "ST(7)": ["ST", "(", "7", ")"],
        "!is": ["!", "is"],
        "!in": ["!", "in"],
        ");": [")", ";"],
        "scope(success)": ["scope", "(", "success", ")"],
        "scope(exit)": ["scope", "(", "exit", ")"],
        "scope(failure)": ["scope", "(", "failure", ")"],
        "C++": ["C", "++"],
        "C++,": ["C", "++", ","],
        "Objective - C": ["Objective", "-", "C"],
        "( )": ["(", ")"],
    ];
    foreach (i, ref output; symbols)
    {
        Symbol[] output2;
        foreach (s; output)
        {
            if (s.isToken && s.name in tokensToSplit)
            {
                assert(!s.hasOpt);
                foreach (x; tokensToSplit[s.name])
                {
                    output2 ~= Symbol(x, true);
                }
            }
            else
                output2 ~= s;
        }
        output = output2;
    }

    if (name.endsWith("String"))
        isToken = true;
    if (name == "Token" || name == "Keyword" || name == "StringLiteral" || name == "TokenString")
        isToken = false;
    string code;
    if (isToken)
        code ~= "token ";
    code ~= name;
    if (name.endsWith("Comment") || name == "SpecialTokenSequence"
            || name == "EndOfLine" || name == "WhiteSpace")
        code ~= " @IgnoreToken";
    if (name == "Module")
        code ~= " @Start";
    if (name == "Identifier")
        code ~= " @LowPrio";
    if (isToken)
        context.tokens[name] = true;
    code ~= "\n";
    foreach (i, ref output; symbols)
    {
        if (name == "ParameterAttributes" && output.length == 1
                && output[0].name == "ParameterAttributes")
            continue;

        if (name == "NestingBlockComment")
        {
            output.length++;
            output[$ - 1] = output[$ - 2];
            output[$ - 2].isToken = false;
            output[$ - 2].name = "/(+*)/";
        }
        if (name == "NestingBlockCommentCharacter" && output[0].name == "NestingBlockComment")
        {
            output.length++;
            output[1] = output[0];
            output[0].isToken = false;
            output[0].name = "/(\\/*)/";
        }
        if (name == "NestingBlockCommentCharacters" && output.length == 1)
        {
            output[0].isToken = false;
            output[0].name = "eps";
        }
        if ((name == "DoubleQuotedCharacters" || name == "WysiwygCharacters"
                || name == "HexStringChars") && output.length == 1)
        {
            output[0].isToken = false;
            output[0].name = "eps";
        }

        if (i)
            code ~= "    |";
        else
            code ~= "    =";
        foreach (ref s; output)
        {
            if (s.name == ".." || s.name == "," || s.name == "=")
                s.isToken = true;
            if (name == "TraitsKeyword")
                s.isToken = true;

            if (name == "BlockComment" && s.name == "Characters")
            {
                s.isToken = false;
                s.name = "/(([^*]|[*][*]*[^\\/*])*[*]*)/";
            }
            if (name == "LineComment" && s.name == "Characters")
            {
                s.isToken = false;
                s.name = "/([^\\n\\r\\u000D\\u000A\\u2028\\u2029\\0\\x1a]*)/";
            }
            if (name == "NestingBlockCommentCharacter" && s.name == "Character")
            {
                s.isToken = false;
                s.name = "/[^+\\/]|++*[^+\\/]|\\/\\/*[^+\\/]/";
            }
            if (name == "DoubleQuotedCharacter" && s.name == "Character")
            {
                s.isToken = false;
                s.name = "/[^\\\"\\\\]/";
            }
            if (name == "SingleQuotedCharacter" && s.name == "Character")
            {
                s.isToken = false;
                s.name = "/[^\\\'\\\\]/";
            }
            if (name == "FloatLiteral" && s.name == "Integer")
            {
                s.isToken = false;
                s.name = "DecimalInteger"; // TODO: only this?
            }
            if (name == "DeclDefs" && output.length == 2)
            {
                if (s.name == "DeclDefs")
                    s.name = "DeclDef";
                else
                    s.name = "DeclDefs";
            }

            if (s.isToken)
            {
                if (!context.isLexer && s.name.length == 1 && s.name[0] >= '0' && s.name[0] <= '9')
                {
                    code ~= " IntegerLiteral>>\"" ~ s.name ~ "\"";
                }
                else
                {
                    string tname = s.name;
                    if (tname.length == 6 && tname.startsWith("\\u"))
                    {
                    }
                    else
                        tname = tname.escapeD;
                    code ~= " \"" ~ tname ~ "\"";
                }
            }
            else
            {
                if (!context.isLexer && output.length == 1 && s.name[0] != '/'
                        && s.name != "eps" && s.name !in context.tokens)
                    code ~= " <" ~ s.name;
                else
                    code ~= " " ~ s.name;
            }
            if (s.hasOpt)
                code ~= "?";
        }
        code ~= "\n";
    }
    code ~= "    ;\n";
    if (name in context.nonterminals)
    {
        //assert(context.nonterminals[name] == code, text(code, "=================\n", context.nonterminals[name]));
    }
    else
        context.nonterminalsOrder ~= name;
    context.nonterminals[name] = code;
}

void analyzeGrammar(Tree tree, Context context)
{
    if (tree is null)
        return;
    size_t start = size_t.max;
    bool isToken = context.isLexer;
    foreach (i, c; tree.childs[2].childs)
    {
        if (c.name == "Macro" && c.childs[1].content == "GNAME")
        {
            if (start != size_t.max)
            {
                analyzeNonterminal(tree.childs[2].childs[start .. i], context, isToken);
                isToken = false;
            }
            start = i;
        }
    }
    if (start != size_t.max)
        analyzeNonterminal(tree.childs[2].childs[start .. $], context, isToken);
}

void findGrammar(Tree tree, Context context)
{
    if (tree is null)
        return;
    if (tree.nodeType == NodeType.nonterminal && tree.name == "Macro"
            && tree.childs[1].content.among("GRAMMAR", "GRAMMAR_LEX"))
    {
        analyzeGrammar(tree, context);
    }
    else
    {
        foreach (c; tree.childs)
            findGrammar(c, context);
    }
}

int main(string[] args)
{
    import P = grammarddoc;
    import std.file;
    import std.path;
    import std.stdio;

    alias L = grammarddoc_lexer.Lexer!LocationAll;
    alias Creator = DynamicParseTreeCreator!(P, LocationAll, LocationRangeStartEnd);
    Creator creator = new Creator;

    if (args.length != 4)
    {
        stderr.writeln("Usage: grammarcppgen dlang.org grammard.ebnf grammardlex.ebnf");
        return 1;
    }
    string dlangRepo = args[1];

    auto git = execute(["git", "-C", dlangRepo, "rev-parse", "HEAD"]);

    Context contextLex = new Context();
    contextLex.isLexer = true;
    foreach (f; ["lex"])
    {
        string filename = dlangRepo ~ "/spec/" ~ f ~ ".dd";

        string inText = readText(filename);

        auto tree = P.parse!(Creator, L)(inText, creator);
        assert(tree.inputLength.bytePos <= inText.length);

        findGrammar(tree, contextLex);
        File of = File(args[3], "w");
        if (git.status == 0)
            of.writeln("// Based on grammar from dlang.org commit ", git.output.strip(), "\n");
        foreach (name; contextLex.nonterminalsOrder)
        {
            of.write(contextLex.nonterminals[name]);
        }
        of.writeln("Letter = [a-zA-Z];");
        of.writeln("Tokens @Array = eps | Tokens Token;");
    }

    Context context = new Context();
    context.tokens = contextLex.tokens;

    foreach (f; [
            "module", "expression", "declaration", "iasm", "attribute",
            "statement", "template", "class", "traits", "function", "struct",
            "unittest", "version", "template-mixin", "enum", "pragma", "interface",
            "type"
        ])
    {
        string filename = dlangRepo ~ "/spec/" ~ f ~ ".dd";

        string inText = readText(filename);

        auto tree = P.parse!(Creator, L)(inText, creator);
        assert(tree.inputLength.bytePos <= inText.length);

        findGrammar(tree, context);
    }
    foreach (name; [
            "ParameterMemberAttributes", "FunctionAttributes", "TypeVector",
            "Opcode"
        ])
    {
        if (name in context.nonterminals)
            continue;
        context.nonterminals[name] = name ~ " = \"TODO\";\n";
        context.nonterminalsOrder ~= name;
    }
    File of = File(args[2], "w");
    if (git.status == 0)
        of.writeln("// Based on grammar from dlang.org commit ", git.output.strip(), "\n");
    of.writeln("import \"grammardlex.ebnf\";");
    foreach (name; context.nonterminalsOrder)
    {
        of.write(context.nonterminals[name]);
    }
    return 0;
}
