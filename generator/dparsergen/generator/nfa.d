
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.nfa;
import dparsergen.core.utils;
import dparsergen.generator.ids;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.typecons;

struct HybridSet(ID)
{
    ID[] data;
    BitSet!ID alreadySetBits;
    size_t graphPointer;
    this(size_t l, size_t graphPointer)
    {
        this.graphPointer = graphPointer;
        alreadySetBits = BitSet!ID(l);
    }

    private bool isSetImpl(ID i) const
    {
        assert(i.graphPointer == graphPointer);
        return alreadySetBits[i];
    }

    bool opIndex(ID i) const
    {
        return isSetImpl(i);
    }

    void opIndexAssign(bool value, ID i)
    {
        assert(i.graphPointer == graphPointer, text(i.graphPointer, " == ", graphPointer));
        assert(value);
        if (!isSetImpl(i))
            data ~= i;
        alreadySetBits[i] = value;
        assert(alreadySetBits[i] == value);
    }

    inout(ID)[] bitsSet() inout
    {
        return data;
    }

    void reset()
    {
        if (data.length)
        {
            data = [];
            alreadySetBits.arr[] = false;
        }
    }
}

unittest
{
    struct ID
    {
        size_t id;
        size_t graphPointer;
        enum invalid = ID(size_t.max);
    }

    HybridSet!ID h = HybridSet!ID(10000, 0);
    assert(h.bitsSet.array == []);
    h[ID(42)] = true;
    assert(h.bitsSet.array == [ID(42)]);
    h[ID(100)] = true;
    assert(h.bitsSet.array == [ID(42), ID(100)]);
}

alias Set = HybridSet;

enum EdgeFlags
{
    none = 0,
    recEdge = 1,
    backwards = 2,
    matchingTokenEdge = 4,
    storeStart = 0x40,
    storeEnd = 0x80,
    compareStart = 0x100,
    compareMiddle = 0x200,
    compareEndTrue = 0x400,
    compareEndFalse = 0x800,
    storeFlags = storeStart | storeEnd,
    compareFlags = compareStart | compareMiddle | compareEndTrue | compareEndFalse,
    matchingFlags = storeFlags | compareFlags // Flags have to match, to treat edges the same
}

final class Graph(Symbol_, Result_, EdgeExtra_ = string)
{
    alias Symbol = Symbol_;
    alias Result = Result_;
    alias EdgeExtra = EdgeExtra_;
    struct NodeID
    {
        size_t id = size_t.max;
        size_t graphPointer;
        enum invalid = NodeID(size_t.max);

        int opCmp(NodeID other) const
        {
            if (id == size_t.max && other.id == size_t.max)
                return 0;
            if (id == size_t.max)
                return -1;
            if (other.id == size_t.max)
                return 1;
            assert(graphPointer == other.graphPointer);
            if (id < other.id)
                return -1;
            if (id > other.id)
                return 1;
            return 0;
        }
    }

    struct Edge
    {
        Symbol symbol;
        NodeID next;
        EdgeExtra extra;
        EdgeFlags flags;
    }

    static class Node
    {
        string name; // for debugging
        Edge[] edges;
        immutable(Result)[] results;
        override string toString() const
        {
            return text("Node ", name);
        }
    }

    size_t graphPointer() const
    {
        return cast(size_t) cast(void*) this;
    }

    Node[] nodes;
    NodeID start, end;
    NodeID[] otherStarts;

    NodeID[2][] invisibleEdges;

    auto nodeIDs() const
    {
        static struct R
        {
            const Graph graph;
            size_t i;
            bool empty() const
            {
                return i >= graph.nodes.length;
            }

            NodeID front() const
            {
                return NodeID(i, graph.graphPointer);
            }

            void popFront()
            {
                i++;
            }
        }

        return R(this);
    }

    Node get(const NodeID i)
    in (i.graphPointer == graphPointer)
    do
    {
        return nodes[i.id];
    }

    NodeID getNext(NodeID n, Symbol s, EdgeFlags flags = EdgeFlags.none)
    {
        foreach (e; getEdges(n))
        {
            if (e.symbol == s
                    && (e.flags & EdgeFlags.matchingFlags) == (flags & EdgeFlags.matchingFlags))
                return e.next;
        }
        return NodeID.invalid;
    }

    Edge* getNextEdge(NodeID n, Symbol s, EdgeFlags flags = EdgeFlags.none)
    {
        foreach (ref e; getEdges(n))
        {
            if (e.symbol == s
                    && (e.flags & EdgeFlags.matchingFlags) == (flags & EdgeFlags.matchingFlags))
                return &e;
        }
        return null;
    }

