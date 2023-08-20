
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.lexergenerator;
import dparsergen.core.utils;
import dparsergen.generator.codewriter;
import dparsergen.generator.grammar;
import dparsergen.generator.nfa;
import dparsergen.generator.parsercodegencommon;
import dparsergen.generator.production;
import std.algorithm;
import std.conv;
import std.exception;
import std.range;
import std.stdio;
import std.uni;
import std.utf;

struct LexerAction
{
    NonterminalID nonterminal = NonterminalID.invalid;
    bool isIgnoreToken;
    bool isNegLookahead;
}

struct DCharToken
{
    CodepointSet* codepoints;
    EdgeFlags specialFlags;
    immutable(SymbolInstance)[] recursiveSequence;
    enum invalid = DCharToken();
    string toString() const
    {
        if (codepoints)
            return codepointSetToStr(*cast(CodepointSet*) codepoints);
        if (recursiveSequence.length)
            return "RecursiveLexer";
        return text(specialFlags);
    }
}

string codepointSetToStr(CodepointSet set)
{
    string r = "[";

    if (0x10ffff in set)
    {
        r ~= "^";
        set = set.inverted;
    }

    foreach (interval; set.byInterval)
    {
        if (interval[0] + 1 == interval[1])
            r ~= interval[0].escapeCodePoint(true);
        else
            r ~= text(interval[0].escapeCodePoint(true), "-",
                    escapeCodePoint(interval[1] - 1, true));
    }
    r ~= "]";
    return r;
}

CodepointSet restrictToAssumedCodepoints(CodepointSet set, CodepointSet assumed)
{
    set = set & assumed;
    foreach (interval; assumed.inverted.byInterval)
    {
        if ((interval[0] != 0 && interval[0] - 1 in set) && interval[1] in set)
            set = set | CodepointSet(interval[0], interval[1]);
    }
    return set;
}

string codepointSetToCode(string varCode, CodepointSet set,
        CodepointSet assumed = CodepointSet().inverted)
{
    bool inverted;
    if (0x10ffff in set)
    {
        inverted = true;
        set = set.inverted;
    }
    set = restrictToAssumedCodepoints(set, assumed);
    return codepointSetToCode(varCode, set, inverted);
}

string codepointSetToCode(string varCode, CodepointSet set, bool inverted)
{
    if (set.empty)
    {
        return inverted.to!string;
    }

    string r;

    if (set.byInterval.length == 1 && set.byInterval.front[0] + 1 == set.byInterval.front[1])
    {
        r ~= varCode;
        r ~= (inverted) ? " != " : " == ";
        r ~= text("'", set.byInterval.front[0].escapeCodePoint(false), "'");
    }
    else
    {
        if (inverted)
            r ~= "!(";

        CommaGen orCode = CommaGen(" || ");

        foreach (interval; set.byInterval)
        {
            r ~= orCode();
            if (interval[0] + 1 == interval[1])
                r ~= text(varCode, " == '", interval[0].escapeCodePoint(false), "'");
            else
                r ~= text("(", varCode, " >= '", interval[0].escapeCodePoint(false),
                        "' && ", varCode, " <= '", (interval[1] - 1).escapeCodePoint(false), "')");
        }
        if (inverted)
            r ~= ")";
    }
    return r;
}

void generateTokenGraph(const EBNFGrammar lexerGrammar, Graph!(DCharToken, LexerAction) g,
        CodepointSet*[] codepointSets, Symbol symbol, Graph!(DCharToken, LexerAction).NodeID start,
        Graph!(DCharToken, LexerAction).NodeID end, EdgeFlags edgeFlags = EdgeFlags.none)
{
    alias G = Graph!(DCharToken, LexerAction);
    alias NodeID = G.NodeID;

    string name = lexerGrammar.getSymbolName(symbol);

    if (name.endsWith("\""))
    {
        assert(name[$ - 1] == name[0]);
        name = name[1 .. $ - 1];
        NodeID current = start;
        size_t i;
        UnescapedChar[] chars = name.byDchar.byUnescapedDchar.array;
        if (edgeFlags != EdgeFlags.none)
            enforce(chars.length);
        foreach (k, d; chars)
        {
            scope (success)
                i++;
            NodeID next = g.addNode(text("x ", i));

            EdgeFlags edgeFlags2;
            if (k == chars.length - 1)
            {
                edgeFlags2 = edgeFlags;
            }

            CodepointSet set = CodepointSet(d.c, d.c + 1);
            foreach (codepointSet; codepointSets)
            {
                if (!(set & *codepointSet).empty)
                    g.addEdge(current, next, DCharToken(codepointSet), edgeFlags2);
            }
            current = next;
        }
        g.addEdge(current, end, DCharToken.invalid);
    }
    else if (name.endsWith("]"))
    {
        assert(name[0] == '[');
        name = name[1 .. $ - 1];
        CodepointSet set = codepointSetFromStr(name);
        foreach (codepointSet; codepointSets)
        {
            if (!(set & *codepointSet).empty)
                g.addEdge(start, end, DCharToken(codepointSet), edgeFlags);
        }
    }
    else if (name.endsWith("\'"))
    {
        assert(name[$ - 1] == name[0]);
        name = name[1 .. $ - 1];
        throw new Exception("not implemented");
    }
    else
        assert(false);
}

