
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.parser;
import dparsergen.core.utils;
import dparsergen.generator.globaloptions;
import dparsergen.generator.grammar;
import dparsergen.generator.ids;
import dparsergen.generator.production;
import std.algorithm;
import std.bitmanip;
import std.conv;
import std.exception;
import std.range;
import std.typecons;

void tokenSetToString(ref Appender!string app, const BitSet!TokenID tokens, EBNFGrammar grammar)
{
    app.put(" {");
    bool first = true;
    foreach (x; tokens.bitsSet)
    {
        if (!first)
            app.put(", ");
        app.put(grammar.getSymbolName(x));
        first = false;
    }
    app.put("}");
}

string tokenSetToString(const BitSet!TokenID tokens, EBNFGrammar grammar)
{
    Appender!string app;
    tokenSetToString(app, tokens, grammar);
    return app.data;
}

struct PrevElement
{
    size_t state;
    size_t elementNr;
}

struct ElementID
{
    size_t state;
    size_t elementNr;
}

struct LRElement
{
    const(Production)* production;
    size_t dotPos;
    BitSet!TokenID lookahead;
    bool ignoreInConflict;
    size_t[] results;
    bool isStartElement;

    immutable(PrevElement)[] prevElements;
    bool[immutable(PrevElement)] prevElementsMap;
    immutable(PrevElement)[] nextElements;

    void addPrevElement(immutable(PrevElement) prev)
    {
        if (prev in prevElementsMap)
            return;
        prevElementsMap[prev] = true;
        prevElements ~= prev;
    }

    void addPrevElement(const(PrevElement)[] prevs)
    {
        foreach (prev; prevs)
            addPrevElement(prev);
    }

    Constraint extraConstraint;

    BitSet!TokenID realLookahead() const
    {
        BitSet!TokenID r = lookahead.dup;
        foreach (l; production.negLookaheads)
            r[l.toTokenID] = false;
        if (production.negLookaheadsAnytoken)
        {
            bool hasEOF = r[TokenID(0)];
            r = BitSet!TokenID(r.length);
            r[TokenID(0)] = hasEOF;
        }
        return r;
    }

    string toStringOnlyProductionBeforeDot(LRGraph graph) const
    {
        Appender!string app;
        toStringOnlyProductionBeforeDot(graph, app);
        return app.data;
    }

    void toStringOnlyProductionBeforeDot(LRGraph graph, ref Appender!string app) const
    {
        const grammar = graph.grammar;
        foreach (i, s; production.symbols[0 .. dotPos])
        {
            if (i == dotPos)
            {
                app.put(".");
                assert(false);
            }
            else
                app.put(" ");

            grammar.symbolInstanceToString(app, s, false);
        }
    }

    string toStringOnlyProductionAfterDot(LRGraph graph) const
    {
        Appender!string app;
        toStringOnlyProductionAfterDot(graph, app);
        return app.data;
    }

    void toStringOnlyProductionAfterDot(LRGraph graph, ref Appender!string app) const
    {
        const grammar = graph.grammar;
        foreach (idiff, s; production.symbols[dotPos .. $])
        {
            auto i = dotPos + idiff;
            if (i > dotPos)
                app.put(" ");

            grammar.symbolInstanceToString(app, s, false);
        }

        foreach (l; production.negLookaheads)
        {
            app.put(" !");
            app.put(graph.grammar.getSymbolName(l));
        }
        if (production.negLookaheadsAnytoken)
            app.put(" !anytoken");
    }

    string toStringOnlyProduction(LRGraph graph) const
    {
        const grammar = graph.grammar;
        Appender!string app;
        toStringOnlyProductionBeforeDot(graph, app);
        app.put(".");
        toStringOnlyProductionAfterDot(graph, app);
        return app.data;
    }

    string toStringOnlyLookahead(LRGraph graph) const
    {
        Appender!string app;
        toStringOnlyLookahead(graph, app);
        return app.data;
    }

    void toStringOnlyLookahead(LRGraph graph, ref Appender!string app) const
    {
        auto grammar = graph.grammar;

        tokenSetToString(app, realLookahead, grammar);
    }

    string toStringOnlyEnd(LRGraph graph) const
    {
        Appender!string app;
        toStringOnlyEnd(graph, app);
        return app.data;
    }

    void toStringOnlyEnd(LRGraph graph, ref Appender!string app) const
    {
        auto grammar = graph.grammar;
        string r;

        if (ignoreInConflict)
            app.put(" ignoreInConflict");

        if (results.length)
        {
            app.put("results: ");
            app.put(results.map!text.join(", "));
        }
        if (isStartElement)
            app.put(" startElement");
    }

    string toString(LRGraph graph) const
    {
        auto grammar = graph.grammar;
        Appender!string app;
        app.put(grammar.getSymbolName(production.nonterminalID));
        app.put(" -> ");
        app.put(toStringOnlyProduction(graph));
        toStringOnlyLookahead(graph, app);
        toStringOnlyEnd(graph, app);
        return app.data;
    }

    string toStringNoLookahead(LRGraph graph) const
    {
        auto grammar = graph.grammar;
        string r = grammar.getSymbolName(production.nonterminalID);
        r ~= " -> ";
        r ~= toStringOnlyProduction(graph);
        return r;
    }

    bool isNextValid(EBNFGrammar grammar) const
    {
        return dotPos < production.symbols.length && grammar.isValid(production.symbols[dotPos]);
    }

    bool isNextNonterminal(EBNFGrammar grammar) const
    {
        return dotPos < production.symbols.length && !production.symbols[dotPos].isToken;
    }

    bool isNextToken(EBNFGrammar grammar) const
    {
        return dotPos < production.symbols.length && production.symbols[dotPos].isToken;
    }

    bool isFinished(EBNFGrammar grammar) const
    {
        return dotPos == production.symbols.length;
    }

    immutable(SymbolInstance) next(EBNFGrammar grammar) const
    {
        assert(isNextValid(grammar));
        return production.symbols[dotPos];
    }

    immutable(SymbolInstance) prev(EBNFGrammar grammar) const
    {
        assert(dotPos > 0);
        return production.symbols[dotPos - 1];
    }

    immutable(SymbolInstance)[] afterNext(EBNFGrammar grammar) const
    {
        return production.symbols[dotPos + 1 .. $];
    }

    immutable(SymbolInstance)[] afterDot(EBNFGrammar grammar) const
    {
        return production.symbols[dotPos .. $];
    }

    immutable(SymbolInstance)[] stackSymbols() const
    {
        return production.symbols[0 .. dotPos];
    }

    LRElement dup() const
    {
        LRElement r = LRElement(production, dotPos, lookahead.dup, ignoreInConflict,
                results.dup, isStartElement, prevElements, null, nextElements, extraConstraint);
        foreach (prev; prevElements)
            r.prevElementsMap[prev] = true;
        return r;
    }

    LRElement advance() const
    {
        assert(dotPos < production.symbols.length);
        LRElement r = LRElement(production, dotPos + 1, lookahead.dup,
                ignoreInConflict, results.dup, isStartElement);
        r.extraConstraint.tags = extraConstraint.tags;
        return r;
    }

    size_t gotoParent() const
    {
        size_t r = stackSymbols.length;
        if (production.productionID == ProductionID.max)
            r++;
        if (r == 0)
            return size_t.max;
        return r - 1;
    }

    auto nextNonterminals(EBNFGrammar grammar, bool directUnwrap) const
    {
        immutable(NonterminalWithConstraint)[] r;
        if (isNextNonterminal(grammar))
        {
            auto n = next(grammar);

            auto n2 = grammar.nextNonterminalWithConstraint(extraConstraint, n, dotPos == 0);

            if (directUnwrap && next(grammar).annotations.contains!"excludeDirectUnwrap")
                directUnwrap = false;

            if (directUnwrap)
            {
                r = grammar.directUnwrapClosureFull(n.toNonterminalID,
                        n2.constraint.negLookaheads, n2.constraint.tags);
            }
            else
                r = [
                    NonterminalWithConstraint(n.toNonterminalID, n2.constraint)
                ];
        }
        else
        {
            directUnwrap = false;
            r = [];
        }

        bool needsNonterminal(NonterminalWithConstraint n)
        {
            return !n.constraint.disabled && (!directUnwrap || grammar.directUnwrapClosureHasSelf(n));
        }
        return r.filter!needsNonterminal;
    }
}

struct LRElementSet
{
    LRElement[] elements;
    NonterminalID[] descentNonterminals;
    alias elements this;
    size_t stackSize() const
    {
        size_t r;
        foreach (e; elements)
        {
            if (e.dotPos > r)
                r = e.dotPos;
        }
        return r;
    }
}

void getNextLookahead(EBNFGrammar grammar, immutable(SymbolInstance)[] l,
        BitSet!TokenID realLookahead, ref bool lookaheadNeedsAfterEnd,
        ref BitSet!TokenID newLookahead)
{
    if (l.length > 0)
    {
        BitSet!TokenID nextLookahead = grammar.firstSet(l);
        newLookahead.length = nextLookahead.length;
        newLookahead |= nextLookahead;
        if (newLookahead[grammar.tokens.getID("$end")])
        {
            lookaheadNeedsAfterEnd = true;
            newLookahead[grammar.tokens.getID("$end")] = false;
            newLookahead |= realLookahead;
        }
    }
    else
    {
        lookaheadNeedsAfterEnd = true;
        newLookahead = realLookahead;
    }
}

