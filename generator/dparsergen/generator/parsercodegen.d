
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.parsercodegen;
import dparsergen.core.utils;
import dparsergen.generator.codewriter;
import dparsergen.generator.globaloptions;
import dparsergen.generator.grammar;
import dparsergen.generator.ids;
import dparsergen.generator.parser;
import dparsergen.generator.parsercodegencommon;
import dparsergen.generator.production;
import dparsergen.generator.regexlookahead;
import std.algorithm;
import std.conv;
import std.exception;
import std.range;
import std.stdio;
import std.typecons;

void generateReduceFunction(ref CodeWriter code, LRGraph graph, string funcName,
        immutable ProductionID[] productionIDs,
        NonterminalID[immutable(NonterminalID[])] combinedReduceNonterminals)
{
    auto grammar = graph.grammar;
    NonterminalID[] combinedReduceNonterminalIDs;
    NonterminalID combinedReduceNonterminal;
    if (productionIDs.length > 1)
    {
        foreach (productionID; productionIDs)
        {
            enforce(!grammar.hasNonTrivialRewriteRule(grammar.productionsData[productionID]));
            combinedReduceNonterminalIDs.addOnce(
                    grammar.productionsData[productionID].nonterminalID);
            code.writeln("// ", grammar.productionString(grammar.productionsData[productionID]));
        }
        combinedReduceNonterminalIDs.sort();
        combinedReduceNonterminal = combinedReduceNonterminals[combinedReduceNonterminalIDs];
    }
    const e = LRElement(grammar.productionsData[productionIDs[0]],
            grammar.productionsData[productionIDs[0]].symbols.length);
    if (e.isFinished(grammar))
    {
        const n = e.stackSymbols.length;

        mixin(genCode("code", q{
            $$CommaGen comma;
            auto $(funcName)(  _
            $$if (n > 0) {
                $(comma())Location parseStart  _
            $$}
            $$foreach (k, symbol; e.stackSymbols) {
                $$if (symbol.dropNode) code.write("/*");
                $(comma())ParseStackElem!(Location,   _
                $$if (symbol.isToken)
                    Token  _
                $$else
                    NonterminalType!$(symbol.id + grammar.startNonterminalID)  _
                ) stack$(e.stackSymbols.length - k)  _
                $$if (symbol.dropNode) code.write("*/");
            $$}
            )
        }));

        code.writeln("{").incIndent;

        if (n == 0)
            code.writeln("Location parseStart = lastTokenEnd;");

        const RewriteRule[] rewriteRules = grammar.getRewriteRules(e.production);
        assert(rewriteRules.length > 0);

        string[] rewriteParameters;
        foreach (k; iota(e.production.symbols.length, 0, -1))
        {
            if (e.production.symbols[$ - k].dropNode)
                rewriteParameters ~= "undefinedIdentifier/*error*/";
            else
                rewriteParameters ~= text("stack", k);
        }

        void genSetParseTree()
        {
            string funcName = "createParseTree";
            if (productionIDs.length > 1)
                funcName ~= "Combined";
            size_t stackPos = n;
            string stackStartExpr = "parseStart";
            mixin(genCode("code", q{
                Location end = lastTokenEnd;
                if (end < parseStart)
                    end = parseStart;

                pt = creator.$(funcName)!(  _
                $$if (productionIDs.length > 1) {
                    $(combinedReduceNonterminal.id + grammar.startNonterminalID)/*Combined:$(combinedReduceNonterminalIDs.map!(n=>grammar.getSymbolName(n)).join("|"))*/  _
                    $$foreach (productionID; productionIDs) {
                        , $(grammar.getRewriteRules(grammar.productionsData[productionID])[$ - 1].applyProduction.productionID + grammar.startProductionID)  _
                    $$}
                $$} else {
                    $(rewriteRules[$ - 1].applyProduction.productionID + grammar.startProductionID)  _
                $$}
                )(  _
                parseStart, end  _
                $$size_t iParam;
                $$foreach (k; 0 .. rewriteRules[$ - 1].applyProduction.symbols.length) {
                    $$if (!rewriteRules[$ - 1].applyProduction.symbols[k].dropNode) {
                        $$if (rewriteRules[$ - 1].parameters[iParam] == size_t.max) {
                            , ParseStackElem!(Location, NonterminalType!$(rewriteRules[$ - 1].applyProduction.symbols[k].id + grammar.startNonterminalID))($(stackStartExpr), NonterminalType!$(rewriteRules[$ - 1].applyProduction.symbols[k].id + grammar.startNonterminalID).init/*null*/)  _
                            $$iParam++;
                        $$} else {
                            , $(rewriteParameters[rewriteRules[$ - 1].parameters[iParam]])  _
                            $$stackStartExpr = text("stack", stackPos, ".end");
                            $$stackPos--;
                            $$iParam++;
                        $$}
                    $$} else {
                        $$stackPos--;
                    $$}
                $$}
                );
                }));
        }

        code.writeln("NonterminalType!(", grammar.nonterminalIDCode(
                nonterminalOutForProduction(rewriteRules[$ - 1].applyProduction)), ") pt;");

        if (grammar.isSimpleProduction(*e.production))
        {
            size_t stackPos = n;
            size_t nrNotDropped = size_t.max;
            foreach (k, s; e.production.symbols)
            {
                if (!s.dropNode)
                {
                    nrNotDropped = stackPos;
                    stackPos--;
                }
                else
                    stackPos--;
            }

            if (nrNotDropped != size_t.max)
            {
                code.writeln("pt = ", rewriteParameters[$ - nrNotDropped], ".val;");
                code.writeln("parseStart = ", rewriteParameters[$ - nrNotDropped], ".start;");
            }
            else
                code.writeln("pt = typeof(pt).init;");
        }
        else
        {
            if (n > 0 && !grammar.nonterminals[e.production.nonterminalID].annotations.contains!"array"()
                    && !grammar.nonterminals[e.production.nonterminalID].annotations.contains!"string"())
            {
                mixin(genCode("code", q{
                    }));
            }
            mixin(genCode("code", q{
                {
                    $$genSetParseTree();
                }
                }));
        }

        mixin(genCode("code", q{
            return ParseStackElem!(Location, NonterminalType!($(grammar.nonterminalIDCode(rewriteRules[$ - 1].applyProduction.nonterminalID))))(parseStart, pt);
            }));

        code.decIndent.writeln("}");
    }
}

string resultType(LRGraph graph, const LRGraphNode node,
        NonterminalID[immutable(NonterminalID[])] combinedReduceNonterminals,
        bool* useUnion = null, NonterminalID* singleNonterminal = null)
{
    auto grammar = graph.grammar;
    immutable inFinalParseState = node.isFinalParseState;
    if (inFinalParseState)
    {
        if (useUnion)
            *useUnion = false;
        if (singleNonterminal)
            *singleNonterminal = node.elements[0].production.symbols[0].toNonterminalID;
        return text("NonterminalType!(",
                node.elements[0].production.symbols[0].id + grammar.startNonterminalID, ")");
    }

    const(NonterminalID)[] nonterminalsOut = node.allNonterminalsOut(grammar);
    if (graph.globalOptions.delayedReduce == DelayedReduce.combined)
    {
        foreach (nonterminals; node.delayedReduceOutCombinations)
        {
            nonterminalsOut ~= combinedReduceNonterminals[nonterminals];
        }
    }
    if (nonterminalsOut.length == 1)
    {
        if (useUnion)
            *useUnion = false;
        if (singleNonterminal)
            *singleNonterminal = nonterminalsOut[0];
        return text("NonterminalType!(", nonterminalsOut[0].id + grammar.startNonterminalID, ")");
    }
    if (useUnion)
        *useUnion = true;
    return text("CreatorInstance.NonterminalUnion!(", "[",
            nonterminalsOut.map!(x => (x.id + grammar.startNonterminalID).text).joiner(", "), "])");
}