    NodeID addNode(string name, immutable(Result)[] results = [])
    {
        auto n = new Node();
        n.name = name;
        n.results = results;
        nodes ~= n;
        return NodeID(nodes.length - 1, graphPointer);
    }

    void addEdge(NodeID from, NodeID to, Symbol symbol, EdgeFlags flags = EdgeFlags.none,
            EdgeExtra extra = EdgeExtra.init, size_t line = __LINE__)
    in
    {
        assert(from.graphPointer == graphPointer);
        assert(to.graphPointer == graphPointer);
    }
    do
    {
        get(from).edges ~= Edge(symbol, to, extra, flags);
    }

    NodeID nodeID(size_t i)
    {
        assert(i < nodes.length);
        return NodeID(i, cast(size_t) cast(void*) this);
    }

    NodeID[2] addCopy(Graph src)
    {
        immutable delta = nodes.length;
        nodes.length += src.nodes.length;
        foreach (i, n; src.nodes)
        {
            Node n2 = new Node();
            n2.name = n.name;
            n2.results = n.results;
            n2.edges.length = n.edges.length;
            foreach (k, e; n.edges)
            {
                n2.edges[k] = Edge(e.symbol, NodeID(e.next.id + delta,
                        cast(size_t) cast(void*) this), EdgeExtra.init, e.flags);
            }
            nodes[i + delta] = n2;
        }
        return [
            NodeID(src.start.id + delta, cast(size_t) cast(void*) this),
            NodeID(src.end.id + delta, cast(size_t) cast(void*) this)
        ];
    }

    Edge[] getEdges(NodeID nodeID)
    {
        return get(nodeID).edges;
    }

    Set!NodeID createSet() const
    {
        return Set!(NodeID)(nodes.length, graphPointer);
    }
}

void simulate(G)(G graph, Set!(G.NodeID) current, G.Symbol symbol,
        ref Set!(G.NodeID) next, EdgeFlags flags = EdgeFlags.none)
in
{
    assert(current.graphPointer == graph.graphPointer);
    assert(next.graphPointer == graph.graphPointer);
}
do
{
    foreach (node; current.bitsSet)
    {
        foreach (e; graph.getEdges(node))
        {
            auto eflags = e.flags;
            if ((flags & EdgeFlags.matchingFlags) && !(e.flags & EdgeFlags.matchingFlags))
                eflags |= flags & EdgeFlags.compareFlags;
            if (e.symbol == symbol
                    && (eflags & EdgeFlags.matchingFlags) == (flags & EdgeFlags.matchingFlags))
            {
                next[e.next] = true;
            }
        }
    }
    completeEmpty!G(graph, next);
}

Set!(G.NodeID) simulate(G)(G graph, Set!(G.NodeID) current, G.Symbol symbol)
in
{
    assert(current.graphPointer == graph.graphPointer);
}
do
{
    assert(current.graphPointer == graph.graphPointer);
    Set!(G.NodeID) next = graph.createSet();
    simulate!G(graph, current, symbol, next);
    return next;
}

void completeEmpty(G)(G graph, ref Set!(G.NodeID) current)
in
{
    assert(current.graphPointer == graph.graphPointer);
}
do
{
    void add(G.NodeID node)
    {
        foreach (e; graph.getEdges(node))
        {
            if (e.symbol == G.Symbol.invalid)
            {
                if (current[e.next])
                    continue;
                current[e.next] = true;
                add(e.next);
            }
        }
    }

    foreach (node; current.bitsSet)
    {
        add(node);
    }
}

Set!(G.NodeID) simulate(G)(G graph, G.NodeID start, G.Symbol[] input)
in
{
    assert(start.graphPointer == graph.graphPointer);
}
do
{
    Set!(G.NodeID) current = graph.createSet();
    current[start] = true;
    completeEmpty!G(graph, current);
    foreach (s; input)
    {
        current = simulate!G(graph, current, s);
    }
    return current;
}

G.Result[] reachableResults(G)(G graph, G.NodeID start)
in
{
    assert(start.graphPointer == graph.graphPointer);
}
do
{
    bool[G.NodeID] done;
    bool[G.Result] results;
    void findReachable(G.NodeID node)
    {
        if (node in done)
            return;
        done[node] = true;
        foreach (r; graph.get(node).results)
        {
            results[r] = true;
        }
        foreach (e; graph.get(node).edges)
        {
            findReachable(e.next);
        }
    }

    findReachable(start);
    G.Result[] resultsArr;
    foreach (r, v; results)
    {
        resultsArr ~= r;
    }
    return resultsArr;
}