LRElementSet elementSetClosure(LRGraph graph, const LRElement[] startElements)
in
{
    foreach (ref e; startElements)
    {
        assert(e.extraConstraint == Constraint.init);
    }
}
do
{
    auto grammar = graph.grammar;
    Appender!(LRElement[]) result;
    NonterminalID[] descentNonterminals;
    const(Symbol)[][] negLookaheads;
    foreach (e; startElements)
    {
        result.put(e.dup);
    }

    BitSet!NonterminalID nonterminalsAdded;
    NonterminalID[] nonterminalsTodo;
    bool[NonterminalID] preventDescent;
    bool[NonterminalID] enforceDescent;

    size_t[] firstSetCounts;
    size_t[] nonterminalsInDirectUnwrapClosures;
    size_t[] nonterminalsInDirectUnwrapClosures2;
    BitSet!NonterminalID nonterminalsInDirectUnwrapClosuresCounted;
    if (graph.globalOptions.optimizationDescent)
    {
        firstSetCounts.length = grammar.tokens.vals.length;
        nonterminalsInDirectUnwrapClosures.length = grammar.nonterminals.vals.length;
        nonterminalsInDirectUnwrapClosures2.length = grammar.nonterminals.vals.length;
    }

    void changeNonterminalFirstSet(NonterminalID n, int change)
    {
        if (change == 1)
        {
            assert(!nonterminalsInDirectUnwrapClosuresCounted[n]);
            nonterminalsInDirectUnwrapClosuresCounted[n] = true;
        }
        else if (change == -1)
        {
            assert(nonterminalsInDirectUnwrapClosuresCounted[n]);
            nonterminalsInDirectUnwrapClosuresCounted[n] = false;
        }
        else
            assert(false);
        foreach (token; graph.grammar.firstSetImpl(n, [], []).bitsSet)
        {
            firstSetCounts[token.id] += change;
        }
        foreach (n2; grammar.directUnwrapClosureFull(n, [], []))
        {
            if (n2.nonterminalID == n)
                continue;
            if (change == 1 && nonterminalsAdded[n2.nonterminalID] && nonterminalsInDirectUnwrapClosuresCounted[n2.nonterminalID])
            {
                changeNonterminalFirstSet(n2.nonterminalID, -1);
            }
            nonterminalsInDirectUnwrapClosures[n2.nonterminalID.id] += change;
        }
        foreach (n2; grammar.directUnwrapClosureFull(n, [], []))
        {
            if (n2.nonterminalID == n)
                continue;
            if (change == -1 && nonterminalsAdded[n2.nonterminalID] && nonterminalsTodo.canFind(n2.nonterminalID) && nonterminalsInDirectUnwrapClosures[n2.nonterminalID.id] == 0)
                changeNonterminalFirstSet(n2.nonterminalID, 1);
        }
    }

    void addedElement(size_t i)
    {
        if (graph.globalOptions.optimizationDescent)
        {
            if (result.data[i].isNextToken(grammar))
            {
                auto token = result.data[i].next(grammar).toTokenID;
                firstSetCounts[token.id]++;
            }

            if (result.data[i].isNextNonterminal(grammar))
            {
                auto n = result.data[i].next(grammar).toNonterminalID;

                foreach (n2; grammar.directUnwrapClosureFull(n, [], []))
                {
                    nonterminalsInDirectUnwrapClosures2[n2.nonterminalID.id]++;
                }
            }
        }

        foreach (n; result.data[i].nextNonterminals(graph.grammar,
                graph.globalOptions.directUnwrap))
        {
            if (!nonterminalsAdded[n.nonterminalID])
            {
                if (graph.globalOptions.optimizationDescent)
                {
                    if (nonterminalsInDirectUnwrapClosures[n.nonterminalID.id] == 0)
                    {
                        changeNonterminalFirstSet(n.nonterminalID, 1);
                    }
                }
                nonterminalsAdded[n.nonterminalID] = true;
                nonterminalsTodo ~= n.nonterminalID;
            }

            if (result.data[i].isStartElement
                    && n.nonterminalID == result.data[i].production.nonterminalID)
                preventDescent[n.nonterminalID] = true;

            if (n.hasLookaheadAnnotation
                    || result.data[i].next(grammar).annotations.contains!"lookahead"())
                enforceDescent[n.nonterminalID] = true;
        }
    }

    foreach (i; 0 .. result.data.length)
        addedElement(i);

    bool compareNonterminals(NonterminalID a, NonterminalID b)
    {
        auto ca = grammar.directUnwrapClosureFull(a, [], []);
        auto cb = grammar.directUnwrapClosureFull(b, [], []);
        if (ca.length > cb.length)
            return true;
        return false;
    }

    while (nonterminalsTodo.length)
    {
        nonterminalsTodo.sort!(compareNonterminals, SwapStrategy.stable);
        auto n = nonterminalsTodo[0];
        nonterminalsTodo = nonterminalsTodo[1 .. $];

        if (graph.globalOptions.optimizationDescent)
        {
            if (nonterminalsInDirectUnwrapClosures[n.id] > 0)
            {
                continue;
            }
        }

        bool hasEnableToken;
        foreach (a; graph.grammar.nonterminals[n].annotations.otherAnnotations)
            if (a.startsWith("enableToken("))
                hasEnableToken = true;

        bool uniqueFirstSet = false;
        if (graph.globalOptions.optimizationDescent
            && !grammar.canBeEmpty(n)
            && !grammar.isMutuallyLeftRecursive(n)
            && !grammar.nonterminals[n].annotations.contains!"noOptDescent")
        {
            uniqueFirstSet = true;
            foreach (token; graph.grammar.firstSetImpl(n, [], []).bitsSet)
            {
                if (firstSetCounts[token.id] != 1)
                    uniqueFirstSet = false;
            }

            foreach (n2; grammar.directUnwrapClosureFull(n, [], []))
            {
                if (nonterminalsInDirectUnwrapClosures2[n2.nonterminalID.id] != nonterminalsInDirectUnwrapClosures2[n.id])
                    uniqueFirstSet = false;
            }
        }

        if (!graph.globalOptions.glrParser
                && (graph.grammar.nonterminals[n].annotations.contains!"backtrack"()
                    || graph.grammar.nonterminals[n].annotations.contains!"lookahead"()
                    || hasEnableToken
                    || n in enforceDescent
                    || uniqueFirstSet)
                && n !in preventDescent)
        {
            descentNonterminals.addOnce(n);

            if (!graph.startNonterminalsSet[n.id])
            {
                graph.startNonterminalsSet[n.id] = true;
                graph.startNonterminals ~= StartNonterminal(n);
            }
        }
        else
        {
            bool canStartWithEmpty;
            size_t prevLength = result.data.length;
            foreach (prodNr, p; graph.grammar.getProductions(n))
            {
                if (graph.globalOptions.directUnwrap
                        && grammar.isDirectUnwrapProduction(*p))
                    continue;
                if (p.symbols.length && graph.grammar.canBeEmpty(p.symbols[0]))
                    canStartWithEmpty = true;

                size_t elementNr = result.data.length;
                auto newElem = LRElement(p, 0);
                result.put(newElem);
            }
            if (graph.globalOptions.optimizationDescent)
            {
                if (nonterminalsInDirectUnwrapClosures[n.id] == 0)
                {
                    if (!canStartWithEmpty)
                        changeNonterminalFirstSet(n, -1);
                }
            }
            foreach (i; prevLength .. result.data.length)
                addedElement(i);
        }
    }

    size_t[] mapping;
    mapping.length = result.data.length;
    foreach (i; 0 .. result.data.length)
        mapping[i] = i;

    static int specialElementOrder(const LRElement* e)
    {
        if (e.isStartElement && e.production.symbols.length == 1)
            return 1;
        if (e.isStartElement)
            return 2;
        return 100;
    }

    bool[NonterminalID] startNonterminals;
    foreach (i; 0 .. result.data.length)
        if (result.data[i].isStartElement)
            startNonterminals[result.data[i].production.nonterminalID] = true;

    mapping.sort!((ia, ib) {
        auto a = &result.data[ia];
        auto b = &result.data[ib];

        int soA = specialElementOrder(a);
        int soB = specialElementOrder(b);

        if (soA < soB)
            return true;
        if (soA > soB)
            return false;

        if (a.dotPos > b.dotPos)
            return true;
        if (a.dotPos < b.dotPos)
            return false;

        auto pA = a.production;
        auto pB = b.production;

        if (pA.nonterminalID in startNonterminals && pB.nonterminalID !in startNonterminals)
            return true;
        if (pA.nonterminalID !in startNonterminals && pB.nonterminalID in startNonterminals)
            return false;

        if (pA.nonterminalID.id < pB.nonterminalID.id)
            return true;
        if (pA.nonterminalID.id > pB.nonterminalID.id)
            return false;

        foreach (i; 0 .. min(pA.symbols.length, pB.symbols.length))
        {
            if (pA.symbols[i].isToken < pB.symbols[i].isToken)
                return true;
            if (pA.symbols[i].isToken > pB.symbols[i].isToken)
                return false;

            if (pA.symbols[i].id < pB.symbols[i].id)
                return true;
            if (pA.symbols[i].id > pB.symbols[i].id)
                return false;
        }

        if (pA.symbols.length < pB.symbols.length)
            return true;
        if (pA.symbols.length > pB.symbols.length)
            return false;

        return false;
    });

    size_t[] mappingReverse;
    mappingReverse.length = result.data.length;
    foreach (i; 0 .. result.data.length)
        mappingReverse[mapping[i]] = i;

    Appender!(LRElement[]) result2;
    result2.reserve(result.data.length);
    foreach (i; 0 .. result.data.length)
    {
        result2.put(result.data[mapping[i]]);
        immutable(PrevElement)[] prevElements;
        foreach (PrevElement x; result2.data[i].prevElements)
        {
            if (x.state == size_t.max)
                x.elementNr = mappingReverse[x.elementNr];
            prevElements ~= x;
        }
        result2.data[i].prevElements = prevElements;
        result2.data[i].prevElementsMap = null;
        foreach (prev; prevElements)
            result2.data[i].prevElementsMap[prev] = true;
    }
    descentNonterminals.sort();
    return LRElementSet(result2.data, descentNonterminals);
}

