
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.parsercodegencommon;
import dparsergen.core.utils;
import dparsergen.generator.codewriter;
import dparsergen.generator.grammar;
import dparsergen.generator.ids;
import dparsergen.generator.parser;
import dparsergen.generator.production;
import std.algorithm;
import std.conv;
import std.range;

string nonterminalIDCode(EBNFGrammar grammar, NonterminalID nonterminalID)
{
    if (nonterminalID.id == SymbolID.max)
        return "SymbolID.max";
    if (nonterminalID.id >= grammar.nonterminals.vals.length)
        return text(grammar.startNonterminalID + nonterminalID.id);
    return text(grammar.startNonterminalID + nonterminalID.id, "/*",
            grammar.nonterminals[nonterminalID].name, "*/");
}

string tokenDCode(string tokName)
{
    if (tokName.startsWith('\"') || tokName.startsWith('\''))
    {
        string r = "q{";
        r ~= tokName;
        r ~= "}";
        return r;
    }
    else if (tokName.startsWith('['))
    {
        assert(tokName[$ - 1] == ']');
        string r = "\"[";
        r ~= escapeD(tokName[1 .. $ - 1]);
        r ~= "]\"";
        return r;
    }
    else if (tokName == "$end")
        return "\"" ~ tokName ~ "\"";
    else
        return "\"" ~ escapeD(tokName) ~ "\"";
}

string tokenDCode(const Token tok)
{
    return tokenDCode(tok.name);
}

bool isIdentifierStr(string s)
{
    foreach (char c; s)
    {
        if (!c.inCharSet!"_0-9a-zA-Z")
            return false;
    }
    return true;
}

string parseFunctionName(LRGraph graph, size_t stateNr, string prefix = "parse")
in (stateNr < graph.states.length)
{
    if (graph.states[stateNr].elements.length)
    {
        auto e = graph.states[stateNr].elements[0];
        if (e.isStartElement && e.dotPos == 0)
        {
            string name = graph.grammar.getSymbolName(e.production.symbols[0]);
            if (graph.states[stateNr].isStartNode && isIdentifierStr(name))
                return text(prefix, name, "/*", stateNr, "*/");
            else
                return text(prefix, stateNr, "/*", name, "*/");
        }
    }
    return text(prefix, stateNr);
}

string reduceFunctionName(LRGraph graph, const Production* production, string prefix = "reduce")
{
    string name = graph.grammar.getSymbolName(production.nonterminalID);
    if (isIdentifierStr(name))
        return text(prefix, production.productionID, "_", name, "/*",
                graph.grammar.productionString(production), "*/");
    else
        return text(prefix, production.productionID, "/*",
                graph.grammar.productionString(production), "*/");
}

string nonterminalFlagsToCode(NonterminalFlags t)
{
    if (t == NonterminalFlags.none)
        return "NonterminalFlags.none";
    string r;
    static foreach (n; [
            "empty", "nonterminal", "string", "array", "arrayOfNonterminal",
            "arrayOfString"
        ])
    {
        {
            mixin("NonterminalFlags x = NonterminalFlags." ~ n ~ ";");
            if (t & x)
            {
                r ~= " | NonterminalFlags." ~ n;
                t = t & ~x;
            }
        }
    }
    assert(t == NonterminalFlags.none);
    return r[3 .. $];
}

string createAllTokensCode(EBNFGrammar grammar)
{
    string allTokensCode;
    foreach (i, t; grammar.tokens.vals)
    {
        allTokensCode ~= text("    /* ", i + grammar.startTokenID,
                ": */ immutable(Token)(", t.tokenDCode, ", ", t.annotations.toString, "),\n");
    }
    return allTokensCode;
}