string parserStackType(LRGraph graph, size_t stateNr, size_t pos)
{
    auto grammar = graph.grammar;
    const LRGraphNode node = graph.states[stateNr];
    auto k = node.stackSymbols.length - pos;
    auto symbol = node.stackSymbols[k];
    string r = "ParseStackElem!(Location, ";
    if (symbol.isToken)
        r ~= "Token";
    else if (node.stackDelayedReduce[k])
        r ~= text("NonterminalType!",
                grammar.nonterminalIDCode(node.stackDelayedReduce[k][0].toNonterminalID));
    else if (symbol.id == SymbolID.max && graph.globalOptions.directUnwrap)
    {
        if (node.isArrayOnStack(grammar, k))
            r ~= "CreatorInstance.NonterminalArray";
        else
            r ~= "CreatorInstance.Type";
    }
    else
        r ~= text("NonterminalType!", grammar.nonterminalIDCode(symbol.toNonterminalID));
    r ~= ")";
    return r;
}

void createParseFunction(ref CodeWriter code, LRGraph graph, size_t stateNr, const LRGraphNode node, bool useRegexlookahead,
        ref EBNFGrammar lookaheadGrammar,
        NonterminalID[immutable(NonterminalID[])] combinedReduceNonterminals,
        ref RegexLookahead regexLookahead)
{
    auto grammar = graph.grammar;
    immutable endTok = grammar.tokens.getID("$end");

    createParseStateComments(code, graph, stateNr, node);

    if (node.elements.length == 0)
    {
        code.writeln("// skipped ", parseFunctionName(graph, stateNr));
        code.writeln();
        return;
    }

    ActionTable actionTable = genActionTable(graph, node);
    bool hasDelayedReduceOutput;
    foreach (t, x; actionTable.actions)
        foreach (s, a; x)
        {
            if (a.type == ActionType.delayedReduce)
            {
                if (a.reusedDelayedNonterminals.length > 0)
                    hasDelayedReduceOutput = true;
                foreach (e; a.delayedElements)
                    if (node.elements[e].dotPos > 0)
                        hasDelayedReduceOutput = true;
            }
        }

    if (graph.globalOptions.delayedReduce)
        hasDelayedReduceOutput = true;

    size_t[2] minMaxGotoParent = node.minMaxGotoParent;
    immutable inFinalParseState = node.isFinalParseState;

    const Symbol[] stackSymbols = node.stackSymbols;
    bool[] stackSymbolsNotDropped = node.stackSymbolsNotDropped;
    bool[] stackSymbolsStartOfProduction = node.stackSymbolsStartOfProduction;

    bool thisHasTags = node.hasTags(graph);

    bool thisResultUsesUnion;
    NonterminalID thisResultSingleNonterminal;

    mixin(genCode("code", q{
        $(inFinalParseState ? "" : "private ")  _
        int $(parseFunctionName(graph, stateNr))(  _
        ref $(resultType(graph, node, combinedReduceNonterminals, &thisResultUsesUnion, &thisResultSingleNonterminal)) result,   _
        ref Location resultLocation  _
        $$if (thisHasTags) {
            , scope Tag *outTags$(inFinalParseState ? " = null" : "")  _
        $$}
        $$foreach (k, symbol; node.stackSymbols) {
            $$if (stackSymbolsStartOfProduction[k]) {
                , Location parseStart$(stackSymbols.length - k)  _
            $$}
            $$if (!stackSymbolsNotDropped[k]) code.write("/+");
            , $(parserStackType(graph, stateNr, stackSymbols.length - k)) stack$(stackSymbols.length - k)  _
            $$if (!stackSymbolsNotDropped[k]) code.write("+/");
            $$if (node.needsTagsOnStack(grammar, k)) {
                , Tag stackTags$(stackSymbols.length - k)  _
            $$}
        $$}
        )
        }));

    code.writeln("{");
    code.incIndent;
    code.writeln("alias ThisParseResult = typeof(result);");

    auto actionCases = groupActions(graph, actionTable);

    foreach (n; actionTable.usedNegLookahead.sortedKeys)
        code.writeln("bool disallow", symbolNameCode(grammar, n), ";");

    size_t allowTokenCount;
    foreach (e; node.elements)
    {
        if (!e.isStartElement)
            continue;

        foreach (a; graph.grammar.nonterminals[e.production.nonterminalID]
                .annotations.otherAnnotations)
            if (a.startsWith("enableToken("))
            {
                enforce(a.endsWith(")"));
                string name = a[12 .. $ - 1];
                auto id = graph.grammar.tokens.getID(name);
                code.writeln("const bool allowToken", allowTokenCount,
                        "Orig = lexer.allowToken!", graph.grammar.tokens[id].tokenDCode, ";");
                code.writeln("lexer.allowToken!", graph.grammar.tokens[id].tokenDCode, " = true;");
                code.writeln("scope(exit)");
                code.writeln("    lexer.allowToken!", graph.grammar.tokens[id].tokenDCode,
                        " = allowToken", allowTokenCount, "Orig;");
                allowTokenCount++;
            }
    }

    if (actionTable.hasShift)
    {
        code.writeln("alias ParseResultIn = CreatorInstance.NonterminalUnion!([",
                node.allNonterminals(grammar).map!(x => (x.id + grammar.startNonterminalID)
                    .text).joiner(", "), "]);");
        code.writeln("ParseResultIn currentResult;");
        code.writeln("Location currentResultLocation;");
        if (actionTable.hasTags)
            code.writeln("Tag currentTags;");
        code.writeln("int gotoParent = -1;");
    }
    code.writeln("Location currentStart = lexer.front.currentLocation;");

    bool stillReachable = true;
    void shiftCode(size_t newState, string var, bool tokenShift, bool delayedReduceShift)
    {
        if (newState == size_t.max)
        {
            code.writeln(q{lastError = new SingleParseException!Location("shift to empty state ", lexer.front.currentLocation, lexer.front.currentLocation);});
            code.writeln(q{return -1;});
            return;
        }

        const LRGraphNode nextNode = graph.states[newState];
        const Symbol[] nextStackSymbols = nextNode.stackSymbols;
        assert(nextStackSymbols.length <= stackSymbols.length + 1, text(stateNr, " ", newState));

        const(Symbol)[] nextTopStackSymbols;
        foreach (e; nextNode.elements)
        {
            auto s = e.stackSymbols;
            if (s.length == 0)
                continue;
            nextTopStackSymbols.addOnce(s[$ - 1]);
        }

        bool nextHasTags = graph.states[newState].hasTags(graph);

        mixin(genCode("code", q{
            auto next = $(var);
            $$bool nextUsesUnion;
            $$NonterminalID nextSingleNonterminal;
            $(resultType(graph, graph.states[newState], combinedReduceNonterminals, &nextUsesUnion, &nextSingleNonterminal)) r;
            Location rl;
            gotoParent = $(parseFunctionName(graph, newState))(r, rl  _
            $$bool[] stackSymbolsNotDropped2 = nextNode.stackSymbolsNotDropped;
            $$bool[] stackSymbolsStartOfProduction2 = nextNode.stackSymbolsStartOfProduction;
            $$if (nextHasTags) {
                , &currentTags  _
            $$}
            $$foreach (k; iota(nextStackSymbols.length - 1, 0, -1)) {
                $$if (stackSymbolsStartOfProduction2[$ - 1-k]) {
                    , parseStart$(k)  _
                $$}
                $$if (stackSymbolsNotDropped2[$ - 1-k]) {
                    , stack$(k)  _
                $$} else {
                    /*, stack$(k)*/  _
                $$}
                $$if (nextNode.needsTagsOnStack(grammar, nextStackSymbols.length - k - 1)) {
                    , stackTags$(k)  _
                $$}
            $$}
            $$if (stackSymbolsStartOfProduction2.length && stackSymbolsStartOfProduction2[$ - 1]) {
                , currentStart  _
            $$}
            $$if (stackSymbolsNotDropped2.length && stackSymbolsNotDropped2[$ - 1]) {
                , next  _
            $$} else {
                /*, next*/  _
            $$}
            $$if (nextNode.needsTagsOnStack(grammar, nextStackSymbols.length - 1)) {
                , currentTags  _
            $$}
            );
            $$if (actionTable.hasTags && !nextHasTags) {
                currentTags = Tag.none;
            $$}
            if (gotoParent < 0)
                return gotoParent;
            $$if (nextNode.minMaxGotoParent[0] > 0) {
                assert(gotoParent > 0);
                $$if (inFinalParseState) {
                    $$if (nextUsesUnion) {
                        auto tree = r.get!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID));
                    $$} else {
                        auto tree = r;
                    $$}
                    result = tree;
                    resultLocation = rl;
                    $$if (thisHasTags) {
                        if (outTags)
                            *outTags = $(actionTable.hasTags ? "currentTags" : "Tag.none");
                    $$}
                    return 0;
                $$} else {
                    $$if (nextUsesUnion == thisResultUsesUnion) {
                        result = r;
                    $$} else {
                        result = ThisParseResult.create($(grammar.nonterminalIDCode(nextSingleNonterminal)), r);
                    $$}
                    resultLocation = rl;
                    $$if (thisHasTags) {
                        if (outTags)
                            *outTags = $(actionTable.hasTags ? "currentTags" : "Tag.none");
                    $$}
                    return gotoParent - 1;
                $$}
            $$} else {
                $$stillReachable = true;
                $$if (nextUsesUnion) {
                    currentResult = r;
                $$} else {
                    currentResult = ParseResultIn.create($(grammar.nonterminalIDCode(nextSingleNonterminal)), r);
                $$}
                currentResultLocation = rl;
            $$}
            }));
    }

    bool hasConflict = false;
    foreach (subTokenActions; actionTable.actions)
        foreach (a; subTokenActions)
        {
            if (a.type == ActionType.conflict)
                hasConflict = true;
        }

    bool shownConflictError;

    void printConflictComment(Action bestAction, TokenID currentToken = TokenID.invalid)
    {
        assert(bestAction.type == ActionType.conflict);
        code.writeln("/+");
        code.writeln(bestAction);
        code.writeln("  currentToken: ", grammar.getSymbolName(currentToken));
        foreach (a; bestAction.conflictActions)
        {
            if (a.type == ActionType.reduce || a.type == ActionType.accept)
            {
                auto e = node.elements[a.elementNr];
                code.writeln("  reduce ", e.toString(graph));
                if (currentToken != TokenID.invalid)
                {
                    bool[ElementID] done;
                    bool findReduceElement(size_t stateNr, const LRElement e)
                    {
                        auto node = graph.states[stateNr];
                        if (e.dotPos == 0)
                        {
                            foreach (elementNr2, e2; node.elements)
                            {
                                if (e2.dotPos >= e2.production.symbols.length)
                                    continue;
                                if (e2.production.symbols[e2.dotPos].isToken)
                                    continue;
                                bool found;
                                foreach (n; e2.nextNonterminals(graph.grammar,
                                        graph.globalOptions.directUnwrap))
                                {
                                    if (n.nonterminalID == e.production.nonterminalID)
                                    {
                                        found = true;
                                        break;
                                    }
                                }
                                if (!found)
                                    continue;

                                if (e2.dotPos + 1 < e2.production.symbols.length
                                        && grammar.firstSetContains(e2.production.symbols[e2.dotPos + 1 .. $],
                                            currentToken))
                                {
                                    code.writeln("    source: ", e2.toString(graph));
                                    return true;
                                }
                                if (e2.production.symbols[e2.dotPos + 1 .. $].all!(
                                        s => grammar.canBeEmpty(s)))
                                {
                                    if (ElementID(stateNr, elementNr2) !in done)
                                    {
                                        done[ElementID(stateNr, elementNr2)] = true;
                                        if (findReduceElement(stateNr, e2))
                                        {
                                            code.writeln("    state self: ", e2.toString(graph));
                                            return true;
                                        }
                                    }
                                }
                            }
                        }
                        foreach (prev; e.prevElements)
                        {
                            size_t prevState = prev.state;
                            if (prevState == size_t.max)
                                prevState = stateNr;
                            auto e2 = graph.states[prevState].elements[prev.elementNr];
                            if (!e2.lookahead[currentToken])
                                continue;
                            if (ElementID(prevState, prev.elementNr) in done)
                            {
                                continue;
                            }
                            done[ElementID(prevState, prev.elementNr)] = true;
                            if (findReduceElement(prevState, e2))
                            {
                                if (prev.state == size_t.max)
                                {
                                    code.writeln("    state self: ", e2.toString(graph));
                                }
                                else
                                {
                                    code.writeln("    state ", prev.state,
                                            ": ", e2.toString(graph));
                                }
                                return true;
                            }
                        }
                        return false;
                    }

                    findReduceElement(stateNr, e);
                }
            }
            else if (a.type == ActionType.shift)
            {
                code.writeln("  ", a);
                if (currentToken != TokenID.invalid)
                {
                    foreach (e; node.elements)
                    {
                        if (grammar.firstSet(e.afterDot(grammar))[currentToken])
                        {
                            code.writeln("    ", e.toString(graph));
                        }
                    }
                }
            }
            else if (a.type == ActionType.descent)
            {
                code.writeln("  descent ", grammar.getSymbolName(a.nonterminalID));
                if (currentToken != TokenID.invalid)
                {
                    NonterminalID nonterminalID = a.nonterminalID;
                    bool[NonterminalID] done;
                    outer: while (nonterminalID !in done)
                    {
                        done[nonterminalID] = true;
                        foreach (p; grammar.getProductions(nonterminalID))
                        {
                            foreach (i; 0 .. p.symbols.length)
                            {
                                if (p.symbols[i].isToken)
                                {
                                    if (p.symbols[i] == currentToken)
                                    {
                                        code.writeln("    source ", i, " ",
                                                grammar.productionString(p));
                                        break outer;
                                    }
                                    break;
                                }
                                else
                                {
                                    BitSet!TokenID firstSet = grammar.firstSet(p.symbols[i .. i + 1]);
                                    if (!firstSet[grammar.tokens.getID("$end")])
                                        break;
                                }
                            }
                        }
                        foreach (p; grammar.getProductions(nonterminalID))
                        {
                            foreach (i; 0 .. p.symbols.length)
                            {
                                BitSet!TokenID firstSet = grammar.firstSet(p.symbols[i .. i + 1]);
                                if (firstSet[currentToken])
                                {
                                    if (!p.symbols[i].isToken)
                                    {
                                        foreach (p2; grammar.getProductions(
                                                p.symbols[i].toNonterminalID))
                                        {
                                            if (grammar.firstSet(p2.symbols)[currentToken])
                                            {
                                                code.writeln("    middle ", i, " ",
                                                        grammar.productionString(p));
                                                nonterminalID = p.symbols[i].toNonterminalID;
                                                continue outer;
                                            }
                                        }
                                    }
                                }
                                if (!firstSet[grammar.tokens.getID("$end")])
                                    break;
                            }
                        }
                    }
                }
            }
            else
                code.writeln("  ", a);
            if (currentToken != TokenID.invalid)
                code.writeln("    next lookahead: ", tokenSetToString(calcNextLookahead(graph,
                        stateNr, a, currentToken), grammar));
        }
        code.writeln("+/");
    }

    void actionCode(Action bestAction, TokenID currentToken = TokenID.invalid,
            bool disallowNextLookahead = false)
    {
        assert(bestAction.type != ActionType.none);

        void generateReduceParameters(ref CodeWriter code, const LRElement e)
        {
            bool needsComma, needsCommentClose;
            if (e.production.symbols.length > 0)
            {
                code.write("parseStart", e.production.symbols.length);
                needsComma = true;
            }
            foreach (k; iota(e.production.symbols.length, 0, -1))
            {
                if (needsComma)
                    code.write(", ");
                needsComma = true;
                if (e.production.symbols[$ - k].dropNode)
                {
                    if (!needsCommentClose)
                        code.write("/*");
                    code.write("dropped");
                    needsCommentClose = true;
                }
                else
                {
                    if (needsCommentClose)
                    {
                        code.write("*/");
                        needsCommentClose = false;
                    }
                    code.write("stack", k);
                }
            }
            if (needsCommentClose)
                code.write("*/");
        }

        if (bestAction.type == ActionType.shift)
        {
            shiftCode(bestAction.newState, "popToken()", true, false);
        }
        else if (bestAction.type == ActionType.reduce || bestAction.type == ActionType.accept)
        {
            auto e = node.elements[bestAction.elementNr];
            size_t n = e.stackSymbols.length;

            if (checkTagsCode!((k) => text("stackTags", k))(code, grammar, e.production))
            {
                mixin(genCode("code", q{
                {
                    lastError = new SingleParseException!Location(text("Wrong tags"), lexer.front.currentLocation, lexer.front.currentTokenEnd);
                    return -1;
                }
                }));
            }

            if (e.isStartElement)
            {
                if (thisHasTags)
                {
                    code.writeln("if (outTags)");
                    code.writeln("    *outTags = ", reduceTagsCode!((k) => text("stackTags",
                            k))(grammar, e.production), ";");
                }
                if (n > 0)
                {
                    if (thisResultUsesUnion)
                        code.writeln("result = ThisParseResult.create(",
                                grammar.nonterminalIDCode(e.production.nonterminalID),
                                ", stack1.val);");
                    else
                        code.writeln("result = stack1.val;");
                    code.writeln("resultLocation = stack1.start;");
                    code.writeln("return 1;");
                }
                else
                {
                    code.writeln("result = ThisParseResult.init;");
                    code.writeln("resultLocation = Location.init;");
                    code.writeln("return 0;");
                }
            }
            else if (n == 0)
            {
                if (thisHasTags)
                {
                    code.writeln("currentTags = ", reduceTagsCode!((k) => text("stackTags",
                            k))(grammar, e.production), ";");
                }
                code.write("auto tmp = ", reduceFunctionName(graph, e.production, "reduce"), "(");
                generateReduceParameters(code, e);
                code.writeln(");");
                code.writeln("currentResult = ParseResultIn.create(",
                        grammar.nonterminalIDCode(e.production.nonterminalID), ", tmp.val);");
                code.writeln("currentResultLocation = tmp.start;");
                code.writeln("gotoParent = 0;");
                stillReachable = true;
            }
            else
            {
                if (thisHasTags)
                {
                    code.writeln("if (outTags)");
                    code.writeln("    *outTags = ", reduceTagsCode!((k) => text("stackTags",
                            k))(grammar, e.production), ";");
                }
                code.write("auto tmp = ", reduceFunctionName(graph, e.production, "reduce"), "(");
                generateReduceParameters(code, e);
                code.writeln(");");
                if (thisResultUsesUnion)
                    code.writeln("result = ThisParseResult.create(",
                            grammar.nonterminalIDCode(e.production.nonterminalID), ", tmp.val);");
                else
                    code.writeln("result = tmp.val;");
                code.writeln("resultLocation = tmp.start;");
                code.writeln("return ", n - 1, ";");
            }
        }
        else if (bestAction.type == ActionType.delayedReduce)
        {
            bool tagsCompatible = true;
            foreach (i, ei; bestAction.delayedElements)
            {
                if (i == 0)
                    continue;
                if (
                    node.elements[ei].production.tags
                        != node.elements[bestAction.delayedElements[i - 1]].production.tags)
                    tagsCompatible = false;
                auto symbolsLast = node
                    .elements[bestAction.delayedElements[i - 1]].production.symbols;
                foreach (j, s; node.elements[ei].production.symbols)
                    if (symbolsLast[j].tags != s.tags)
                        tagsCompatible = false;
            }

            enforce(tagsCompatible, () {
                string r = "Tags are not compatible for delayed reduce state:\n";
                foreach (ei; bestAction.delayedElements)
                {
                    auto e = node.elements[ei];
                    r ~= e.toString(graph);
                    r ~= "\n";
                    r ~= text(e.production.tags);
                    foreach (s; e.production.symbols)
                        r ~= text(" ", s.tags);
                    r ~= "\n";
                }
                return r;
            }());

            if (checkTagsCode!((k) => text("stackTags", k))(code, grammar,
                    node.elements[bestAction.delayedElements[0]].production))
            {
                mixin(genCode("code", q{
                {
                    lastError = new SingleParseException!Location(text("Wrong tags"), lexer.front.currentLocation, lexer.front.currentTokenEnd);
                    return -1;
                }
                }));
            }
            if (graph.globalOptions.delayedReduce == DelayedReduce.combined)
            {
                auto e = node.elements[bestAction.delayedElements[0]];
                size_t n = e.stackSymbols.length;
                NonterminalID[] nonterminals;
                ProductionID[] productionIDs;
                foreach (x; bestAction.delayedElements)
                {
                    nonterminals.addOnce(node.elements[x].production.nonterminalID);
                    productionIDs.addOnce(node.elements[x].production.productionID);
                }
                nonterminals.sort();
                productionIDs.sort();
                string name = "Combined:" ~ nonterminals.map!(n => grammar.getSymbolName(n))
                    .join("|");

                if (thisHasTags)
                {
                    code.writeln("if (outTags)");
                    code.writeln("    *outTags = ", reduceTagsCode!((k) => text("stackTags",
                            k))(grammar, e.production), ";");
                }
                code.write("auto tmp = ",
                        "combinedReduce" ~ productionIDs.map!(i => text(i)).join("_"), "(");
                generateReduceParameters(code, e);
                code.writeln(");");
                code.writeln("result = ThisParseResult.create(",
                        combinedReduceNonterminals[nonterminals].id, "/*", name, "*/, tmp.val);");
                code.writeln("resultLocation = tmp.start;");
                code.writeln("return ", n - 1, ";");
            }
            else
                assert(false);
        }
        else if (bestAction.type == ActionType.descent)
        {
            assert(bestAction.nonterminalID.id != SymbolID.max);

            auto nextNode = graph.states[graph.nonterminalToState[bestAction.nonterminalID.id]];
            bool nextHasTags = nextNode.hasTags(graph);

            mixin(genCode("code", q{
                {
                    $$if (actionTable.hasTags && !nextHasTags) {
                        currentTags = Tag.none;
                    $$}
                    $(resultType(graph, nextNode, combinedReduceNonterminals)) pt;
                    Location rl;
                    gotoParent = $(parseFunctionName(graph, graph.nonterminalToState[bestAction.nonterminalID.id]))(pt, rl$(nextHasTags ? ", &currentTags" : ""));
                    if (gotoParent < 0)
                        return gotoParent;
                    assert(gotoParent == 0);
                    currentResult = ParseResultIn.create($(grammar.nonterminalIDCode(bestAction.nonterminalID)), pt);
                    currentResultLocation = rl;
                }
                }));
            stillReachable = true;
        }
        else if (bestAction.type == ActionType.conflict && () {
                foreach (a; bestAction.conflictActions)
                    if (a.allowRegexLookahead)
                        return true;
                return false;
            }())
        {
            code.writeln("/+");
            code.writeln("  regexLookahead:");
            foreach (a; bestAction.conflictActions)
                code.writeln("    ", a);
            code.writeln("+/");

            if (regexLookahead is null)
            {
                regexLookahead = new RegexLookahead(grammar,
                        actionTable.reduceConflictProductions, useRegexlookahead);
            }

            RegexLookaheadGraph regexLookaheadGraph = new RegexLookaheadGraph;
            regexLookaheadGraph.id = regexLookahead.graphs.length;
            regexLookahead.graphs ~= regexLookaheadGraph;

            size_t[NonterminalID] descentActionByNonterminal;
            size_t shiftAction = size_t.max;
            foreach (i, action; bestAction.conflictActions)
            {
                if (action.type == ActionType.descent)
                    descentActionByNonterminal[action.nonterminalID] = i;
                else if (action.type == ActionType.shift)
                {
                    enforce(shiftAction == size_t.max);
                    shiftAction = i;
                }
                else if (action.type == ActionType.reduce)
                {
                    auto e = node.elements[action.elementNr];
                    NonterminalID ml = regexLookahead.getLookaheadNonterminal(graph,
                            stateNr, action.elementNr);
                    immutable(SymbolInstance)[] symbols = [SymbolInstance(ml)];
                    regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[],
                            size_t)(symbols, i));
                }
                else
                    enforce(false);
            }
            foreach (i, e; node.elements)
            {
                if (e.isNextNonterminal(grammar))
                {
                    foreach (nextNonterminal; e.nextNonterminals(grammar,
                            graph.globalOptions.directUnwrap))
                    {
                        if (nextNonterminal.nonterminalID in descentActionByNonterminal)
                        {
                            size_t lookaheadUntil = e.dotPos + 1;
                            while (lookaheadUntil < e.production.symbols.length /* && e.production.symbols[lookaheadUntil].annotations.contains!"lookahead"*/ )
                                lookaheadUntil++;
                            immutable(SymbolInstance)[] symbols = SymbolInstance(
                                    nextNonterminal.nonterminalID)
                                ~ e.production.symbols[e.dotPos + 1 .. lookaheadUntil];
                            if (e.production.annotations.contains!"lookahead")
                            {
                                NonterminalID ml = regexLookahead.getLookaheadNonterminal(graph,
                                        stateNr, i);
                                symbols ~= SymbolInstance(ml);
                            }
                            else
                                symbols ~= [
                                    SymbolInstance(regexLookahead.getLookaheadNonterminalSimple(graph, stateNr, i)),
                                    SymbolInstance(regexLookahead.grammar2.tokens.id("$anything"))
                                ];
                            regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[], size_t)(symbols,
                                    descentActionByNonterminal[nextNonterminal.nonterminalID]));
                        }
                    }
                }
                else if (e.isNextToken(grammar) && e.next(grammar).toTokenID == currentToken)
                {
                    size_t lookaheadUntil = e.dotPos + 1;
                    while (lookaheadUntil < e.production.symbols.length)
                        lookaheadUntil++;
                    immutable(SymbolInstance)[] symbols = e.production
                        .symbols[e.dotPos .. lookaheadUntil];
                    if (e.production.annotations.contains!"lookahead")
                    {
                        NonterminalID ml = regexLookahead.getLookaheadNonterminal(graph,
                                stateNr, i);
                        symbols ~= SymbolInstance(ml);
                    }
                    else
                        symbols ~= [
                            SymbolInstance(regexLookahead.getLookaheadNonterminalSimple(graph, stateNr, i)),
                            SymbolInstance(regexLookahead.grammar2.tokens.id("$anything"))
                        ];
                    regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[],
                            size_t)(symbols, shiftAction));
                }
            }

            code.writeln("switch (checkRegexLookahead", regexLookaheadGraph.id, "())");
            code.writeln("{").incIndent;
            bool anyStillReachable = false;
            foreach (i, action; bestAction.conflictActions)
            {
                mixin(genCode("code", q{
                    case $(i):
                    {
                        $$stillReachable = false;
                        $$actionCode(action, currentToken);
                    }
                    $$if (stillReachable) {
                        $$anyStillReachable = true;
                        break;
                    $$} else {
                        assert(false);
                    $$}
                }));
            }
            code.writeln("case SymbolID.max:");
            code.writeln("    return -1;");
            code.writeln("default:");
            code.writeln("    assert(false);");
            code.decIndent.writeln("}");

            stillReachable = anyStillReachable;
        }
        else if (bestAction.type == ActionType.conflict
                && currentToken != TokenID.invalid && !disallowNextLookahead)
        {
            BitSet!TokenID[] nextLookaheads;
            nextLookaheads.length = bestAction.conflictActions.length;
            foreach (i, a; bestAction.conflictActions)
            {
                nextLookaheads[i] = calcNextLookahead(graph, stateNr, a, currentToken);
            }
            BitSet!TokenID[] exclusiveNextLookaheads;
            exclusiveNextLookaheads.length = bestAction.conflictActions.length;
            foreach (i, a; bestAction.conflictActions)
            {
                exclusiveNextLookaheads[i] = nextLookaheads[i].dup;
                foreach (j, a2; bestAction.conflictActions)
                {
                    if (i != j)
                    {
                        foreach (t; nextLookaheads[j].bitsSet)
                            exclusiveNextLookaheads[i][t] = false;
                    }
                }
            }
            bool hasStillConflict;
            foreach (i, a; bestAction.conflictActions)
            {
                foreach (t; nextLookaheads[i].bitsSet)
                    if (!exclusiveNextLookaheads[i][t])
                        hasStillConflict = true;
            }
            bool[] hasExclusive;
            hasExclusive.length = bestAction.conflictActions.length;
            bool hasAnyExclusive;
            foreach (i, a; bestAction.conflictActions)
            {
                foreach (t; exclusiveNextLookaheads[i].bitsSet)
                {
                    hasExclusive[i] = true;
                    hasAnyExclusive = true;
                    break;
                }
            }
            if (!hasAnyExclusive)
            {
                actionCode(bestAction, currentToken, true);
            }
            else
            {
                if (hasStillConflict)
                    printConflictComment(bestAction, currentToken);
                code.writeln("Lexer tmpLexer = *lexer;");
                code.writeln("tmpLexer.popFront();");
                bool needsElse;
                foreach (i, a; bestAction.conflictActions)
                {
                    if (!hasExclusive[i])
                        continue;
                    if (needsElse)
                        code.write("else ");
                    needsElse = true;
                    bool needsOr;
                    code.writeln("if (", tokenSetCode(grammar,
                            exclusiveNextLookaheads[i], "tmpLexer"), ")");
                    code.writeln("{").incIndent;
                    actionCode(a, currentToken, true);
                    code.decIndent.writeln("}");
                }
                code.writeln("else");
                code.writeln("{").incIndent;
                if (hasStillConflict)
                {
                    actionCode(bestAction, currentToken, true);
                }
                else
                {
                    mixin(genCode("code", q{
                    lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                        tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                    return -1;
                    }));
                }
                code.decIndent.writeln("}");
            }
        }
        else if (bestAction.type == ActionType.conflict)
        {
            printConflictComment(bestAction, currentToken);
            mixin(genCode("code", q{
            lastError = new SingleParseException!Location(text("conflict \"$(bestAction.errorMessage.escapeD)\"  \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""), lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
            }));
            if (!shownConflictError)
            {
                stderr.writeln("Warning: Parse conflict in state ", stateNr);
                shownConflictError = true;
            }
        }
        else
            assert(false);
    }

    if (node.backtrackStates.length)
    {
        assert(node.type == LRGraphNodeType.backtrack || node.type == LRGraphNodeType.lookahead);
    }

    if (node.type == LRGraphNodeType.backtrack)
    {
        assert(node.backtrackStates.length);
        code.writeln("Lexer savedLexer = *lexer;");
        code.writeln("Location savedLastTokenEnd = lastTokenEnd;");
        code.writeln("ParseException[", node.backtrackStates.length, "] exceptions;");
        code.writeln("int gotoParent = -1;");

        NonterminalID startNonterminal = node.elements[0].production.nonterminalID;
        const Production*[] productions = grammar.getProductions(startNonterminal);
        assert(productions.length == node.backtrackStates.length);

        string[] prods;
        foreach (i, s; node.backtrackStates)
        {
            prods ~= grammar.productionString(productions[i]);
            mixin(genCode("code", q{
                // try $(s)  $(grammar.productionString(productions[i]))
                try
                {
                    $(resultType(graph, graph.states[s], combinedReduceNonterminals)) r;
                    Location rl;
                    gotoParent = $(parseFunctionName(graph, s))(r, rl);
                    if (gotoParent < 0)
                    {
                        throw lastError;
                    }
                    if ($(tokenSetCode(grammar, node.elements[0].lookahead, "lexer", true)))
                    {
                        throw new SingleParseException!Location(text("unexpected  \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""), lexer.front.currentLocation, lexer.front.currentTokenEnd);
                    }
                    result = r;
                    resultLocation = rl;
                    return gotoParent;
                }
                catch(ParseException e)
                {
                    if (!e.allowBacktrack())
                        throw e;
                    lastError = null;
                    *lexer = savedLexer;
                    lastTokenEnd = savedLastTokenEnd;
                    exceptions[$(i)] = e;
                }
                }));
        }
        mixin(genCode("code", q{
            lastError = new BacktrackParseException("no try worked", $(prods), exceptions.dup);
            return -1;
            }));
        stillReachable = false;
    }
    else if (node.type == LRGraphNodeType.lookahead)
    {
        assert(node.backtrackStates.length);
        code.writeln("//lookahead;");

        if (regexLookahead is null)
        {
            regexLookahead = new RegexLookahead(grammar,
                    actionTable.reduceConflictProductions, useRegexlookahead);
        }

        RegexLookaheadGraph regexLookaheadGraph = new RegexLookaheadGraph;
        regexLookaheadGraph.id = regexLookahead.graphs.length;
        regexLookahead.graphs ~= regexLookaheadGraph;

        NonterminalID startNonterminal = node.elements[0].production.nonterminalID;
        const Production*[] productions = grammar.getProductions(startNonterminal);
        assert(productions.length == node.backtrackStates.length);

        foreach (i, s; node.backtrackStates)
        {
            auto p = productions[i];

            immutable(SymbolInstance)[] symbols = p.symbols ~ SymbolInstance(
                    regexLookahead.grammar2.tokens.id("$end"));
            regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[],
                    size_t)(symbols, i));
        }

        code.writeln("switch (checkRegexLookahead", regexLookaheadGraph.id, "())");
        code.writeln("{").incIndent;
        foreach (i, s; node.backtrackStates)
        {
            mixin(genCode("code", q{
                case $(i):
                {
                    return $(parseFunctionName(graph, node.backtrackStates[i]))(result, resultLocation);
                }
                assert(false);
            }));
        }
        code.writeln("case SymbolID.max:");
        code.writeln("    return -1;");
        code.writeln("default:");
        code.writeln("    assert(false);");
        code.decIndent.writeln("}");

        stillReachable = false;
    }
    else
    {
        if (hasConflict && !useRegexlookahead)
        {
            foreach (e; node.elements)
            {
                if (e.production.annotations.contains!"regexLookahead")
                {
                    useRegexlookahead = true;
                }
                if (e.dotPos < e.production.symbols.length
                        && e.production.symbols[e.dotPos].annotations.contains!"regexLookahead")
                {
                    useRegexlookahead = true;
                }
            }
        }

        if (hasConflict && useRegexlookahead)
        {
            if (regexLookahead is null)
            {
                regexLookahead = new RegexLookahead(grammar,
                        actionTable.reduceConflictProductions, useRegexlookahead);
            }

            RegexLookaheadGraph regexLookaheadGraph = new RegexLookaheadGraph;
            regexLookaheadGraph.id = regexLookahead.graphs.length;
            regexLookahead.graphs ~= regexLookaheadGraph;

            Action[] actions;
            size_t[Action] actionIds;
            foreach (k, element; node.elements)
            {
                NonterminalID l1 = regexLookahead.getLookaheadNonterminal(graph, stateNr, k);
                if (element.isFinished(regexLookahead.grammar2))
                {
                    Action action = Action(ActionType.reduce, 0, element.production,
                            k, NonterminalID.invalid, element.ignoreInConflict);
                    size_t id;
                    if (action in actionIds)
                        id = actionIds[action];
                    else
                    {
                        id = actions.length;
                        actions ~= action;
                        actionIds[action] = id;
                    }
                    immutable(SymbolInstance)[] symbols = [SymbolInstance(l1)];
                    regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[],
                            size_t)(symbols, id));
                }
                else if (element.next(grammar).isToken)
                {
                    NonterminalID lshift = regexLookahead.grammar2.nonterminals.id(text("$lshift_",
                            stateNr, "_", k));
                    regexLookahead.grammar2.addProduction(new Production(lshift,
                            element.production.symbols[element.dotPos .. $] ~ [
                                immutable(SymbolInstance)(l1)
                            ]));
                    size_t nextState = size_t.max;
                    foreach (edge; node.edges)
                        if (edge.symbol == element.next(grammar))
                            nextState = edge.next;
                    Action action = Action(ActionType.shift, nextState);
                    size_t id;
                    if (action in actionIds)
                        id = actionIds[action];
                    else
                    {
                        id = actions.length;
                        actions ~= action;
                        actionIds[action] = id;
                    }
                    immutable(SymbolInstance)[] symbols = [
                        SymbolInstance(lshift)
                    ];
                    regexLookaheadGraph.sequences.addOnce(tuple!(immutable(SymbolInstance)[],
                            size_t)(symbols, id));
                }
            }

            code.writeln("switch (checkRegexLookahead", regexLookaheadGraph.id, "())");
            code.writeln("{").incIndent;
            bool anyStillReachable = false;
            foreach (i, action; actions)
            {
                mixin(genCode("code", q{
                    case $(i):
                    {
                        $$stillReachable = false;
                        $$actionCode(action);
                    }
                    $$if (stillReachable) {
                        $$anyStillReachable = true;
                        break;
                    $$} else {
                        assert(false);
                    $$}
                }));
            }
            code.writeln("case SymbolID.max:");
            code.writeln("    return -1;");
            code.writeln("default:");
            code.writeln("    assert(false);");
            code.decIndent.writeln("}");

            stillReachable = anyStillReachable;
        }
        else
        {
            stillReachable = false;
            bool anyNonEndTokens = false;
            foreach (t; actionTable.actions.sortedKeys)
                if (t != endTok)
                    anyNonEndTokens = true;
            bool skipIf = !anyNonEndTokens && ((actionTable.defaultReduceAction.type != ActionType.none
                    && (endTok !in actionTable.actions
                    || actionTable.defaultReduceAction == actionTable.actions[endTok][""]))
                    || (actionTable.defaultReduceAction.type == ActionType.none
                        && endTok in actionTable.actions));

            if (!skipIf && endTok !in actionTable.actions)
            {
                mixin(genCode("code", q{
                    if (lexer.empty)
                    {
                        lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
                        return -1;
                    }
                    }));
            }

            foreach (caseInfo; actionCases)
            {
                if (skipIf && caseInfo.tokens.length == 1 && caseInfo.tokens[0] == endTok)
                    continue;
                assert(caseInfo.tokens.length == 1 || caseInfo.subToken.length == 0);
                string ifText = caseInfo.tokens[0] == endTok ? "if (" : "else if (";
                foreach (i, t; caseInfo.tokens)
                {
                    if (i)
                        ifText ~= " || ";
                    if (t == endTok)
                        ifText ~= "lexer.empty";
                    else
                        ifText ~= text("lexer.front.symbol == Lexer.tokenID!",
                                grammar.tokens[t].tokenDCode);
                }
                if (caseInfo.subToken.length)
                    ifText ~= text(" && lexer.front.content == ", caseInfo.subToken);
                ifText ~= ")";

                code.writeln(ifText).writeln("{").incIndent;
                foreach (t; caseInfo.tokens)
                {
                    if (t in actionTable.usedNegLookahead)
                    {
                        assert(caseInfo.tokens.length == 1);
                        code.writeln("disallow", symbolNameCode(grammar, t), " = true;");
                    }
                }

                actionCode(caseInfo.action, caseInfo.tokens.length == 1
                        ? caseInfo.tokens[0] : TokenID.invalid);
                code.decIndent.writeln("}");
            }

            if (actionTable.defaultReduceAction.type != ActionType.none)
            {
                if (!skipIf)
                    code.writeln("else");
                code.writeln("{").incIndent;
                actionCode(actionTable.defaultReduceAction);
                code.decIndent.writeln("}");
            }
            else if (endTok in actionTable.actions)
            {
                if (!skipIf)
                    code.writeln("else");
                code.writeln("{").incIndent;
                actionCode(actionTable.actions[endTok][""]);
                code.decIndent.writeln("}");
            }
            else
            {
                mixin(genCode("code", q{
                    else
                    {
                        lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                            lexer.front.currentLocation, lexer.front.currentTokenEnd);
                        return -1;
                    }
                    }));
            }
        }
        if (actionTable.hasShift && stillReachable && actionTable.jumps.length)
            code.writeln("");
    }

    void genJumpCode(NonterminalID nonterminalID, size_t newState)
    {
        mixin(genCode("code", q{
            $$if (nonterminalID in actionTable.usedNegLookahead) {
                disallow$(symbolNameCode(grammar, nonterminalID)) = true;
            $$}
            $$if (newState != size_t.max && trivialState(graph.states[newState])) {
                currentResult = ParseResultIn.create($(grammar.nonterminalIDCode(graph.states[newState].elements[0].production.nonterminalID)), currentResult.get!($(grammar.nonterminalIDCode(nonterminalID))));
                currentResultLocation = currentResultLocation;
            $$} else {
                $$shiftCode(newState, text(parserStackType(graph, newState, 1), "(currentResultLocation, currentResult.get!(", (nonterminalID.id >= grammar.nonterminals.vals.length)?text(nonterminalID.id):grammar.nonterminalIDCode(nonterminalID), ")())"), false, nonterminalID.id == SymbolID.max);
            $$}
            }));
    }

    mixin(genCode("code", q{
        $$if (actionTable.hasShift && stillReachable) {
            $$if (actionTable.jumps.length || actionTable.jumps2.length) {
                while (gotoParent == 0)
                {
                    $$CommaGen elseCodeOuter = CommaGen("else ");
                    $$foreach (nonterminalID; actionTable.jumps.sortedKeys) {
                        $$auto jumps2 = actionTable.jumps[nonterminalID];
                        $$if (!node.allNonterminals(grammar).canFind(nonterminalID)) continue;
                        $(elseCodeOuter())if (currentResult.nonterminalID == $(grammar.nonterminalIDCode(nonterminalID)))
                        {
                            $$CommaGen elseCode = CommaGen("else ");
                            $$bool hasDisallowCheck;
                            $$foreach (checkDisallowedSymbols; jumps2.sortedKeys) {
                                $$auto newState = jumps2[checkDisallowedSymbols];
                                $$if (checkDisallowedSymbols.length == 0) {
                                    $$genJumpCode(nonterminalID, newState);
                                $$} else {
                                    $$CommaGen and = CommaGen(" && ");
                                    $$hasDisallowCheck = true;
                                    $(elseCode())if (  _
                                    $$foreach (x; checkDisallowedSymbols) {
                                        $(and())disallow$(symbolNameCode(grammar, x[0])) == $(x[1])  _
                                    $$}
                                    )
                                    {
                                        $$genJumpCode(nonterminalID, newState);
                                    }
                                $$}
                            $$}
                            $$if (hasDisallowCheck) {
                                else
                                    assert(false);
                            $$}
                        }
                    $$}
                    $$if (graph.globalOptions.delayedReduce == DelayedReduce.combined && actionTable.jumps2.length > 0) {
                        $$foreach (nonterminalIDs; actionTable.jumps2.sortedKeys) {
                            $$auto jumps2 = actionTable.jumps2[nonterminalIDs];
                            $(elseCodeOuter())if (currentResult.nonterminalID == $(combinedReduceNonterminals[nonterminalIDs].id)/*Combined:$(nonterminalIDs.map!(n=>grammar.getSymbolName(n)).join("|"))*/)
                            {
                                $$CommaGen elseCode = CommaGen("else ");
                                $$bool hasDisallowCheck;
                                $$foreach (checkDisallowedSymbols, newState; jumps2) {
                                    $$if (checkDisallowedSymbols.length == 0) {
                                        $$genJumpCode(combinedReduceNonterminals[nonterminalIDs], newState);
                                    $$} else {
                                        $$CommaGen and = CommaGen(" && ");
                                        $$hasDisallowCheck = true;
                                        $(elseCode())if (  _
                                        $$foreach (x; checkDisallowedSymbols) {
                                            $(and())disallow$(symbolNameCode(grammar, x[0])) == $(x[1])  _
                                        $$}
                                        )
                                        {
                                            $$genJumpCode(combinedReduceNonterminals[nonterminalIDs], newState);
                                        }
                                    $$}
                                $$}
                                $$if (hasDisallowCheck) {
                                    else
                                        assert(false);
                                $$}
                            }
                        $$}
                    $$}
                    else
                        assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
                }

            $$} else {
                assert(gotoParent != 0);
            $$}
            $$if (inFinalParseState) {
                auto tree = currentResult.get!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID));
                result = tree;
                resultLocation = currentResultLocation;
                return 0;
            $$} else if (minMaxGotoParent[0] == SymbolID.max) {
                assert(false);
            $$} else {
                $$if (thisResultUsesUnion) {
                    result = currentResult;
                $$} else {
                    result = currentResult.get!($(grammar.nonterminalIDCode(thisResultSingleNonterminal)));
                $$}
                resultLocation = currentResultLocation;
                return gotoParent - 1;
            $$}
        $$}
        }));

    code.decIndent.writeln("}");
}