LRElement[] elementSetGoto(LRGraph graph, size_t prevState,
        const LRElement[] elements, Symbol next, string subToken)
{
    assert(graph.grammar.isValid(next));
    if (!next.isToken)
        assert(subToken == "");
    Appender!(LRElement[]) result;

    foreach (i, e; elements)
    {
        if (!e.isNextValid(graph.grammar))
            continue;

        bool isGood;

        SymbolInstance nextP = e.next(graph.grammar);

        if (nextP.isToken != next.isToken)
            continue;

        if (next.isToken)
        {
            if (nextP == next && (nextP.subToken.length == 0 || nextP.subToken == subToken))
                isGood = true;
        }
        else
        {
            if (graph.globalOptions.directUnwrap)
            {
                if (nextP == next && graph.grammar.directUnwrapClosureHasSelf(
                        graph.grammar.nextNonterminalWithConstraint(e.extraConstraint,
                        nextP, e.dotPos == 0)))
                    isGood = true;
                if (!nextP.annotations.contains!"excludeDirectUnwrap")
                {
                    if (next.toNonterminalID in graph.grammar.directUnwrapClosureMap(
                            graph.grammar.nextNonterminalWithConstraint(e.extraConstraint,
                            nextP, e.dotPos == 0)))
                    {
                        isGood = true;
                    }
                }
            }
            else
            {
                if (nextP == next)
                    isGood = true;
            }
        }

        if (isGood)
        {
            auto newElem = LRElement(e.production, e.dotPos + 1, e.lookahead.dup);
            newElem.isStartElement = e.isStartElement;
            newElem.addPrevElement(PrevElement(prevState, i));
            result.put(newElem); //const(LR0Element)(e.productionID, e.dotPos + 1);
        }
    }
    //assert(result.data.length);

    return result.data;
}

LRElementSet gotoSet(LRGraph graph, size_t prevState, const LRElement[] elements,
        const NonterminalID[] next)
{
    Appender!(LRElement[]) result;

    foreach (i, e; elements)
    {
        if (!e.isNextValid(graph.grammar))
            continue;

        SymbolInstance nextP = e.next(graph.grammar);

        if (nextP.isToken)
            continue;

        bool isGood;

        if (next.canFind(nextP))
            isGood = true;

        if (graph.globalOptions.directUnwrap && !nextP.annotations.contains!"excludeDirectUnwrap")
        {
            foreach (n; next)
                if (n in graph.grammar.directUnwrapClosureMap(
                        graph.grammar.nextNonterminalWithConstraint(e.extraConstraint,
                        nextP, e.dotPos == 0)))
                {
                    isGood = true;
                }
        }

        if (isGood)
        {
            auto newElem = LRElement(e.production, e.dotPos + 1, e.lookahead.dup);
            newElem.isStartElement = e.isStartElement;
            newElem.addPrevElement(PrevElement(prevState, i));
            result.put(newElem); //const(LR0Element)(e.productionID, e.dotPos + 1);
        }
    }

    return elementSetClosure(graph, result.data);
}

LRElement[] firstElement(LRGraph graph, SymbolID nonterminalID, bool needsEmptyProduction)
{
    auto grammar = graph.grammar;
    Production* production = new Production();

    production.isVirtual = true;
    production.nonterminalID = NonterminalID(nonterminalID);
    production.symbols = [SymbolInstance(Symbol(false, nonterminalID))];
    production.productionID = ProductionID.max;

    LRElement[] result = [LRElement(production, 0)];
    result[0].isStartElement = true;

    if (needsEmptyProduction)
    {
        production = new Production();

        production.isVirtual = true;
        production.nonterminalID = NonterminalID(nonterminalID);
        production.symbols = [];
        production.productionID = ProductionID.max;

        result ~= [LRElement(production, 0)];
        result[$ - 1].isStartElement = true;
    }

    return result;
}

enum LRGraphNodeType
{
    unknown,
    lr,
    descent,
    backtrack,
    lookahead
}

struct LRGraphEdge
{
    Symbol symbol;
    string subToken;
    size_t next;
    Tuple!(Symbol, bool)[] checkDisallowedSymbols;
    immutable(NonterminalID)[] delayedNonterminals;
}

class LRGraphNode
{
    LRElementSet elements;
    LRGraphEdge[] edges;
    LRGraphEdge[] reverseEdges;
    const(Symbol)[] shortestSymbolPath;
    immutable(size_t)[] backtrackStates;
    LRGraphNodeType type;
    bool isStartNode;
    immutable(NonterminalID[])[] stackDelayedReduce;
    immutable(NonterminalID[])[] delayedReduceCombinations;
    immutable(NonterminalID[])[] delayedReduceOutCombinations;
    size_t delayedReduceCombinationsDone;

    this()
    {
    }

    this(LRElementSet elements)
    {
        this.elements = elements;
    }

    size_t[2] minMaxGotoParent() const
    {
        size_t min = size_t.max;
        size_t max = 0;
        foreach (e; elements)
        {
            size_t x = e.gotoParent;
            if (x != size_t.max && x < min)
                min = x;
            if (x != size_t.max && x > max)
                max = x;
        }
        return [min, max];
    }

    bool[] stackSymbolsNotDropped() const
    {
        bool[] r;
        r.length = stackSymbols.length;
        foreach (e; elements)
        {
            foreach (i, s; e.stackSymbols)
            {
                if (!s.dropNode)
                    r[$ - e.stackSymbols.length + i] = true;
            }
        }
        return r;
    }

    bool[] stackSymbolsStartOfProduction() const
    {
        bool[] r;
        r.length = stackSymbols.length;
        foreach (e; elements)
        {
            if (e.stackSymbols.length)
                r[$ - e.stackSymbols.length] = true;
        }
        return r;
    }

    size_t stackSize() const
    {
        size_t r;
        foreach (e; elements)
        {
            if (e.dotPos > r)
                r = e.dotPos;
        }
        return r;
    }

    immutable(Symbol)[] stackSymbols() const
    {
        Symbol[] r;
        bool[] hasSymbol;
        r.length = stackSize();
        hasSymbol.length = stackSize();
        foreach (e; elements)
        {
            auto s = e.stackSymbols;
            foreach (i; 0 .. s.length)
            {
                size_t p = i + r.length - s.length;
                if (hasSymbol[p])
                {
                    if (s[i] != r[p])
                        r[p] = Symbol(false, SymbolID.max);
                }
                else
                    r[p] = s[i];
                hasSymbol[p] = true;
            }
        }
        return r.idup;
    }

    bool hasSetStackSymbols() const
    {
        immutable(Symbol)[] r;
        foreach (e; elements)
        {
            auto s = e.stackSymbols;
            foreach (i; 0 .. min(s.length, r.length))
                if (r[$ - 1 - i] != s[$ - 1 - i].symbol)
                    return true;

            if (s.length > r.length)
            {
                r = [];
                foreach (x; s)
                    r ~= x.symbol;
            }
        }
        return false;
    }

    bool isFinalParseState() const
    {
        return elements.length >= 1 && elements[0].isStartElement && elements[0].dotPos == 0;
    }

    bool isArrayOnStack(EBNFGrammar grammar, size_t i) const
    {
        size_t stackSize = this.stackSize();
        foreach (e; elements)
        {
            auto s = e.stackSymbols;
            if (i < stackSize - s.length)
                continue;

            size_t k = i + s.length - stackSize;
            if (!s[k].isToken
                    && (grammar.nonterminals[s[k].toNonterminalID].flags & NonterminalFlags.array) != 0)
                return true;
        }
        return false;
    }

    bool needsTagsOnStack(EBNFGrammar grammar, size_t i) const
    {
        size_t stackSize = this.stackSize();
        foreach (e; elements)
        {
            auto s = e.stackSymbols;
            if (i < stackSize - s.length)
                continue;

            size_t k = i + s.length - stackSize;
            if (s[k].isToken)
                continue;
            auto possibleTags = grammar.nonterminals[s[k].toNonterminalID].possibleTags;
            if (s[k].annotations.contains!"inheritAnyTag" && possibleTags.length)
                return true;
            if (s[k].unwrapProduction && possibleTags.length)
                return true;
            if (e.isStartElement && possibleTags.length)
                return true;
            foreach (tagUsage; s[k].tags)
            {
                if (possibleTags.canFind(tagUsage.tag))
                    return true;
            }
        }
        return false;
    }

    NonterminalID[] allNonterminals(EBNFGrammar grammar) const
    {
        BitSet!NonterminalID n;
        foreach (e; elements)
        {
            n[e.production.nonterminalID] = true;
        }
        foreach (x; elements.descentNonterminals)
        {
            n[x] = true;
        }
        return n.bitsSet.array;
    }

    NonterminalID[] allNonterminalsOut(EBNFGrammar grammar) const
    {
        BitSet!NonterminalID n;
        foreach (e; elements)
        {
            if (e.dotPos > 0 || e.isStartElement)
            {
                NonterminalID nonterminalID = nonterminalOutForProduction(e.production);
                if (n.length <= nonterminalID.id)
                    n.length = nonterminalID.id + 1;
                n[nonterminalID] = true;
            }
        }
        return n.bitsSet.array;
    }

    NonterminalID[] directUnwrapNonterminalsOnStack(EBNFGrammar grammar, size_t pos) const
    {
        BitSet!NonterminalID n;
        foreach (e; elements)
        {
            auto s = e.stackSymbols;
            if (s.length < pos)
                continue;
            if (s[$ - pos].isToken)
                continue;
            BitSet!NonterminalID tmp;
            tmp.length = grammar.nonterminals.vals.length;
            if (s[$ - pos].annotations.contains!"excludeDirectUnwrap")
                tmp[s[$ - pos].toNonterminalID] = true;
            else
            {
                foreach (m2; grammar.directUnwrapClosure(grammar.nextNonterminalWithConstraint(e.extraConstraint,
                        s[$ - pos], e.dotPos == 0)))
                    tmp[m2.nonterminalID] = true;
            }
            if (n.length == 0)
                n = tmp;
            else
                n &= tmp;
        }
        return n.bitsSet.array;
    }

    bool hasTags(LRGraph graph) const
    {
        foreach (e; elements)
            if (!e.extraConstraint.disabled && graph.grammar.nonterminals[e.production.nonterminalID].possibleTags.length)
                return true;
        foreach (s; backtrackStates)
            if (graph.states[s].hasTags(graph))
                return true;
        return false;
    }
}

struct NextLookaheadCacheKey
{
    size_t stateNr;
    size_t elementNr;
    TokenID currentToken;
}

class LRGraph
{
    EBNFGrammar grammar;
    this(EBNFGrammar grammar)
    {
        this.grammar = grammar;
    }

