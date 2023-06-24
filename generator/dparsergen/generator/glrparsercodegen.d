
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.glrparsercodegen;
import dparsergen.core.utils;
import dparsergen.generator.codewriter;
import dparsergen.generator.grammar;
import dparsergen.generator.parser;
import dparsergen.generator.parsercodegencommon;
import dparsergen.generator.production;
import std.algorithm;
import std.conv;
import std.range;
import std.typecons;

bool needsExtraStateData(LRGraph graph, size_t stateNr, const LRGraphNode node)
{
    auto grammar = graph.grammar;
    foreach (e; node.elements)
    {
        if (e.isNextValid(grammar) && e.next(grammar).negLookaheads.length > 0)
            return true;
    }
    return false;
}

void createExtraStateData(ref CodeWriter code, LRGraph graph, size_t stateNr, const LRGraphNode node)
{
    auto grammar = graph.grammar;
    bool[Symbol] usedNegLookahead;
    mixin(genCode("code", q{
        static struct $(parseFunctionName(graph, stateNr, "StateData"))
        {
            $$foreach (e; node.elements) {
                $$if (e.isNextValid(grammar)) {
                    $$foreach (n; e.next(grammar).negLookaheads) {
                        $$if (n !in usedNegLookahead) {
                            bool disallow$(symbolNameCode(grammar, n));
                            $$usedNegLookahead[n] = true;
                        $$}
                    $$}
                $$}
            $$}
        }
        }));
}

bool isSingleReduceState(LRGraph graph, size_t stateNr)
{
    auto grammar = graph.grammar;
    const LRGraphNode node = graph.states[stateNr];
    return node.elements.length == 1 && node.elements[0].isFinished(grammar)
        && !node.elements[0].isStartElement;
}

void createParseFunction(ref CodeWriter code, LRGraph graph, size_t stateNr, const LRGraphNode node)
{
    auto grammar = graph.grammar;
    immutable endTok = grammar.tokens.getID("$end");

    createParseStateComments(code, graph, stateNr, node);

    if (node.hasSetStackSymbols && !graph.globalOptions.directUnwrap)
    {
        code.writeln("// hasSetStackSymbols => skipped ", parseFunctionName(graph, stateNr));
        code.writeln();
        return;
    }

    ActionTable actionTable = genActionTable(graph, node);

    void actionCode(Action bestAction)
    {
        assert(bestAction.type != ActionType.none);

        code.writeln("// ", bestAction.type);

        if (bestAction.type == ActionType.shift)
        {
            //code.writeln("writeln(\"shift token \", input.front);");

            if (!isSingleReduceState(graph, bestAction.newState))
            {
                code.writeln("StackNode *nextNode = shift!true(stackNode, start, ",
                        bestAction.newState, ", tokenContent);");
            }
            else
            {
                code.writeln("StackNode *nextNode = shift!false(stackNode, start, ",
                        bestAction.newState, ", tokenContent);");
            }

            auto nextNode = graph.states[bestAction.newState];
            if (isSingleReduceState(graph, bestAction.newState))
            {
                foreach (e; nextNode.elements)
                {
                    if (e.isFinished(grammar) && !e.isStartElement)
                    {
                        code.writeln("{").incIndent;
                        code.writeln("// early reduce ", grammar.productionString(e.production));
                        code.writeln(reduceFunctionName(graph, e.production),
                                "(nextNode, start, end, end, true);");
                        code.decIndent.writeln("}");
                    }
                }
            }
        }
        else if (bestAction.type == ActionType.reduce)
        {
            code.writeln(reduceFunctionName(graph, bestAction.production),
                    "(stackNode, start, end, lastTokenEnd, false);");
        }
        else if (bestAction.type == ActionType.delayedReduce)
        {
            assert(false);
        }
        else if (bestAction.type == ActionType.accept)
        {
            code.writeln("acceptedStackTops.addOnce(stackNode);");
        }
        else if (bestAction.type == ActionType.descent)
        {
            assert(false);
        }
        else if (bestAction.type == ActionType.conflict)
        {
            mixin(genCode("code", q{
            bool anyGood = false;
            ParseException[] exceptions;
            $$foreach (a2; bestAction.conflictActions) {
                try
                {
                    $$actionCode(a2);
                    anyGood = true;
                }
                catch(ParseException e)
                {
                    exceptions ~= e;
                }
            $$}
            if (!anyGood)
            {
                if (exceptions.length == 1)
                    throw exceptions[0];
                else
                    throw new MultiParseException("", exceptions);
            }
            }));
        }
        else
            assert(false);
    }

    static struct ActionX
    {
        Action action;
        Tuple!(TokenID, string)[] conditions;
    }

    ActionX[] actions;
    size_t[Action] actionsMap;

    foreach (t; actionTable.actions.sortedKeys)
    {
        auto a = actionTable.actions[t];
        foreach (subToken; a.sortedKeys)
        {
            auto a2 = a[subToken];
            auto x = tuple!(TokenID, string)(t, subToken);
            if (a2 !in actionsMap)
            {
                actionsMap[a2] = actions.length;
                actions ~= ActionX(a2);
            }
            actions[actionsMap[a2]].conditions ~= x;
        }
    }

    bool[Symbol] usedNegLookahead;
    foreach (e; node.elements)
    {
        if (e.isNextValid(grammar))
            foreach (n; e.next(grammar).negLookaheads)
                if (n !in usedNegLookahead)
                {
                    usedNegLookahead[n] = true;
                }
    }

    mixin(genCode("code", q{
        private void $(parseFunctionName(graph, stateNr, "pushTokenState"))(  _
        StackNode *stackNode, size_t tokenId, Token tokenContent, Location start, Location end)
        {
            $$if (node.type == LRGraphNodeType.backtrack) {
                assert(false, "Not used for GLR parser");
            $$} else if (node.type == LRGraphNodeType.lookahead) {
                assert(false, "Not used for GLR parser");
            $$} else {
                $$string ifPrefix="";
                $$foreach (l; usedNegLookahead.sortedKeys) {
                    $$if (l.isToken) {
                        if (tokenId == getTokenID!$(grammar.tokens[l.toTokenID].tokenDCode))
                            stackNode.$(parseFunctionName(graph, stateNr, "stateData")).disallow$(symbolNameCode(grammar, l)) = true;
                    $$}
                $$}
                $$foreach (a; actions) {
                    $(ifPrefix)if (  _
                    $$CommaGen orCode = CommaGen(" || ");
                    $$foreach (c; a.conditions) {
                        $$if (c[1] == "") {
                            $(orCode())tokenId == getTokenID!$(grammar.tokens[c[0]].tokenDCode)  _
                        $$} else {
                            $(orCode())(tokenId == getTokenID!$(grammar.tokens[c[0]].tokenDCode) && tokenContent == $(c[1]))  _
                        $$}
                    $$}
                    )
                    {
                        $$actionCode(a.action);
                    }
                    $$ifPrefix = "else ";
                $$}
                $$if (actionTable.defaultReduceAction.type != ActionType.none) {
                    $(ifPrefix == "else " ? "else" : ifPrefix)
                    {
                        $$actionCode(actionTable.defaultReduceAction);
                    }
                $$} else if (endTok in actionTable.actions) {
                    $(ifPrefix == "else " ? "else" : ifPrefix)
                    {
                        $$actionCode(actionTable.actions[endTok][""]);
                    }
                $$} else {
                    $(ifPrefix == "else " ? "else" : ifPrefix)
                    {
                        $$if (endTok in actionTable.actions) {
                            throw new SingleParseException!Location(text("unexpected Token \"", tokenContent, "\"  \"", getTokenName(tokenId), "\""),
                                start, end);
                        $$} else {
                            if (tokenId == getTokenID!$(grammar.tokens[endTok].tokenDCode))
                                throw new SingleParseException!Location("EOF",
                                    start, end);
                            else
                                throw new SingleParseException!Location(text("unexpected Token \"", tokenContent, "\"  \"", getTokenName(tokenId), "\""),
                                    start, end);
                        $$}
                        assert(0);
                    }
                $$}
            $$}
        }
        }));

    if (!needsJumps(graph, stateNr, node, actionTable))
        return;

    mixin(genCode("code", q{
        private void $(parseFunctionName(graph, stateNr, "pushTokenState"))(  _
        StackNode *stackNode, PendingReduce pendingReduce, Location tokenStart, Location tokenEnd, bool alreadyShifted$(grammar.tags.vals.length ? ", Tag tags" : ""))
        {
            size_t newState;
            bool setStackTops = true;
            switch (pendingReduce.nonterminalID)
            {
                $$foreach (nonterminalID; actionTable.jumps.sortedKeys) {
                    $$auto jumps2 = actionTable.jumps[nonterminalID];
                    case $(grammar.nonterminalIDCode(nonterminalID)):
                        $$if (nonterminalID in usedNegLookahead) {
                            stackNode.$(parseFunctionName(graph, stateNr, "stateData")).disallow$(symbolNameCode(grammar, nonterminalID)) = true;
                        $$}
                        $$CommaGen elseCode = CommaGen("else ");
                        $$bool hasDisallowCheck;
                        $$foreach (checkDisallowedSymbols; jumps2.sortedKeys) {
                            $$auto newState = jumps2[checkDisallowedSymbols];
                            $$if (checkDisallowedSymbols.length == 0) {
                                $$if (newState == size_t.max) {
                                    $$assert(false);
                                $$} else {
                                    $$auto nextNode = graph.states[newState];
                                    $$if (isSingleReduceState(graph, newState)) {
                                        newState = $(newState);
                                        setStackTops = !alreadyShifted;
                                    $$} else {
                                        newState = $(newState);
                                    $$}
                                    $$if (isSingleReduceState(graph, newState)) {
                                        setStackTops = false;
                                    $$}
                                $$}
                            $$} else {
                                $$CommaGen and = CommaGen(" && ");
                                $$hasDisallowCheck = true;
                                $(elseCode())if (  _
                                $$foreach (x; checkDisallowedSymbols) {
                                    $(and())stackNode.$(parseFunctionName(graph, stateNr, "stateData")).disallow$(symbolNameCode(grammar, x[0])) == $(x[1])  _
                                $$}
                                )
                                {
                                    $$if (newState == size_t.max) {
                                        $$assert(false);
                                    $$} else {
                                        $$auto nextNode = graph.states[newState];
                                        $$if (isSingleReduceState(graph, newState)) {
                                            newState = $(newState);
                                            setStackTops = !alreadyShifted;
                                        $$} else {
                                            newState = $(newState);
                                        $$}
                                        $$if (isSingleReduceState(graph, newState)) {
                                            setStackTops = false;
                                        $$}
                                    $$}
                                }
                            $$}
                        $$}
                        $$if (hasDisallowCheck) {
                            else assert(false);
                        $$}
                    break;
                $$}
                default:
                    assert(0, text("no jump ", pendingReduce.nonterminalID));
            }
            StackNode* stackNodeNew = shift(stackNode, newState, pendingReduce, alreadyShifted, setStackTops$(grammar.tags.vals.length ? ", tags" : ""));
        }
        }));
}

