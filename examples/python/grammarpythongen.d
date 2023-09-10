module grammardgen;
import dparsergen.core.dynamictree;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
import std.algorithm;
import std.array;
import std.ascii;
import std.conv;
import std.process;
import std.stdio;
import std.string;
import std.uni;

static import grammarpeg_lexer;

alias Tree = DynamicParseTree!(LocationAll, LocationRangeStartEnd);

string convertName(string name)
{
    if (name == "NAME")
        return "Identifier";
    if (name == "STRING")
        return "Stringliteral";
    if (name == "NEWLINE")
        return "Newline";
    if (name == "INDENT")
        return "Indent";
    if (name == "DEDENT")
        return "Dedent";
    if (name == "SPACE")
        return "Space";
    if (name == "NUMBER")
        return "Number";
    string r;
    bool wordStart = true;
    foreach (char c; name)
    {
        if (c >= 'a' && c <= 'z')
        {
            if (wordStart)
                r ~= c - 'a' + 'A';
            else
                r ~= c;
            wordStart = false;
        }
        else if (c == '_')
        {
            wordStart = true;
        }
        else
            r ~= c;
    }
    return r;
}

void writeSymbol(File outfile, Tree tree, const string[string] replacements)
{
    assert(tree.nodeType == NodeType.token);
    if (tree.content[0] == '\'' || tree.content[0] == '"')
        outfile.write("\"", tree.content[1 .. $ - 1], "\"");
    else
    {
        string name = tree.content;
        if (tree.content[0] == '`')
            name = name[1 .. $ - 1];
        name = convertName(name);
        if (name in replacements)
            name = replacements[name];
        outfile.write(name);
    }
}
void writeExpression(File outfile, Tree tree, const string[string] replacements)
{
    if (tree.name == "NamedExpression")
    {
        writeExpression(outfile, tree.childs[$ - 1], replacements);
    }
    else if (tree.name == "Expression" && tree.childs.length == 1)
    {
        writeSymbol(outfile, tree.childs[0], replacements);
    }
    else if (tree.name == "Expression" && tree.childs.length == 2)
    {
        writeExpression(outfile, tree.childs[0], replacements);
        outfile.write(tree.childs[1].content);
    }
    else if (tree.name == "Expression" && tree.childs.length == 3)
    {
        if (tree.childs[1].childs.length == 1)
        {
            auto production = tree.childs[1].childs[0];
            if (production.nodeType == NodeType.nonterminal && production.name == "Production")
            {
                auto childs = filterProductionChilds(production.childs[0].childs);
                if (childs.length == 1)
                {
                    writeExpression(outfile, childs[0], replacements);
                    return;
                }
            }
        }

        outfile.write("{");
        foreach (production; tree.childs[1].childs)
        {
            if (production.nodeType == NodeType.token)
                outfile.write(" ", production.content, " ");
            else
                writeExpression(outfile, production, replacements);
        }
        outfile.write("}");
    }
    else if (tree.name == "PrefixExpression" && tree.childs.length == 4)
    {
        outfile.write("list(");
        writeExpression(outfile, tree.childs[2], replacements);
        outfile.write(", ");
        writeSymbol(outfile, tree.childs[0], replacements);
        outfile.write(")");
    }
    else if (tree.name == "PrefixExpression" && tree.childs.length == 2
        && tree.childs[0].content == "&&")
    {
        //outfile.write("/*&&*/");
        writeExpression(outfile, tree.childs[1], replacements);
    }
    else if (tree.name == "PrefixExpression")
    {
        outfile.write("/* ");
        foreach (part; tree.childs)
        {
            if (part.nodeType == NodeType.token)
                outfile.write(part.content);
            else if(part.name == "PrefixExpression" && part.childs.length == 2)
            {
                outfile.write(part.childs[0].content);
                writeExpression(outfile, part.childs[1], replacements);
            }
            else
                writeExpression(outfile, part, replacements);
        }
        outfile.write(" */");
    }
    else if (tree.name == "BracketExpression")
    {
        if (tree.childs[1].childs.length == 1
            && tree.childs[1].childs[0].name == "Production"
            && tree.childs[1].childs[0].childs[0].childs.length == 1)
        {
            writeExpression(outfile, tree.childs[1].childs[0], replacements);
            outfile.write("?");
        }
        else
        {
            outfile.write("{");
            foreach (production; tree.childs[1].childs)
            {
                if (production.nodeType == NodeType.token)
                    outfile.write(" ", production.content, " ");
                else
                    writeExpression(outfile, production, replacements);
            }
            outfile.write("}?");
        }
    }
    else if (tree.name == "Production")
    {
        foreach (i, expr; filterProductionChilds(tree.childs[0].childs))
        {
            if (i)
                outfile.write(" ");
            writeExpression(outfile, expr, replacements);
        }
    }
    else
        outfile.write(tree);
}

Tree[] filterProductionChilds(Tree[] childs)
{
    Tree[] r;
    foreach (expr; childs)
    {
        if (expr.name == "PrefixExpression" && expr.childs.length == 2
            && expr.childs[0].content.among("!", "&"))
            continue;
        if (expr.name == "PrefixExpression" && expr.childs.length == 1
            && expr.childs[0].content == "~")
            continue;
        r ~= expr;
    }
    return r;
}