    LRGraphNode[] states;
    const(StartNonterminal)[] startNonterminals;
    BitArray startNonterminalsSet;
    size_t[] nonterminalToState;

    size_t[const(LRGraphNodeKey)] statesByKey2;
    size_t[const(LRGraphNodeKey)] closureCache;

    GlobalOptions globalOptions;

    size_t[][Tuple!(size_t, size_t)] statesWithProduction;

    immutable(ProductionID)[][] delayedReduceProductionCombinations;

    BitSet!TokenID[NextLookaheadCacheKey] nextLookaheadCache;
}

struct LRGraphNodeKey
{
    LRGraph graph;
    const LRElement[] elements;
    const NonterminalID[] descentNonterminals;

    size_t toHash() const pure nothrow
    {
        size_t r = 0;
        enum prime = 17;

        r = (r * prime) ^ elements.length;
        r = (r * prime) ^ descentNonterminals.length;

        foreach (k; 0 .. elements.length)
        {
            auto e = &elements[k];
            r = (r * prime) ^ e.dotPos;
            r = (r * prime) ^ e.production.nonterminalID.id;
            r = (r * prime) ^ e.production.symbols.length;
        }
        foreach (k; 0 .. descentNonterminals.length)
        {
            r = (r * prime) ^ descentNonterminals[k].id;
        }
        return r;
    }

    bool opEquals(ref const LRGraphNodeKey s) const pure nothrow
    {
        if (s.elements.length != elements.length)
            return false;
        if (s.descentNonterminals != descentNonterminals)
            return false;
        foreach (k; 0 .. elements.length)
        {
            auto e1 = &elements[k];
            auto e2 = &s.elements[k];
            if (e1.dotPos != e2.dotPos)
                return false;
            if (e1.production !is e2.production)
            {
                if (e1.production.nonterminalID != e2.production.nonterminalID)
                    return false;
                if (e1.production.symbols.length != e2.production.symbols.length)
                    return false;
                foreach (i; 0 .. e1.production.symbols.length)
                {
                    auto s1 = e1.production.symbols[i];
                    auto s2 = e2.production.symbols[i];
                    if (s1.isToken != s2.isToken)
                        return false;
                    if (s1.tags != s2.tags)
                        return false;
                    if (!(graph.globalOptions.mergeSimilarStates && s1.isToken && i < e1.dotPos))
                    {
                        if (s1.id != s2.id)
                            return false;
                        if (s1.subToken != s2.subToken)
                            return false;
                    }
                }
            }
        }

        return true;
    }
}

NonterminalID nonterminalOutForProduction(const(Production)* p)
{
    return p.nonterminalID;
}

bool similarElements(const LRElement e1, const LRElement e2)
{
    if (e1.dotPos != e2.dotPos)
        return false;
    if (e1.production.nonterminalID != e2.production.nonterminalID)
        return false;
    if (e1.production.symbols.length != e2.production.symbols.length)
        return false;
    foreach (i; 0 .. e1.production.symbols.length)
    {
        if (e1.production.symbols[i].isToken != e2.production.symbols[i].isToken)
            return false;
        if (e1.production.symbols[i].isToken)
        {
            if (i >= e1.dotPos && e1.production.symbols[i] != e2.production.symbols[i])
                return false;
        }
        else
        {
            if (e1.production.symbols[i] != e2.production.symbols[i])
                return false;
        }
    }
    return true;
}

sizediff_t countUntilGraph(LRGraph graph, const LRElementSet s)
{
    sizediff_t r = -1;
    auto x = LRGraphNodeKey(graph, s.elements, s.descentNonterminals) in graph.statesByKey2;
    if (x)
        r = *x;
    return r;
}

private size_t makeLRGraphRec(LRGraph graph, LRElementSet s, const(Symbol)[] path,
        LRGraph origGraph, size_t depth = 0)
{
    if (s.length == 0)
        return size_t.max;
    auto r = countUntilGraph(graph, s);

    if (r < 0)
    {
        if (origGraph !is null)
        {
            r = countUntilGraph(origGraph, s);
            if (r >= 0)
            {
                if (r >= graph.states.length)
                    graph.states.length = r + 1;
                graph.states[r] = new LRGraphNode(s);
                graph.statesByKey2[LRGraphNodeKey(graph, s.elements, s.descentNonterminals)] = r;
            }
        }
        if (r < 0)
        {
            r = graph.states.length;
            graph.states = graph.states ~ new LRGraphNode(s);
            graph.statesByKey2[LRGraphNodeKey(graph, s.elements, s.descentNonterminals)] = r;
        }
        graph.states[r].shortestSymbolPath = path;

        bool[Tuple!(Symbol, string)] done;
        Tuple!(Symbol, string)[] todoList;
        foreach (e; s)
        {
            if (!e.isNextValid(graph.grammar))
                continue;
            auto symbol = e.next(graph.grammar);
            auto symbolWithSubToken = tuple!(Symbol, string)(symbol.symbol, symbol.subToken);
            if (symbolWithSubToken !in done)
            {
                if (symbol.isToken)
                {
                    done[symbolWithSubToken] = true;
                    todoList ~= symbolWithSubToken;
                }
                else
                {
                    foreach (n; e.nextNonterminals(graph.grammar, graph.globalOptions.directUnwrap))
                    {
                        symbolWithSubToken = tuple!(Symbol, string)(n.nonterminalID, "");
                        if (symbolWithSubToken in done)
                            continue;
                        done[symbolWithSubToken] = true;
                        todoList ~= symbolWithSubToken;
                    }
                }
            }
        }
        sort!((a, b) => ((a[0].id == b[0].id) ? (a[1] < b[1]) : (a[0].id < b[0].id)))(todoList);
        foreach (x; todoList)
        {
            auto newElemAll = elementSetGoto(graph, r, s, x[0], x[1]);

            immutable(Symbol)[] disallowableSymbols;
            foreach (i, e; newElemAll)
            {
                disallowableSymbols.addOnce(e.prev(graph.grammar).negLookaheads);
            }

            assert(disallowableSymbols.length < 30);
            foreach (uint bits; 0 .. (1 << disallowableSymbols.length))
            {
                Tuple!(Symbol, bool)[] checkDisallowedSymbols;
                foreach (j, symbol; disallowableSymbols)
                {
                    if ((bits & (1 << j)))
                    {
                        checkDisallowedSymbols ~= tuple!(Symbol, bool)(symbol, true);
                    }
                    else
                    {
                        checkDisallowedSymbols ~= tuple!(Symbol, bool)(symbol, false);
                    }
                }
                LRElement[] newElemFiltered;
                foreach (i, e; newElemAll)
                {
                    bool filtered;
                    foreach (j, symbol; disallowableSymbols)
                    {
                        if ((bits & (1 << j)) && e.prev(graph.grammar)
                                .negLookaheads.canFind(symbol))
                            filtered = true;
                    }

                    if (!filtered)
                    {
                        newElemFiltered ~= newElemAll[i];
                    }
                }

                if (newElemFiltered.length == 0)
                    continue;

                auto newElem = elementSetClosure(graph, newElemFiltered);
                size_t nid;
                auto nidp = LRGraphNodeKey(graph, newElem.elements, newElem.descentNonterminals) in graph.closureCache;
                if (nidp)
                {
                    nid = *nidp;
                    size_t i;
                    assert(nid < graph.states.length, text(nid, " ", graph.states.length));
                    auto node = graph.states[nid];
                    foreach (ref e; newElem.elements)
                    {
                        while (true)
                        {
                            if ((node.elements[i].production is e.production
                                    && node.elements[i].dotPos == e.dotPos)
                                    || (graph.globalOptions.mergeSimilarStates
                                        && similarElements(node.elements[i], e)))
                            {
                                break;
                            }
                            i++;
                        }
                        node.elements[i].addPrevElement(e.prevElements);
                        i++;
                    }
                }
                else
                {
                    nid = makeLRGraphRec(graph, newElem, path ~ x[0], origGraph, depth + 1);
                    if (nid != size_t.max)
                        graph.closureCache[LRGraphNodeKey(graph, newElem.elements, newElem.descentNonterminals)] = nid;
                }
                graph.states[r].edges ~= LRGraphEdge(x[0], x[1], nid, checkDisallowedSymbols);
                if (nid != size_t.max)
                    graph.states[nid].reverseEdges ~= LRGraphEdge(x[0], x[1], r,
                            checkDisallowedSymbols);
            }
        }
    }
    else
    {
        if (path.length < graph.states[r].shortestSymbolPath.length)
            graph.states[r].shortestSymbolPath = path;

        size_t[] mapping;
        mapping.length = s.elements.length;
        foreach (i; 0 .. s.elements.length)
        {
            mapping[i] = size_t.max;
            foreach (k; 0 .. graph.states[r].elements.length)
            {
                if ((s.elements[i].production is graph.states[r].elements[k].production
                        && s.elements[i].dotPos == graph.states[r].elements[k].dotPos)
                        || (graph.globalOptions.mergeSimilarStates
                            && similarElements(s.elements[i], graph.states[r].elements[k])))
                {
                    assert(mapping[i] == size_t.max);
                    mapping[i] = k;
                }
            }
            assert(mapping[i] != size_t.max);
        }
        foreach (i; 0 .. s.elements.length)
        {
            foreach (PrevElement x; s.elements[i].prevElements)
            {
                if (x.state == size_t.max)
                    x.elementNr = mapping[x.elementNr];
                graph.states[r].elements[mapping[i]].addPrevElement(x);
            }
        }
    }

    return r;
}