void createReduceFunction(ref CodeWriter code, LRGraph graph, const Production* production)
{
    auto grammar = graph.grammar;
    const RewriteRule[] rewriteRules = grammar.getRewriteRules(production);
    assert(rewriteRules.length > 0);

    string[] rewriteParameters;
    foreach (k; 0 .. production.symbols.length)
    {
        if (!production.symbols[k].dropNode)
            rewriteParameters ~= text("stack", k);
        else
            rewriteParameters ~= "undefinedIdentifier/*error*/";
    }

    size_t[] prevStateSet(const size_t[] states)
    {
        size_t[] r;
        foreach (s; states)
            foreach (edge; graph.states[s].reverseEdges)
                r.addOnce(edge.next);
        r.sort();
        return r;
    }

    mixin(genCode("code", q{
        private static StackEdgeData* $(reduceFunctionName(graph, production, "reduceImpl"))(ref PushParser this_,   _
        StackEdge*[] parameterEdges, Location lastTokenEnd)
        {
            assert(parameterEdges.length == $(production.symbols.length));
            StackEdgeData*[] parameterEdgesData;
            parameterEdgesData.length = $(production.symbols.length);
            $$foreach (k; 0 .. production.symbols.length) {
                parameterEdgesData[$(k)] = parameterEdges[$(k)].data;
            $$}
            StackEdgeData* r = new StackEdgeData(false);
            $$foreach (k; 1 .. production.symbols.length + 1) {
                StackEdgeData *stackEdge$(k) = parameterEdges[$ - $(k)].data; // $(grammar.symbolInstanceToString(production.symbols[$ - k]))
            $$}
            $$foreach (k; 1 .. production.symbols.length + 2) {
                $$if (k <= production.symbols.length) {
                    $$if (production.symbols[$ - k].isToken) {
                        assert(stackEdge$(k).isToken);
                    $$} else if (graph.globalOptions.directUnwrap) {
                        assert(!stackEdge$(k).isToken && stackEdge$(k).nonterminal.nonterminalID.among(  _
                        $$foreach (n; grammar.directUnwrapClosure(production.symbols[$ - k])) {
                            $(grammar.nonterminalIDCode(n.nonterminalID)),   _
                        $$}
                        ), text(stackEdge$(k).isToken, "  ", stackEdge$(k).nonterminal.nonterminalID, "  ", cast(void*) stackEdge$(k)));
                    $$} else {
                        assert(!stackEdge$(k).isToken && stackEdge$(k).nonterminal.nonterminalID == $(grammar.nonterminalIDCode(production.symbols[$ - k].toNonterminalID)));
                    $$}
                    assert(stackEdge$(k).start.bytePos != size_t.max);
                $$}
            $$}
            $$if (grammar.isSimpleProduction(*production) && !grammar.nonterminals[production.nonterminalID].annotations.contains!"array"()) {
                $$size_t nrNotDropped=size_t.max;
                $$foreach (k, s; production.symbols) {
                    $$if (!s.dropNode) {
                        $$nrNotDropped = k;
                    $$}
                $$}
                NonterminalType!($(grammar.nonterminalIDCode(nonterminalOutForProduction(production)))) pt;
                $$if (nrNotDropped != size_t.max) {
                    $$if (production.symbols[nrNotDropped].isToken) {
                        pt = stackEdge$(production.symbols.length - nrNotDropped).token;
                    $$} else if (graph.globalOptions.directUnwrap) {
                        pt = stackEdge$(production.symbols.length - nrNotDropped).nonterminal.get!(  _
                        $$foreach (n; grammar.directUnwrapClosure(production.symbols[nrNotDropped])) {
                            $(grammar.nonterminalIDCode(n.nonterminalID)),   _
                        $$}
                        );
                    $$} else {
                        pt = stackEdge$(production.symbols.length - nrNotDropped).nonterminal.get!$(grammar.nonterminalIDCode(production.symbols[nrNotDropped].toNonterminalID));
                    $$}
                    Location newTreeStart = stackEdge$(production.symbols.length - nrNotDropped).start;
                $$} else {
                    pt = typeof(pt).init;
                    Location newTreeStart = Location.invalid;
                $$}

                r.nonterminal = Creator.NonterminalUnionAny.create($(grammar.nonterminalIDCode(nonterminalOutForProduction(production))), pt);
                r.start = newTreeStart;
            $$} else {
                $$if (production.symbols.length > 0) {
                    Location newTreeStart = stackEdge$(production.symbols.length).start;
                    $$for (size_t i=production.symbols.length - 1; i > 0; i--) {
                        if (!newTreeStart.isValid)
                            newTreeStart = stackEdge$(i).start;
                    $$}
                $$} else {
                    Location newTreeStart = Location.invalid;
                $$}
                $$string stackStartExpr = "newTreeStart";
                Location reduceEnd = lastTokenEnd;
                if (reduceEnd < newTreeStart)
                    reduceEnd = newTreeStart;
                $$foreach (k; 0 .. production.symbols.length) {
                    $$if (production.symbols[k].isToken) {
                        ParseStackElem!(Location, Token) stack$(k)
                            = ParseStackElem!(Location, Token)  _
                            (stackEdge$(production.symbols.length - k).start, stackEdge$(production.symbols.length - k).token);
                    $$} else if (graph.globalOptions.directUnwrap) {
                        ParseStackElem!(Location, NonterminalType!$(grammar.nonterminalIDCode(production.symbols[k].toNonterminalID))) stack$(k)
                            = ParseStackElem!(Location, NonterminalType!$(grammar.nonterminalIDCode(production.symbols[k].toNonterminalID)))  _
                            (stackEdge$(production.symbols.length - k).start, stackEdge$(production.symbols.length - k).nonterminal.get!(  _
                            $$foreach (n; grammar.directUnwrapClosure(production.symbols[k])) {
                                $(grammar.nonterminalIDCode(n.nonterminalID)),   _
                            $$}
                            ));
                    $$} else {
                        ParseStackElem!(Location, NonterminalType!$(grammar.nonterminalIDCode(production.symbols[k].toNonterminalID))) stack$(k)
                            = ParseStackElem!(Location, NonterminalType!$(grammar.nonterminalIDCode(production.symbols[k].toNonterminalID)))  _
                            (stackEdge$(production.symbols.length - k).start, stackEdge$(production.symbols.length - k).nonterminal.get!$(grammar.nonterminalIDCode(production.symbols[k].toNonterminalID)));
                    $$}
                $$}

                NonterminalType!($(grammar.nonterminalIDCode(nonterminalOutForProduction(rewriteRules[$ - 1].applyProduction)))) pt  _
                = this_.creator.createParseTree!($(rewriteRules[$ - 1].applyProduction.productionID + grammar.startProductionID))  _
                (newTreeStart, reduceEnd  _
                $$size_t iParam;
                $$foreach (k; 0 .. rewriteRules[$ - 1].applyProduction.symbols.length) {
                    $$if (!rewriteRules[$ - 1].applyProduction.symbols[k].dropNode) {
                        $$if (rewriteRules[$ - 1].parameters[iParam] == size_t.max) {
                            , ParseStackElem!(Location, NonterminalType!$(rewriteRules[$ - 1].applyProduction.symbols[k].id + grammar.startNonterminalID))(Location.invalid, NonterminalType!$(rewriteRules[$ - 1].applyProduction.symbols[k].id + grammar.startNonterminalID).init/*null*/)  _
                            $$iParam++;
                        $$} else {
                            , $(rewriteParameters[rewriteRules[$ - 1].parameters[iParam]])  _
                            $$stackStartExpr = text("Location.init/*stackEdge", production.symbols.length - k, ".end*/");
                            $$iParam++;
                        $$}
                    $$} else {
                    $$}
                $$}
                );

                r.nonterminal = Creator.NonterminalUnionAny.create($(grammar.nonterminalIDCode(nonterminalOutForProduction(rewriteRules[$ - 1].applyProduction))), pt);
                r.start = newTreeStart;
            $$}
            return r;
        }
        $$if (tuple!(size_t, size_t)(production.productionID, production.symbols.length) in graph.statesWithProduction) {
            private   _
            void   _
            $(reduceFunctionName(graph, production))(  _
            StackNode *stackNode, Location tokenStart, Location tokenEnd, Location lastTokenEnd, bool alreadyShifted  _
            )
            {
                ParseException[] exceptions;
                bool anyGood;
                // $(grammar.productionString(production))   $(production.tags)
                $$string currentStackNode = "stackNode";
                $$const(size_t)[] possibleStates;
                $$possibleStates = graph.statesWithProduction[tuple!(size_t, size_t)(production.productionID, production.symbols.length)];
                $$foreach (k; 1 .. production.symbols.length + 1) {
                    assert($(currentStackNode).previous.length > 0);
                    assert($(currentStackNode).state.among(  _
                    $$foreach (prevState; possibleStates) {
                        $(prevState),   _
                    $$}
                    ), text("state = ", $(currentStackNode).state));
                    foreach (StackEdge* stackEdge$(k); $(currentStackNode).previous) // $(grammar.symbolInstanceToString(production.symbols[$ - k]))
                    {
                    $$code.incIndent;
                    $$foreach (t; production.symbols[$ - k].tags) {
                    $$}
                    $$currentStackNode = text("stackEdge", k, ".node");
                    $$possibleStates = prevStateSet(possibleStates);
                $$}
                $$if (grammar.tags.vals.length) {
                    Tag tags = $(reduceTagsCode!((k) => text("stackEdge", k, ".tags"))(grammar, production));
                    $$if (checkTagsCode!((k) => text("stackEdge", k, ".tags"))(code, grammar, production)) {
                            continue;
                    $$}
                $$}
                try
                {
                    StackEdge*[] parameterEdges = tmpData.stackEdgePointerAllocator.allocate(null, $(production.symbols.length));
                    $$foreach (k; iota(production.symbols.length, 0, -1)) {
                        parameterEdges[$(production.symbols.length - k)] = stackEdge$(k);
                    $$}
                    pushToken(  _
                    $$if (production.symbols.length == 0) {
                        stackNode,   _
                    $$} else {
                        stackEdge$(production.symbols.length).node,   _
                    $$}
                    PendingReduce($(grammar.nonterminalIDCode(nonterminalOutForProduction(rewriteRules[$ - 1].applyProduction))),   _
                    parameterEdges, $(production.productionID), &$(reduceFunctionName(graph, production, "reduceImpl"))), tokenStart, tokenEnd, alreadyShifted$(grammar.tags.vals.length ? ", tags" : ""));
                    anyGood = true;
                }
                catch(ParseException e)
                {
                    exceptions ~= e;
                }
                $$foreach (k; 1 .. production.symbols.length + 1) {
                    $$code.decIndent;
                    }
                $$}
                if (!anyGood)
                {
                    if (exceptions.length == 1)
                        throw exceptions[0];
                    else if (exceptions.length == 0)
                        throw new SingleParseException!Location("no reduce", tokenStart, tokenEnd);
                    else
                        throw new MultiParseException("", exceptions);
                }
            }
        $$}
        }));
}