void genGraphForNonterminal(const EBNFGrammar lexerGrammar, Graph!(DCharToken, LexerAction) g,
        CodepointSet*[] codepointSets, NonterminalID currentNonterminal, Graph!(DCharToken, LexerAction)
        .NodeID start, Graph!(DCharToken, LexerAction).NodeID end,
        ref Graph!(DCharToken, LexerAction)[NonterminalID] graphByNonterminal)
{
    alias G = Graph!(DCharToken, LexerAction);
    alias NodeID = G.NodeID;

    bool[Symbol] done;
    void genSubgraph(Symbol symbol, NodeID start, NodeID end,
            EdgeFlags firstEdgeFlags = EdgeFlags.none)
    {
        assert(!symbol.isToken);
        if (symbol in done && done[symbol])
            throw new Exception(text("cycle ", lexerGrammar.getSymbolName(symbol)));
        done[symbol] = true;
        scope (success)
            done[symbol] = false;

        string name = lexerGrammar.getSymbolName(symbol);

        if (name.endsWith("\"") || name.endsWith("]") || name.endsWith("\'"))
        {
            generateTokenGraph(lexerGrammar, g, codepointSets, symbol, start, end, firstEdgeFlags);
        }
        else if (name.startsWith("$tokenminus"))
        {
            size_t foundProductions;
            foreach (p; lexerGrammar.productions)
            {
                if (p.nonterminalID != symbol.toNonterminalID)
                    continue;
                foundProductions++;

                assert(p.symbols.length == 2);

                G dfa2 = new G();
                dfa2.start = dfa2.addNode("start");

                foreach (i, s; p.symbols)
                {
                    if (s.isToken)
                    {
                        auto endM = dfa2.addNode("end");
                        generateTokenGraph(lexerGrammar, dfa2, codepointSets,
                                s.toTokenID, dfa2.start, endM, EdgeFlags.none);
                        dfa2.get(endM).results = [
                            LexerAction(NonterminalID.invalid, i > 0)
                        ];
                    }
                    else
                    {
                        auto prevNodesLength = dfa2.nodes.length;
                        auto g1 = genGraphForNonterminal(lexerGrammar,
                                codepointSets, s.toNonterminalID, graphByNonterminal);

                        auto startM = dfa2.addCopy(g1)[0];
                        foreach (j; prevNodesLength .. dfa2.nodes.length)
                        {
                            if (dfa2.nodes[j].results.length)
                                dfa2.nodes[j].results = [
                                    LexerAction(NonterminalID.invalid, i > 0)
                                ];
                        }
                        dfa2.addEdge(dfa2.start, startM, DCharToken.invalid);
                    }
                }

                dfa2 = dfa2.makeDeterministic(dfa2.start);
                dfa2 = dfa2.minimizeDFA;
                foreach (j; 0 .. dfa2.nodes.length)
                {
                    if (dfa2.nodes[j].results.length)
                    {
                        bool hasNotIgnored, hasIgnored;
                        foreach (r; dfa2.nodes[j].results)
                            if (r.isIgnoreToken)
                                hasIgnored = true;
                            else
                                hasNotIgnored = true;
                        if (!hasIgnored && hasNotIgnored)
                            dfa2.nodes[j].results = [
                                LexerAction(NonterminalID.invalid)
                            ];
                        else
                            dfa2.nodes[j].results = [];
                    }
                }
                dfa2 = dfa2.makeDeterministic(dfa2.start);
                dfa2 = dfa2.removeDeadStates;
                dfa2 = dfa2.minimizeDFA;

                enforce(firstEdgeFlags == EdgeFlags.none || dfa2.get(dfa2.start).results.length == 0);

                auto prevNodesLength = g.nodes.length;

                auto startM = g.addCopy(dfa2)[0];
                g.addEdge(start, startM, DCharToken.invalid);
                foreach (j; prevNodesLength .. g.nodes.length)
                {
                    if (g.nodes[j].results.length)
                    {
                        g.nodes[j].results = [];
                        g.addEdge(g.nodeID(j), end, DCharToken.invalid);
                    }
                }
                foreach (ref e; g.get(startM).edges)
                {
                    e.flags = firstEdgeFlags;
                }
            }
            assert(foundProductions == 1, text(name, " foundProductions=", foundProductions));
        }
        else
        {
            foreach (p; lexerGrammar.productions)
            {
                if (p.nonterminalID != symbol.toNonterminalID)
                    continue;

                enforce(p.symbols.length != 1 || p.symbols[0] != symbol, text("Error: Symbol ",
                        lexerGrammar.getSymbolName(symbol), " recursively uses just itself"));

                NodeID startP = g.addNode("start " ~ lexerGrammar.productionString(p));
                NodeID endP = g.addNode("end " ~ lexerGrammar.productionString(p));
                g.addEdge(endP, end, DCharToken.invalid);

                NodeID current = startP;
                bool connectStart = true, connectEnd = true;

                if (p.annotations.contains!"recursiveLexer"())
                {
                    enforce(firstEdgeFlags == EdgeFlags.none);

                    foreach (i, s; p.symbols)
                    {
                        NodeID next = g.addNode("x");
                        if (s.isToken)
                            generateTokenGraph(lexerGrammar, g, codepointSets, s, current, next);
                        else
                        {
                            g.addEdge(current, next, DCharToken(null,
                                    EdgeFlags.none, p.symbols[i .. $]));
                            current = next;
                            break;
                        }
                        current = next;
                    }
                    if (connectStart)
                        g.addEdge(start, startP, DCharToken.invalid);
                    if (connectEnd)
                        g.addEdge(current, endP, DCharToken.invalid);
                }
                else
                {
                    EdgeFlags nextEdgeFlags = firstEdgeFlags;
                    foreach (i, s; p.symbols)
                    {
                        EdgeFlags nextEdgeFlags2 = nextEdgeFlags;
                        nextEdgeFlags = EdgeFlags.none;
                        if (s.annotations.contains!"store" || s.annotations.contains!"compareTrue"
                                || s.annotations.contains!"compareFalse")
                        {
                            enforce(i || nextEdgeFlags2 == EdgeFlags.none);
                            enforce(s != symbol);
                            //enforce(i + 1 < p.symbols.length);

                            G dfa2;
                            if (s.isToken)
                            {
                                dfa2 = new G();
                                dfa2.start = dfa2.addNode("start");
                                auto endM = dfa2.addNode("end");
                                generateTokenGraph(lexerGrammar, dfa2, codepointSets,
                                        s.toTokenID, dfa2.start, endM, EdgeFlags.none);
                                dfa2.get(endM).results = [
                                    LexerAction(NonterminalID.invalid, true)
                                ];
                            }
                            else
                            {
                                dfa2 = genGraphForNonterminal(lexerGrammar,
                                        codepointSets, s.toNonterminalID, graphByNonterminal);
                            }

                            NodeID next = g.addNode("x");

                            auto prevNodesLength = g.nodes.length;
                            auto startM = g.addCopy(dfa2)[0];
                            auto newNodesLength = g.nodes.length;
                            foreach (j; prevNodesLength .. newNodesLength)
                            {
                                foreach (ref e; g.nodes[j].edges)
                                {
                                    if (!s.annotations.contains!"store")
                                        e.flags |= EdgeFlags.compareMiddle;
                                }
                            }
                            foreach (ref e; g.get(startM).edges)
                            {
                                if (g.get(e.next).edges.length)
                                    g.addEdge(current, e.next, e.symbol, s.annotations.contains!"store"
                                            ? EdgeFlags.storeStart : EdgeFlags.compareStart);
                                if (g.get(e.next).results.length)
                                    g.addEdge(current, next, e.symbol, s.annotations.contains!"store"
                                            ? EdgeFlags.storeStart
                                            : (EdgeFlags.compareStart | (s.annotations.contains!"compareTrue"
                                                ? EdgeFlags.compareEndTrue
                                                : EdgeFlags.compareEndFalse)));
                            }
                            foreach (j; prevNodesLength .. newNodesLength)
                            {
                                foreach (e; g.nodes[j].edges)
                                {
                                    if (g.get(e.next).results.length)
                                    {
                                        g.addEdge(g.nodeID(j), next, e.symbol,
                                                s.annotations.contains!"store" ? EdgeFlags.none
                                                : s.annotations.contains!"compareTrue"
                                                ? EdgeFlags.compareEndTrue
                                                : EdgeFlags.compareEndFalse);
                                    }
                                }
                            }
                            foreach (j; prevNodesLength .. newNodesLength)
                            {
                                g.nodes[j].results = [];
                            }

                            if (s.annotations.contains!"store")
                            {
                                NodeID next2 = g.addNode("x");
                                g.addEdge(next, next2, DCharToken(null, EdgeFlags.storeEnd));
                                next = next2;
                            }

                            current = next;
                        }
                        else if (i == p.symbols.length - 1 && s == symbol
                                && firstEdgeFlags != EdgeFlags.none)
                        {
                            done[symbol] = false;
                            NodeID next = g.addNode("x");
                            if (s.isToken)
                                generateTokenGraph(lexerGrammar, g, codepointSets,
                                        s, current, next, EdgeFlags.none);
                            else
                                genSubgraph(s, current, next, EdgeFlags.none);
                            current = next;
                            done[symbol] = true;
                        }
                        else if (s == symbol)
                        {
                            if (i != 0 && i != p.symbols.length - 1)
                                throw new Exception("not regular");

                            if (i == 0)
                            {
                                g.addEdge(end, current, DCharToken.invalid, EdgeFlags.backwards);
                                connectStart = false;
                            }
                            if (i == p.symbols.length - 1)
                            {
                                g.addEdge(current, start, DCharToken.invalid, EdgeFlags.backwards);
                                connectEnd = false;
                            }
                        }
                        else
                        {
                            NodeID next = g.addNode("x");
                            if (s.isToken)
                                generateTokenGraph(lexerGrammar, g, codepointSets,
                                        s, current, next, nextEdgeFlags2);
                            else
                                genSubgraph(s, current, next, nextEdgeFlags2);
                            current = next;
                        }
                    }
                    enforce(nextEdgeFlags == EdgeFlags.none,
                            text("Empty lexer rule used with flags ", nextEdgeFlags));

                    if (connectStart)
                        g.addEdge(start, startP, DCharToken.invalid);
                    if (connectEnd)
                        g.addEdge(current, endP, DCharToken.invalid);
                }

                foreach (x; p.negLookaheads)
                {
                    auto endNegLookahead = g.addNode(
                            "neglookahead " ~ lexerGrammar.productionString(p) ~ " " ~ text(x));
                    if (x.isToken)
                        generateTokenGraph(lexerGrammar, g, codepointSets, x,
                                endP, endNegLookahead);
                    else
                        genSubgraph(x, endP, endNegLookahead);
                    g.get(endNegLookahead).results = [
                        LexerAction(currentNonterminal, false, true)
                    ];
                }
            }
        }
    }

    genSubgraph(currentNonterminal, start, end);
}