string createAllNonterminalsCode(EBNFGrammar grammar)
{
    string allNonterminalsCode;
    foreach (i, n; grammar.nonterminals.vals)
    {
        allNonterminalsCode ~= text("    /* ", i + grammar.startNonterminalID, ": */ immutable(Nonterminal)(", "\"",
                n.name.escapeD, "\", ", n.flags.nonterminalFlagsToCode, ", ",
                n.annotations.toString, ", [", n.buildNonterminals.map!(
                    x => (x + grammar.startNonterminalID).text).joiner(", "), "]),\n");
    }
    return allNonterminalsCode;
}

string createAllProductionsCode(EBNFGrammar grammar)
{
    string code;
    foreach (t; grammar.origGrammar.productionsData)
    {
        if (t is null)
        {
            code ~= "    immutable(Production)(),\n";
        }
        else
        {
            code ~= text("    // ", t.productionID + grammar.startProductionID,
                    ": ", grammar.productionString(t), "\n");
            code ~= text("    immutable(Production)(immutable(NonterminalID)(",
                    t.nonterminalID.id + grammar.startNonterminalID, "), [");

            if (t.symbols.length)
            {
                foreach (i, s; t.symbols)
                {
                    code ~= text("\n                immutable(SymbolInstance)(",
                        s.symbol, ", ",
                        s.subToken.toDStringLiteral, ", ",
                        s.symbolInstanceName.toDStringLiteral, ", ",
                        s.unwrapProduction, ", ",
                        s.dropNode, ", ",
                        s.annotations, ", ",
                        s.negLookaheads, ")",
                        i + 1 < t.symbols.length ? "," : "");
                }
                code ~= "\n            ";
            }

            code ~= text("], ",
                    t.annotations.toString, ", ",
                    t.negLookaheads, ", ",
                    t.negLookaheadsAnytoken, ", ",
                    t.isVirtual);

            code ~= text("),\n");
        }
    }
    return code;
}