void createStartParseFunction(ref CodeWriter code, LRGraph graph, size_t stateNr,
        const LRGraphNode node)
{
    auto grammar = graph.grammar;
    immutable endTok = grammar.tokens.getID("$end");

    assert(node.stackSymbols.length == 0);

    mixin(genCode("code", q{
        /*private*/   _
        void   _
        $(parseFunctionName(graph, stateNr, "startParse"))(  _
        )
        {
            lastTokenEnd = Location.init;
            stackTops = [new StackNode($(stateNr))];
            acceptedStackTops = [];
            clearTmpData();
            pushToken(getTokenID!"$flushreduces", Token.init, lastTokenEnd, lastTokenEnd);
        }
        }));
}

void createWrapperParseFunction(ref CodeWriter code, LRGraph graph, size_t stateNr,
        const LRGraphNode node)
{
    auto grammar = graph.grammar;

    assert(node.stackSymbols.length == 0);

    mixin(genCode("code", q{
        /*private*/   _
        ParseStackElem!(Location, NonterminalType!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID)))[]   _
        $(parseFunctionName(graph, stateNr, "multiParse"))(  _
        )
        {
            scope(failure)
            {
                stackTops = [];
                acceptedStackTops = [];
            }

            alias ThisParseResult = typeof(return);
            pushParser.$(parseFunctionName(graph, stateNr, "startParse"))();
            while (!lexer.empty)
            {
                pushParser.pushToken(translateTokenIdFromLexer!Lexer(lexer.front.symbol), lexer.front.content, lexer.front.currentLocation, lexer.front.currentTokenEnd);
                if (acceptedStackTops.length)
                {
                    if (stackTops.length == 0)
                        break;
                    else
                        acceptedStackTops = [];
                }
                lexer.popFront();
            }
            if (acceptedStackTops.length == 0)
            {
                pushParser.pushEnd();
            }
            assert(stackTops.length == 0);
            ParseStackElem!(Location, NonterminalType!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID)))[] r;
            assert(acceptedStackTops.length >= 1);
            foreach (t; acceptedStackTops)
            {
                foreach (prev; t.previous)
                {
                    assert(prev.node.previous.length == 0);
                    NonterminalType!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID)) pt;
                    switch (prev.data.nonterminal.nonterminalID)
                    {
                        $$foreach (n; grammar.directUnwrapClosure(node.elements[0].production.symbols[0].toNonterminalID, [], [])) {
                            case $(grammar.nonterminalIDCode(n.nonterminalID)):
                                pt = prev.data.nonterminal.get!($(grammar.nonterminalIDCode(n.nonterminalID)));
                                break;
                        $$}
                        default:
                            assert(false);
                    }
                    r ~= ParseStackElem!(Location, NonterminalType!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID))))(prev.data.start, pt);
                }
            }
            stackTops = [];
            acceptedStackTops = [];
            return r;
        }

        /*private*/   _
        ParseStackElem!(Location, NonterminalType!($(node.elements[0].production.symbols[0].id + grammar.startNonterminalID)))   _
        $(parseFunctionName(graph, stateNr))(  _
        )
        do
        {
            auto r = $(parseFunctionName(graph, stateNr, "multiParse"))();

            if (r.length == 0)
            {
                return ParseStackElem!(Location, NonterminalType!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID)))).init;
            }

            static if (pushParser.canMerge!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID))))
            if (r.length != 1)
            {
                NonterminalType!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID))) pt = creator.mergeParseTrees!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID)))(Location.init, lastTokenEnd, r);
                return ParseStackElem!(Location, NonterminalType!($(grammar.nonterminalIDCode(node.elements[0].production.symbols[0].toNonterminalID))))(Location.init, pt);
            }

            assert(r.length == 1, "Root node $(grammar.getSymbolName(node.elements[0].production.symbols[0])) is not mergeable.");
            return r[0];
        }
        }));
}