void calculateLookahead(LRGraph graph)
{
    auto grammar = graph.grammar;

    foreach (j, node; graph.states)
    {
        foreach (k, ref e; node.elements)
        {
            e.lookahead = BitSet!TokenID(grammar.tokens.vals.length);
            if (e.isStartElement)
                e.lookahead[grammar.tokens.getID("$end")] = true;
        }
    }

    static struct NonterminalLookaheadInfo
    {
        BitSet!TokenID lookahead;
        immutable(PrevElement)[] prevElements;
        bool[immutable(PrevElement)] prevElementsMap;

        void addPrevElement(immutable(PrevElement) prev)
        {
            if (prev in prevElementsMap)
                return;
            prevElementsMap[prev] = true;
            prevElements ~= prev;
        }
    }

    foreach (j, node; graph.states)
    {
        NonterminalLookaheadInfo[ProductionID] nonterminalLookaheadInfos;
        foreach (k, ref e; node.elements)
        {
            foreach (nextNonterminal; e.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
            {
                bool lookaheadNeedsAfterEnd;
                BitSet!TokenID newLookahead;

                auto l = e.afterNext(grammar);
                getNextLookahead(grammar, l, e.realLookahead,
                        lookaheadNeedsAfterEnd, newLookahead);

                if (e.next(graph.grammar).annotations.contains!"eager")
                {
                    newLookahead = BitSet!TokenID(newLookahead.length);
                    newLookahead[graph.grammar.tokens.getID("$end")] = true;
                }

                if (node.elements.descentNonterminals.canFind(nextNonterminal.nonterminalID)
                        && !e.next(grammar).annotations.contains!"eager")
                {
                    auto state2 = graph.nonterminalToState[nextNonterminal.nonterminalID.id];
                    foreach (k2, ref e2; graph.states[state2].elements)
                    {
                        if (e2.dotPos == 0 && e2.isStartElement)
                        {
                            e2.lookahead |= newLookahead;
                            if (lookaheadNeedsAfterEnd)
                                e.nextElements.addOnce(PrevElement(state2, k2));
                        }
                    }
                }

                foreach (p; graph.grammar.getProductions(nextNonterminal.nonterminalID))
                {
                    if (graph.globalOptions.directUnwrap && grammar.isDirectUnwrapProduction(*p))
                        continue;
                    if (!graph.grammar.isProductionAllowed(nextNonterminal, p))
                        continue;

                    NonterminalLookaheadInfo* nonterminalLookaheadInfo = p
                        .productionID in nonterminalLookaheadInfos;

                    if (nonterminalLookaheadInfo !is null)
                    {
                        nonterminalLookaheadInfo.lookahead |= newLookahead;
                        if (lookaheadNeedsAfterEnd && !e.next(graph.grammar)
                                .annotations.contains!"eager")
                            nonterminalLookaheadInfo.addPrevElement(PrevElement(size_t.max, k));
                    }
                    else
                    {
                        nonterminalLookaheadInfos[p.productionID] = NonterminalLookaheadInfo(
                                newLookahead.dup);
                        nonterminalLookaheadInfo = p.productionID in nonterminalLookaheadInfos;
                        if (lookaheadNeedsAfterEnd && !e.next(graph.grammar)
                                .annotations.contains!"eager")
                            nonterminalLookaheadInfo.addPrevElement(PrevElement(size_t.max, k));
                    }
                }
            }
        }

        foreach (k, ref e; node.elements)
        {
            if (e.dotPos > 0)
                continue;
            if (e.isStartElement)
                continue;
            if (e.production.productionID !in nonterminalLookaheadInfos)
                continue;
            e.lookahead |= nonterminalLookaheadInfos[e.production.productionID].lookahead;
            foreach (prev; nonterminalLookaheadInfos[e.production.productionID].prevElements)
            {
                node.elements[prev.elementNr].nextElements ~= PrevElement(j, k);
            }
        }
    }

    bool changed = true;
    while (changed)
    {
        changed = false;

        foreach (j, node; graph.states)
        {
            foreach (k, ref e; node.elements)
            {
                foreach (x; e.nextElements)
                {
                    if (graph.states[x.state].elements[x.elementNr].lookahead.addOnce(
                            e.realLookahead))
                        changed = true;
                }
            }
        }
    }
}

void calculateExtraConstraints(LRGraph graph)
{
    auto grammar = graph.grammar;

    bool changed = true;
    while (changed)
    {
        changed = false;

        foreach (j, node; graph.states)
        {
            Constraint[ProductionID] constraintByProduction;
            foreach (k, ref e; node.elements)
            {
                if (e.extraConstraint.disabled)
                    continue;

                foreach (nextNonterminal; e.nextNonterminals(grammar,
                        graph.globalOptions.directUnwrap))
                {
                    foreach (p; graph.grammar.getProductions(nextNonterminal.nonterminalID))
                    {
                        if (graph.globalOptions.directUnwrap
                                && grammar.isDirectUnwrapProduction(*p))
                            continue;
                        if (!graph.grammar.isProductionAllowed(nextNonterminal, p))
                            continue;

                        if (p.productionID in constraintByProduction)
                            constraintByProduction[p.productionID] = grammar.orConstraint(
                                    constraintByProduction[p.productionID],
                                    nextNonterminal.constraint);
                        else
                            constraintByProduction[p.productionID] = nextNonterminal.constraint;
                    }
                }

                foreach (x; e.nextElements)
                {
                    auto newConstraint = grammar.orConstraint(
                            graph.states[x.state].elements[x.elementNr].extraConstraint,
                            e.extraConstraint);
                    if (graph.states[x.state].elements[x.elementNr].extraConstraint != newConstraint)
                    {
                        graph.states[x.state].elements[x.elementNr].extraConstraint = newConstraint;
                        changed = true;
                    }
                }
            }
            foreach (k, ref e; node.elements)
            {
                if (e.dotPos > 0)
                    continue;
                if (e.isStartElement)
                    continue;
                if (e.production.productionID !in constraintByProduction)
                    continue;
                auto newConstraint = grammar.orConstraint(e.extraConstraint,
                        constraintByProduction[e.production.productionID]);
                if (e.extraConstraint != newConstraint)
                {
                    e.extraConstraint = newConstraint;
                    changed = true;
                }
            }
        }
    }
}

void addDelayedReduceStates(LRGraph graph, LRGraph origGraph = null)
{
    auto grammar = graph.grammar;

    foreach (k; 0 .. graph.states.length)
    {
        ActionTable actionTable = genActionTable(graph, graph.states[k]);
        foreach (t, actions; actionTable.actions)
            foreach (subToken, action; actions)
            {
                if (action.type == ActionType.delayedReduce)
                {
                    NonterminalID[] nonterminals;
                    ProductionID[] productionIDs;
                    size_t stackSize;
                    foreach (e; action.delayedElements)
                    {
                        nonterminals.addOnce(graph.states[k].elements[e].production.nonterminalID);
                        productionIDs.addOnce(graph.states[k].elements[e].production.productionID);
                        stackSize = graph.states[k].elements[e].production.symbols.length;
                    }
                    nonterminals.sort();
                    productionIDs.sort();
                    immutable NonterminalID[] nonterminalsI = nonterminals.idup;
                    if (!graph.delayedReduceProductionCombinations.canFind(productionIDs))
                        graph.delayedReduceProductionCombinations ~= productionIDs.idup;

                    void addDelayedReduce(size_t i, size_t k)
                    {
                        if (i == 0)
                        {
                            graph.states[k].delayedReduceCombinations.addOnce(nonterminalsI);
                            return;
                        }
                        else
                        {
                            graph.states[k].delayedReduceOutCombinations.addOnce(nonterminalsI);
                        }
                        foreach (e; graph.states[k].reverseEdges)
                        {
                            addDelayedReduce(i - 1, e.next);
                        }
                    }

                    addDelayedReduce(stackSize, k);
                }
            }
    }

    foreach (k; 0 .. graph.states.length)
    {
        for (; graph.states[k].delayedReduceCombinationsDone
                < graph.states[k].delayedReduceCombinations.length; graph
                .states[k].delayedReduceCombinationsDone++)
        {
            auto generatedSet = graph.states[k]
                .delayedReduceCombinations[graph.states[k].delayedReduceCombinationsDone];
            auto newElem = gotoSet(graph, k, graph.states[k].elements, generatedSet);
            assert(newElem.stackSize <= graph.states[k].elements.stackSize + 1);
            auto r2 = countUntilGraph(graph, newElem);
            if (r2 == k)
                continue;
            auto nid = makeLRGraphRec(graph, newElem,
                    graph.states[k].shortestSymbolPath ~ generatedSet[0], origGraph, 0);
            graph.states[k].edges ~= LRGraphEdge(Symbol(false, SymbolID.max),
                    "", nid, [], generatedSet);
            if (nid != size_t.max)
                graph.states[nid].reverseEdges ~= LRGraphEdge(Symbol(false,
                        SymbolID.max), "", k, [], generatedSet);
        }
    }
}

LRGraph makeLRGraph(EBNFGrammar grammar, GlobalOptions globalOptions, LRGraph origGraph = null)
{
    LRGraph graph = new LRGraph(grammar);
    graph.globalOptions = globalOptions;

    if (origGraph !is null)
        graph.states.length = origGraph.states.length;

    graph.nonterminalToState.length = grammar.nonterminals.vals.length;
    graph.startNonterminalsSet.length = grammar.nonterminals.vals.length;

    graph.startNonterminals = grammar.startNonterminals;
    foreach (startNonterminals; grammar.startNonterminals)
        graph.startNonterminalsSet[startNonterminals.nonterminal.id] = true;
    size_t i = 0;
    while (i < graph.startNonterminals.length)
    {
        auto start = firstElement(graph, graph.startNonterminals[i].nonterminal.id,
                graph.startNonterminals[i].needsEmptyProduction);

        bool isBacktrack = graph.grammar.nonterminals[graph.startNonterminals[i].nonterminal]
            .annotations.contains!"backtrack"();
        bool isLookahead = graph.grammar.nonterminals[graph.startNonterminals[i].nonterminal]
            .annotations.contains!"lookahead"();
        if (!graph.globalOptions.glrParser && (isBacktrack || isLookahead))
        {
            LRElementSet set = LRElementSet(start);

            size_t backtrackState = graph.states.length;
            graph.states = graph.states ~ new LRGraphNode(set);
            graph.statesByKey2[LRGraphNodeKey(graph, set.elements, set.descentNonterminals)] = backtrackState;
            graph.states[backtrackState].isStartNode = true;
            graph.states[backtrackState].shortestSymbolPath
                = [graph.startNonterminals[i].nonterminal];
            if (isBacktrack)
                graph.states[backtrackState].type = LRGraphNodeType.backtrack;
            else
                graph.states[backtrackState].type = LRGraphNodeType.lookahead;
            graph.nonterminalToState[graph.startNonterminals[i].nonterminal.id] = backtrackState;

            foreach (prodNr, p; graph.grammar.getProductions(
                    graph.startNonterminals[i].nonterminal))
            {
                LRElementSet set2 = elementSetClosure(graph, [
                        LRElement(p, 0, set[0].lookahead)
                        ]);
                set2.elements = start ~ set2.elements;
                foreach (ref e; set2.elements[1 .. $])
                {
                    auto prevElements = e.prevElements;
                    e.prevElements = [];
                    e.prevElementsMap = null;
                    foreach (PrevElement x; prevElements)
                    {
                        if (x.state == size_t.max)
                            x.elementNr++; // account for start element
                        e.addPrevElement(x);
                    }
                    if (e.production is p && e.dotPos == 0)
                    {
                        e.addPrevElement(PrevElement(size_t.max, 0));
                    }
                }
                set2.elements[0].addPrevElement(PrevElement(backtrackState, 0));

                size_t state2 = makeLRGraphRec(graph, set2,
                        [graph.startNonterminals[i].nonterminal], origGraph);

                graph.states[backtrackState].backtrackStates ~= state2;
            }
        }
        else
        {
            LRElementSet set = elementSetClosure(graph, start);
            size_t id = makeLRGraphRec(graph, set,
                    [graph.startNonterminals[i].nonterminal], origGraph);
            graph.nonterminalToState[graph.startNonterminals[i].nonterminal.id] = id;
            graph.states[id].isStartNode = true;
        }
        i++;
    }

    do
    {
        foreach (ref node; graph.states)
        {
            foreach (ref e; node.elements)
            {
                e.nextElements = [];
                e.extraConstraint = Constraint.init;
                e.extraConstraint.disabled = !e.isStartElement;
            }
        }
        foreach (j, node; graph.states)
        {
            foreach (k, e; node.elements)
            {
                foreach (x; e.prevElements)
                {
                    if (x.state == size_t.max)
                        graph.states[j].elements[x.elementNr].nextElements ~= PrevElement(j, k);
                    else
                        graph.states[x.state].elements[x.elementNr].nextElements ~= PrevElement(j, k);
                }
            }
        }

        calculateExtraConstraints(graph);

        calculateLookahead(graph);

        size_t prevNumStates = graph.states.length;

        if (graph.globalOptions.delayedReduce)
        {
            addDelayedReduceStates(graph, origGraph);
        }

        if (prevNumStates == graph.states.length)
            break;
    }
    while (true);

    foreach (k; 0 .. graph.states.length)
    {
        const stackSize = graph.states[k].stackSize;
        NonterminalID[][] stackDelayedReduce;
        stackDelayedReduce.length = stackSize;
        bool nonterminalPossible(size_t i, NonterminalID n)
        {
            foreach (e; graph.states[k].elements)
            {
                if (e.dotPos < i + 1)
                    continue;
                if (n in grammar.directUnwrapClosureMap(e.production.symbols[e.dotPos - i - 1].toNonterminalID,
                        e.production.symbols[e.dotPos - i - 1].negLookaheads,
                        e.production.symbols[e.dotPos - i - 1].tags))
                    return true;
            }
            return false;
        }

        void buildStackDelayedReduce(size_t i, size_t k)
        {
            if (i >= stackSize)
                return;
            foreach (e; graph.states[k].reverseEdges)
            {
                bool allNonterminalsPossible = true;
                foreach (x; e.delayedNonterminals)
                {
                    if (!nonterminalPossible(i, x))
                        allNonterminalsPossible = false;
                }
                if (allNonterminalsPossible)
                    foreach (x; e.delayedNonterminals)
                    {
                        stackDelayedReduce[$ - 1 - i].addOnce(x);
                    }
                buildStackDelayedReduce(i + 1, e.next);
            }
        }

        buildStackDelayedReduce(0, k);
        graph.states[k].stackDelayedReduce.length = 0;
        foreach (ref x; stackDelayedReduce)
        {
            if (x.length <= 1)
                x = [];
            x.sort();
            graph.states[k].stackDelayedReduce ~= x.idup;
        }
    }

    foreach (j, node; graph.states)
    {
        foreach (e; node.elements)
            graph.statesWithProduction[tuple!(size_t,
                        size_t)(e.production.productionID, e.dotPos)] ~= j;
    }

    return graph;
}

BitSet!TokenID elementFirstSet(const LRElement e, LRGraph graph)
{
    auto l = e.afterDot(graph.grammar);
    if (l.length > 0)
    {
        BitSet!TokenID lookahead;
        lookahead = graph.grammar.firstSet(l, e.extraConstraint, e.dotPos == 0);
        if (lookahead[graph.grammar.tokens.getID("$end")])
        {
            lookahead[graph.grammar.tokens.getID("$end")] = false;
            lookahead |= e.lookahead;
        }
        return lookahead;
    }
    else
    {
        return e.lookahead.dup;
    }
}

BitSet!TokenID nodeFirstSet(const LRGraphNode node, LRGraph graph)
{
    BitSet!TokenID r = BitSet!TokenID(graph.grammar.tokens.vals.length);
    foreach (e; node.elements)
    {
        r |= elementFirstSet(e, graph);
    }
    return r;
}

enum ActionType
{
    none,
    shift,
    reduce,
    accept,
    descent,
    conflict,
    delayedReduce
}

struct Action
{
    ActionType type;
    size_t newState = size_t.max; // for shift and nonterminal
    const(Production)* production; // for reduce
    size_t elementNr = size_t.max; // for reduce
    NonterminalID nonterminalID = NonterminalID.invalid; // for descent
    bool ignoreInConflict;
    string errorMessage; // for conflict
    const(Action)[] conflictActions; // for conflict
    immutable(size_t)[] delayedElements;
    immutable(NonterminalID)[] reusedDelayedNonterminals;
    bool allowRegexLookahead;
    string toString() const
    {
        string r;
        if (type == ActionType.shift)
            r = text("shift ", newState);
        else if (type == ActionType.reduce)
            r = text("reduce ", elementNr);
        else if (type == ActionType.accept)
            r = text("accept ", elementNr);
        else if (type == ActionType.descent)
            r = text("descent ", nonterminalID);
        else if (type == ActionType.conflict)
            r = text("conflict");
        else if (type == ActionType.delayedReduce)
            r = text("delayedReduce ", delayedElements, reusedDelayedNonterminals);
        else
            r = text(type);
        if (ignoreInConflict)
            r ~= " ignoreInConflict";
        return r;
    }

    int opCmp(ref const Action other) const
    {
        if (type != other.type)
            return type < other.type ? -1 : 1;
        if (newState != other.newState)
            return newState < other.newState ? -1 : 1;
        if (elementNr != other.elementNr)
            return elementNr < other.elementNr ? -1 : 1;
        if (nonterminalID != other.nonterminalID)
            return nonterminalID < other.nonterminalID ? -1 : 1;
        if (nonterminalID != other.nonterminalID)
            return nonterminalID < other.nonterminalID ? -1 : 1;
        return 0;
    }
}

struct ActionTable
{
    size_t[Tuple!(Symbol, bool)[]][NonterminalID] jumps;
    size_t[Tuple!(Symbol, bool)[]][immutable(NonterminalID)[]] jumps2;
    Action[string][TokenID] actions;
    bool hasShift;
    Action defaultReduceAction;
    bool hasTags;
    bool[ProductionID] reduceConflictProductions;
    bool[Symbol] usedNegLookahead;
}

bool hasSubToken(const Production *p)
{
    foreach (s; p.symbols)
    {
        if (s.symbol.isToken && s.subToken.length)
        {
            return true;
        }
    }
    return false;
}

bool actionIgnored(LRGraph graph, const LRGraphNode node, const Action a, const Action[] actions)
{
    auto grammar = graph.grammar;
    if (a.ignoreInConflict)
        return true;
    if (a.type == ActionType.reduce || a.type == ActionType.accept)
    {
        auto p = node.elements[a.elementNr].production;
        if ((p.symbols.length && p.symbols[$ - 1].annotations.contains!"eager"
                || p.annotations.contains!"eagerEnd"()) && actions.length == 2
                && ((actions[0] == a && actions[1].type.among(ActionType.shift,
                    ActionType.descent)) || (actions[1] == a
                    && actions[0].type.among(ActionType.shift, ActionType.descent))))
            return true;
        if (!hasSubToken(p))
        {
            bool otherHasSubToken;
            foreach (e2; node.elements)
            {
                auto stackSymbols = e2.stackSymbols;
                if (stackSymbols.length > p.symbols.length)
                    stackSymbols = stackSymbols[$ - p.symbols.length .. $];
                foreach (s2; stackSymbols)
                {
                    if (s2.symbol.isToken && s2.subToken.length)
                    {
                        otherHasSubToken = true;
                    }
                }
            }
            if (otherHasSubToken)
                return true;
        }
        return p.annotations.contains!"ignoreInConflict"()
            || grammar.nonterminals[p.nonterminalID].annotations.contains!"ignoreInConflict"();
    }
    return false;
}

ActionTable genActionTable(LRGraph graph, const LRGraphNode node)
{
    ActionTable r;
    auto grammar = graph.grammar;
    immutable endTok = graph.grammar.tokens.getID("$end");
    Action[][string][TokenID] actions;

    bool[NonterminalID] regexLookaheadNonterminals;
    bool[TokenID] regexLookaheadTokens;
    size_t numRegexLookaheads;
    if (!graph.globalOptions.glrParser)
    {
        foreach (e; node.elements)
        {
            if (e.extraConstraint.disabled)
                continue;
            if (!e.isNextValid(grammar))
            {
                if (e.production.annotations.contains!"lookahead")
                    numRegexLookaheads++;
            }
            else if (e.isNextNonterminal(grammar))
            {
                foreach (n; e.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
                {
                    if (n.hasLookaheadAnnotation || e.next(grammar)
                            .annotations.contains!"lookahead")
                    {
                        regexLookaheadNonterminals[n.nonterminalID] = true;
                    }
                }
            }
            else if (e.next(grammar).annotations.contains!"lookahead")
            {
                regexLookaheadTokens[e.next(grammar).toTokenID] = true;
            }
        }
        numRegexLookaheads += regexLookaheadNonterminals.length;
        numRegexLookaheads += regexLookaheadTokens.length;
    }

    bool[Symbol] validShifts;
    foreach (e; node.elements)
    {
        if (e.extraConstraint.disabled)
            continue;
        if (!e.isNextValid(grammar))
            continue;

        if (e.isNextNonterminal(grammar))
        {
            foreach (n; e.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
            {
                validShifts[n.nonterminalID] = true;
            }
        }
        else
        {
            validShifts[e.next(grammar).toTokenID] = true;
        }
    }
    foreach (edge; node.edges)
    {
        if (edge.delayedNonterminals.length)
        {
            bool allValidShifts = true;
            foreach (n; edge.delayedNonterminals)
                if (n !in validShifts)
                    allValidShifts = false;
            if (!allValidShifts)
                continue;
        }
        else
        {
            if (edge.symbol !in validShifts)
                continue;
        }
        r.hasShift = true;
        if (graph.states[edge.next].hasTags(graph))
            r.hasTags = true;
        if (edge.symbol.isToken)
        {
            Action a;
            a = Action(ActionType.shift, edge.next);
            a.allowRegexLookahead = !!(edge.symbol.toTokenID in regexLookaheadTokens);
            actions[edge.symbol.toTokenID][edge.subToken] = [a];
        }
        else if (edge.delayedNonterminals.length > 0)
        {
            r.jumps2[edge.delayedNonterminals][edge.checkDisallowedSymbols] = edge.next;
        }
        else
        {
            r.jumps[edge.symbol.toNonterminalID][edge.checkDisallowedSymbols] = edge.next;
        }
    }

    foreach (descentNonterminal; node.elements.descentNonterminals)
    {
        if (descentNonterminal !in validShifts)
            continue;
        if (grammar.nonterminals[descentNonterminal].possibleTags.length)
            r.hasTags = true;
        auto nextNode = graph.states[graph.nonterminalToState[descentNonterminal.id]];
        if (nextNode.hasTags(graph))
            r.hasTags = true;
        BitSet!TokenID firstTokens = grammar.firstSet([
            SymbolInstance(descentNonterminal)
        ]);
        foreach (e; node.elements)
        {
            if (e.extraConstraint.disabled)
                continue;
            if (e.isNextNonterminal(grammar))
            {
                BitSet!TokenID allAllowedTokens;
                foreach (n; e.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
                {
                    if (n.nonterminalID == descentNonterminal)
                    {
                        BitSet!TokenID allowedTokensHere;
                        allowedTokensHere.length = firstTokens.length;
                        allowedTokensHere.arr[] = true;
                        foreach (nl; n.constraint.negLookaheads)
                        {
                            if (nl.isToken)
                            {
                                allowedTokensHere[nl.toTokenID] = false;
                            }
                        }
                        if (allAllowedTokens.length == 0)
                        {
                            allAllowedTokens = allowedTokensHere;
                        }
                        else
                        {
                            allAllowedTokens |= allowedTokensHere;
                        }
                    }
                }
                if (allAllowedTokens.length)
                {
                    firstTokens &= allAllowedTokens;
                }
            }
        }

        foreach (t; firstTokens.bitsSet)
        {
            Action a;
            a = Action(ActionType.descent, size_t.max, null, size_t.max, descentNonterminal);
            a.allowRegexLookahead = !!(descentNonterminal in regexLookaheadNonterminals);
            if (t !in actions || "" !in actions[t] || !actions[t][""].canFind(a))
                actions[t][""] ~= a;
        }
    }

    size_t numberOfFinished;
    size_t numberOfDescent;
    bool[NonterminalID] descentNonterminals;
    foreach (elementNr, e; node.elements)
    {
        if (e.extraConstraint.disabled)
            continue;
        if (e.isFinished(grammar))
        {
            numberOfFinished++;
        }
    }
    foreach (descentNonterminal; node.elements.descentNonterminals)
    {
        if (descentNonterminal !in descentNonterminals)
        {
            descentNonterminals[descentNonterminal] = true;
            numberOfDescent++;
        }
    }

    BitSet!TokenID allEndNegLookaheadTokens;
    foreach (elementNr, e; node.elements)
    {
        if (e.extraConstraint.disabled)
            continue;
        if (!e.isFinished(graph.grammar))
            continue;
        foreach (l; e.production.negLookaheads)
        {
            if (l.toTokenID in actions)
                continue;
            allEndNegLookaheadTokens[l.toTokenID] = true;
        }
    }

    foreach (elementNr, e; node.elements)
    {
        if (e.extraConstraint.disabled)
            continue;
        if (!e.isFinished(graph.grammar))
            continue;

        const BitSet!TokenID usedTokens = e.realLookahead;

        foreach (j; usedTokens.bitsSet)
        {
            Action a;
            a = Action(e.isStartElement ? ActionType.accept : ActionType.reduce, 0,
                    e.production, elementNr, NonterminalID.invalid, e.ignoreInConflict);
            a.allowRegexLookahead = e.production.annotations.contains!"lookahead";
            actions[j][""] ~= []; // ensure it exists
            if (!actions[j][""].canFind(a))
                actions[j][""] ~= a;
        }

        if (usedTokens[endTok])
        {
            foreach (j; allEndNegLookaheadTokens.bitsSet)
            {
                if (e.production.negLookaheadsAnytoken)
                    continue;
                if (e.production.negLookaheads.canFind(j))
                    continue;
                Action a;
                a = Action(e.isStartElement ? ActionType.accept : ActionType.reduce, 0,
                        e.production, elementNr, NonterminalID.invalid, e.ignoreInConflict);
                a.allowRegexLookahead = e.production.annotations.contains!"lookahead";
                actions[j][""] ~= []; // ensure it exists
                if (!actions[j][""].canFind(a))
                    actions[j][""] ~= a;
            }
        }
    }

    foreach (t, a1; actions)
    {
        if ("" in a1)
        {
            foreach (s, ref a2; a1)
            {
                if (s == "")
                    continue;
                foreach (a3; a1[""])
                    if (a3.type != ActionType.shift)
                        a2 ~= a3;
            }
        }
    }

    Action[] applyDelayedReduce(Action[] actions, TokenID token, string subToken)
    {
        if (!graph.globalOptions.delayedReduce)
            return actions;
        if (actions.length <= 1)
            return actions;

        Action lastReduceAction;

        immutable(size_t)[] delayedElements;
        foreach (ax; actions)
        {
            if (ax.type == ActionType.shift)
                return actions;
            if (ax.type == ActionType.reduce && node.elements[ax.elementNr].dotPos == 0)
                return actions;

            if (ax.type != ActionType.reduce)
                return actions;
            if (grammar.hasNonTrivialRewriteRule(node.elements[ax.elementNr].production))
                return actions;
            if (lastReduceAction.type == ActionType.reduce
                    && ax.production.symbols.length != lastReduceAction.production.symbols.length)
                return actions;
            if (lastReduceAction.type == ActionType.reduce
                    && grammar.nonterminals[ax.production.nonterminalID].annotations.contains!"array"
                    != grammar.nonterminals[lastReduceAction.production.nonterminalID]
                    .annotations.contains!"array")
                return actions;
            lastReduceAction = ax;
            delayedElements ~= ax.elementNr;
        }

        immutable(NonterminalID)[] reusedDelayedNonterminals;
        if (delayedElements.all!(e => node.elements[e].production.symbols.length == 1))
            foreach (i, e; node.elements)
            {
                if (e.dotPos == 0)
                    continue;
                if (e.production.symbols[e.dotPos - 1].isToken)
                    continue;
                if (delayedElements.canFind(i))
                    continue;
                auto f = elementFirstSet(e, graph);
                if (f[token])
                    reusedDelayedNonterminals ~= e.production.symbols[e.dotPos - 1].toNonterminalID;
            }

        if (delayedElements.length == 0)
            return actions;
        if (delayedElements.length == 1 && reusedDelayedNonterminals.length == 0)
            return actions;

        Action bestAction = Action(ActionType.delayedReduce);
        bestAction.delayedElements = delayedElements;
        bestAction.reusedDelayedNonterminals = reusedDelayedNonterminals;

        return [bestAction];
    }

    Action findBestAction(Action[] actions)
    {
        if (actions.length == 0)
            return Action(ActionType.none);
        Action bestAction = actions[0];
        size_t numNotIgnored;
        if (!actionIgnored(graph, node, bestAction, actions))
            numNotIgnored++;

        foreach (ax; actions[1 .. $])
        {
            if (!actionIgnored(graph, node, ax, actions))
            {
                numNotIgnored++;
                bestAction = ax;
            }
        }
        if (numNotIgnored > 1)
        {
            string message;
            foreach (a; actions)
                message ~= text("\n", a);
            bestAction = Action(ActionType.conflict);
            bestAction.errorMessage = message;
            actions.sort();
            bestAction.conflictActions = actions;
            foreach (ax; actions)
            {
                if (ax.type.among(ActionType.reduce, ActionType.accept))
                {
                    r.reduceConflictProductions[node.elements[ax.elementNr].production.productionID]
                        = true;
                }
            }
        }
        return bestAction;
    }

    foreach (t, a1; actions)
        foreach (s, a2; a1)
        {
            Action bestAction = findBestAction(applyDelayedReduce(a2, t, s));

            if (bestAction.type == ActionType.reduce && numberOfFinished == 1 && t != endTok)
            {
                if (r.defaultReduceAction.type != ActionType.none)
                    assert(r.defaultReduceAction == bestAction);
                r.defaultReduceAction = bestAction;
            }
            else if (bestAction.type == ActionType.descent
                    && (numberOfFinished != 1 && numberOfDescent == 1) && t != endTok)
            {
                if (r.defaultReduceAction.type != ActionType.none)
                    assert(r.defaultReduceAction == bestAction);
                r.defaultReduceAction = bestAction;
            }
            else
                r.actions[t][s] = bestAction;
        }

    foreach (e; node.elements)
    {
        if (e.isNextValid(grammar))
            foreach (n; e.next(grammar).negLookaheads)
                if (n !in r.usedNegLookahead)
                {
                    r.usedNegLookahead[n] = true;
                }
    }

    return r;
}

struct ActionCaseInfo
{
    TokenID[] tokens;
    string subToken;
    Action action;
    bool allowCombined;
}

ActionCaseInfo[] groupActions(LRGraph graph, ActionTable actionTable)
{
    auto grammar = graph.grammar;
    immutable endTok = grammar.tokens.getID("$end");
    ActionCaseInfo[] cases;
    bool[TokenID] hasSubToken;

    foreach (t, a; actionTable.actions)
    {
        foreach (subToken, _; a)
        {
            if (subToken.length)
                hasSubToken[t] = true;
        }
    }

    bool checkAllowCombined(TokenID t)
    {
        if (t !in actionTable.actions)
            return false;
        auto a = actionTable.actions[t];
        return t !in actionTable.usedNegLookahead && t !in hasSubToken
            && a[""].type.among(ActionType.reduce, ActionType.accept, ActionType.descent);
    }

    if (endTok in actionTable.actions)
    {
        cases ~= ActionCaseInfo([endTok], "", actionTable.actions[endTok][""], checkAllowCombined(endTok));
    }

    foreach (t; actionTable.actions.sortedKeys)
    {
        auto a = actionTable.actions[t];
        if (t == endTok)
            continue;

        bool allowCombined = checkAllowCombined(t);

        if (allowCombined)
        {
            bool found;
            foreach (i, ref caseInfo; cases)
            {
                if (caseInfo.allowCombined && caseInfo.action == a[""])
                {
                    caseInfo.tokens ~= t;
                    found = true;
                    break;
                }
            }
            if (found)
                continue;
        }

        foreach (subToken; a.sortedKeys)
        {
            auto a2 = a[subToken];

            if (a2.type != ActionType.none)
            {
                cases ~= ActionCaseInfo([t], subToken, a2, allowCombined);
            }
        }
    }

    cases.sort!((a, b) {
        if (a.tokens != b.tokens)
            return a.tokens < b.tokens;
        if (a.subToken != b.subToken)
        {
            if (a.subToken == "")
                return false;
            if (b.subToken == "")
                return true;
            return a.subToken < b.subToken;
        }
        return false;
    });

    return cases;
}

bool trivialState(LRGraphNode s)
{
    if (s.elements.length != 1)
        return false;
    auto e = s.elements[0];
    if (e.production.symbols.length != 1)
        return false;
    if (e.dotPos != 1)
        return false;
    if (e.production.symbols[0].isToken)
        return false;
    if (s.stackDelayedReduce[0].length)
        return false;
    return e.production.symbols[0].unwrapProduction;
}

bool needsJumps(LRGraph graph, size_t stateNr, const LRGraphNode node, ActionTable actionTable)
{
    if (node.type == LRGraphNodeType.lookahead || node.type == LRGraphNodeType.backtrack)
        return false;

    bool hasJumps;
    foreach (nonterminalID, _; actionTable.jumps)
        hasJumps = true;
    if (!hasJumps)
        return false;

    return true;
}

void calcNextLookahead(ref BitSet!TokenID result, LRGraph graph, SymbolWithConstraint symbol,
        TokenID currentToken, ref bool[NonterminalWithConstraint] done, size_t indent)
{
    auto grammar = graph.grammar;
    if (symbol.symbol.isToken)
    {
    }
    else
    {
        if (NonterminalWithConstraint(symbol.symbol.toNonterminalID, symbol.constraint) in done)
            return;
        done[NonterminalWithConstraint(symbol.symbol.toNonterminalID, symbol.constraint)] = true;
        foreach (p; grammar.getProductions(symbol.symbol.toNonterminalID))
        {
            if (!grammar.isProductionAllowed(NonterminalWithConstraint(symbol.symbol.toNonterminalID,
                    symbol.constraint), p))
                continue;

            foreach (pos; 0 .. p.symbols.length)
            {
                auto s = grammar.nextSymbolWithConstraint(symbol.constraint,
                        p.symbols[pos], pos == 0);
                calcNextLookahead(result, graph, s, currentToken, done, indent + 2);
                if (grammar.hasExactToken(p.symbols[pos], currentToken))
                {
                    auto tmpElement = LRElement(p, pos + 1);
                    tmpElement.extraConstraint = symbol.constraint;
                    auto set = elementFirstSet(tmpElement, graph);
                    result |= set;
                }
                if (!grammar.canBeEmpty(p.symbols[pos]))
                    break;
            }
        }
    }
}

bool calcNextLookaheadAfter(ref BitSet!TokenID result, LRGraph graph, size_t stateNr,
        size_t elementNr, size_t dotPos, TokenID currentToken, size_t indent)
{
    auto grammar = graph.grammar;
    auto element2 = graph.states[stateNr].elements[elementNr];
    foreach (pos; dotPos .. element2.production.symbols.length)
    {
        if (grammar.firstSet(element2.production.symbols[pos .. $])[currentToken])
        {
            bool[NonterminalWithConstraint] done2;
            auto s = grammar.nextSymbolWithConstraint(element2.extraConstraint,
                    element2.production.symbols[pos], pos == 0);
            calcNextLookahead(result, graph, s, currentToken, done2, indent + 2);
            if (grammar.hasExactToken(element2.production.symbols[pos], currentToken))
            {
                auto tmpElement = LRElement(element2.production, pos + 1, element2.lookahead.dup);
                tmpElement.extraConstraint = element2.extraConstraint;
                auto set = elementFirstSet(tmpElement, graph);
                result |= set;
            }
        }
        if (!grammar.canBeEmpty(element2.production.symbols[pos]))
            return false;
    }
    return true;
}

BitSet!TokenID calcNextLookahead(LRGraph graph, size_t stateNr, size_t elementNr,
        TokenID currentToken, size_t indent)
{
    auto grammar = graph.grammar;

    auto cacheEntry = NextLookaheadCacheKey(stateNr, elementNr, currentToken) in graph.nextLookaheadCache;
    if (cacheEntry)
        return *cacheEntry;
    BitSet!TokenID result;
    result.length = grammar.tokens.vals.length;
    graph.nextLookaheadCache[NextLookaheadCacheKey(stateNr, elementNr, currentToken)] = result;

    auto element = graph.states[stateNr].elements[elementNr];

    if (element.production.annotations.contains!"eagerEnd")
    {
        result[grammar.tokens.getID("$end")] = true;
        graph.nextLookaheadCache[NextLookaheadCacheKey(stateNr, elementNr, currentToken)] = result;
        return result;
    }

    foreach (prev; element.prevElements)
        result |= calcNextLookahead(graph, prev.state == size_t.max ? stateNr
                : prev.state, prev.elementNr, currentToken, indent + 1);

    if (element.dotPos == 0 && element.isStartElement)
    {
        foreach (state2, node2; graph.states)
        {
            if (!node2.elements.descentNonterminals.canFind(element.production.nonterminalID))
                continue;
            foreach (elementNr2, element2; graph.states[state2].elements)
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
                    if (calcNextLookaheadAfter(result, graph, state2,
                            elementNr2, element2.dotPos + 1, currentToken, indent))
                    {
                        result |= calcNextLookahead(graph, state2, elementNr2,
                                currentToken, indent + 1);
                    }
                }
            }
        }
    }
    if (element.dotPos == 0 && !element.isStartElement)
    {
        foreach (elementNr2, element2; graph.states[stateNr].elements)
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
                if (calcNextLookaheadAfter(result, graph, stateNr, elementNr2,
                        element2.dotPos + 1, currentToken, indent))
                {
                    result |= calcNextLookahead(graph, stateNr, elementNr2,
                            currentToken, indent + 1);
                }
            }
        }
    }

    graph.nextLookaheadCache[NextLookaheadCacheKey(stateNr, elementNr, currentToken)] = result;
    return result;
}

