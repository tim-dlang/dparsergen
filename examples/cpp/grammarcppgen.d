import std.algorithm;
import std.array;
import std.ascii;
import std.conv;
import std.exception;
import std.file : readText;
import std.stdio;
import std.string;

struct Node
{
    string text;
    Node[] childs;
}

Node[] parseTexImpl(ref string input)
{
    Node[] r;
    while (input.length)
    {
        if (input.length >= 2 && input[0] == '\\' && isAlpha(input[1]))
        {
            size_t l = 1;
            while (l < input.length && isAlphaNum(input[l]))
                l++;
            string name = input[0 .. l];

            if (l < input.length && input[l] == '{' && (name == "\\begin" || name == "\\end"))
            {
                l++;
                while (l < input.length && input[l] != '{' && input[l] != '}')
                    l++;
                enforce(l < input.length && input[l] == '}', text(input[0 .. l],
                        " ### ", input[l .. $]));
                l++;
            }
            else if (name != "\\bigl" && name != "\\big" && name != "\\bigr"
                    && name != "\\pnum" && name != "\\tcode")
            {
                size_t lastNonWhite = l;
                while (l < input.length)
                {
                    if (input[l] == '{')
                    {
                        l++;
                        size_t braceCount = 1;
                        bool escaped;
                        while (l < input.length && braceCount)
                        {
                            if (!escaped)
                            {
                                if (input[l] == '{')
                                    braceCount++;
                                else if (input[l] == '}')
                                    braceCount--;
                            }
                            if (input[l] == '\\')
                                escaped = !escaped;
                            else
                                escaped = false;
                            l++;
                        }
                        enforce(braceCount == 0, text(input[0 .. l], " ### ", input[l .. $]));
                        lastNonWhite = l;
                    }
                    else if (input[l] == '[')
                    {
                        l++;
                        while (l < input.length && input[l] != '[' && input[l] != ']')
                            l++;
                        enforce(l < input.length && input[l] == ']',
                                text(input[0 .. l], " ### ", input[l .. $]));
                        l++;
                        lastNonWhite = l;
                    }
                    else if (isWhite(input[l]))
                        l++;
                    else
                    {
                        break;
                    }
                }
                l = lastNonWhite;
            }

            r ~= Node(input[0 .. l]);
            input = input[l .. $];
            //stderr.writeln(r[$ - 1]);

            if (name == "\\begin")
            {
                r[$ - 1].childs = parseTexImpl(input);
                enforce(r[$ - 1].childs[$ - 1].text == "\\end{" ~ r[$ - 1].text["\\begin{".length .. $ - 1] ~ "}",
                        text(r[$ - 1].text, " ", r[$ - 1].childs[$ - 1].text));
            }
            else if (name == "\\end")
            {
                return r;
            }
        }
        else
        {
            size_t l = 1;
            while (l < input.length && input[l] != '\\' && input[l] != '%')
                l++;
            r ~= Node(input[0 .. l]);
            input = input[l .. $];
        }
    }
    return r;
}

Node[] parseTex(string input)
{
    Node[] r = parseTexImpl(input);
    enforce(input.length == 0);
    return r;
}

string removeComments(string input)
{
    Appender!string app;
    bool inComment;
    bool afterEscape;
    foreach (char c; input)
    {
        if (!afterEscape)
        {
            if (c == '%')
                inComment = true;
            else if (c == '\n')
                inComment = false;
        }
        if (c == '\\')
            afterEscape = !afterEscape;
        else
            afterEscape = false;
        if (!inComment)
            app.put(c);
    }
    return app.data;
}

struct Production
{
    string[] symbols;
}

struct Nonterm
{
    string name;
    string section;
    Production[] productions;
}

string toPascalCase(string s)
{
    Appender!string app;
    bool beginning = true;
    foreach (char c; s)
    {
        if (c == '-' || c == '_')
            beginning = true;
        else
        {
            if (beginning)
                app.put(std.ascii.toUpper(c));
            else
                app.put(c);
            beginning = false;
        }
    }
    return app.data;
}