Graph!(G.Symbol, G.Result, G.EdgeExtra) makeDeterministic(G)(G inputGraph, G.NodeID start,
        bool stopOnSingleResult = false,
        immutable(G.Result)[]delegate(immutable(G.Result)[]) filterResult = null)
in
{
    assert(start.graphPointer == inputGraph.graphPointer);
}
do
{
    alias Symbol = G.Symbol;
    alias Result = G.Result;
    alias NodeID = G.NodeID;
    alias EdgeExtra = G.EdgeExtra;
    alias Node = G.Node;
    Graph!(Symbol, Result, EdgeExtra) g = new Graph!(Symbol, Result, EdgeExtra)();
    Set!NodeID startset = inputGraph.createSet();
    startset[start] = true;
    completeEmpty!G(inputGraph, startset);

    NodeID[immutable(NodeID)[]] states;
    size_t uniqueID;
    NodeID add(Set!NodeID s, size_t depth)
    {
        NodeID[] atmp = s.bitsSet.array;
        atmp.sort!"a.id < b.id"();
        immutable NodeID[] a = atmp.idup;
        if (a in states)
            return states[a];
        NodeID nodeID = g.addNode(text(uniqueID++ /*s.bitsSet.map!(n=>inputGraph.get(n).name[]).joiner("\\n")*/ ));
        Node node = g.get(nodeID);
        states[a] = nodeID;
        static struct NodeEdgeID
        {
            NodeID nodeID;
            size_t edgeID;
        }

        NodeEdgeID[Tuple!(Symbol, EdgeFlags)] done;
        Set!NodeID next = inputGraph.createSet();
        foreach (n; s.bitsSet)
        {
            addOnce(node.results, inputGraph.get(n).results);
        }
        if (filterResult !is null)
            node.results = filterResult(node.results);
        if (stopOnSingleResult)
        {
            if (node.results.length <= 1)
                return nodeID;
        }
        foreach (n; s.bitsSet)
        {
            foreach (e; inputGraph.getEdges(n))
            {
                if (e.symbol == Symbol.invalid)
                    continue;
                auto key = tuple!(Symbol, EdgeFlags)(e.symbol, e.flags & EdgeFlags.matchingFlags);
                if (key in done)
                {
                    g.getEdges(done[key].nodeID)[done[key].edgeID].extra ~= e.extra;
                    continue;
                }
                next.reset();
                simulate!G(inputGraph, s, e.symbol, next, e.flags);
                node.edges ~= G.Edge(e.symbol, add(next, depth + 1), e.extra, e.flags);
                done[key] = NodeEdgeID(nodeID, node.edges.length - 1);
            }
        }
        return nodeID;
    }

    g.start = add(startset, 0);

    return g;
}

string defaultNodeResultsText(G)(G graph, G.NodeID node)
{
    return text(graph.get(node).results);
}

void toGraphViz(alias tokenName = text, alias resultsText = defaultNodeResultsText, G)(G g,
        string filename)
{
    toGraphViz2!((ts) => ts.map!(e => text(tokenName(e.symbol), " (", e.extra,
            ")")).join("\n"), resultsText, G)(g, filename);
}

void toGraphViz2(alias tokensName = (ts) => ts.map!(t => text(t)).join("\n"),
        alias resultsText = defaultNodeResultsText, G)(G g, string filename)
{
    File f = File(filename, "w");
    f.writeln("digraph G {");
    f.writeln("\trankdir=LR;");
    f.writeln("\tgraph [fontname = \"arial\"];");
    f.writeln("\tnode [fontname = \"arial\"];");
    f.writeln("\tedge [fontname = \"arial\"];");
    f.writeln("\tnode[shape = circle];");
    toGraphViz2!(tokensName, resultsText, G)(g, f);
    f.writeln("\t\"\" [shape = none];");
    if (g.start != G.NodeID.invalid)
        f.writeln("\t\"\" -> \"node", g.start.id, "\";");
    foreach (s; g.otherStarts)
        f.writeln("\t\"\" -> \"node", s.id, "\";");
    f.writeln("}");
}

void toGraphViz(alias tokenName = text, alias resultsText = defaultNodeResultsText, G)(G g,
        File f, size_t idoffset = 0)
{
    toGraphViz2!((ts) => ts.map!(e => text(tokenName(e.symbol), " (", e.extra,
            ")")).join("\n"), resultsText, G)(g, f, idoffset);
}