Graph!(DCharToken, LexerAction) genGraphForNonterminal(const EBNFGrammar lexerGrammar, CodepointSet*[] codepointSets,
        NonterminalID currentNonterminal, ref Graph!(DCharToken,
            LexerAction)[NonterminalID] graphByNonterminal)
{
    alias G = Graph!(DCharToken, LexerAction);
    alias NodeID = G.NodeID;

    if (currentNonterminal in graphByNonterminal)
    {
        enforce(graphByNonterminal[currentNonterminal]!is null);
        return graphByNonterminal[currentNonterminal];
    }

    graphByNonterminal[currentNonterminal] = null;

    G dfa2 = new G();
    dfa2.start = dfa2.addNode("start");

    NodeID endM = dfa2.addNode("end");
    dfa2.get(endM).results = [LexerAction(currentNonterminal)];

    genGraphForNonterminal(lexerGrammar, dfa2, codepointSets,
            currentNonterminal, dfa2.start, endM, graphByNonterminal);

    dfa2 = dfa2.makeDeterministic(dfa2.start);
    dfa2 = dfa2.minimizeDFA;
    graphByNonterminal[currentNonterminal] = dfa2;
    return dfa2;
}

class SubAutomaton
{
    immutable(SymbolInstance)[] recursiveSequence;
    Graph!(DCharToken, LexerAction) dfa;
}