BitSet!TokenID calcNextLookahead(LRGraph graph, size_t stateNr, Action action, TokenID currentToken)
{
    auto grammar = graph.grammar;
    BitSet!TokenID r;
    r.length = grammar.tokens.vals.length;
    if (action.type == ActionType.shift)
    {
        foreach (element; graph.states[stateNr].elements)
        {
            if (element.isNextToken(grammar) && element.next(grammar).toTokenID == currentToken)
            {
                auto set = elementFirstSet(element.advance, graph);
                r |= set;
            }
        }
    }
    else if (action.type.among(ActionType.reduce, ActionType.accept))
    {
        r |= calcNextLookahead(graph, stateNr, action.elementNr, currentToken, 1);
    }
    else if (action.type == ActionType.descent)
    {
        {
            bool[NonterminalWithConstraint] done2;
            calcNextLookahead(r, graph,
                    SymbolWithConstraint(action.nonterminalID), currentToken, done2, 1);
        }
        foreach (element2; graph.states[stateNr].elements)
        {
            bool elementPossible;
            foreach (n; element2.nextNonterminals(grammar, graph.globalOptions.directUnwrap))
            {
                if (n.nonterminalID == action.nonterminalID)
                {
                    elementPossible = true;
                }
            }
            if (elementPossible)
            {
                if (grammar.hasExactToken(action.nonterminalID, currentToken))
                {
                    auto set = elementFirstSet(element2.advance, graph);
                    r |= set;
                }
                if (grammar.canBeEmpty(action.nonterminalID))
                {
                    if (calcNextLookaheadAfter(r, graph, stateNr, action.elementNr,
                            graph.states[stateNr].elements[action.elementNr].dotPos + 1,
                            currentToken, 1))
                    {
                        //result |= calcNextLookahead(graph, stateNr, elementNr2, currentToken, indent + 1);
                    }
                }
            }
        }
    }
    else
    {
        enforce(false);
        foreach (t; grammar.tokens.allIDs)
            r[t] = true;
    }
    return r;
}
