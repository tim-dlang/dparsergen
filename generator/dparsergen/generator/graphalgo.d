
//          Copyright Tim Schendekehl 2026.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.graphalgo;

/**
Calculate the strongly connected components of a directed graph with
Tarjan's algorithm.

`successors` is called once for every node as `successors(node, sink)` and
has to call `sink(successor)` for every edge starting at `node`.

`onComponent` is called for every component with component index and
an array of component nodes.
*/
void findSCCs(I)(
    size_t numNodes,
    void delegate(I n, scope void delegate(I) sink) successors,
    void delegate(I index, const scope I[] component) onComponent)
{
    assert(numNodes <= I.max);

    enum I unvisited = I.max;

    static struct NodeData
    {
        I index = unvisited;
        I lowlink;
        bool onStack;
    }

    NodeData[] nodes = new NodeData[](numNodes);
    I[] stack = new I[](numNodes);
    size_t stackLength;
    I nextIndex;
    I componentIndex;

    void strongConnect(const I v)
    {
        nodes[v].index = nextIndex;
        nodes[v].lowlink = nextIndex;
        nextIndex++;
        stack[stackLength++] = v;
        nodes[v].onStack = true;

        successors(v, (I w)
        {
            if (nodes[w].index == unvisited)
            {
                strongConnect(w);
                if (nodes[w].lowlink < nodes[v].lowlink)
                    nodes[v].lowlink = nodes[w].lowlink;
            }
            else if (nodes[w].onStack && nodes[w].index < nodes[v].lowlink)
                nodes[v].lowlink = nodes[w].index;
        });

        if (nodes[v].lowlink == nodes[v].index)
        {
            const I c = componentIndex;
            componentIndex++;

            size_t prevStackLength = stackLength;
            while (true)
            {
                const I w = stack[--stackLength];
                nodes[w].onStack = false;
                if (w == v)
                    break;
            }
            onComponent(c, stack[stackLength .. prevStackLength]);
        }
    }

    foreach (rootIndex; 0 .. numNodes)
    {
        const root = cast(I) rootIndex;
        if (nodes[root].index != unvisited)
            continue;

        strongConnect(root);
    }
}

I[] findSCCsAsComponentIndices(I)(
        size_t numNodes, void delegate(I n, scope void delegate(I) sink) successors)
{
    I[] result = new I[numNodes];

    void onComponent(I index, const scope I[] component)
    {
        foreach (w; component)
        {
            result[w] = index;
        }
    }
    findSCCs!(I)(numNodes, successors, &onComponent);

    return result;
}

I[][] findSCCsAsArray(I)(
        size_t numNodes, void delegate(I n, scope void delegate(I) sink) successors)
{
    I[][] result;

    void onComponent(I index, const scope I[] component)
    {
        result ~= component.dup;
    }
    findSCCs!(I)(numNodes, successors, &onComponent);

    return result;
}

I[] sccsArrayToComponentIndices(I)(I[][] sccs, size_t numNodes)
{
    I[] result = new I[numNodes];
    foreach (i, component; sccs)
    {
        foreach (w; component)
            result[w] = cast(I) i;
    }
    return result;
}

unittest
{
    alias NodeID = uint;

    static NodeID[][] edges;
    void nextNodes(NodeID n, scope void delegate(NodeID) sink)
    {
        foreach (s; edges[n])
            sink(s);
    }

    edges = [[1], [2], [1], [3], []];
    auto r = findSCCsAsArray!NodeID(edges.length, &nextNodes);
    assert(r == [[1, 2], [0], [3], [4]]);

    edges = [[1], [2, 4], [0, 3], [1], []];
    r = findSCCsAsArray!NodeID(edges.length, &nextNodes);
    assert(r == [[4], [0, 1, 2, 3]]);

    edges = [];
    r = findSCCsAsArray!NodeID(0, &nextNodes);
    assert(r.length == 0);
}

/**
Shortest path `from -> ... -> to`. The result starts with `from` and
ends with `to`. For `from == to` it is a cycle with at least one edge.
Returns null, if no path is found.

`successors` is called once for every node as `successors(node, sink)` and
has to call `sink(successor)` for every edge starting at `node`.
*/
I[] shortestPath(I)(I from, I to, I numNodes, void delegate(I n, scope void delegate(I) sink) successors)
{
    I[] prev = new I[](numNodes);
    prev[] = I.max;
    I[] queue = [from];
    bool found;
    for (size_t i = 0; i < queue.length && !found; i++)
    {
        const I v = queue[i];
        successors(v, (I succ)
        {
            if (found)
                return;
            if (succ == to)
            {
                prev[succ] = v;
                found = true;
                return;
            }
            if (prev[succ] == I.max && succ != from)
            {
                prev[succ] = v;
                queue ~= succ;
            }
        });
    }
    if (!found)
        return null;

    I[] path;
    I current = to;
    path ~= current;
    while (current != from || path.length == 1)
    {
        assert(prev[current] != I.max);
        current = prev[current];
        path ~= current;
    }
    foreach (i; 0 .. path.length / 2)
    {
        I tmp = path[i];
        path[i] = path[$ - 1 - i];
        path[$ - 1 - i] = tmp;
    }
    return path;
}

unittest
{
    alias NodeID = uint;

    static NodeID[][] edges;
    void nextNodes(NodeID n, scope void delegate(NodeID) sink)
    {
        foreach (s; edges[n])
            sink(s);
    }

    edges = [[1], [2], [1], [3], []];

    assert(shortestPath!NodeID(0, 1, cast(uint) edges.length, &nextNodes) == [0, 1]);
    assert(shortestPath!NodeID(0, 2, cast(uint) edges.length, &nextNodes) == [0, 1, 2]);
    assert(shortestPath!NodeID(0, 3, cast(uint) edges.length, &nextNodes) == []);
    assert(shortestPath!NodeID(3, 3, cast(uint) edges.length, &nextNodes) == [3, 3]);
}