void toGraphViz2(alias tokensName, alias resultsText, G)(G g, File f, size_t idoffset = 0)
{
    string nodeStr(G.NodeID nid)
    {
        return text("\"node", nid.id + idoffset, "\"");
    }

    foreach (id; g.nodeIDs)
    {
        auto n = g.get(id);
        f.write("\t", nodeStr(id), " [");
        string label = n.name;
        if (n.results.length > 0)
        {
            f.writeln("shape = doublecircle");
        }
        label ~= "\n" ~ resultsText(g, id);
        f.write("  label =\"", label.escapeD, "\"");
        f.writeln("];");
        struct Key
        {
            G.NodeID next;
            bool backwards;
            EdgeFlags flags;
        }

        G.Edge[][Key] edgeBuckets;
        foreach (e; g.getEdges(id))
        {
            Key key = Key(e.next, (e.flags & EdgeFlags.backwards) != 0,
                    e.flags & EdgeFlags.matchingFlags);
            if (key !in edgeBuckets)
                edgeBuckets[key] = [];
            edgeBuckets[key] ~= e;
        }
        foreach (key, e; edgeBuckets)
        {
            if (key.backwards)
                f.writeln("\t", nodeStr(key.next), " -> ", nodeStr(id),
                        " [ label = \"", tokensName(e).escapeD, "\"",
                        (e.any!(x => (x.flags & EdgeFlags.matchingTokenEdge) != 0)
                            ? " arrowType=tee" : ""), " dir=back", "];");
            else
                f.writeln("\t", nodeStr(id), " -> ", nodeStr(key.next),
                        " [ label = \"", tokensName(e).escapeD, "\"",
                        (e.any!(x => (x.flags & EdgeFlags.matchingTokenEdge) != 0)
                            ? " arrowType=tee" : ""), "];");
        }
    }
    foreach (e; g.invisibleEdges)
    {
        f.writeln("\t", nodeStr(e[0]), " -> ", nodeStr(e[1]), " [ label = \"\" style=dashed];");
    }
}