void createShiftFunctions(ref CodeWriter code, LRGraph graph)
{
    EBNFGrammar grammar = graph.grammar;

    mixin(genCode("code", q{
        StackNode *shift(bool onStack)(StackNode *stackNode, Location start, size_t state, Token token)
        {
            StackNode* n = null;
            n = tmpData.stackNodeByState[state];
            if (n is null)
            {
                n = new StackNode(state);
                tmpData.stackNodeByState[state] = n;
                static if (onStack)
                    stackTops ~= n;
            }
            foreach (ref edge; n.previous)
            {
                if (edge.node is stackNode)
                {
                    assert(edge.data.isToken);
                    assert(edge.data.token == token);
                    return n;
                }
            }
            StackEdgeData* data = new StackEdgeData(true, start);
            data.token = token;
            n.previous ~= new StackEdge(stackNode, data);
            return n;
        }

        StackNode* shift(StackNode *stackNode, size_t state, PendingReduce pendingReduce, bool alreadyShifted, bool setStackTops$(grammar.tags.vals.length?", Tag tags":""))
        {
            assert(pendingReduce.next is null);

            bool allowEdgeReduce = true;

            switch (pendingReduce.nonterminalID)
            {
                static foreach (nonterminalID; startNonterminalID .. endNonterminalID)
                    static if (!canMerge!nonterminalID)
                    {
                        case nonterminalID:
                    }
                allowEdgeReduce = false;
                break;
                default:
            }

            size_t stateHash = (state + stackNode.state * 31) % tmpData.pendingReduceIds.length;

            size_t count;
            for (size_t k = tmpData.pendingReduceIds[stateHash]; k != size_t.max; k = tmpData.pendingReduces.data[k].nextPendingReduce2)
            {
                auto pendingReduce2 = &tmpData.pendingReduces.data[k];
                count++;
                if (pendingReduce2.stackNode.state == state && pendingReduce2.stackEdge.node is stackNode && pendingReduce2.alreadyShifted == alreadyShifted)
                {
                    for (PendingReduce *pendingReduce2x = pendingReduce2.pendingReduces; pendingReduce2x !is null; pendingReduce2x = pendingReduce2x.next)
                    {
                        if (pendingReduce2x.nonterminalID == pendingReduce.nonterminalID
                            && pendingReduce2x.productionID is pendingReduce.productionID
                            && pendingReduce2x.parameterEdges.length == pendingReduce.parameterEdges.length)
                        {
                            bool eq = true;
                            foreach (i, p; pendingReduce2x.parameterEdges)
                                if (p !is pendingReduce.parameterEdges[i])
                                    eq = false;
                            if (eq)
                            {
                                return pendingReduce2.stackNode;
                            }
                        }
                    }
                }
            }

            PendingReduce *pendingReducePtr = tmpData.pendingReduceAllocator.allocate(pendingReduce, 1).ptr;

            if (allowEdgeReduce)
            {
                for (size_t k = tmpData.pendingReduceIds[stateHash]; k != size_t.max; k = tmpData.pendingReduces.data[k].nextPendingReduce2)
                {
                    auto pendingReduce2 = &tmpData.pendingReduces.data[k];
                    if (pendingReduce2.stackNode.state == state
                        $$if (grammar.tags.vals.length) {
                            && pendingReduce2.stackEdge.tags == tags
                        $$}
                        && pendingReduce2.stackEdge.node is stackNode
                        && pendingReduce2.alreadyShifted == alreadyShifted)
                    {
                        pendingReducePtr.next = pendingReduce2.pendingReduces;
                        pendingReduce2.pendingReduces = pendingReducePtr;
                        hasAddedPendingReduce = true;
                        return pendingReduce2.stackNode;
                    }
                }
            }

            if (tmpData.stackNodeByState[state + (!alreadyShifted) * $(graph.states.length)] !is null)
            {
                StackNode* n = tmpData.stackNodeByState[state + (!alreadyShifted) * $(graph.states.length)];
                n.previous ~= new StackEdge(stackNode);
                $$if (grammar.tags.vals.length) {
                    n.previous[$ - 1].tags = tags;
                $$}
                tmpData.pendingReduces.put(PendingReduce2(n, n.previous[$ - 1], alreadyShifted, pendingReducePtr, tmpData.pendingReduceIds[stateHash]));
                tmpData.pendingReduceIds[stateHash] = tmpData.pendingReduces.data.length - 1;
                hasAddedPendingReduce = true;
                return n;
            }

            StackNode* n = new StackNode(state);
            n.previous ~= new StackEdge(stackNode, null);
            $$if (grammar.tags.vals.length) {
                n.previous[$ - 1].tags = tags;
            $$}
            tmpData.stackNodeByState[state + (!alreadyShifted) * $(graph.states.length)] = n;

            hasAddedPendingReduce = true;
            tmpData.pendingReduces.put(PendingReduce2(n, n.previous[$ - 1], alreadyShifted, pendingReducePtr, tmpData.pendingReduceIds[stateHash]));
            tmpData.pendingReduceIds[stateHash] = tmpData.pendingReduces.data.length - 1;

            if (alreadyShifted && setStackTops)
                stackTops ~= n;

            return n;
        }
    }));
}