const(char)[] createParserModule(LRGraph graph, string modulename, bool useRegexlookahead)
{
    EBNFGrammar grammar = graph.grammar;

    if (graph.states.length == 0)
        return "// no states\n";

    CodeWriter code;
    code.indentStr = "    ";

    string nonterminalNameCode(const Nonterminal n)
    {
        return n.name.escapeD;
    }

    string allTokensCode = createAllTokensCode(grammar);
    string allNonterminalsCode = createAllNonterminalsCode(grammar);

    immutable(NonterminalID)[][] delayedReduceCombinations;
    NonterminalID[immutable(NonterminalID[])] combinedReduceNonterminals;
    if (graph.globalOptions.delayedReduce == DelayedReduce.combined)
    {
        foreach (stateNr; 0 .. graph.states.length)
        {
            foreach (x; graph.states[stateNr].delayedReduceCombinations)
                delayedReduceCombinations.addOnce(x);
        }
        delayedReduceCombinations.sort();
        foreach (i, nonterminals; delayedReduceCombinations)
        {
            combinedReduceNonterminals[nonterminals] = NonterminalID(
                    cast(SymbolID)(i + grammar.nonterminals.vals.length));
            string name = "Combined:" ~ nonterminals.map!(n => grammar.getSymbolName(n)).join("|");
            allNonterminalsCode ~= text("    /* ",
                    i + grammar.nonterminals.vals.length + grammar.startNonterminalID, ": */ immutable(Nonterminal)(", "\"",
                    name.escapeD, "\", ",
                    grammar.nonterminals.vals[nonterminals[0].id].flags.nonterminalFlagsToCode, ", [",
                    grammar.nonterminals.vals[nonterminals[0].id].annotations.contains!"array"
                        ? "\"Array\"" : "", "], ",
                    " []", ")", ",\n");
        }
    }

    EBNFGrammar lookaheadGrammar;

    RegexLookahead regexLookahead;

    mixin(genCode("code", q{
        // Generated with DParserGen.
        module $(modulename);
        import dparsergen.core.grammarinfo;
        import dparsergen.core.parseexception;
        import dparsergen.core.parsestackelem;
        import dparsergen.core.utils;
        import std.algorithm;
        import std.conv;
        import std.meta;
        import std.stdio;
        import std.traits;

        enum SymbolID startTokenID = $(grammar.startTokenID);
        static assert(allTokens.length < SymbolID.max - startTokenID);
        enum SymbolID endTokenID = startTokenID + allTokens.length;

        enum SymbolID startNonterminalID = $(grammar.startNonterminalID);
        static assert(allNonterminals.length < SymbolID.max - startNonterminalID);
        enum SymbolID endNonterminalID = startNonterminalID + allNonterminals.length;

        enum ProductionID startProductionID = $(grammar.startProductionID);
        static assert(allProductions.length < ProductionID.max - startProductionID);
        enum ProductionID endProductionID = startProductionID + allProductions.length;

        enum nonterminalIDFor(string name) = startNonterminalID + staticIndexOf!(name,
            $$foreach (i, n; grammar.nonterminals.vals) {
                    "$(nonterminalNameCode(n))",
            $$}
                );
        $$if (grammar.tags.vals.length) {
            enum Tag
            {
                none = 0,
                $$foreach (i, t; grammar.tags.vals) {
                    $(t.name) = 1 << $(i),
                $$}
            }
        $$}

        struct Parser(CreatorInstance, alias L  _
        )
        {
            alias Lexer = L;
            alias Location = typeof(Lexer.init.front.currentLocation);
            alias LocationDiff = typeof(Location.init - Location.init);

            CreatorInstance creator;
            Lexer* lexer;
            ParseException lastError;

            template NonterminalType(size_t nonterminalID)
                    if (nonterminalID >= startNonterminalID && nonterminalID < endNonterminalID)
            {
                alias NonterminalType = CreatorInstance.NonterminalType!nonterminalID;
            }

            alias Token = typeof(lexer.front.content);

            Location lastTokenEnd;

            ParseStackElem!(Location, Token) popToken()
            {
                if (lexer.front.currentLocation - lastTokenEnd != LocationDiff.invalid)
                    assert(lexer.front.currentLocation >= lastTokenEnd,
                            text(lastTokenEnd, " ", lexer.front.currentLocation));

                lastTokenEnd = lexer.front.currentTokenEnd;
                auto tok = lexer.front.content;
                auto pos = lexer.front.currentLocation;
                lexer.popFront;

                assert(lastTokenEnd >= pos);

                if (!lexer.empty)
                {
                    assert(lexer.front.currentLocation >= lastTokenEnd,
                            text(lastTokenEnd, " ", lexer.front.currentLocation));
                }

                return ParseStackElem!(Location, Token)(pos, tok);
            }
            $$foreach (production; graph.grammar.productions) {
                $$generateReduceFunction(code, graph, reduceFunctionName(graph, production, "reduce"), [production.productionID], combinedReduceNonterminals);

            $$}
            $$foreach (productionIDs; graph.delayedReduceProductionCombinations) {
                $$generateReduceFunction(code, graph, "combinedReduce" ~ productionIDs.map!(i=>text(i)).join("_"), productionIDs, combinedReduceNonterminals);

            $$}
            $$foreach (i, n; graph.states) {
                $$if (!trivialState(n)) {
                    $$createParseFunction(code, graph, i, n, useRegexlookahead, lookaheadGrammar, combinedReduceNonterminals, regexLookahead);
                $$}
            $$}
            $$if (regexLookahead !is null) {
                $$regexLookahead.genGraphs();
                $$regexLookahead.genMatchFuncs(code);
                $$foreach (g; regexLookahead.graphs) {
                    $$regexLookahead.genGraph(code, g);
                $$}
            $$}
        }

        immutable allTokens = [
        $(allTokensCode)];

        immutable allNonterminals = [
        $(allNonterminalsCode)];

        immutable allProductions = [
        $(createAllProductionsCode(grammar))];

        immutable GrammarInfo grammarInfo = immutable(GrammarInfo)(
                startTokenID, startNonterminalID, startProductionID,
                allTokens, allNonterminals, allProductions);

        Creator.Type parse(Creator, alias Lexer, string startNonterminal = "$(graph.grammar.getSymbolName(graph.grammar.startNonterminals[0].nonterminal).escapeD)")(ref Lexer lexer, Creator creator)
        {
            alias Location = typeof(Lexer.init.front.currentLocation);
            auto parser = Parser!(Creator, Lexer)(
                    creator,
                    &lexer);
            ParameterTypeTuple!(__traits(getMember, parser, "parse" ~ startNonterminal))[0] parseResult;
            Location parseResultLocation;
            int gotoParent = __traits(getMember, parser, "parse" ~ startNonterminal)(parseResult, parseResultLocation);
            if (gotoParent < 0)
            {
                assert(parser.lastError !is null);
                throw parser.lastError;
            }
            else
                assert(parser.lastError is null);
            auto result = parseResult;
            creator.adjustStart(result, parseResultLocation);
            return result;
        }

        Creator.Type parse(Creator, alias Lexer, string startNonterminal = "$(graph.grammar.getSymbolName(graph.grammar.startNonterminals[0].nonterminal).escapeD)")(string input, Creator creator, typeof(Lexer.init.front.currentLocation) startLocation = typeof(Lexer.init.front.currentLocation).init)
        {
            alias Location = typeof(Lexer.init.front.currentLocation);
            Lexer lexer = Lexer(input, startLocation);
            auto result = parse!(Creator, Lexer, startNonterminal)(lexer, creator);
            if (!lexer.empty)
            {
                throw new SingleParseException!Location("input left after parse",
                        lexer.front.currentLocation, lexer.front.currentTokenEnd);
            }
            return result;
        }
        }));

    return code.data;
}