Graph!(Symbol, Result, EdgeExtra) minimizeDFA(Symbol, Result, EdgeExtra)(
        Graph!(Symbol, Result, EdgeExtra) g, bool verbose = false, bool anyEdges = false)
{
    alias NodeID = Graph!(Symbol, Result, EdgeExtra).NodeID;

    NodeID[][] partitions;
    foreach (node; g.nodeIDs)
    {
        bool found = false;
        foreach (ref p; partitions)
        {
            bool[Result] resFound;
            bool areEqual = true;
            foreach (res; g.get(node).results)
            {
                resFound[res] = true;
            }
            foreach (res; g.get(p[0]).results)
            {
                if (res !in resFound)
                    areEqual = false;
                resFound[res] = false;
            }
            foreach (res, x; resFound)
                if (x)
                    areEqual = false;
            if (areEqual)
            {
                p ~= node;
                found = true;
            }
        }
        if (!found)
        {
            partitions ~= [node];
        }
    }

    void printPartitions()
    {
        writeln("partitions:");
        foreach (i, p; partitions)
            writeln(i, ": ", p.map!(n => g.get(n).name).join(", "));
    }

    if (verbose)
        printPartitions();

    bool changed;
    size_t[NodeID] partitionIDs;

    void updatePartitionIDs()
    {
        partitionIDs = null;
        foreach (i, p; partitions)
        {
            foreach (n; p)
                partitionIDs[n] = i;
        }
    }

    do
    {
        updatePartitionIDs();

        NodeID[][] newPartitions;
        foreach (p; partitions)
        {
            if (!anyEdges)
            {
                alias Key = Tuple!(Symbol, EdgeFlags);
                NodeID[][size_t[Key]] next;

                foreach (node; p)
                {
                    size_t[Key] edgePartitions;
                    foreach (e; g.get(node).edges)
                    {
                        edgePartitions[Key(e.symbol, e.flags & EdgeFlags.matchingFlags)] = partitionIDs[e
                            .next];
                    }
                    next[edgePartitions] ~= node;
                }
                foreach (p2; next)
                    newPartitions ~= p2;
            }
            else
            {
                NodeID[][immutable(size_t)[]] next;
                foreach (node; p)
                {
                    size_t[] nextNodes;
                    foreach (e; g.get(node).edges)
                    {
                        nextNodes.addOnce(partitionIDs[e.next]);
                    }
                    nextNodes.sort();
                    next[nextNodes.idup] ~= node;
                }

                foreach (p2; next)
                {
                    alias Key = Tuple!(Symbol, EdgeFlags);
                    NodeID[][] newPartitions2;
                    size_t[Key][] partitionEdges;

                    foreach (node; p2)
                    {
                        bool good;
                        foreach (i; 0 .. newPartitions2.length)
                        {
                            good = true;
                            foreach (e; g.get(node).edges)
                            {
                                auto key = Key(e.symbol, e.flags & EdgeFlags.matchingFlags);
                                if (key in partitionEdges[i]
                                        && partitionEdges[i][key] != partitionIDs[e.next])
                                {
                                    good = false;
                                    break;
                                }
                            }
                            if (good)
                            {
                                foreach (e; g.get(node).edges)
                                {
                                    auto key = Key(e.symbol, e.flags & EdgeFlags.matchingFlags);
                                    partitionEdges[i][key] = partitionIDs[e.next];
                                }
                                newPartitions2[i] ~= node;
                                break;
                            }
                        }
                        if (!good)
                        {
                            newPartitions2 ~= [node];
                            partitionEdges ~= null;
                            foreach (e; g.get(node).edges)
                            {
                                auto key = Key(e.symbol, e.flags & EdgeFlags.matchingFlags);
                                partitionEdges[$ - 1][key] = partitionIDs[e.next];
                            }
                        }
                    }

                    newPartitions ~= newPartitions2;
                }
            }
        }
        changed = newPartitions.length > partitions.length;
        partitions = newPartitions;

        if (verbose)
            printPartitions();
    }
    while (changed);

    NodeID[NodeID] nodeEquivalentMap;

    foreach (p; partitions)
    {
        foreach (n; p[1 .. $])
            nodeEquivalentMap[n] = p[0];
    }
    updatePartitionIDs();

    Graph!(Symbol, Result, EdgeExtra) r = new Graph!(Symbol, Result, EdgeExtra)();
    NodeID[NodeID] nodeMap;
    size_t uniqueNr;
    foreach (n; g.nodeIDs)
    {
        NodeID rn = n;
        while (rn in nodeEquivalentMap)
            rn = nodeEquivalentMap[rn];

        if (rn !in nodeMap)
        {
            string name = partitions[partitionIDs[n]].map!(i => i.id.text).join(", ");
            nodeMap[rn] = r.addNode(name, g.get(rn).results);
        }

        nodeMap[n] = nodeMap[rn];
    }
    if (g.start != NodeID.invalid)
        r.start = nodeMap[g.start];
    foreach (s; g.otherStarts)
        r.otherStarts ~= nodeMap[s];

    foreach (n; g.nodeIDs)
    {
        foreach (e; g.get(n).edges)
        {
            auto e2 = r.getNextEdge(nodeMap[n], e.symbol, e.flags);
            if (e2 is null)
                r.addEdge(nodeMap[n], nodeMap[e.next], e.symbol,
                        e.flags & EdgeFlags.matchingFlags, e.extra);
            else
                e2.extra ~= e.extra;
        }
    }

    return r;
}

Graph!(Symbol, Result, EdgeExtra) removeDeadStates(Symbol, Result, EdgeExtra)(
        Graph!(Symbol, Result, EdgeExtra) g)
{
    alias G = Graph!(Symbol, Result, EdgeExtra);
    auto isAlive = g.createSet();
    foreach (n; g.nodeIDs)
    {
        if (g.get(n).results.length)
            isAlive[n] = true;
    }
    bool changed;
    do
    {
        changed = false;
        foreach (n; g.nodeIDs)
        {
            if (isAlive[n])
                continue;
            foreach (e; g.getEdges(n))
            {
                if (isAlive[e.next])
                {
                    isAlive[n] = true;
                    changed = true;
                }
            }
        }
    }
    while (changed);

    G.NodeID[G.NodeID] nodeMap;
    G r = new G();
    G.NodeID mapNode(G.NodeID n)
    {
        if (n !in nodeMap)
        {
            nodeMap[n] = r.addNode(g.get(n).name, g.get(n).results);
        }
        return nodeMap[n];
    }

    r.start = mapNode(g.start);
    foreach (n; g.nodeIDs)
    {
        if (!isAlive[n])
            continue;
        foreach (e; g.getEdges(n))
        {
            if (!isAlive[e.next])
                continue;
            r.addEdge(mapNode(n), mapNode(e.next), e.symbol, e.flags, e.extra);
        }
    }
    return r;
}