void createParseFunctions(ref CodeWriter code, LRGraph graph)
{
    EBNFGrammar grammar = graph.grammar;

    mixin(genCode("code", q{
        private void pushToken(StackNode *stackNode, size_t tokenId, Token tokenContent, Location start, Location end)
        {
            switch (stackNode.state)
            {
                $$foreach (i, n; graph.states) {
                    $$if (!n.hasSetStackSymbols || graph.globalOptions.directUnwrap) {
                        case $(i): $(parseFunctionName(graph, i, "pushTokenState"))  _
                        (stackNode, tokenId, tokenContent, start, end); break;
                    $$}
                $$}
                default: assert(false, text("state=", stackNode.state));
            }
        }
        void pushToken(size_t tokenId, Token tokenContent, Location start, Location end)
        in
        {
            assert(start.isValid);
            assert(end.isValid);
            assert(lastTokenEnd.isValid);
        }
        do
        {
            if (stackTops.length == 0)
            {
                if (acceptedStackTops.length == 0)
                    throw new SingleParseException!Location("no more stackTops",
                                start, end);
                else
                    throw new SingleParseException!Location("no more stackTops (but acceptedStackTops)",
                                start, end);
            }
            StackNode*[] savedStackTops = stackTops;
            assert(savedStackTops);
            stackTops = [];
            acceptedStackTops = [];
            ParseException[] exceptions;
            assert(tmpData.pendingReduces.data.length == 0);

            assert(!tmpData.inUse);
            tmpData.inUse = true;

            scope(exit)
            {
                clearTmpData();
                tmpData.inUse = false;
            }

            if (tokenId == getTokenID!"$flushreduces")
            {
                foreach (stackNode; savedStackTops)
                {
                    switch (stackNode.state)
                    {
                        $$foreach (i, n; graph.states) {
                            $$if (!isSingleReduceState(graph, i)) {
                                case $(i): stackTops ~= stackNode; break;
                            $$}
                        $$}
                        default: break;
                    }
                }
                foreach (stackNode; savedStackTops)
                {
                    switch (stackNode.state)
                    {
                        $$foreach (i, n; graph.states) {
                            $$if (isSingleReduceState(graph, i)) {
                                case $(i):
                                    $$foreach (e; n.elements) {
                                        $$if (e.isFinished(grammar) && !e.isStartElement) {
                                            $$if (e.production.symbols.length && e.production.symbols[$ - 1].isToken) {
                                                // Nothing to do for token
                                            $$} else {
                                                $(reduceFunctionName(graph, e.production))(stackNode, start, end, end, true);
                                            $$}
                                        $$}
                                    $$}
                                    break;
                            $$}
                        $$}
                        default: break;
                    }
                }
            }
            else
            {
                foreach (stackNode; savedStackTops)
                {
                    try
                    {
                        pushToken(stackNode, tokenId, tokenContent, start, end);
                    }
                    catch(ParseException e)
                    {
                        exceptions ~= e;
                    }
                }
            }

            do
            {
                hasAddedPendingReduce = false;
                for (size_t i=0; i < tmpData.pendingReduces.data.length; i++)
                {
                    if (tmpData.pendingReduces.data[i].alreadyShifted)
                    {
                        try
                        {
                            switch (tmpData.pendingReduces.data[i].stackNode.state)
                            {
                                $$foreach (i, n; graph.states) {
                                    $$if (isSingleReduceState(graph, i)) {
                                        case $(i):
                                            $$foreach (e; n.elements) {
                                                $$if (e.isFinished(grammar) && !e.isStartElement) {
                                                    $$if (e.production.symbols.length && e.production.symbols[$ - 1].isToken) {
                                                        // Nothing to do for token
                                                    $$} else {
                                                        $(reduceFunctionName(graph, e.production))(tmpData.pendingReduces.data[i].stackNode, start, end, end, true);
                                                    $$}
                                                $$}
                                            $$}
                                            break;
                                    $$}
                                $$}
                                default: break;
                            }
                        }
                        catch(ParseException e)
                        {
                            exceptions ~= e;
                        }

                        continue;
                    }

                    try
                    {
                        pushToken(tmpData.pendingReduces.data[i].stackNode, tokenId, tokenContent, start, end);
                    }
                    catch(ParseException e)
                    {
                        exceptions ~= e;
                    }
                }
            } while (hasAddedPendingReduce);

            foreach (ref pendingReduce; tmpData.pendingReduces.data)
            {
                onPendingReduce(pendingReduce, end);
            }

            lastTokenEnd = end;
            if (stackTops.length == 0 && acceptedStackTops.length == 0)
            {
                if (exceptions.length > 0)
                    if (exceptions.length == 1)
                        throw exceptions[0];
                    else
                        throw new MultiParseException("", exceptions);
                else
                    throw new SingleParseException!Location(text("no stackTops ", tmpData.pendingReduces.data.length),
                                start, end);
            }
        }
    }));

    mixin(genCode("code", q{
        void onPendingReduce(ref PendingReduce2 pendingReduce, Location end)
        {
            assert(pendingReduce.stackEdge.data is null || !pendingReduce.stackEdge.data.isToken);
            if (pendingReduce.stackEdge.reduceDone)
                return;
            pendingReduce.stackEdge.reduceDone = true;
            for (PendingReduce *pendingReducex = pendingReduce.pendingReduces; pendingReducex !is null; pendingReducex = pendingReducex.next)
                foreach (edge; pendingReducex.parameterEdges)
                    foreach (ref pendingReduce2x; tmpData.pendingReduces.data)
                        if (pendingReduce2x.stackEdge is edge)
                            onPendingReduce(pendingReduce2x, end);
            Location reduceEnd = pendingReduce.alreadyShifted ? end : lastTokenEnd;
            size_t num;
            for (PendingReduce *pendingReducePtr = pendingReduce.pendingReduces; pendingReducePtr !is null; pendingReducePtr = pendingReducePtr.next)
                num++;
            if (num == 1)
            {
                pendingReduce.stackEdge.data = pendingReduce.pendingReduces[0].dg(this, pendingReduce.pendingReduces.parameterEdges, reduceEnd);
                assert(pendingReduce.stackEdge.data.nonterminal.nonterminalID == pendingReduce.pendingReduces.nonterminalID);
            }
            else
            {
                static Appender!(PendingReduce*[]) appPendingReduce;
                scope(exit)
                    appPendingReduce.clear;
                for (PendingReduce *pendingReducePtr = pendingReduce.pendingReduces; pendingReducePtr !is null; pendingReducePtr = pendingReducePtr.next)
                    appPendingReduce.put(pendingReducePtr);
                PendingReduce*[] pendingReducesHere = appPendingReduce.data;
                foreach (i; 0 .. pendingReducesHere.length/2)
                {
                    auto tmp = pendingReducesHere[i];
                    pendingReducesHere[i] = pendingReducesHere[$ - 1-i];
                    pendingReducesHere[$ - 1-i] = tmp;
                }
                pendingReducesHere.sort!((a, b) => a.productionID < b.productionID);

                Creator.NonterminalUnionAny[] nonterminals;
                Location[] nonterminalStarts;
                nonterminals.length = pendingReducesHere.length;
                nonterminalStarts.length = pendingReducesHere.length;
                foreach (i; 0 .. pendingReducesHere.length)
                {
                    StackEdgeData* data = pendingReducesHere[i].dg(this, pendingReducesHere[i].parameterEdges, reduceEnd);
                    nonterminals[i] = data.nonterminal;
                    nonterminalStarts[i] = data.start;
                    assert(nonterminals[i].nonterminalID == pendingReducesHere[i].nonterminalID);
                }
                Location nonterminalStart = nonterminalStarts[0];
                foreach (i; 1 .. pendingReducesHere.length)
                    if (nonterminalStarts[i] < nonterminalStart)
                        nonterminalStart = nonterminalStarts[i];

                $$if (graph.globalOptions.directUnwrap) {
                    switch (pendingReduce.stackNode.state)
                    {
                        $$foreach (i, n; graph.states) {
                            $$if (n.stackSize() >= 0) {
                                $$NonterminalID[] possible = n.directUnwrapNonterminalsOnStack(graph.grammar, 1);
                                $$if (possible.length) {
                                    static if (canMerge!($(grammar.nonterminalIDCode(possible[0]))))
                                    {
                                        case $(i):
                                        {
                                            onPendingReduce$(i)(pendingReduce, end, nonterminals, nonterminalStarts, nonterminalStart);
                                        }
                                        break;
                                    }
                                $$}
                            $$}
                        $$}
                        default: assert(false);
                    }

                $$} else {
                    switchlabel: switch (pendingReducesHere[0].nonterminalID)
                    {
                        static foreach (nonterminalID; startNonterminalID .. endNonterminalID)
                        {
                            static if (canMerge!nonterminalID)
                            {
                                case nonterminalID:
                                {
                                    ParseStackElem!(Location, NonterminalType!nonterminalID)[] pts;
                                    pts.length = nonterminals.length;
                                    foreach (i; 0 .. nonterminals.length)
                                        $$if (graph.globalOptions.directUnwrap) {
                                            pts[i] = ParseStackElem!(Location, NonterminalType!nonterminalID)(nonterminalStarts[i], nonterminals[i].get!(arrayToAliasSeq!(NonterminalClosures[nonterminalID])));
                                        $$} else {
                                            pts[i] = ParseStackElem!(Location, NonterminalType!nonterminalID)(nonterminalStarts[i], nonterminals[i].get!nonterminalID);
                                        $$}
                                    NonterminalType!nonterminalID pt = creator.mergeParseTrees!nonterminalID(nonterminalStart, pendingReduce.alreadyShifted?end:lastTokenEnd, pts);
                                    pendingReduce.stackEdge.data = new StackEdgeData(false);
                                    pendingReduce.stackEdge.data.start = nonterminalStart;
                                    pendingReduce.stackEdge.data.nonterminal =
                                        Creator.NonterminalUnionAny.create(nonterminalID, pt);
                                }
                                break switchlabel;
                            }
                        }
                        default:
                            assert(0);
                    }
                $$}
            }
        }

        $$if (graph.globalOptions.directUnwrap) {
            $$foreach (i, n; graph.states) {
                $$if (n.stackSize() >= 0) {
                    $$NonterminalID[] possible = n.directUnwrapNonterminalsOnStack(graph.grammar, 1);
                    $$if (possible.length) {
                        void onPendingReduce$(i)(ref PendingReduce2 pendingReduce, Location end, Creator.NonterminalUnionAny[] nonterminals, Location[] nonterminalStarts, Location nonterminalStart)
                        {
                            static if (canMerge!($(grammar.nonterminalIDCode(possible[0]))))
                            {
                                ParseStackElem!(Location, NonterminalType!$(grammar.nonterminalIDCode(possible[0])))[] pts;
                                pts.length = nonterminals.length;
                                foreach (i; 0 .. nonterminals.length)
                                {
                                    bool found;
                                    static foreach (nonterminalID; [  _
                                        $$foreach (nonterminal; possible) {
                                            $(grammar.nonterminalIDCode(nonterminal)),   _
                                        $$}
                                    ])
                                    {
                                        if (nonterminals[i].nonterminalID == nonterminalID)
                                        {
                                            pts[i] = ParseStackElem!(Location, NonterminalType!nonterminalID)(nonterminalStarts[i], nonterminals[i].get!(nonterminalID));
                                            found = true;
                                        }
                                    }
                                    assert(found);
                                }
                                NonterminalType!$(grammar.nonterminalIDCode(possible[0])) pt = creator.mergeParseTrees!$(grammar.nonterminalIDCode(possible[0]))(nonterminalStart, pendingReduce.alreadyShifted?end:lastTokenEnd, pts);
                                pendingReduce.stackEdge.data = new StackEdgeData(false);
                                pendingReduce.stackEdge.data.start = nonterminalStart;
                                pendingReduce.stackEdge.data.nonterminal =
                                    Creator.NonterminalUnionAny.create($(grammar.nonterminalIDCode(possible[0])), pt);
                            }
                        }
                    $$}
                $$}
            $$}
        $$}

        void pushToken(StackNode *stackNode, PendingReduce pendingReduce, Location tokenStart, Location tokenEnd, bool alreadyShifted$(grammar.tags.vals.length?", Tag tags":""))
        in
        {
            assert(lastTokenEnd.isValid);
        }
        do
        {
            switch (stackNode.state)
            {
                $$foreach (i, n; graph.states) {
                    $$if (!trivialState(n) && needsJumps(graph, i, n, genActionTable(graph, n))) {
                        $$if (!n.hasSetStackSymbols || graph.globalOptions.directUnwrap) {
                            case $(i): $(parseFunctionName(graph, i, "pushTokenState"))  _
                            (stackNode, pendingReduce, tokenStart, tokenEnd, alreadyShifted$(grammar.tags.vals.length?", tags":"")); break;
                        $$}
                    $$}
                $$}
                default: assert(false);
            }
        }

        void pushEnd()
        in
        {
            assert(lastTokenEnd.bytePos != size_t.max);
        }
        do
        {
            pushToken(getTokenID!"$end", Token.init, lastTokenEnd, lastTokenEnd);
        }
    }));
}