bool endAmong(T...)(string s, T endings)
{
    foreach (e; endings)
        if (s.endsWith(e))
            return true;
    return false;
}

int main(string[] args)
{
    if (args.length != 5)
    {
        stderr.writeln(
                "Usage: grammarcppgen cplusplus-draft/source grammarcpp.ebnf grammarcpreproc.ebnf grammarcppcommon.ebnf");
        return 1;
    }
    string dir = args[1];
    string[] filenames;
    void findIncludes(Node[] nodes)
    {
        foreach (node; nodes)
        {
            string name;
            if (node.text.startsWith("\\include{"))
                name = node.text["\\include{".length .. $ - 1];
            if (node.text.startsWith("\\input{"))
                name = node.text["\\input{".length .. $ - 1];
            if (name.length && name != "lex")
                filenames ~= name;
            findIncludes(node.childs);
        }
    }

    findIncludes(parseTex(removeComments(readText(dir ~ "/std.tex"))));
    filenames = filenames ~ "lex";

    Nonterm[] nonterms;
    foreach (filename; filenames)
    {
        if (filename == "grammar")
            continue;
        if (filename == "cpp")
            continue;
        string input = readText(dir ~ "/" ~ filename ~ ".tex");

        string currentSection;
        foreach (node; parseTex(removeComments(input)))
        {
            if (node.text.startsWith("\\rSec"))
            {
                currentSection = node.text.findSplit("[")[2].findSplit("]")[0];
            }
            if (node.text == "\\begin{bnf}" || node.text == "\\begin{bnftab}")
            {
                Node[] childs = node.childs[0 .. $ - 1];
                while (childs[0].text.strip() == ""
                        || childs[0].text.startsWith("\\indextext{")
                        || childs[0].text.startsWith("\\microtypesetup{")
                        || childs[0].text.startsWith("\\obeyspaces"))
                    childs = childs[1 .. $];
                Nonterm nonterm;
                nonterm.section = currentSection;
                if (childs[0].text.startsWith("\\nontermdef{"))
                {
                    nonterm.name = childs[0].text["\\nontermdef{".length .. $ - 1].toPascalCase;
                }
                else if (childs[0].text.endsWith(":"))
                {
                    nonterm.name = childs[0].text[0 .. $ - 1].strip().toPascalCase;
                }
                else
                    enforce(false, childs[0].text);
                childs = childs[1 .. $];

                while (childs.length && childs[0].text.strip() == "" && childs[0].childs.length == 0)
                    childs = childs[1 .. $];

                bool useOneOf;
                if (childs.length && childs[0].text == "\\textnormal{one of}")
                {
                    useOneOf = true;
                    childs = childs[1 .. $];
                }

                foreach (c; childs)
                {
                    auto stripped = c.text.strip();
                    while (stripped.startsWith("\\>"))
                        stripped = stripped[2 .. $];

                    bool needsOpt;
                    if (stripped.length > 6 && stripped.startsWith("\\opt{"))
                    {
                        stripped = stripped["\\opt{".length .. $ - 1].strip();
                        needsOpt = true;
                    }

                    if (stripped == "\\br")
                    {
                        nonterm.productions ~= Production();
                    }
                    else if (stripped == "\\quad")
                    {
                    }
                    else if (stripped == "\\opt" || stripped == "\\opt{}")
                    {
                        nonterm.productions[$ - 1].symbols[$ - 1] ~= "?";
                    }
                    else if (stripped.startsWith("\\terminal{") || stripped.startsWith("\\keyword{"))
                    {
                        if (stripped.startsWith("\\terminal{"))
                            stripped = stripped["\\terminal{".length .. $ - 1];
                        else
                            stripped = stripped["\\keyword{".length .. $ - 1];
                        string unescaped;
                        immutable string[2][] replacements = [
                            ["\\textbackslash", "\\\\"],
                            ["\\tilde", "~"],
                            ["\\shl", "<<"],
                            ["\\shr", ">>"],
                            ["\\{", "{"],
                            ["\\}", "}"],
                            ["\\&", "&"],
                            ["\\%", "%"],
                            ["\\^", "^"],
                            ["\\#", "#"],
                            ["{-}", "-"],
                            ["$||$", "||"],
                        ];
                        outer: while (stripped.length)
                        {
                            foreach (replacement; replacements)
                            {
                                if (stripped.startsWith(replacement[0]))
                                {
                                    stripped = stripped[replacement[0].length .. $];
                                    unescaped ~= replacement[1];

                                    if (replacement[0][0] == '\\' && stripped.startsWith("{}"))
                                        stripped = stripped[2 .. $];
                                    else if (replacement[0][0] == '\\' && stripped.startsWith(" "))
                                        stripped = stripped[1 .. $];
                                    continue outer;
                                }
                            }
                            unescaped ~= stripped[0];
                            stripped = stripped[1 .. $];
                        }
                        foreach (part; unescaped.splitter(" "))
                        {
                            if (part.length == 0)
                                continue;
                            if (useOneOf && nonterm.productions[$ - 1].symbols.length)
                                nonterm.productions ~= Production();
                            part = "\"" ~ part ~ "\"";
                            if (part.endsWith("\\opt\""))
                                part = part[0 .. $ - 5] ~ "\"?";
                            nonterm.productions[$ - 1].symbols ~= part;
                        }
                        if (needsOpt)
                            nonterm.productions[$ - 1].symbols[$ - 1] ~= "?";
                    }
                    else if (stripped.startsWith("\\textnormal{"))
                    {
                        stripped = stripped["\\textnormal{".length .. $ - 1];
                        if (nonterm.productions.length == 0)
                            nonterm.productions ~= Production();
                        nonterm.productions[$ - 1].symbols ~= "TODO /* " ~ stripped ~ " */";
                    }
                    else if (stripped.length)
                    {
                        if (nonterm.productions.length == 0)
                            nonterm.productions ~= Production();
                        foreach (part; stripped.splitter(" "))
                        {
                            if (part.length)
                                nonterm.productions[$ - 1].symbols ~= part.toPascalCase;
                        }
                        if (needsOpt)
                            nonterm.productions[$ - 1].symbols[$ - 1] ~= "?";
                    }
                }

                if (nonterm.productions.length && nonterm.productions[$ - 1].symbols.length == 0)
                    nonterm.productions = nonterm.productions[0 .. $ - 1];

                nonterms ~= nonterm;
            }
        }
    }

    File[3] outfiles;
    outfiles[0] = File(args[2], "w");
    outfiles[1] = File(args[3], "w");
    outfiles[2] = File(args[4], "w");
    outfiles[0].writeln("import \"", args[4], "\";\n");
    outfiles[1].writeln("import \"", args[4], "\";\n");

    string[3] lastSection;
    foreach (nonterm; nonterms)
    {
        size_t outfileIndex = 0;
        if (nonterm.section.startsWith("cpp") || nonterm.section.among("lex.pptoken", "lex.ppnumber", "lex.header"))
            outfileIndex = 1;
        if (nonterm.section.among("lex.name", "lex.charset", "lex.string", "lex.ccon")
            || nonterm.name.endAmong("Digit"))
            outfileIndex = 2;
        if (nonterm.name == "NonzeroDigit")
            outfileIndex = 0;
        File outfile = outfiles[outfileIndex];

        if (lastSection[outfileIndex] != nonterm.section)
        {
            if (lastSection[outfileIndex].length)
                outfile.writeln();
            outfile.writeln("// Section ", nonterm.section);
        }
        outfile.writeln(nonterm.name);
        foreach (i, p; nonterm.productions)
        {
            outfile.write("    ", i ? "|" : "=");
            foreach (s; p.symbols)
            {
                outfile.write(" ");
                outfile.write(s);
            }
            outfile.writeln();
        }
        outfile.writeln("    ;");
        lastSection[outfileIndex] = nonterm.section;
    }

    return 0;
}
