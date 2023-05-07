
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.doc;
import dparsergen.core.utils;
import dparsergen.generator.ebnf;
import dparsergen.generator.grammarebnf;
import std.array;
import std.stdio;
import std.string;
import std.uni;

enum DocType
{
    html,
    markdown
}

string nameWithSpace(string name)
{
    string r;
    foreach (i, dchar c; name)
    {
        if (i && c.isUpper && !name[i - 1].isUpper)
            r ~= " ";
        r ~= c;
    }
    return r;
}

void genDoc(EBNF ebnf, string docfilename, DocType docType)
{
    File f = File(docfilename, "w");
    if (docType == DocType.html)
    {
        f.writeln("<html>");
        f.writeln("<body>");
    }
    Declaration[][string] declarationsByName;
    foreach (d; ebnf.symbols)
        declarationsByName[d.name] ~= d;
    Declaration[][] blocks;
    auto symbols = ebnf.symbols;
    string[string] firstNamePerBlock;
    while (symbols.length)
    {
        size_t combinedSymbols = 1;
        while (combinedSymbols < symbols.length
                && symbols[combinedSymbols].documentation.strip() == "ditto")
            combinedSymbols++;
        blocks ~= symbols[0 .. combinedSymbols];
        foreach (i; 0..combinedSymbols)
            firstNamePerBlock[symbols[i].name] = symbols[0].name;
        symbols = symbols[combinedSymbols .. $];
    }

    string anchorName(string name)
    {
        if (name in firstNamePerBlock)
            name = firstNamePerBlock[name];
        return nameWithSpace(name).replace(" ", "-").toLower;
    }

    string escape(string str)
    {
        if (docType == DocType.html)
            return escapeHTML(str);
        else
        {
            Appender!string app;
            foreach (char c; str)
            {
                if (c == '&')
                    app.put("&amp;");
                else if (c == '\"')
                    app.put("&quot;");
                else if (c == '$')
                    app.put("&#36;");
                else if (c == '<')
                    app.put("&lt;");
                else if (c == '>')
                    app.put("&gt;");
                else if (c == '*')
                    app.put("\\*");
                else if (c == '_')
                    app.put("\\_");
                else if (c == '~')
                    app.put("\\~");
                else if (c == '\\')
                    app.put("\\\\");
                else if (c == '#')
                    app.put("\\#");
                else
                    app.put(c);
            }
            return app.data;
        }
    }

    void delegate(Tree expr) writeExpressionDg;
    void writeComment(string content)
    {
        bool inCodeBlock;
        bool inParagraph;
        string paragraphEnd;
        foreach (line; content.splitLines)
        {
            string lineStripped = line.strip();
            if (docType == DocType.html && inParagraph && lineStripped == "")
            {
                f.writeln(paragraphEnd);
                paragraphEnd = "";
                inParagraph = false;
            }
            else if (line.strip == "```")
            {
                if (inParagraph)
                {
                    if (docType == DocType.html)
                        f.writeln(paragraphEnd);
                    paragraphEnd = "";
                    inParagraph = false;
                }
                inCodeBlock = !inCodeBlock;
                if (inCodeBlock)
                    f.writeln("<pre>");
                else
                    f.writeln("</pre>");
            }
            else if (!inCodeBlock && lineStripped.startsWith("$TRANSITIVE_UNWRAP_TABLE(")
                    && lineStripped.endsWith(")"))
            {
                if (inParagraph && docType == DocType.html)
                {
                    f.writeln(paragraphEnd);
                    paragraphEnd = "";
                    inParagraph = false;
                }

                f.writeln("<table>");
                bool[string] done;
                void onDeclaration(string name)
                {
                    if (name in done)
                        return;
                    done[name] = true;

                    foreach (ref d; declarationsByName.get(name, []))
                    {
                        Tree[] alternatives = [d.exprTree];
                        while (alternatives[0].nonterminalID == nonterminalIDFor!"Alternation")
                            alternatives = [
                                alternatives[0].childs[0],
                                alternatives[0].childs[2]
                            ] ~ alternatives[1 .. $];
                        Tree[] realExprs;
                        string[] unwrapNames;
                        foreach (expr; alternatives)
                        {
                            bool unwrapProduction = false;
                            while (true)
                            {
                                if (expr.nonterminalID == nonterminalIDFor!"AnnotatedExpression")
                                {
                                    foreach (c; expr.childs[2].memberOrDefault!"childs")
                                    {
                                        if (c.childs[0].content == "<")
                                            unwrapProduction = true;
                                    }
                                    expr = expr.childs[$ - 1];
                                }
                                else if (expr.nonterminalID == nonterminalIDFor!"Concatenation"
                                        && expr.childs.length == 2)
                                    expr = expr.childs[0];
                                else
                                    break;
                            }
                            if (expr.nonterminalID == nonterminalIDFor!"Name" && unwrapProduction)
                            {
                                unwrapNames ~= expr.childs[0].content;
                            }
                            else
                                realExprs ~= expr;
                        }
                        foreach (expr; realExprs)
                        {
                            f.writeln("<tr>");
                            f.writeln("<td><a href=\"#", anchorName(d.name).escapeHTML,
                                    "\">", escape(d.name), "</a></td>");
                            f.writeln("<td>");
                            Tree[] parts;
                            if (expr.nonterminalID == nonterminalIDFor!"Concatenation")
                            {
                                if (expr.childs.length == 3)
                                    parts = expr.childs[0]
                                        ~ expr.childs[1].memberOrDefault!"childs";
                                if (expr.childs.length == 2)
                                    parts = [expr.childs[0]];
                            }
                            else
                                parts = [expr];
                            foreach (part; parts)
                            {
                                f.write(" ");
                                writeExpressionDg(part);
                            }
                            f.writeln("</td>");
                            f.writeln("</tr>");
                        }
                        foreach (unwrapName; unwrapNames)
                            onDeclaration(unwrapName);
                    }
                }

                foreach (name; lineStripped[25 .. $ - 1].split(", "))
                    onDeclaration(name.strip);
                f.writeln("</table>");
            }
            else if (inCodeBlock)
                f.writeln(escape(line));
            else
            {
                if (!inParagraph)
                {
                    inParagraph = true;
                    if (docType == DocType.html)
                    {
                        if (lineStripped.startsWith("*"))
                        {
                            f.writeln("<ul><li>");
                            paragraphEnd = "</li></ul>";
                            line = line.stripLeft[1 .. $].stripLeft;
                        }
                        else
                        {
                            f.writeln("<p>");
                            paragraphEnd = "</p>";
                        }
                    }
                }
                else
                {
                    if (docType == DocType.html)
                    {
                        if (lineStripped.startsWith("*"))
                        {
                            if (paragraphEnd != "</li></ul>")
                            {
                                f.writeln(paragraphEnd);
                                f.writeln("<ul><li>");
                                paragraphEnd = "</li></ul>";
                            }
                            else
                            {
                                f.writeln("</li><li>");
                            }
                            line = line.stripLeft[1 .. $].stripLeft;
                        }
                    }
                }
                while (line.length)
                {
                    if (line[0] == '`')
                    {
                        size_t i = 1;
                        while (i < line.length && line[i] != '`')
                            i++;
                        if (i < line.length)
                        {
                            f.write("<a href=\"#", anchorName(line[1 .. i]).escapeHTML,
                                    "\">", escape(line[1 .. i]), "</a>");
                            line = line[i + 1 .. $];
                        }
                    }
                    f.write(line[0]);
                    line = line[1 .. $];
                }
                f.writeln();
            }
        }
        if (inCodeBlock)
            f.writeln("</pre>");
        if (inParagraph && docType == DocType.html)
            f.writeln(paragraphEnd);
        f.writeln();
    }

    void writeExpression(Tree expr)
    {
        Tree realExpr = expr;
        while (realExpr.nonterminalID == nonterminalIDFor!"AnnotatedExpression")
        {
            realExpr = realExpr.childs[$ - 1];
        }
        if (realExpr.nonterminalID == nonterminalIDFor!"Name")
        {
            f.write("<a href=\"#", anchorName(realExpr.childs[0].content).escapeHTML,
                    "\">", escape(realExpr.childs[0].content), "</a>");
        }
        else if (realExpr.nonterminalID == nonterminalIDFor!"Token")
        {
            f.write("<b>", escape(realExpr.childs[0].content), "</b>");
        }
        else if (realExpr.nonterminalID == nonterminalIDFor!"Optional")
        {
            writeExpression(realExpr.childs[0]);
            f.write("?");
        }
        else if (realExpr.nonterminalID == nonterminalIDFor!"Repetition")
        {
            writeExpression(realExpr.childs[0]);
            f.write("*");
        }
        else if (realExpr.nonterminalID == nonterminalIDFor!"RepetitionPlus")
        {
            writeExpression(realExpr.childs[0]);
            f.write("+");
        }
        else
        {
            f.write(ebnfTreeToString(realExpr).escapeHTML);
        }
    }

    writeExpressionDg = &writeExpression;

    writeComment(ebnf.globalDocumentation);

    foreach (symbolsHere; blocks)
    {
        f.write(docType == DocType.html ? "<h3>" : "### ", nameWithSpace(symbolsHere[0].name).escapeHTML);

        if (docType == DocType.html)
        {
            foreach (s; symbolsHere)
                f.write("<a id=\"", anchorName(s.name).escapeHTML, "\">", "</a>");
        }

        if (docType == DocType.html)
            f.writeln("</h3>");
        else
            f.writeln();
        f.writeln("<pre>");

        foreach (i, s; symbolsHere)
        {
            /*if (i)
                f.writeln();*/
            if (s.type == DeclarationType.token)
                f.write("token ");
            else if (s.type == DeclarationType.fragment)
                f.write("fragment ");

            f.writeln(s.name);

            Tree[] alternatives = [s.exprTree];
            while (alternatives[0].nonterminalID == nonterminalIDFor!"Alternation")
                alternatives = [
                    alternatives[0].childs[0], alternatives[0].childs[2]
                ] ~ alternatives[1 .. $];

            foreach (j, alternative; alternatives)
            {
                f.write("    ", j ? "|" : "=");

                Tree[] parts;
                if (alternative.nonterminalID == nonterminalIDFor!"Concatenation")
                {
                    if (alternative.childs.length == 3)
                        parts = alternative.childs[0]
                            ~ alternative.childs[1].memberOrDefault!"childs";
                    if (alternative.childs.length == 2)
                        parts = [alternative.childs[0]];
                }
                else
                    parts = [alternative];
                foreach (part; parts)
                {
                    f.write(" ");
                    writeExpression(part);
                }
                if (parts.length == 0)
                    f.write(" <i>empty</i>");
                f.writeln();
            }
            f.writeln("    ;");
        }

        f.writeln("</pre>");

        writeComment(symbolsHere[0].documentation);
    }
    if (docType == DocType.html)
    {
        f.writeln("</body>");
        f.writeln("</html>");
    }
}