const(char)[] createParserModule(LRGraph graph, string modulename)
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

    bool needsDelayedParseTreeConstructor;
    foreach (node; graph.states)
    {
        if (node.hasSetStackSymbols && graph.globalOptions.delayedReduce)
            needsDelayedParseTreeConstructor = true;
    }

    mixin(genCode("code", q{
        // Generated with DParserGen.
        module $(modulename);
        import dparsergen.core.grammarinfo;
        import dparsergen.core.parseexception;
        import dparsergen.core.parsestackelem;
        import dparsergen.core.utils;
        import std.algorithm;
        import std.array;
        import std.conv;
        import std.meta;
        import std.stdio;

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

        size_t getTokenIDImpl(string tok)
        {
            auto r = allTokens.countUntil!(t=>t.name == tok);
            assert(r >= 0 && r < allTokens.length, "token not found " ~ tok);
            return r + startTokenID;
        }
        enum size_t getTokenID(string tok) = getTokenIDImpl(tok);
        string getTokenName(size_t id)
        {
            if (id == size_t.max)
                return text("???");
            if (id < startTokenID)
                return text("???:", id);
            if (id >= endTokenID)
                return text("???:", id);
            return allTokens[id - startTokenID].name;
        }
        string getNonterminalName(size_t id)
        {
            if (id == size_t.max)
                return text("???");
            if (id < startNonterminalID || id > endNonterminalID)
                return text("???:", id);
            return allNonterminals[id - startNonterminalID].name;
        }
        $$if (needsDelayedParseTreeConstructor) {
            class DelayedParseTreeConstructor(alias Creator)
            {
                alias Location = Creator.Location;
                alias LocationDiff = typeof(Location.init - Location.init);

                immutable size_t[] nonterminalIDs;
                LocationDiff inputLength;
                this(immutable size_t[] nonterminalIDs, LocationDiff inputLength)
                {
                    this.nonterminalIDs = nonterminalIDs;
                    this.inputLength = inputLength;
                }
            }
        $$}
        $$if (grammar.tags.vals.length) {
            enum Tag
            {
                none = 0,
                $$foreach (i, t; grammar.tags.vals) {
                    $(t.name) = 1 << $(i),
                $$}
            }
        $$}

        struct PushParser(alias Creator, Token)
        {
            alias Location = Creator.Location;
            Creator creator;

            alias LocationDiff = typeof(Location.init - Location.init);

            $$foreach (i, n; graph.states) {
                $$if (needsExtraStateData(graph, i, n)) {
                    $$createExtraStateData(code, graph, i, n);

                $$}
            $$}
            static struct StackNode
            {
                size_t state;
                StackEdge*[] previous;
                union
                {
                    $$foreach (i, n; graph.states) {
                        $$if (needsExtraStateData(graph, i, n)) {
                            $(parseFunctionName(graph, i, "StateData")) $(parseFunctionName(graph, i, "stateData"));
                        $$}
                    $$}
                }
            }
            static struct StackEdgeData
            {
                bool isToken;
                Location start;
                union
                {
                    Creator.NonterminalUnionAny nonterminal;
                    Token token;
                }
            }
            static struct StackEdge
            {
                StackNode *node;
                StackEdgeData *data;
                bool reduceDone;
                $$if (grammar.tags.vals.length) {
                    Tag tags;
                $$}
            }

            static struct PendingReduce
            {
                SymbolID nonterminalID;
                StackEdge*[] parameterEdges;
                ProductionID productionID;
                StackEdgeData* function(ref PushParser this_, StackEdge*[] parameterEdges, Location lastTokenEnd) dg;
                PendingReduce* next;
            }
            static struct PendingReduce2
            {
                StackNode* stackNode;
                StackEdge* stackEdge;
                bool alreadyShifted;
                PendingReduce* pendingReduces;
                size_t nextPendingReduce2;
            }

            static struct TmpData
            {
                bool inUse;
                StackNode*[$(graph.states.length * 2)] stackNodeByState;
                size_t[$(graph.states.length * 2)] pendingReduceIds;
                SimpleArrayAllocator!(PendingReduce, 4 * 1024 - 32) pendingReduceAllocator;
                SimpleArrayAllocator!(StackEdge*, 4 * 1024 - 32) stackEdgePointerAllocator;
                Appender!(PendingReduce2[]) pendingReduces;
            }
            TmpData tmpData;

            void clearTmpData()
            {
                tmpData.stackNodeByState[] = null;
                tmpData.pendingReduceIds[] = size_t.max;
                tmpData.pendingReduceAllocator.clearAll();
                tmpData.stackEdgePointerAllocator.clearAll();
                tmpData.pendingReduces.clear();
            }

            StackNode*[] stackTops;
            StackNode*[] acceptedStackTops;

            Location lastTokenEnd;
            bool hasAddedPendingReduce;

            $$createShiftFunctions(code, graph);

            void dumpStates(string indent="")
            {
                write(indent, "stackTops:");
                foreach (stackNode; stackTops)
                {
                    write(" ", stackNode.state);
                }
                writeln();
                write(indent, "acceptedStackTops:");
                foreach (stackNode; acceptedStackTops)
                {
                    write(" ", stackNode.state);
                }
                writeln();
            }

            alias NonterminalType(size_t nonterminalID) = Creator.NonterminalType!nonterminalID;
            enum canMerge(size_t nonterminalID) = Creator.canMerge!nonterminalID;

            $$foreach (production; graph.grammar.productions) {
                $$createReduceFunction(code, graph, production);

            $$}

            $$foreach (i, n; graph.states) {
                $$if (true || !trivialState(n)) {
                    $$createParseFunction(code, graph, i, n);

                $$}
            $$}

            $$foreach (i, n; graph.states) {
                $$if (n.isStartNode) {
                    $$createStartParseFunction(code, graph, i, n);

                $$}
            $$}

            $$createParseFunctions(code, graph);

            Creator.Type getParseTree(string startNonterminal = "$(graph.grammar.getSymbolName(graph.grammar.startNonterminals[0].nonterminal).escapeD)")()
            {
                assert(stackTops.length == 0, text(stackTops));
                assert(acceptedStackTops.length <= 1, text(acceptedStackTops));
                if (acceptedStackTops.length)
                {
                    assert(acceptedStackTops[0].previous.length == 1);
                    assert(acceptedStackTops[0].previous[0].node.previous.length == 0);
                    return acceptedStackTops[0].previous[0].data.nonterminal.get!(nonterminalIDFor!startNonterminal);
                }
                return Creator.Type.init;
            }
        }
    }));
    mixin(genCode("code", q{
        SymbolID translateTokenIdFromLexer(alias Lexer)(SymbolID t)
        {
            $$foreach (t2; grammar.tokens.allIDs) {
                if (t == Lexer.tokenID!$(tokenDCode(grammar.tokens[t2])))
                    return $(t2.id + grammar.startTokenID);
            $$}
            return SymbolID.max;
        }

        struct Parser(alias Creator, alias L)
        {
            alias Lexer = L;
            alias Location = typeof(Lexer.init.front.currentLocation);
            alias LocationDiff = typeof(Location.init - Location.init);

            Lexer *lexer;

            PushParser!(Creator, typeof(Lexer.init.front.content)) pushParser;

            alias pushParser this;

            template NonterminalType(size_t nonterminalID) if (nonterminalID >= startNonterminalID && nonterminalID < endNonterminalID)
            {
                alias NonterminalType = Creator.NonterminalType!nonterminalID;
            }

                this(Creator creator, Lexer *lexer)
                {
                    pushParser.creator = creator;
                    this.lexer = lexer;
                }

            $$foreach (i, n; graph.states) {
                $$if (n.isStartNode) {
                    $$createWrapperParseFunction(code, graph, i, n);
                $$}
            $$}
        }

        immutable allTokens = [
        $(allTokensCode)];

        immutable allNonterminals = [
        $(allNonterminalsCode)];

        immutable allProductions = [
        $(createAllProductionsCode(grammar))];

        $$if (graph.globalOptions.directUnwrap) {
            immutable nonterminalClosures = [
                $$foreach (i, n; grammar.nonterminals.vals) {
                    /*$(i) $(grammar.getSymbolName(NonterminalID(i.to!SymbolID)))*/ [  _
                    $$foreach (m2; grammar.directUnwrapClosure(NonterminalID(i.to!SymbolID), [], [])) {
                        $(grammar.nonterminalIDCode(m2.nonterminalID)),   _
                    $$}
                    ],
                $$}
            ];

        $$}
        immutable GrammarInfo grammarInfo = immutable(GrammarInfo)(
                startTokenID, startNonterminalID, startProductionID,
                allTokens, allNonterminals, allProductions);

        Creator.Type parse(Creator, alias Lexer, string startNonterminal = "$(graph.grammar.getSymbolName(graph.grammar.startNonterminals[0].nonterminal).escapeD)")(ref Lexer lexer, Creator creator)
        {
            alias Location = typeof(Lexer.init.front.currentLocation);
            auto parser = Parser!(Creator, Lexer)(
                    creator,
                    &lexer);
            auto parseResult = parser.$(parseFunctionName(graph, 0))();
            Creator.Type result = parseResult.val;
            creator.adjustStart(result, parseResult.start);
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