void createParseStateComments(ref CodeWriter code, LRGraph graph,
        const LRElementSet elements, const NonterminalID[][] stackDelayedReduce = [
        ])
{
    auto grammar = graph.grammar;

    if (elements.simpleLLState)
        code.writeln("// simpleLLState: ", grammar.getSymbolName(elements.onlyNonterminal));

    assert(stackDelayedReduce.length == 0
            || stackDelayedReduce.length == elements.stackSize, code.data);
    foreach (i, nonterminals; stackDelayedReduce)
    {
        if (nonterminals.length == 0)
            continue;
        code.write("// delayed reduce at ", long(i) - long(elements.stackSize), ":");
        foreach (n; nonterminals)
            code.write(" ", grammar.getSymbolName(n));
        code.writeln();
    }

    {
        Appender!(string) app;
        enum numColumns = 4;
        size_t[numColumns + 1][] positions;
        positions.length = elements.length;

        foreach (k, e; elements)
        {
            size_t col = 0;
            positions[k][col++] = app.data.length;

            app.put("//  ");
            app.put(grammar.getSymbolName(e.production.nonterminalID));

            positions[k][col++] = app.data.length;

            app.put(" -> ");

            positions[k][col++] = app.data.length;

            if (e.extraConstraint.disabled)
                app.put("@@disabled@@ ");

            e.toStringOnlyProductionBeforeDot(graph, app);

            positions[k][col++] = app.data.length;

            app.put(".");
            if (e.isNextValid(grammar))
            {
                auto constraint = graph.grammar.nextSymbolWithConstraint(e.extraConstraint,
                        e.next(grammar), e.dotPos == 0).constraint;
                if (e.dotPos == 0)
                    foreach (l; e.extraConstraint.negLookaheads)
                    {
                        app.put("!");
                        app.put(grammar.getSymbolName(l));
                        app.put(" ");
                    }
                foreach (t; constraint.tags)
                {
                    if (t.reject)
                        app.put(text("@rejectTag(", grammar.tags[t.tag].name, ") "));
                    if (t.needed)
                        app.put(text("@needTag(", grammar.tags[t.tag].name, ") "));
                }
            }
            e.toStringOnlyProductionAfterDot(graph, app);

            e.toStringOnlyLookahead(graph, app);

            e.toStringOnlyEnd(graph, app);

            positions[k][col++] = app.data.length;
        }

        size_t[numColumns] columnSizes;
        foreach (k, e; elements)
        {
            foreach (col; 0 .. numColumns)
            {
                size_t size = positions[k][col + 1] - positions[k][col];
                if (size > columnSizes[col])
                    columnSizes[col] = size;
            }
        }
        foreach (k, e; elements)
        {
            foreach (col; 0 .. numColumns)
            {
                size_t size = positions[k][col + 1] - positions[k][col];
                bool alignRight = col == 2;
                if (alignRight)
                    foreach (_; size .. columnSizes[col])
                        code.write(' ');
                code.write(app.data[positions[k][col] .. positions[k][col + 1]]);
                if (!alignRight && col + 1 < numColumns)
                    foreach (_; size .. columnSizes[col])
                        code.write(' ');
            }
            code.writeln();
        }
    }

    if (graph.globalOptions.directUnwrap)
    {
        bool[NonterminalWithConstraint] directUnwrapDone;
        foreach (k, e; elements)
        {
            if (!e.isNextNonterminal(grammar))
                continue;
            auto n = e.next(grammar);
            if (elements.descentNonterminals.canFind(n.toNonterminalID))
                continue;
            if (NonterminalWithConstraint(n.toNonterminalID,
                    Constraint(n.negLookaheads, n.tags)) in directUnwrapDone)
                continue;
            directUnwrapDone[NonterminalWithConstraint(n.toNonterminalID,
                        Constraint(n.negLookaheads, n.tags))] = true;
            foreach (m2; e.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
            {
                if (n == m2.nonterminalID)
                    continue;
                code.write("//  ", grammar.getSymbolName(n.toNonterminalID),
                        " ---> ", grammar.getSymbolName(m2.nonterminalID));
                if (m2.constraint.disabled)
                    code.write("     @@disabled@@");
                if (m2.constraint.negLookaheads.length)
                {
                    code.write("     negLookahead:");
                    foreach (l; m2.constraint.negLookaheads)
                        code.write(" ", grammar.getSymbolName(l));
                }
                if (m2.constraint.tags.length)
                {
                    code.write("     tags:");
                    foreach (t; m2.constraint.tags)
                    {
                        if (t.reject)
                            code.write(" @rejectTag(", grammar.tags[t.tag].name, ")");
                        if (t.needed)
                            code.write(" @needTag(", grammar.tags[t.tag].name, ")");
                    }
                }
                code.writeln();
            }
        }
    }
    foreach (n; elements.descentNonterminals)
    {
        code.write("// descent ", grammar.getSymbolName(n));
        code.writeln();
    }
}

void createParseStateComments(ref CodeWriter code, LRGraph graph, size_t stateNr,
        const LRGraphNode node)
{
    auto grammar = graph.grammar;

    code.writeln("// path: ",
            node.shortestSymbolPath.map!(s => grammar.getSymbolName(s)).joiner(" "));
    code.writeln("// type: ", node.type);

    createParseStateComments(code, graph, node.elements, node.stackDelayedReduce);
}

struct CommaGen
{
    string commaStr = ", ";
    bool alreadyCalled;
    this(string commaStr)
    {
        this.commaStr = commaStr;
    }

    @disable this(this);
    string opCall(bool setCalled = true)
    {
        if (alreadyCalled)
            return commaStr;
        if (setCalled)
            alreadyCalled = true;
        return "";
    }
}

string symbolNameCode(EBNFGrammar grammar, Symbol s)
{
    string name = grammar.getSymbolName(s);
    if (isIdentifierStr(name))
    {
        return "Symbol" ~ name;
    }
    else
    {
        if (s.isToken)
            return text("Token", s.id, "/+", name, "+/");
        else
            return text("Nonterminal", s.id, "/+", name, "+/");
    }
}

string reduceTagsCode(alias stackTagVar)(EBNFGrammar grammar, const Production* production)
{
    assert(grammar.tags.vals.length);

    string r;
    bool isEmpty = true;
    foreach (t; production.tags)
    {
        if (r.length)
            r ~= " ";
        if (!isEmpty)
            r ~= "| ";
        isEmpty = false;
        r ~= "Tag." ~ grammar.tags[t].name;
    }

    foreach (k; 1 .. production.symbols.length + 1)
    {
        if (production.symbols[$ - k].isToken)
            continue;
        auto possibleTags = grammar
            .nonterminals[production.symbols[$ - k].toNonterminalID].possibleTags;
        if (production.symbols[$ - k].unwrapProduction
                || production.symbols[$ - k].annotations.contains!"inheritAnyTag"
                || (production.symbols.length == 1
                    && production.symbols[0].symbol == production.nonterminalID))
        {
            if (r.length)
                r ~= " ";
            if (possibleTags.length == 0)
                r ~= "/+";
            if (!isEmpty)
                r ~= "| ";
            r ~= stackTagVar(k);
            if (possibleTags.length == 0)
                r ~= "+/";
            if (possibleTags.length)
                isEmpty = false;
        }
        else
        {
            foreach (t; production.symbols[$ - k].tags)
            {
                if (t.inherit)
                {
                    if (r.length)
                        r ~= " ";
                    bool possible = possibleTags.canFind(t.tag);
                    if (!possible)
                        r ~= "/+";
                    if (!isEmpty)
                        r ~= "| ";
                    r ~= text("(", stackTagVar(k), " & Tag.", grammar.tags[t.tag].name, ")");
                    if (!possible)
                        r ~= "+/";
                    if (possible)
                        isEmpty = false;
                }
            }
        }
    }
    if (isEmpty)
    {
        if (r.length)
            r ~= " ";
        r ~= "Tag.init";
    }
    return r;
}

bool checkTagsCode(alias stackTagVar)(ref CodeWriter code, EBNFGrammar grammar,
        const Production* production)
{
    bool needsIf;
    foreach (k; 1 .. production.symbols.length + 1)
    {
        if (production.symbols[$ - k].isToken)
            continue;
        auto possibleTags = grammar
            .nonterminals[production.symbols[$ - k].toNonterminalID].possibleTags;
        foreach (t; production.symbols[$ - k].tags)
        {
            if (!possibleTags.canFind(t.tag))
                continue;
            if (t.reject || t.needed)
            {
                if (!needsIf)
                    code.write("if (");
                else
                    code.write(" || ");
                needsIf = true;

                if (t.reject && t.needed)
                    code.write("true /* Tag needed and rejected: ", grammar.tags[t.tag].name, "*/");
                else if (t.reject)
                    code.write("(", stackTagVar(k), " & Tag.", grammar.tags[t.tag].name, ")");
                else if (t.needed)
                    code.write("!(", stackTagVar(k), " & Tag.", grammar.tags[t.tag].name, ")");
            }
        }
    }
    if (needsIf)
        code.writeln(")");
    return needsIf;
}

string tokenSetCode(EBNFGrammar grammar, const BitSet!TokenID set, string var, bool inverted = false)
{
    size_t count;
    string inner;
    foreach (t; set.bitsSet)
    {
        if (t == grammar.tokens.getID("$end"))
            continue;
        if (count)
            inner ~= inverted ? " && " : " || ";
        count++;
        inner ~= var ~ ".front.symbol " ~ (inverted
                ? "!=" : "==") ~ " Lexer.tokenID!" ~ grammar.tokens[t].tokenDCode;
    }
    string r;
    if (set[grammar.tokens.getID("$end")])
    {
        r = (inverted ? "!" : "") ~ var ~ ".empty";
        if (count)
            r ~= (inverted ? " && " : " || ") ~ inner;
    }
    else
    {
        r = (inverted ? "" : "!") ~ var ~ ".empty";
        if (count > 1)
            r ~= (inverted ? " || " : " && ") ~ "(" ~ inner ~ ")";
        else if (count)
            r ~= (inverted ? " || " : " && ") ~ inner;
    }
    return r;
}