void generateStateMachine(ref CodeWriter code, const EBNFGrammar lexerGrammar,
        Graph!(DCharToken, LexerAction) dfa, bool inSubAutomaton, SubAutomaton[] subAutomatons)
{
    alias G = Graph!(DCharToken, LexerAction);
    alias NodeID = G.NodeID;

    class EdgeData
    {
        CodepointSet set;
        const(SymbolInstance)[] recursiveSequence;
        G.NodeID next, next2, next3;
        LexerAction[] saveResult;
        bool isEndEdge;
        EdgeFlags flags;
    }

    EdgeData[][G.NodeID] edgesPerNode;
    CodepointSet[G.NodeID] allAllowedSets;
    foreach (n; dfa.nodeIDs)
    {
        EdgeData[] edges;
        CodepointSet allAllowedSet;
        bool hasRecursiveLexer;
        foreach (e; dfa.getEdges(n))
        {
            EdgeFlags flags = e.flags;
            EdgeData x;
            foreach (x2; edges)
                if (e.symbol.codepoints !is null && x2.set == *e.symbol.codepoints)
                {
                    enforce((flags & ~EdgeFlags.compareFlags) == (x2.flags & ~EdgeFlags.compareFlags),
                            text(n, flagsToString(flags), " ",
                                flagsToString(x2.flags), " ", x2.set));
                    flags |= x2.flags;
                    x = x2;
                }
            if (x !is null)
            {
                if (e.symbol.codepoints !is null)
                    x.set |= *e.symbol.codepoints;
                x.recursiveSequence = e.symbol.recursiveSequence;
                x.flags |= flags;
                if (e.symbol.recursiveSequence.length)
                    hasRecursiveLexer = true;
                allAllowedSet |= x.set;
            }
            else
            {
                x = new EdgeData();
                if (e.symbol.codepoints !is null)
                    x.set = *e.symbol.codepoints;
                x.recursiveSequence = e.symbol.recursiveSequence;
                if (e.symbol.recursiveSequence.length)
                    hasRecursiveLexer = true;
                x.flags = flags;
                allAllowedSet |= x.set;
                edges ~= x;
            }

            if (e.flags & EdgeFlags.compareEndTrue)
            {
                x.next3 = e.next;
            }
            else if ((e.flags & EdgeFlags.compareFlags) && !(e.flags & EdgeFlags.compareEndFalse))
            {
                x.next2 = e.next;
            }
            else
            {
                x.next = e.next;
            }
        }
        if (hasRecursiveLexer)
        {
            enforce(edges.length == 1);
        }
        else
        {
            edges ~= new EdgeData();
            edges[$ - 1].set = allAllowedSet.inverted;
            edges[$ - 1].isEndEdge = true;
        }
        edgesPerNode[n] = edges;
        allAllowedSets[n] = allAllowedSet;

        /*foreach (e; edges)
        {
            writeln(n, e.next, e.next2, " ", codepointSetToStr(e.set), " ", e.recursiveSequence);
        }*/
    }

    // Merge similar edges
    foreach (n; dfa.nodeIDs)
    {
        if (edgesPerNode[n].length == 1 && edgesPerNode[n][0].recursiveSequence.length)
            continue;

        struct Key
        {
            G.NodeID next;
            G.NodeID next2;
            G.NodeID next3;
            bool isEndEdge;
            EdgeFlags flags;
            int opCmp(const Key other) const
            {
                if (isEndEdge != other.isEndEdge)
                {
                    if (other.isEndEdge)
                        return -1;
                    if (isEndEdge)
                        return 1;
                }
                if (flags < other.flags)
                    return -1;
                if (flags > other.flags)
                    return 1;
                int r = next.opCmp(other.next);
                if (r)
                    return r;
                r = next2.opCmp(other.next2);
                if (r)
                    return r;
                r = next3.opCmp(other.next3);
                return r;
            }
        }

        DCharToken[Key] edgesMap;
        EdgeData[] edges;
        foreach (e; edgesPerNode[n])
        {
            Key key = Key(e.next, e.next2, e.next3, e.isEndEdge, e.flags);
            if (key !in edgesMap)
            {
                edgesMap[key] = DCharToken(new CodepointSet());
            }
            *edgesMap[key].codepoints |= e.set;
        }
        foreach (key; edgesMap.sortedKeys)
        {
            auto e = edgesMap[key];
            EdgeData e2 = new EdgeData();
            e2.next = key.next;
            e2.next2 = key.next2;
            e2.next3 = key.next3;
            e2.isEndEdge = key.isEndEdge;
            e2.flags = key.flags;
            e2.set = *e.codepoints;
            edges ~= e2;
        }
        edgesPerNode[n] = edges;
    }

    LexerAction[][G.NodeID] reachableResultsPerNode;
    foreach (n; dfa.nodeIDs)
    {
        reachableResultsPerNode[n] = reachableResults(dfa, n);
    }

    // Calculate, which results have to be saved, because it's
    // not known if there will be a longer token.
    foreach (n; dfa.nodeIDs)
    {
        foreach (e; edgesPerNode[n])
        {
            if (e.isEndEdge)
                continue;
            bool[LexerAction] resNext;
            bool[LexerAction] reachableNext;
            if (e.next != NodeID.invalid)
            {
                foreach (res; dfa.get(e.next).results)
                {
                    resNext[res] = true;
                }
                foreach (res; reachableResultsPerNode[e.next])
                {
                    reachableNext[res] = true;
                }
            }
            if (e.next2 != NodeID.invalid)
            {
                bool[LexerAction] resNext2 = resNext;
                resNext = null;
                foreach (res; dfa.get(e.next2).results)
                {
                    if (e.next == NodeID.invalid || res in resNext2)
                        resNext[res] = true;
                }
                foreach (res; reachableResultsPerNode[e.next2])
                {
                    reachableNext[res] = true;
                }
            }
            foreach (res; dfa.get(n).results)
            {
                if (res.isNegLookahead)
                    continue;
                if (LexerAction(res.nonterminal, res.isIgnoreToken, true) in reachableNext)
                    continue;
                if (res !in resNext)
                    e.saveResult.addOnce(res);
            }
        }
    }

    CodepointSet[][G.NodeID] shortestPaths;
    void findShortestPaths(CodepointSet[] path, G.NodeID node)
    {
        if (node !in shortestPaths || path.length < shortestPaths[node].length)
        {
            shortestPaths[node] = path;
            CodepointSet[G.NodeID] edges;
            foreach (e; edgesPerNode[node])
            {
                if (e.isEndEdge)
                    continue;
                if (e.next.id != size_t.max)
                {
                    if (e.next !in edges)
                        edges[e.next] = e.set;
                    else
                        edges[e.next] |= e.set;
                }
                if (e.next2.id != size_t.max)
                {
                    if (e.next2 !in edges)
                        edges[e.next2] = e.set;
                    else
                        edges[e.next2] |= e.set;
                }
            }
            foreach (n; edges.sortedKeys)
            {
                findShortestPaths(path ~ edges[n], n);
            }
        }
    }

    findShortestPaths([], dfa.start);

    bool[G.NodeID] nodesWithCompare;
    foreach (n; dfa.nodeIDs)
    {
        foreach (e; dfa.getEdges(n))
        {
            if (e.flags & (EdgeFlags.compareStart | EdgeFlags.compareMiddle))
                nodesWithCompare[e.next] = true;
        }
    }

    void genCodeForNode(G.NodeID n)
    {
        string resultsComment;
        bool[LexerAction] resultDone;
        foreach (res; dfa.get(n).results)
        {
            resultDone[res] = true;
            resultsComment ~= " " ~ (res.isNegLookahead
                    ? "!" : "") ~ lexerGrammar.getSymbolName(res.nonterminal);
        }
        auto tmpReachableResults = reachableResultsPerNode[n];
        sort!((a, b) => a.nonterminal.id < b.nonterminal.id)(tmpReachableResults);
        foreach (res; tmpReachableResults)
        {
            if (res in resultDone)
                continue;
            resultsComment ~= " (" ~ (res.isNegLookahead
                    ? "!" : "") ~ lexerGrammar.getSymbolName(res.nonterminal) ~ ")";
        }
        code.writeln("//", resultsComment);

        code.write("// path:");
        if (n in shortestPaths)
            foreach (s; shortestPaths[n])
            {
                code.write(" ", codepointSetToStr(s));
            }
        code.writeln();

        if (n == dfa.start)
            code.decIndent.writeln("start:").incIndent;

        auto edges = edgesPerNode[n];
        CodepointSet allAllowedSet = allAllowedSets[n];

        EdgeData findBestNextEdge(CodepointSet codepointsStillPossible)
        {
            EdgeData best;
            foreach (e; edges)
            {
                CodepointSet eSet = e.set & codepointsStillPossible;
                CodepointSet eSet2 = restrictToAssumedCodepoints(e.set, codepointsStillPossible);
                if (eSet.empty)
                    continue;
                if (best is null)
                {
                    best = e;
                    continue;
                }
                CodepointSet bestSet = best.set & codepointsStillPossible;
                CodepointSet bestSet2 = restrictToAssumedCodepoints(best.set,
                        codepointsStillPossible);

                if (eSet2.byInterval.length < bestSet2.byInterval.length)
                    best = e;
                else if (eSet2.byInterval.length > bestSet2.byInterval.length)
                    continue;
                else if (eSet.length < bestSet.length)
                    best = e;
                else if (eSet.length > bestSet.length)
                    continue;
                else if (best.isEndEdge)
                    best = e;
                else
                {
                    auto eIntervals = eSet.byInterval;
                    auto bestIntervals = bestSet.byInterval;
                    while (!eIntervals.empty && !bestIntervals.empty)
                    {
                        if (eIntervals.front[0] < bestIntervals.front[0])
                        {
                            best = e;
                            break;
                        }
                        else if (eIntervals.front[0] > bestIntervals.front[0])
                        {
                            break;
                        }
                        else if (eIntervals.front[1] < bestIntervals.front[1])
                        {
                            best = e;
                            break;
                        }
                        else if (eIntervals.front[1] > bestIntervals.front[1])
                        {
                            break;
                        }
                        eIntervals.popFront;
                        bestIntervals.popFront;
                    }
                }
            }
            return best;
        }

        int getNonterminalPriority(NonterminalID nonterminal)
        {
            if (nonterminal == NonterminalID.invalid)
                return 0;
            if (lexerGrammar.nonterminals[nonterminal].annotations.contains!"ignoreToken"())
                return 1;
            if (lexerGrammar.nonterminals[nonterminal].annotations.contains!"lowPrio"())
                return 2;
            return 3;
        }

        const(LexerAction)[] filterActionConflicts(const(LexerAction)[] resultsAll)
        {
            LexerAction[] best;

            const(LexerAction)[] results;
            const(LexerAction)[] resultsNegLookahead;
            foreach (res; resultsAll)
                if (res.isNegLookahead)
                    resultsNegLookahead ~= res;

            foreach (res; resultsAll)
                if (!res.isNegLookahead)
                {
                    bool hasNegLookahead;
                    foreach (res2; resultsNegLookahead)
                        if (res.nonterminal == res2.nonterminal)
                            hasNegLookahead = true;
                    if (!hasNegLookahead)
                        results ~= res;
                }

            if (results.length <= 1)
                return results;

            foreach (res; results)
            {
                int resPriority = getNonterminalPriority(res.nonterminal);
                int bestPriority = (best.length > 0) ? getNonterminalPriority(best[0].nonterminal)
                    : 0;
                if (resPriority > bestPriority)
                    best = [res];
                else if (resPriority == bestPriority)
                    best ~= res; // conflict
            }
            if (best.length > 1
                    && lexerGrammar.nonterminals[best[0].nonterminal].annotations.contains!"ignoreToken"())
                best.length = 1;
            assert(best.length > 0);
            return best;
        }

        void genLexCode(bool ascii)
        {
            mixin(genCode("code", q{
                $$CodepointSet currentAllowedCodepoints = ascii ? unicode.ASCII : (unicode.ASCII.inverted);
                $$if (!ascii /*&& !(allAllowedSet & currentAllowedCodepoints).empty*/) {
                    string inputCopyNext = inputCopy;
                    import std.utf;

                    dchar currentDchar = decodeFront!(Yes.useReplacementDchar)(inputCopyNext);
                $$}
                $$bool needsElse = false;
                $$bool elseStillAllowed = true;
                $$CodepointSet codepointsStillPossible = currentAllowedCodepoints;
                $$while (true) {
                    $$EdgeData e = findBestNextEdge(codepointsStillPossible);
                    $$if (e is null) break;
                    $$if ((e.set & codepointsStillPossible).empty) continue;
                    $$assert(elseStillAllowed);
                    $(needsElse?"else":"")  _
                    $$if ((codepointsStillPossible - e.set).empty) {
                        $("")
                        $$elseStillAllowed = false;
                    $$} else {
                        $(needsElse?" ":"")if ($(codepointSetToCode(ascii?"currentChar":"currentDchar", e.set, codepointsStillPossible)))
                    $$}
                    {
                        $$if (e.isEndEdge) {
                            $$if (dfa.get(n).results.length > 0) {
                                goto endstate$(n.id);
                            $$} else if ((allAllowedSet.inverted & currentAllowedCodepoints).empty) {
                                assert(false);
                            $$} else {
                                $$if (inSubAutomaton) {
                                    if (hasPreviousSymbol)
                                        return false;
                                $$} else {
                                    if (foundSymbol != SymbolID.max)
                                        goto lexerend;
                                $$}
                                else
                                    throw lexerException(text("Error unexpected \'", $(ascii?"currentChar":"currentDchar").escapeChar(false), "\'"), "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                            $$}
                        $$} else {
                            $$needsElse = true;
                            $$if (e.saveResult.length > 0) {
                                $$auto filteredActionConflicts2 = filterActionConflicts(e.saveResult);
                                $$if (filteredActionConflicts2.length > 1) {
                                    foundSymbol = SymbolID.max;
                                $$} else {
                                    assert(inputCopy.ptr >= input.ptr);
                                    foundSymbol = tokenID!"$(lexerGrammar.getSymbolName(filteredActionConflicts2[0].nonterminal).escapeD)";
                                    foundLength = inputCopy.ptr - input.ptr;
                                    foundIsIgnore = $(filteredActionConflicts2[0].isIgnoreToken);
                                $$}
                            $$}
                            $$if (e.flags & EdgeFlags.storeEnd) {
                                assert(storedStart != size_t.max);
                                storedString = input[storedStart .. inputCopy.ptr - input.ptr];
                                storedStart = size_t.max;
                            $$}
                            $$if (e.flags & (EdgeFlags.compareStart | EdgeFlags.storeStart)) {
                                assert(storedStart == size_t.max);
                                storedStart = inputCopy.ptr - input.ptr;
                            $$}
                            $$if (e.flags & EdgeFlags.compareFlags) {
                                assert(storedStart != size_t.max);
                                string compareString = input[storedStart .. $(ascii ? "inputCopy.ptr + 1": "inputCopyNext.ptr") - input.ptr];
                                bool currentCharCorrect = compareString.length <= storedString.length && $(ascii?"currentChar == storedString[compareString.length - 1]" : "inputCopy[0 .. inputCopyNext.ptr - inputCopy.ptr] == storedString[compareString.length - (inputCopyNext.ptr - inputCopy.ptr)..compareString.length]");
                            $$}
                            $$if (ascii) {
                                inputCopy = inputCopy[1 .. $];
                            $$} else {
                                inputCopy = inputCopyNext;
                            $$}
                            $$if (e.flags & (EdgeFlags.compareFlags)) {
                                if (compareString.length == storedString.length && currentCharCorrect)
                                {
                                    $$if (e.flags & (EdgeFlags.compareEndTrue | EdgeFlags.compareEndFalse)) {
                                        assert(compareString == storedString);
                                        storedStart = size_t.max;
                                    $$}
                                    $$if (e.next3.id == size_t.max) {
                                        throw lexerException(text("Error unexpected \'", $(ascii?"currentChar":"currentDchar").escapeChar(false), "\'"), "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                                    $$} else {
                                        goto state$(e.next3.id);
                                    $$}
                                }
                                else if (compareString.length < storedString.length && currentCharCorrect)
                                {
                                    $$if (e.next2.id == size_t.max) {
                                        throw lexerException(text("Error unexpected \'", $(ascii?"currentChar":"currentDchar").escapeChar(false), "\'"), "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                                    $$} else {
                                        goto state$(e.next2.id);
                                    $$}
                                }
                                else
                                {
                                    storedStart = size_t.max;
                                    $$if (e.next.id == size_t.max) {
                                        throw lexerException(text("Error unexpected \'", $(ascii?"currentChar":"currentDchar").escapeChar(false), "\'"), "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                                    $$} else {
                                        goto state$(e.next.id);
                                    $$}
                                }
                            $$} else {
                                $$if (n in nodesWithCompare) {
                                    storedStart = size_t.max;
                                $$}
                                goto state$(e.next.id);
                            $$}
                        $$}
                    }
                    $$codepointsStillPossible = codepointsStillPossible - e.set;
                $$}
                $$assert(!elseStillAllowed);
                }));
        }

        code.writeln("{").incIndent;
        if (edges.length == 1 && edges[0].recursiveSequence.length)
        {
            code.writeln("// RecursiveLexer");
            SubAutomaton a;
            size_t i;
            foreach (i2, a2; subAutomatons)
                if (a2.recursiveSequence == edges[0].recursiveSequence)
                {
                    a = a2;
                    i = i2;
                    break;
                }
            code.writeln("if (lexPart", i, "(inputCopy, ", inSubAutomaton
                    ? "hasPreviousSymbol" : "foundSymbol != SymbolID.max", "))");
            code.writeln("    goto state", edges[0].next.id, ";");
            code.writeln("else");
            if (inSubAutomaton)
                code.writeln("    return false;");
            else
                code.writeln("    goto lexerend;");
        }
        else
        {
            mixin(genCode("code", q{
                if (inputCopy.length == 0)
                $$if (dfa.get(n).results.length >= 1) {
                        $$if (inSubAutomaton) {
                            $$enforce(dfa.getEdges(n).length == 0);
                            return true;
                        $$} else {
                            goto endstate$(n.id);
                        $$}
                $$} else {
                    {
                        $$if (inSubAutomaton) {
                            if (input.ptr == inputCopy.ptr)
                                return false;
                            else if (hasPreviousSymbol)
                                return false;
                        $$} else {
                            if (input.ptr == inputCopy.ptr)
                                goto lexerend;
                            else if (foundSymbol != SymbolID.max)
                                goto lexerend;
                        $$}
                        else
                            throw lexerException("EOF", "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                    }
                $$}
                $$if (!allAllowedSet.empty) {
                    char currentChar = inputCopy[0];
                    if (currentChar < 0x80)
                    {
                        $$genLexCode(true);
                    }
                    else
                    {
                        $$genLexCode(false);
                    }
                $$} else {
                    $$if (dfa.get(n).results.length > 0) {
                        $$if (inSubAutomaton) {
                            return true;
                        $$} else {
                            goto endstate$(n.id);
                        $$}
                    $$} else {
                        $$if (inSubAutomaton) {
                            if (hasPreviousSymbol)
                                return false;
                        $$} else {
                            if (foundSymbol != SymbolID.max)
                                goto lexerend;
                        $$}
                        else
                            throw lexerException("Error", "$(codepointSetToStr(allAllowedSet).escapeD)", inputCopy.ptr - input.ptr);
                    $$}
                $$}
                }));
        }
        code.decIndent.writeln("}");

        if (dfa.get(n).results.length > 0)
            code.writeln("endstate", n.id, ":");

        void genEndState(const(LexerAction)[] results)
        {
            auto filteredActionConflicts = filterActionConflicts(results);

            if (filteredActionConflicts.length == 0)
            {
                mixin(genCode("code", q{
                    {
                        if (foundSymbol != SymbolID.max)
                            goto lexerend;
                        else
                            throw lexerException("Error", "", inputCopy.ptr - input.ptr);
                    }
                    }));
            }
            else if (filteredActionConflicts.length > 1)
            {
                auto conflictNames = filteredActionConflicts.map!(
                        res => lexerGrammar.getSymbolName(res.nonterminal).escapeD).join(' ');
                stderr.writeln("Warning: Lexer conflict for ", conflictNames);
                mixin(genCode("code", q{
                        throw lexerException("conflict $(conflictNames)", "", inputCopy.ptr - input.ptr);
                    }));
            }
            else if (filteredActionConflicts.length == 1)
            {
                mixin(genCode("code", q{
                    {
                        assert(inputCopy.ptr >= input.ptr);
                        foundSymbol = tokenID!"$(lexerGrammar.getSymbolName(filteredActionConflicts[0].nonterminal).escapeD)";
                        foundLength = inputCopy.ptr - input.ptr;
                        foundIsIgnore = $(filteredActionConflicts[0].isIgnoreToken);
                        goto lexerend;
                    }
                    }));
            }
        }

        void genEndStateRek(const(LexerAction)[] resultsIn, const(LexerAction)[] results)
        {
            if (resultsIn.length == 0)
                genEndState(results);
            else if (
                lexerGrammar.nonterminals[resultsIn[0].nonterminal].annotations.contains!"inContextOnly"())
            {
                mixin(genCode("code", q{
                        if (allowToken!$(lexerGrammar.nonterminals[resultsIn[0].nonterminal].name.tokenDCode))
                        $$genEndStateRek(resultsIn[1 .. $], results ~ resultsIn[0]);
                        else
                        $$genEndStateRek(resultsIn[1 .. $], results);
                    }));
            }
            else
                genEndStateRek(resultsIn[1 .. $], results ~ resultsIn[0]);
        }

        if (!inSubAutomaton && dfa.get(n).results.length > 0)
            genEndStateRek(dfa.get(n).results, []);

        code.writeln();
    }

    foreach (n; dfa.nodeIDs)
    {
        code.decIndent.writeln("state", n.id, ":").incIndent;
        genCodeForNode(n);
    }
}

void removeMinimalMatchEdges(Graph!(DCharToken, LexerAction) g, EBNFGrammar lexerGrammar)
{
    foreach (n; g.nodeIDs)
    {
        if (g.get(n).results.length == 0)
            continue;
        bool allMinimalMatch = true;
        foreach (res; g.get(n).results)
            if (!lexerGrammar.nonterminals[res.nonterminal].annotations.contains!"minimalMatch")
                allMinimalMatch = false;
        if (allMinimalMatch)
        {
            g.get(n).edges = [];
        }
    }
}

const(char)[] createLexerCode(EBNFGrammar lexerGrammar, string modulename, string dfafilename)
{
    CodeWriter code;
    code.indentStr = "    ";

    string allTokensCode = createAllTokensCode(lexerGrammar);
    string allNonterminalsCode = createAllNonterminalsCode(lexerGrammar);

    alias G = Graph!(DCharToken, LexerAction);
    alias NodeID = G.NodeID;

    G graph = new G();

    string symbolName(Symbol s)
    {
        return lexerGrammar.getSymbolName(s);
    }

    string tokenName(DCharToken s)
    {
        return codepointSetToStr(*s.codepoints);
    }

    string edgeText(G.Edge[] edges)
    {
        string r;

        CodepointSet set;

        bool hasEmpty;

        foreach (e; edges)
        {
            if (e.symbol.recursiveSequence.length)
                r ~= text("RecursiveLexer");
            else if (e.symbol.codepoints is null)
                hasEmpty = true;
            else
                set |= *e.symbol.codepoints;
        }

        if (hasEmpty)
        {
            r ~= "ε";
        }

        if (!hasEmpty || !set.empty)
        {
            if (r.length > 0)
                r ~= "\n";

            r ~= codepointSetToStr(set);
        }
        EdgeFlags combinedFlags;
        foreach (e; edges)
        {
            combinedFlags |= e.flags | e.symbol.specialFlags;
        }
        if (combinedFlags & EdgeFlags.storeStart)
            r ~= text("\nStoreStart");
        if (combinedFlags & EdgeFlags.storeEnd)
            r ~= text("\nStoreEnd");
        if (combinedFlags & EdgeFlags.compareStart)
            r ~= text("\nCompareStart");
        if (combinedFlags & EdgeFlags.compareEndTrue)
            r ~= text("\nCompareEndTrue");
        if (combinedFlags & EdgeFlags.compareEndFalse)
            r ~= text("\nCompareEndFalse");
        if (combinedFlags & EdgeFlags.compareMiddle)
            r ~= text("\nCompareMiddle");
        return r;
    }

    string resultsText(G graph, G.NodeID node)
    {
        string r;

        string resultName(LexerAction res)
        {
            string r;
            if (res.nonterminal != NonterminalID.invalid)
            {
                if (res.isNegLookahead)
                    r ~= "!";
                r ~= text(lexerGrammar.getSymbolName(res.nonterminal));
                if (
                    lexerGrammar.nonterminals[res.nonterminal].annotations.contains!"ignoreToken"())
                    r ~= " IgnoreToken";
            }
            else
                r ~= "invalid";

            if (res.isIgnoreToken)
                r ~= " ignore";
            return r;
        }

        bool[LexerAction] done;
        foreach (res; graph.get(node).results)
        {
            done[res] = true;
            r ~= text(resultName(res), "\n");
        }
        foreach (res; reachableResults(graph, node))
        {
            if (res in done)
                continue;
            r ~= text("(", resultName(res), ")\n");
        }

        return r;
    }

    CodepointSet*[] codepointSets;
    void addCodepointSet(CodepointSet set)
    {
        for (size_t i = 0; i < codepointSets.length; i++)
        {
            if (set == *codepointSets[i])
                return;
            if (!(set & *codepointSets[i]).empty)
            {
                CodepointSet both = set & *codepointSets[i];
                CodepointSet first = *codepointSets[i] - set;
                set = set - *codepointSets[i];
                *codepointSets[i] = both;
                if (!first.empty)
                    codepointSets ~= new CodepointSet(first);
            }
        }
        if (!set.empty)
        {
            codepointSets ~= new CodepointSet(set);
        }
    }

    void updateCodepointSets(string name)
    {
        if (name.endsWith("\""))
        {
            assert(name[$ - 1] == name[0], name);
            name = name[1 .. $ - 1];
            foreach (d; name.byDchar.byUnescapedDchar)
            {
                addCodepointSet(CodepointSet(d.c, d.c + 1));
            }
        }
        else if (name.endsWith("]"))
        {
            assert(name[0] == '[', name);
            name = name[1 .. $ - 1];
            CodepointSet set = codepointSetFromStr(name);
            addCodepointSet(set);
        }
        else if (name.endsWith("\'"))
        {
            throw new Exception("not implemented");
        }
    }

    foreach (n; lexerGrammar.startNonterminals)
    {
        string name = lexerGrammar.nonterminals[n.nonterminal].name;
        updateCodepointSets(name);
    }
    foreach (p; lexerGrammar.productions)
    {
        foreach (i, s; p.symbols)
        {
            string name = lexerGrammar.getSymbolName(s);
            updateCodepointSets(name);
        }
    }

    {
        CodepointSet combined;
        foreach (set; codepointSets)
        {
            assert((combined & *set).empty);
            combined |= *set;
        }
    }

    graph.start = graph.addNode("start");

    Graph!(DCharToken, LexerAction)[NonterminalID] graphByNonterminal;

    foreach (n; lexerGrammar.nonterminals.allIDs())
    {
        if (!lexerGrammar.nonterminals[n].annotations.contains!"ignoreToken"())
            continue;

        string name = lexerGrammar.nonterminals[n].name;
        NodeID startM = graph.addNode("start " ~ name);
        graph.addEdge(graph.start, startM, DCharToken.invalid);
        NodeID endM = graph.addNode("end");
        graph.get(endM).results = [LexerAction(n, true)];

        genGraphForNonterminal(lexerGrammar, graph, codepointSets, n, startM,
                endM, graphByNonterminal);
    }

    foreach (n; lexerGrammar.startNonterminals)
    {
        string name = lexerGrammar.nonterminals[n.nonterminal].name;
        NodeID startM = graph.addNode("start " ~ name);
        graph.addEdge(graph.start, startM, DCharToken.invalid);
        NodeID endM = graph.addNode("end");
        graph.get(endM).results = [LexerAction(n.nonterminal)];

        genGraphForNonterminal(lexerGrammar, graph, codepointSets,
                n.nonterminal, startM, endM, graphByNonterminal);
    }

    foreach (n; graph.nodeIDs)
    {
        graph.get(n).name = text(n.id);
    }

    graph = graph.makeDeterministic(graph.start);

    foreach (n; graph.nodeIDs)
    {
        G.Node node = graph.get(n);
        G.Edge[] edges = node.edges;
        node.edges = [];

        foreach (e; edges)
        {
            assert((e.symbol.codepoints !is null) + (
                    e.symbol.specialFlags != EdgeFlags.none) + (
                    e.symbol.recursiveSequence.length != 0) == 1);
            if (e.symbol.codepoints is null && e.symbol.recursiveSequence.length == 0)
            {
                assert(e.next != n);
                foreach (e2; graph.get(e.next).edges)
                {
                    assert(e2.symbol.codepoints !is null);
                    graph.addEdge(n, e2.next, e2.symbol,
                            e2.flags | e.symbol.specialFlags, e2.extra);
                }
            }
            else
            {
                node.edges ~= e;
            }
        }
    }
    graph = graph.makeDeterministic(graph.start);

    foreach (res; graph.get(graph.start).results)
    {
        if (lexerGrammar.nonterminals[res.nonterminal].annotations.contains!"ignoreToken"())
            continue;
        stderr.writeln("Warning: Token ",
                lexerGrammar.getSymbolName(res.nonterminal), " could be empty");
    }

    // Make sure, no token can be empty.
    {
        auto oldStart = graph.start;
        graph.start = graph.addNode("start");
        graph.get(graph.start).edges = graph.get(oldStart).edges.dup;
        graph = graph.makeDeterministic(graph.start);
    }

    graph = graph.minimizeDFA;

    graph.removeMinimalMatchEdges(lexerGrammar);
    graph = graph.minimizeDFA;

    if (dfafilename.length)
        graph.toGraphViz2!(edgeText, resultsText)(dfafilename);

    SubAutomaton[] subAutomatons;
    void addSubAutomatons(G graph)
    {
        foreach (n; graph.nodeIDs)
        {
            foreach (e; graph.getEdges(n))
            {
                if (e.symbol.recursiveSequence.length)
                {
                    size_t i;
                    for (i = 0; i < subAutomatons.length; i++)
                    {
                        if (subAutomatons[i].recursiveSequence == e.symbol.recursiveSequence)
                            break;
                    }
                    if (i >= subAutomatons.length)
                    {
                        SubAutomaton a = new SubAutomaton;
                        a.recursiveSequence = e.symbol.recursiveSequence;
                        subAutomatons ~= a;
                    }
                }
            }
        }
    }

    addSubAutomatons(graph);

    EBNFGrammar grammar2 = new EBNFGrammar(null);
    grammar2.nonterminals = lexerGrammar.nonterminals.dup;
    grammar2.tokens = lexerGrammar.tokens.dup;
    grammar2.productionsData = lexerGrammar.productionsData;

    for (size_t i = 0; i < subAutomatons.length; i++)
    {
        NonterminalID n = grammar2.nonterminals.id(text("$m_", i));
        grammar2.addProduction(new Production(n, subAutomatons[i].recursiveSequence));

        auto graph2 = genGraphForNonterminal(grammar2, codepointSets, n, graphByNonterminal);

        subAutomatons[i].dfa = graph2;
        addSubAutomatons(subAutomatons[i].dfa);
    }

    mixin(genCode("code", q{
        // Generated with DParserGen.
        module $(modulename);
        import dparsergen.core.grammarinfo;
        import dparsergen.core.parseexception;
        import dparsergen.core.utils;
        import std.conv;
        import std.string;
        import std.typecons;

        enum SymbolID startTokenID = $(lexerGrammar.startTokenID);
        static assert(allNonterminalTokens.length < SymbolID.max - startTokenID);
        enum SymbolID endTokenID = startTokenID + allNonterminalTokens.length;

        SymbolID getTokenID(string tok)
        {
            foreach (i; 0 .. allNonterminalTokens.length)
                if (allNonterminalTokens[i].name == tok)
                    return cast(SymbolID)(startTokenID + i);
            return SymbolID.max;
        }

        struct Lexer(Location, bool includeIgnoredTokens = false)
        {
            alias LocationDiff = typeof(Location.init - Location.init);
            string input;
            this(string input, Location startLocation = Location.init)
            {
                this.input = input;
                this.front.currentLocation = startLocation;
                popFront;
            }

            enum tokenID(string tok) = getTokenID(tok);
            string tokenName(size_t id)
            {
                return allNonterminalTokens[id - startTokenID].name;
            }

            static struct Front
            {
                string content;
                SymbolID symbol;
                Location currentLocation;
                static if (includeIgnoredTokens)
                    bool isIgnoreToken;

                Location currentTokenEnd()
                {
                    return currentLocation + LocationDiff.fromStr(content);
                }
            }

            Front front;
            bool empty;

            $$foreach (t; lexerGrammar.nonterminals.allIDs) {
                $$if (lexerGrammar.nonterminals[t].annotations.contains!"inContextOnly"()) {
                    // InContextOnly: $(lexerGrammar.nonterminals[t].name)
                    bool allowTokenId$(t.id);
                    bool allowToken(string tok)() if (tok == $(lexerGrammar.nonterminals[t].name.tokenDCode))
                    {
                        return allowTokenId$(t.id);
                    }
                    void allowToken(string tok)(bool b) if (tok == $(lexerGrammar.nonterminals[t].name.tokenDCode))
                    {
                        allowTokenId$(t.id) = b;
                    }

                $$}
            $$}
            void popFront()
            {
                input = input[front.content.length .. $];
                front.currentLocation = front.currentLocation + LocationDiff.fromStr(front.content);

                popFrontImpl();
            }

            void popFrontImpl()
            {
                size_t foundLength;
                SymbolID foundSymbol = SymbolID.max;
                bool foundIsIgnore;

                string inputCopy = input;

                size_t storedStart = size_t.max;
                string storedString;

                goto start;

                $$generateStateMachine(code, lexerGrammar, graph, false, subAutomatons);
                lexerend:

                if (foundSymbol != SymbolID.max)
                {
                    if (foundLength == 0)
                    {
                        if (!inputCopy.empty)
                            throw lexerException("no token", null, inputCopy.ptr + 1 - input.ptr);
                        else
                        {
                            front.content = "";
                            front.symbol = SymbolID(0);
                            static if (includeIgnoredTokens)
                                front.isIgnoreToken = false;
                            empty = true;
                            return;
                        }
                    }
                    static if (!includeIgnoredTokens)
                    {
                        if (foundIsIgnore)
                        {
                            front.currentLocation = front.currentLocation + LocationDiff.fromStr(input[0 .. foundLength]);
                            input = input[foundLength .. $];
                            inputCopy = input;
                            foundLength = 0;
                            foundIsIgnore = false;
                            foundSymbol = SymbolID.max;
                            storedStart = size_t.max;
                            storedString = null;
                            goto start;
                        }
                    }
                    front.content = input[0 .. foundLength];
                    front.symbol = foundSymbol;
                    static if (includeIgnoredTokens)
                        front.isIgnoreToken = foundIsIgnore;
                    empty = false;
                    return;
                }
                else if (input.length == 0)
                {
                    front.content = "";
                    front.symbol = SymbolID(0);
                    static if (includeIgnoredTokens)
                        front.isIgnoreToken = false;
                    empty = true;
                    return;
                }
                else
                    throw lexerException("no token", null, 1);
            }

            $$foreach (i, a; subAutomatons) {
                // $(lexerGrammar.symbolInstanceToString(a.recursiveSequence))
                private bool lexPart$(i)(ref string inputCopy, bool hasPreviousSymbol)
                {
                    $$generateStateMachine(code, grammar2, subAutomatons[i].dfa, true, subAutomatons);
                    assert(false);
                }

            $$}
            SingleParseException!Location lexerException(string errorText, string expected, size_t len,
                    string file = __FILE__, size_t line = __LINE__)
            {
                string str = errorText;
                if (expected.length)
                    str ~= ", expected " ~ expected;
                return new SingleParseException!Location(str, front.currentLocation, front.currentLocation, file, line);
            }
        }

        immutable allNonterminalTokens = [
        $(allNonterminalsCode)];
        }));

    return code.data;
}
