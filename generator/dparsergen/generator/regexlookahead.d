
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.regexlookahead;
import dparsergen.core.utils;
import dparsergen.generator.codewriter;
import dparsergen.generator.grammar;
import dparsergen.generator.nfa;
import dparsergen.generator.parser;
import dparsergen.generator.parsercodegencommon;
import dparsergen.generator.production;
import std.algorithm;
import std.conv;
import std.exception;
import std.range;
import std.stdio;
import std.typecons;

NonterminalID normalizeNonterminalID(EBNFGrammar grammar, NonterminalID startNonterminal)
{
    NonterminalID origStartNonterminal = startNonterminal;
    while (true)
    {
        auto productions = grammar.getProductions(startNonterminal);
        if (productions.length != 1)
            break;
        if (productions[0].symbols.length != 1)
            break;
        if (productions[0].symbols[0].isToken)
            break;
        startNonterminal = productions[0].symbols[0].toNonterminalID;
        if (startNonterminal == origStartNonterminal)
            break;
    }

    return startNonterminal;
}

struct RegexLookaheadEdgeExtra
{
    immutable(SymbolInstance)[][] sequences;

    void opOpAssign(string op)(RegexLookaheadEdgeExtra rhs) if (op == "~")
    {
        sequences.addOnce(rhs.sequences);
    }
}

class RegexLookaheadGraph
{
    size_t id;
    bool isInnerGraph;
    Tuple!(immutable(SymbolInstance)[], size_t)[] sequences;
    Graph!(Symbol, size_t, RegexLookaheadEdgeExtra) dfa;
    bool frozen;
}

class RegexLookahead
{
    alias G = Graph!(Symbol, size_t, RegexLookaheadEdgeExtra);
    alias NodeID = G.NodeID;
    EBNFGrammar grammar;
    const bool[ProductionID] reduceConflictProductions;
    EBNFGrammar grammar2;
    bool useRegexlookahead;

    RegexLookaheadGraph[] graphs;
    RegexLookaheadGraph[immutable(SymbolInstance[])[]] innerGraphs;

    bool grammarFinished;

    immutable(SymbolInstance)[][TokenID] subGraphTokens;
    TokenID subGraphToken;

    TokenID[][TokenID] matchingTokensMap;
    bool[TokenID] matchingTokensAll;

    this(EBNFGrammar grammar, const bool[ProductionID] reduceConflictProductions,
            bool useRegexlookahead)
    {
        this.grammar = grammar;
        this.reduceConflictProductions = reduceConflictProductions;
        this.useRegexlookahead = useRegexlookahead;

        foreach (m; grammar.matchingTokens)
        {
            matchingTokensMap[m[0]] ~= m[1];
            matchingTokensAll[m[0]] = true;
            matchingTokensAll[m[1]] = true;
        }

        grammar2 = new EBNFGrammar(null);
        grammar2.nonterminals = grammar.nonterminals.dup;
        grammar2.tokens = grammar.tokens.dup;
        grammar2.productionsData = grammar.productionsData;
        grammar2.matchingTokens = grammar.matchingTokens.dup;

        subGraphToken = grammar2.tokens.id("$subGraph");
        grammar2.tokens.id("$anything");

        const(Production)*[] productionsData;
        productionsData.length = grammar.productionsData.length;
        foreach (i, p; grammar.productionsData)
        {
            if (p is null)
                continue;
            immutable(SymbolInstance)[] symbols = p.symbols;
            for (size_t j = 0; j < symbols.length; j++)
            {
                if (j && symbols[j - 1].isToken)
                {
                    size_t k = j;
                    while (k < symbols.length && !symbols[k].isToken)
                        k++;
                    if (k >= symbols.length)
                        break;
                    assert(symbols[k].isToken);

                    TokenID startToken = symbols[j - 1].toTokenID;
                    bool foundMatching;
                    for (; k < symbols.length; k++)
                    {
                        if (!symbols[k].isToken)
                            continue;
                        TokenID endToken = symbols[k].toTokenID;
                        foreach (matching; grammar.matchingTokens)
                        {
                            if (startToken == matching[0] && endToken == matching[1])
                                foundMatching = true;
                        }
                        if (foundMatching)
                            break;
                    }
                    if (!foundMatching)
                        continue;

                    string subSymbolsName = "$subSymbols(";
                    immutable(SymbolInstance)[] subSymbols;
                    foreach (s; symbols[j .. k])
                    {
                        if (!s.isToken)
                            subSymbols ~= SymbolInstance(normalizeNonterminalID(grammar,
                                    s.symbol.toNonterminalID));
                        else
                            subSymbols ~= SymbolInstance(s.symbol);
                        subSymbolsName ~= text(grammar.getSymbolName(s), ", ");
                    }
                    subSymbolsName ~= ")";

                    TokenID t = grammar2.tokens.id(subSymbolsName);
                    subGraphTokens[t] = subSymbols;
                    symbols = symbols[0 .. j] ~ SymbolInstance(t) ~ symbols[k .. $];
                }
            }

            if (symbols is p.symbols)
                productionsData[i] = p;
            else
            {
                auto p2 = new Production(p.nonterminalID, symbols);
                p2.productionID = cast(ProductionID) i;
                productionsData[i] = p2;
            }
        }
        grammar2.productionsData = productionsData;

        matchGraph = new Graph!(TokenID[2], size_t);
    }