void handleDefinition(File outfile, Tree definition, bool isLexer, const string[string] replacements)
{
    if (definition.childs.length <= 1)
        return;
    if (definition.childs[0].content.startsWith("invalid_"))
        return;
    if (definition.childs[0].content == "@")
        return;
    if (convertName(definition.childs[0].content) in replacements)
        return;
    outfile.write(convertName(definition.childs[0].content));
    if (!isLexer && definition.start.line < 95)
    {
        if (definition.childs[0].content == "fstring")
            outfile.write("Start");
        outfile.write(" @start");
    }
    outfile.writeln();

    bool first = true;
    foreach (production; definition.childs[$ - 2].childs)
    {
        if (production.nodeType != NodeType.nonterminal)
            continue;
        if (production.childs[0].childs.length == 1
            && production.childs[0].childs[0].name == "Expression"
            && production.childs[0].childs[0].childs.length == 1
            && production.childs[0].childs[0].childs[0].content.startsWith("invalid"))
            continue;
        outfile.write("    ", first ? "=" : "|");
        size_t numExprs;
        foreach (expr; production.childs[0].childs)
        {
            numExprs++;
        }
        foreach (expr; filterProductionChilds(production.childs[0].childs))
        {
            outfile.write(" ");
            if (numExprs == 1 && expr.name == "Expression" && expr.childs.length == 1 && std.ascii.isLower(expr.childs[0].content[0]))
                outfile.write("<");
            writeExpression(outfile, expr, replacements);
        }
        first = false;
        outfile.writeln();
    }
    outfile.writeln("    ;");
}

int main(string[] args)
{
    import P = grammarpeg;
    import std.file;
    import std.path;
    import std.stdio;

    alias L = grammarpeg_lexer.Lexer!LocationAll;
    alias Creator = DynamicParseTreeCreator!(P, LocationAll, LocationRangeStartEnd);
    Creator creator = new Creator;

    if (args.length != 3)
    {
        stderr.writeln("Usage: grammarpythongen cpython/ grammarpython.ebnf");
        return 1;
    }

    string cpythonDir = args[1];

    string[string] replacements;
    replacements["TargetWithStarAtom"] = "Primary";
    replacements["TPrimary"] = "Primary";
    replacements["StarAtom"] = "Atom";
    replacements["DelTAtom"] = "Unused";
    replacements["DelTarget"] = "Primary";
    replacements["DelTAtom"] = "Unused";
    replacements["TLookahead"] = "Unused";
    replacements["SingleTarget"] = "Primary";
    replacements["SingleSubscriptAttributeTarget"] = "Primary";

    File outfile = File(args[2], "w");

    string inText = readText(cpythonDir ~ "/Grammar/python.gram");

    auto tree = P.parse!(Creator, L)(inText, creator);
    assert(tree.inputLength.bytePos <= inText.length);

    foreach (definition; tree.childs[0].childs)
    {
        handleDefinition(outfile, definition, false, replacements);
    }

    outfile.writeln(q"EOS
token INDENT;
token DEDENT;

token SPACE @ignoreToken
    = [ \t]+
    ;

token Newline
    = "\n" | "\r" | "\r\n"
    ;

token NAME @lowPrio
    = [a-zA-Z]+
    ;
EOS");

    inText = "";
    bool inGrammar;
    foreach (line; File(cpythonDir ~ "/Doc/reference/lexical_analysis.rst", "r").byLine)
    {
        if (line.startsWith(".. productionlist:: python-grammar"))
            inGrammar = true;
        else if (!line.startsWith(" "))
            inGrammar = false;
        else if (inGrammar)
        {
            line = line.strip;
            if (line.startsWith(":"))
            {
                line = line[1 .. $];
                if (inText.length)
                    inText = inText[0 .. $ - 1];
            }
            inText ~= line ~ "\n";
        }
    }

    tree = P.parse!(Creator, L)(inText, creator);
    assert(tree.inputLength.bytePos <= inText.length);
    foreach (definition; tree.childs[$ - 1].childs)
    {
        handleDefinition(outfile, definition, true, replacements);
    }

    void writeCharCategory(string name)
    {
        auto set = unicode(name);
        outfile.writeln("    // ", name);
        outfile.write("    | [");
        size_t lineLength;
        foreach (interval; set.byInterval)
        {
            string newText;
            if (interval[0] + 1 == interval[1])
                newText = interval[0].escapeCodePoint(false);
            else if (interval[0] + 2 == interval[1])
                newText = text(interval[0].escapeCodePoint(false),
                    (interval[1] - 1).escapeCodePoint(false));
            else
                newText = text(interval[0].escapeCodePoint(false), "-",
                    (interval[1] - 1).escapeCodePoint(false));
            if (lineLength + newText.length + 8 > 72)
            {
                outfile.writeln("]");
                outfile.write("    | [");
                lineLength = 0;
            }
            lineLength += newText.length;
            outfile.write(newText);
        }
        outfile.writeln("]");
    }
    outfile.writeln("fragment IdStart");
    outfile.writeln("    = \"_\"");
    foreach (category; ["Uppercase_Letter", "Lowercase_Letter", "Titlecase_Letter", "Modifier_Letter", "Other_Letter", "Letter_Number", "Other_ID_Start"])
        writeCharCategory(category);
    outfile.writeln("    ;");
    outfile.writeln("fragment IdContinue");
    outfile.writeln("    = IdStart");
    foreach (category; ["Nonspacing_Mark", "Spacing_Mark", "Decimal_Number", "Connector_Punctuation", "Other_ID_Continue"])
        writeCharCategory(category);
    outfile.writeln("    ;");

    return 0;
}