    NonterminalID[ElementID] lookaheadNonterminals;
    NonterminalID getLookaheadNonterminal(LRGraph graph, size_t state, size_t elementNr)
    {
        auto entry = ElementID(state, elementNr) in lookaheadNonterminals;
        if (entry)
            return *entry;
        assert(!grammarFinished);

        auto node = graph.states[state];
        auto element = node.elements[elementNr];

        NonterminalID l1 = grammar2.nonterminals.id(text("$l_", state, "_", elementNr));
        lookaheadNonterminals[ElementID(state, elementNr)] = l1;

        if (element.dotPos == 0 && element.isStartElement)
            grammar2.addProduction(new Production(l1,
                    [SymbolInstance(grammar2.tokens.id("$end"))]));
        if (element.dotPos == 0 && !element.isStartElement)
        {
            foreach (k2, element2; node.elements)
            {
                bool elementPossible;
                foreach (n; element2.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
                {
                    if (n.nonterminalID == element.production.nonterminalID)
                    {
                        elementPossible = true;
                    }
                }
                if (elementPossible)
                {
                    auto afterNext = element2.afterNext(grammar);
                    if (useRegexlookahead || element2.production.symbols.length == 1
                            || element.production.productionID in reduceConflictProductions
                            || element2.production.annotations.contains!"lookahead"
                            || afterNext.length == 0)
                    {
                        NonterminalID l2 = getLookaheadNonterminal(graph, state, k2);
                        grammar2.addProduction(new Production(l1,
                                afterNext ~ [immutable(SymbolInstance)(l2)]));
                    }
                    else if (afterNext.length > 0)
                    {
                        grammar2.addProduction(new Production(l1,
                                afterNext ~ [
                                    immutable(SymbolInstance)(grammar2.tokens.id("$anything"))
                                ]));
                    }
                    else
                    {
                        grammar2.addProduction(new Production(l1,
                                [
                                    SymbolInstance(grammar2.tokens.id("$anything"))
                                ]));
                    }
                }
            }
        }

        foreach (prev; element.prevElements)
        {
            if (prev.state == size_t.max)
            {
                continue;
            }

            NonterminalID l2 = getLookaheadNonterminal(graph, prev.state, prev.elementNr);
            grammar2.addProduction(new Production(l1, [SymbolInstance(l2)]));
        }

        return l1;
    }

    NonterminalID[ElementID] lookaheadNonterminalsSimple;
    NonterminalID getLookaheadNonterminalSimple(LRGraph graph, size_t state, size_t elementNr)
    {
        auto entry = ElementID(state, elementNr) in lookaheadNonterminalsSimple;
        if (entry)
            return *entry;
        assert(!grammarFinished);

        auto node = graph.states[state];
        auto element = node.elements[elementNr];

        NonterminalID l1 = grammar2.nonterminals.id(text("$lsimple_", state, "_", elementNr));
        lookaheadNonterminalsSimple[ElementID(state, elementNr)] = l1;

        foreach (t; element.lookahead.bitsSet)
        {
            immutable(SymbolInstance)[] dummySymbols = [
                immutable(SymbolInstance)(t)
            ];
            foreach (matchingTokens; grammar.matchingTokens)
            {
                if (t == matchingTokens[0])
                {
                    dummySymbols ~= immutable(SymbolInstance)(matchingTokens[1]);
                    break;
                }
            }
            grammar2.addProduction(new Production(l1, dummySymbols));
        }
        return l1;
    }

    bool isSimpleNonterminal(NonterminalID n)
    {
        foreach (p; grammar2.getProductions(n))
        {
            foreach (s; p.symbols)
                if (!s.isToken)
                    return false;
        }
        return true;
    }

    G[NonterminalID] nonterminalGraphCache;
    G genNonterminalGraph(NonterminalID startNonterminal)
    {
        startNonterminal = normalizeNonterminalID(grammar2, startNonterminal);

        if (startNonterminal in nonterminalGraphCache)
            return nonterminalGraphCache[startNonterminal];

        immutable endTok = grammar.tokens.getID("$end");

        G g = new G();
        g.start = g.addNode("start");

        immutable(size_t)[] results = [0];
        NodeID end = g.addNode("end");
        NodeID recNode1 = g.addNode("r");
        NodeID recNode2 = g.addNode("r");
        g.get(end).results = results;
        NodeID[2][NonterminalID] done;
        NodeID[2] genSubgraph(NonterminalID nonterminal)
        {
            if (nonterminal in done)
                return done[nonterminal];
            NodeID[2] nonterminalNodes = [
                g.addNode("start " ~ grammar2.getSymbolName(nonterminal)),
                g.addNode("end " ~ grammar2.getSymbolName(nonterminal))
            ];
            done[nonterminal] = nonterminalNodes;
            scope (success)
                if (isSimpleNonterminal(nonterminal))
                    done.remove(nonterminal);
            foreach (p; grammar2.getProductions(nonterminal))
            {
                NodeID current = nonterminalNodes[0];
                foreach (s; p.symbols)
                {
                    NodeID n = g.addNode("x");
                    if (s.isToken)
                    {
                        if (s.toTokenID in subGraphTokens)
                        {
                            g.addEdge(current, n, subGraphToken, EdgeFlags.none,
                                    RegexLookaheadEdgeExtra([
                                        subGraphTokens[s.toTokenID]
                                    ]));
                        }
                        else
                            g.addEdge(current, n, s);
                    }
                    else
                    {
                        auto subNodes = genSubgraph(s.toNonterminalID);
                        g.addEdge(current, subNodes[0], Symbol.invalid);
                        g.addEdge(subNodes[1], n, Symbol.invalid);
                    }
                    current = n;
                }
                g.addEdge(current, nonterminalNodes[1], Symbol.invalid);
            }
            return nonterminalNodes;
        }

        auto nonterminalNodes = genSubgraph(startNonterminal);
        g.addEdge(g.start, nonterminalNodes[0], Symbol.invalid);
        g.addEdge(nonterminalNodes[1], end, Symbol.invalid);

        string symbolName(Symbol s)
        {
            return grammar2.getSymbolName(s);
        }

        g = g.makeDeterministic!(typeof(g))(g.start).minimizeDFA;
        nonterminalGraphCache[startNonterminal] = g;

        return g;
    }

    Symbol[][][NonterminalID] nonterminalGraphSimpleCache;
    Symbol[][] genNonterminalGraphSimple(NonterminalID startNonterminal)
    {
        startNonterminal = normalizeNonterminalID(grammar2, startNonterminal);

        if (startNonterminal in nonterminalGraphSimpleCache)
            return nonterminalGraphSimpleCache[startNonterminal];

        Appender!(Symbol[][]) sequences;

        immutable endTok = grammar.tokens.getID("$end");

        bool[NonterminalID] done;
        void genSubgraph(NonterminalID nonterminal)
        {
            if (nonterminal in done)
                return;
            done[nonterminal] = true;
            foreach (p; grammar2.getProductions(nonterminal))
            {
                Symbol[] sequence;
                foreach (i, s; p.symbols)
                {
                    if (s.isToken)
                    {
                        if (sequence.length)
                        {
                            bool subGraphNear;
                            if (i)
                            {
                                auto s2 = p.symbols[i - 1];
                                if (s2.isToken && s2.toTokenID in subGraphTokens)
                                {
                                    subGraphNear = true;
                                }
                            }
                            foreach (matching; grammar.matchingTokens)
                            {
                                if (s.toTokenID == matching[1])
                                {
                                    subGraphNear = true;
                                }
                            }
                            foreach (j, s2; p.symbols[i .. $])
                            {
                                if (!s2.isToken || j > 0)
                                    break;
                                if (s2.toTokenID in subGraphTokens)
                                {
                                    subGraphNear = true;
                                    break;
                                }
                            }
                            if (!subGraphNear)
                            {
                                sequences.put(sequence);
                                sequence = [];
                            }
                        }

                        sequence ~= s;
                    }
                    else
                    {
                        if (sequence.length)
                        {
                            sequences.put(sequence);
                            sequence = [];
                        }
                        genSubgraph(s.toNonterminalID);
                    }
                }
                if (sequence.length)
                {
                    sequences.put(sequence);
                    sequence = [];
                }
            }
        }

        genSubgraph(startNonterminal);

        nonterminalGraphSimpleCache[startNonterminal] = sequences.data;

        return sequences.data;
    }

    static void clusterResults(G g)
    {
        immutable(size_t)[][] clusters;
        size_t findCluster(size_t r)
        {
            foreach (i, c; clusters)
            {
                if (c.canFind(r))
                    return i;
            }
            return size_t.max;
        }

        foreach (n; g.nodeIDs)
        {
            immutable(size_t)[] newResults;
            foreach (r; g.get(n).results)
            {
                size_t c = findCluster(r);
                if (c == size_t.max)
                    newResults.addOnce(r);
                else
                {
                    newResults.addOnce(clusters[c]);
                    clusters = clusters[0 .. c] ~ clusters[c + 1 .. $];
                }
            }
            if (newResults.length)
                clusters ~= newResults;
        }

        foreach (n; g.nodeIDs)
        {
            if (g.get(n).results.length)
            {
                auto c = findCluster(g.get(n).results[0]);
                g.get(n).results = clusters[c];
            }
        }
    }

    void genGraph(RegexLookaheadGraph regexLookaheadGraph)
    {
        regexLookaheadGraph.frozen = true;
        G g = new G();
        g.start = g.addNode("start");

        foreach (sequence; regexLookaheadGraph.sequences)
        {
            g.get(g.start).results.addOnce(sequence[1]);

            immutable(size_t)[] results = [sequence[1]];

            if (regexLookaheadGraph.isInnerGraph)
            {
                bool[immutable(Symbol)[]] sequencesDone;
                foreach (j, s; sequence[0])
                {
                    if (s.isToken)
                    {
                        g.addEdge(g.start, g.start, s);
                    }
                    else
                    {
                        foreach (sequence2; genNonterminalGraphSimple(s.toNonterminalID))
                        {
                            if (sequence2 in sequencesDone)
                                continue;
                            sequencesDone[sequence2.idup] = true;
                            NodeID current = g.start;
                            foreach (s2; sequence2)
                            {
                                NodeID n = g.addNode("x");
                                g.addEdge(current, n, s2);
                                current = n;
                            }
                            g.addEdge(current, g.start, Symbol.invalid);
                        }
                    }
                }
                g.get(g.start).results = results;
            }
            else
            {
                NodeID current = g.start;

                bool[immutable(Symbol)[]] firstSequencesDone;
                foreach (j, s; sequence[0])
                {
                    NodeID end = g.addNode("x");
                    g.get(end).results = results;
                    if (s.isToken)
                    {
                        g.addEdge(current, end, s);
                    }
                    else
                    {
                        G g2 = genNonterminalGraph(s.toNonterminalID);

                        NodeID[NodeID] nodeMap;
                        foreach (i; g2.nodeIDs)
                        {
                            NodeID n = g.addNode("x");
                            nodeMap[i] = n;
                            g.get(n).results = results;
                            if (g2.get(i).results.length)
                                g.addEdge(n, end, Symbol.invalid);
                        }
                        foreach (i; g2.nodeIDs)
                        {
                            foreach (edge; g2.get(i).edges)
                            {
                                g.addEdge(nodeMap[i], nodeMap[edge.next],
                                        edge.symbol, EdgeFlags.none, edge.extra);
                            }
                        }
                        g.addEdge(current, nodeMap[g2.start], Symbol.invalid);
                    }
                    current = end;
                }
            }
        }

        string symbolsName(G.Edge[] edges)
        {
            string r;
            foreach (i, e; edges)
            {
                if (i)
                    r ~= "\n";
                r ~= grammar2.getSymbolName(e.symbol);
                foreach (sequence; e.extra.sequences)
                {
                    r ~= "\n -";
                    foreach (s; sequence)
                        r ~= " " ~ grammar2.getSymbolName(s);
                }
            }
            return r;
        }

        g = g.makeDeterministic!(typeof(g))(g.start, !regexLookaheadGraph.isInnerGraph);
        g = g.minimizeDFA();

        if (regexLookaheadGraph.isInnerGraph)
        {
            clusterResults(g);
            g = g.minimizeDFA();

            immutable size_t[] simpleResults = [0];
            foreach (n; g.nodeIDs)
            {
                if (g.get(n).results.length)
                    g.get(n).results = simpleResults;
            }
            g = g.minimizeDFA();
        }

        regexLookaheadGraph.dfa = g;

        foreach (n; g.nodeIDs)
        {
            foreach (e; g.getEdges(n))
            {
                if (e.symbol.isToken && e.symbol.toTokenID in matchingTokensMap)
                {
                    immutable(SymbolInstance)[][] sequences;
                    TokenID[] endTokens;
                    bool hasNonMatchingNext;
                    foreach (e2; g.getEdges(e.next))
                    {
                        if (e2.symbol.isToken && e2.symbol.toTokenID == subGraphToken)
                        {
                            sequences.addOnce(e2.extra.sequences);
                            foreach (e3; g.getEdges(e2.next))
                            {
                                endTokens.addOnce(e3.symbol.toTokenID);
                            }
                        }
                        else
                            hasNonMatchingNext = true;
                    }
                    sequences.sort();
                    enforce(!hasNonMatchingNext || sequences.length == 0);

                    if (sequences.length)
                    {
                        auto matchNode = buildMatchGraph(sequences);
                        matchGraph.otherStarts ~= matchNode;
                        matchGraphStartIndex[sequences.idup] = matchGraph.otherStarts.length - 1;
                        foreach (matchEdge; matchGraph.getEdges(matchNode))
                        {
                            if (matchEdge.symbol[1] == TokenID.invalid)
                                enforce(!endTokens.canFind(matchEdge.symbol[0]));
                        }
                    }
                }
            }
        }
    }

    Graph!(TokenID[2], size_t) matchGraph;
    Graph!(TokenID[2], size_t).NodeID[immutable(SymbolInstance[])[]] matchGraphStates;
    size_t[immutable(SymbolInstance[])[]] matchGraphStartIndex;

    Graph!(TokenID[2], size_t).NodeID buildMatchGraph(immutable(SymbolInstance)[][] sequences)
    {
        if (sequences in matchGraphStates)
        {
            return matchGraphStates[sequences];
        }
        else
        {
            string nodeText;
            foreach (i, sequence; sequences)
            {
                if (i)
                    nodeText ~= "\n";
                foreach (s; sequence)
                    nodeText ~= " " ~ grammar2.getSymbolName(s);
            }

            auto n = matchGraph.addNode(nodeText);
            matchGraphStates[sequences.idup] = n;

            bool[TokenID] usedAlone;
            immutable(SymbolInstance)[][][TokenID[2]] usedMatching;

            bool[Symbol] done;
            void genSubgraph(Symbol s)
            {
                if (s in done)
                    return;
                done[s] = true;
                if (s.isToken)
                {
                    if (s.toTokenID in matchingTokensAll)
                    {
                        if (s.toTokenID in usedAlone)
                            enforce(usedAlone[s.toTokenID]);
                        else
                        {
                            usedAlone[s.toTokenID] = true;
                            matchGraph.addEdge(n, n, [
                                    s.toTokenID, TokenID.invalid
                                    ]);
                        }
                    }
                }
                else
                {
                    foreach (p; grammar2.getProductions(s.toNonterminalID))
                    {
                        for (size_t i = 0; i < p.symbols.length; i++)
                        {
                            if (i + 2 < p.symbols.length && p.symbols[i + 1].isToken
                                    && p.symbols[i + 1].toTokenID in subGraphTokens)
                            {
                                auto t1 = p.symbols[i].toTokenID;
                                auto t2 = p.symbols[i + 2].toTokenID;

                                if (t1 in usedAlone)
                                    enforce(!usedAlone[t1]);
                                else
                                    usedAlone[t1] = false;

                                if (t2 in usedAlone)
                                    enforce(!usedAlone[t2]);
                                else
                                    usedAlone[t2] = false;

                                immutable(SymbolInstance)[][] sequences2 = usedMatching.get([
                                    t1, t2
                                ], []);
                                sequences2.addOnce(subGraphTokens[p.symbols[i + 1].toTokenID]);
                                usedMatching[[t1, t2]] = sequences2;

                                i += 2;
                            }
                            else
                                genSubgraph(p.symbols[i]);
                        }
                    }
                }
            }

            foreach (sequence; sequences)
            {
                foreach (s; sequence)
                    genSubgraph(s);
            }

            foreach (pair, sequences2; usedMatching)
            {
                sequences2.sort();
                auto n2 = buildMatchGraph(sequences2);
                matchGraph.addEdge(n, n2, pair);
            }

            return n;
        }
    }

    void genGraphs()
    {
        grammar2.calcNonterminalCanBeEmpty();
        grammar2.fillProductionsForNonterminal();

        size_t lastLength = graphs.length;
        for (size_t i = 0; i < graphs.length; i++)
        {
            if (i >= lastLength)
            {
                lastLength = graphs.length;
            }

            if (graphs[i] is null)
                continue;

            if (graphs[i].isInnerGraph)
            {
                immutable(SymbolInstance)[][] sequences;
                foreach (sequence; graphs[i].sequences)
                    sequences.addOnce(sequence[0]);
                bool[immutable(SymbolInstance)[]] sequenceMap;
                foreach (sequence; sequences)
                    sequenceMap[sequence] = true;

                bool changed = true;
                while (changed)
                {
                    changed = false;

                    foreach (j; 0 .. graphs.length)
                    {
                        if (i == j)
                            continue;
                        if (graphs[j] is null || !graphs[j].isInnerGraph)
                            continue;
                        size_t commonSequences;
                        foreach (sequence; graphs[j].sequences)
                            if (sequence[0] in sequenceMap)
                                commonSequences++;
                        if (commonSequences)
                        {
                            foreach (sequence; graphs[j].sequences)
                            {
                                if (sequence[0]!in sequenceMap)
                                {
                                    sequences ~= sequence[0];
                                    sequenceMap[sequence[0]] = true;
                                }
                            }
                            graphs[j] = null;
                            changed = true;
                        }
                    }
                }
                sequences.sort();
                graphs[i].sequences = [];
                foreach (k, sequence; sequences)
                    graphs[i].sequences ~= tuple!(immutable(SymbolInstance)[], size_t)(sequence, k);
            }

            genGraph(graphs[i]);
        }

        matchGraph = matchGraph.minimizeDFA();

        string symbolPairName(TokenID[2] pair)
        {
            return grammar2.getSymbolName(pair[0]) ~ "..." ~ grammar2.getSymbolName(pair[1]);
        }

        grammarFinished = true;
    }

    void genMatchFuncs(ref CodeWriter code)
    {
        foreach (n; matchGraph.nodeIDs)
        {
            size_t[TokenID] actions;
            foreach (m; grammar.matchingTokens)
            {
                actions[m[1]] = size_t.max;
            }
            foreach (e; matchGraph.getEdges(n))
            {
                if (e.symbol[1] == TokenID.invalid)
                {
                    actions[e.symbol[0]] = size_t.max - 1;
                }
                else
                {
                    actions[e.symbol[0]] = e.next.id;
                }
            }

            mixin(genCode("code", q{
                int skipMatchingTokens$(n.id)(ref Lexer tmpLexer)
                {
                    while (!tmpLexer.empty)
                    {
                        switch (tmpLexer.front.symbol)
                        {
                        $$foreach (t; actions.sortedKeys) {
                            case Lexer.tokenID!$(tokenDCode(grammar.tokens[t])):
                            $$if (actions[t] == size_t.max) {
                                    return 0;
                            $$} else if (actions[t] == size_t.max - 1) {
                                    break;
                            $$} else {
                                    tmpLexer.popFront;
                                    if (skipMatchingTokens$(actions[t])(tmpLexer) < 0)
                                        return -1;
                                    if (tmpLexer.empty)
                                    {
                                        lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);
                                        return -1;
                                    }
                                    if ($(grammar.matchingTokens.filter!(m=>m[0] == t).map!(m=>text("tmpLexer.front.symbol != Lexer.tokenID!", tokenDCode(grammar.tokens[m[1]]))).joiner(" && ")))
                                    {
                                        lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);
                                        return -1;
                                    }
                                    break;
                            $$}
                        $$}
                        default:
                            break;
                        }
                        tmpLexer.popFront;
                    }
                    lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);
                    return -1;
                }
            }));
        }
    }

    void genGraph(ref CodeWriter code, RegexLookaheadGraph regexLookaheadGraph)
    {
        if (regexLookaheadGraph is null)
            return;
        assert(grammarFinished);

        code.writeln("SymbolID checkRegexLookahead", regexLookaheadGraph.id, "()");
        code.writeln("{").incIndent;

        foreach (sequence; regexLookaheadGraph.sequences)
        {
            code.write("// ", sequence[1], ":");
            foreach (s; sequence[0])
                code.write(" ", grammar2.getSymbolName(s));
            code.writeln();
        }

        immutable endTok = grammar.tokens.getID("$end");
        immutable anythingTok = grammar2.tokens.getID("$anything");

        auto dfa = regexLookaheadGraph.dfa;

        code.writeln("Lexer tmpLexer = *lexer;");
        assert(dfa.get(dfa.start).results.length > 1);
        code.writeln("goto state", dfa.start.id, "b;");

        foreach (n; dfa.nodeIDs)
        {
            code.writeln("state", n.id, ":");
            code.incIndent;

            string resultsComment;
            bool[size_t] resultDone;
            string resultString(size_t res)
            {
                return text(res);
            }

            foreach (res; dfa.get(n).results)
            {
                resultDone[res] = true;
                resultsComment ~= " " ~ resultString(res);
            }
            auto tmpReachableResults = reachableResults(dfa, n);
            sort!((a, b) => a < b)(tmpReachableResults);
            foreach (res; tmpReachableResults)
            {
                if (res in resultDone)
                    continue;
                resultsComment ~= " (" ~ resultString(res) ~ ")";
            }
            code.writeln("//", resultsComment);
            if (dfa.get(n).results.length == 1 && dfa.get(n).results[0] != size_t.max)
            {
                mixin(genCode("code", q{
                    return $(dfa.get(n).results[0]);
                }));
            }
            else if (dfa.get(n).results.length == 1 && dfa.get(n).results[0] == size_t.max)
            {
                code.writeln(q{    lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);});
                code.writeln(q{    return -1;});
            }
            else
            {
                immutable(SymbolInstance)[][] sequences;
                foreach (e; dfa.getEdges(n))
                {
                    if (e.symbol.isToken && e.symbol.toTokenID == subGraphToken)
                    {
                        sequences.addOnce(e.extra.sequences);
                    }
                }

                code.writeln("tmpLexer.popFront();");
                code.decIndent.writeln("state", n.id, "b:").incIndent;

                if (sequences.length)
                {
                    sequences.sort();
                    auto matchNode = matchGraph.otherStarts[matchGraphStartIndex[sequences]];
                    code.writeln("if (skipMatchingTokens", matchNode.id, "(tmpLexer) < 0)");
                    code.writeln("    return SymbolID.max;");
                    foreach (e; dfa.getEdges(n))
                    {
                        code.writeln("goto state", e.next.id, "b;");
                    }
                }
                else
                {
                    G.Edge[][] edges;
                    size_t[G.NodeID] edgesMap;
                    G.Edge edgeEmpty;
                    bool hasAnythingEdge;
                    foreach (e; dfa.getEdges(n))
                    {
                        if (e.symbol == endTok)
                        {
                            edgeEmpty = e;
                            continue;
                        }
                        if (e.symbol == anythingTok)
                        {
                            hasAnythingEdge = true;
                            continue;
                        }
                        if (e.next !in edgesMap)
                        {
                            edgesMap[e.next] = edges.length;
                            edges.length++;
                        }
                        edges[edgesMap[e.next]] ~= e;
                    }
                    sort(edges);
                    stdout.flush();
                    enforce(!hasAnythingEdge
                            || (edgeEmpty.next == G.NodeID.invalid && edges.length == 0));

                    size_t maxEdge = size_t.max;
                    size_t maxEdgeN = 0;

                    code.writeln("if (tmpLexer.empty)");
                    if (edgeEmpty.next == G.NodeID.invalid)
                    {
                        code.writeln("{");
                        code.writeln(q{    lastError = new SingleParseException!Location("EOF for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);});
                        code.writeln(q{    return SymbolID.max;});
                        code.writeln("}");
                    }
                    else
                        code.writeln("    goto state", edgeEmpty.next.id, ";");

                    foreach (i, e; edges)
                    {
                        if (i != maxEdge)
                        {
                            code.write("else ");
                            code.writeln("if (tmpLexer.front.symbol.among(", e.map!(x => text("Lexer.tokenID!",
                                    grammar.tokens[x.symbol.toTokenID].tokenDCode)).joiner(", "),
                                    "))");
                            code.writeln("    goto state", e[0].next.id, ";");
                        }
                    }
                    code.write("else //");
                    if (edgeEmpty.next != G.NodeID.invalid)
                    {
                        code.writeln();
                        code.writeln("    goto state", edgeEmpty.next.id, "; //like empty");
                    }
                    else if (maxEdge == size_t.max)
                    {
                        code.writeln();
                        code.writeln("{");
                        code.writeln(q{    lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);});
                        code.writeln(q{    return SymbolID.max;});
                        code.writeln("}");
                    }
                    else
                    {
                        foreach (x; edges[maxEdge])
                            code.write(" ", grammar.getSymbolName(x.symbol));
                        code.writeln();
                        code.writeln("    goto state", edges[maxEdge][0].next.id, ";");
                    }
                }
            }
            code.decIndent;
        }
        if (dfa.nodes.length == 0)
        {
            code.writeln(q{lastError = new SingleParseException!Location("Error for lookahead", lexer.front.currentLocation, tmpLexer.front.currentLocation);});
            code.writeln("return SymbolID.max;");
        }
        code.decIndent.writeln("}");
    }
}
