
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

/**
This module implements a tree creator, where all tokens, nonterminals
and arrays are represented using the same base class. The list of childs
is just an array of this class. Create an instance of `DynamicParseTreeCreator`
for the used grammar and pass it to the parser.
*/
module dparsergen.core.dynamictree;
import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.nonterminalunion;
import dparsergen.core.parsestackelem;
import dparsergen.core.utils;
import std.algorithm;
import std.array;
import std.conv;

/**
Base class for all tree nodes.

Params:
    Location = Type of location in source file.
    LocationRangeImpl = Template for determining how location ranges are
        stored (start + length, start + end, ...).
*/
abstract class DynamicParseTree(Location, alias LocationRangeImpl = LocationRangeStartLength)
{
    alias LocationDiff = typeof(Location.init - Location.init);
    alias LocationRange = LocationRangeImpl!Location;

    /**
    Location of this tree node in the source file.
    */
    LocationRange location;

    static foreach (field; ["startFromParent", "inputLength", "start", "end"])
    {
        static if (__traits(hasMember, LocationRange, field))
        {
            mixin("final typeof(() { LocationRange x; return x." ~ field ~ "; }()) " ~ field ~ "() const {"
                ~ "return location." ~ field ~ ";}");

            mixin("static if (__traits(compiles, () { LocationRange x; x." ~ field ~ " = x." ~ field ~ "; }))"
                ~ "final void " ~ field ~ "(typeof(() { LocationRange x; return x." ~ field ~ "; }()) n){"
                ~ "location." ~ field ~ " = n; }");
        }
    }

    static if (__traits(hasMember, LocationRange, "setStartEnd"))
    {
        final void setStartEnd(typeof((){ LocationRange x; return x.start; }()) start,
                               typeof((){ LocationRange x; return x.end; }()) end)
        {
            location.setStartEnd(start, end);
        }
    }

    /**
    Information about the grammar for this tree node.
    */
    immutable(GrammarInfo)* grammarInfo;

    /**
    ID of production for this tree starting at `grammarInfo.startProductionID`
    or `ProductionID.max` if not applicable.
    See `grammarInfo.allProductions[productionID - grammarInfo.startProductionID]`
    for details about the prodution.
    */
    ProductionID productionID;

    /**
    ID of nonterminal for this tree starting at `grammarInfo.startNonterminalID`
    or `SymbolID.max` if not applicable.
    See `grammarInfo.allNonterminals[nonterminalID - grammarInfo.startNonterminalID]`
    for details about the nonterminal.
    */
    SymbolID nonterminalID;

    /**
    Type of tree node. Should match the used subclass.
    */
    immutable NodeType nodeType;

    /**
    Name for nonterminals.
    */
    string name() const
    in (nodeType != NodeType.token)
    {
        assert(0);
    }

    /**
    Text content for tokens.
    */
    string content() const
    in (nodeType == NodeType.token)
    {
        assert(0);
    }

    /**
    Childs of this subtree. Will be empty for tokens.
    */
    inout(DynamicParseTree[]) childs() inout
    {
        return [];
    }

    private this(SymbolID nonterminalID, ProductionID productionID,
            NodeType nodeType, immutable GrammarInfo* grammarInfo)
    {
        if (nodeType == NodeType.token || nodeType == NodeType.array)
        {
            assert(nonterminalID == SymbolID.max);
            assert(productionID == ProductionID.max);
        }
        else
        {
            assert(nonterminalID >= grammarInfo.startNonterminalID);
            assert(nonterminalID - grammarInfo.startNonterminalID
                    < grammarInfo.allNonterminals.length);
            if (productionID != ProductionID.max)
            {
                assert(productionID >= grammarInfo.startProductionID);
                assert(
                        productionID - grammarInfo.startProductionID
                        < grammarInfo.allProductions.length);
            }
        }

        this.nonterminalID = nonterminalID;
        this.nodeType = nodeType;
        this.grammarInfo = grammarInfo;
        this.productionID = productionID;
    }

    override string toString() const
    {
        return treeToString(this);
    }

    final bool isToken() const
    {
        return nodeType == NodeType.token;
    }

    /**
    Returns the index of a child by name or size_t.max.
    */
    final size_t childIndexByName(string name)
    in (name.length)
    in (nodeType == NodeType.nonterminal)
    in (grammarInfo !is null)
    {
        immutable(SymbolInstance)[] symbols = grammarInfo
            .allProductions[productionID - grammarInfo.startProductionID].symbols;

        size_t i;
        size_t found = size_t.max;
        foreach (ref symbol; symbols)
        {
            if (symbol.dropNode)
                continue;
            if (symbol.symbolInstanceName == name)
            {
                found = i;
            }
            i++;
        }
        assert(i == childs.length);

        return found;
    }

    /**
    Checks if this subtree has a child with some name.
    */
    final bool hasChildWithName(string name)
    in (name.length)
    in (nodeType == NodeType.nonterminal)
    in (grammarInfo !is null)
    {
        size_t found = childIndexByName(name);
        return found != size_t.max;
    }

    /**
    Gets a child of this subtree by name.
    */
    final DynamicParseTree childByName(string name)
    {
        size_t found = childIndexByName(name);
        assert(found != size_t.max);
        return childs[found];
    }

    /**
    Gets the name of child with index `index`.
    */
    final string childName(size_t index)
    in (nodeType == NodeType.nonterminal)
    in (grammarInfo !is null)
    {
        immutable(SymbolInstance)[] symbols = grammarInfo
            .allProductions[productionID - grammarInfo.startProductionID].symbols;
        size_t i;
        foreach (ref symbol; symbols)
        {
            if (symbol.dropNode)
                continue;
            if (i == index)
            {
                return symbols[i].symbolInstanceName;
            }
            i++;
        }
        assert(false);
    }
}

/**
Tree node class for token.
*/
final class DynamicParseTreeToken(Location, alias LocationRangeImpl = LocationRangeStartLength)
    : DynamicParseTree!(Location, LocationRangeImpl)
{
    private string content_;

    /**
    Creates tree node for token.

    Params:
        content = Text for the token.
        grammarInfo = Information about the grammar this token belongs to.
    */
    this(string content, immutable GrammarInfo* grammarInfo)
    {
        super(SymbolID.max, ProductionID.max, NodeType.token, grammarInfo);
        this.content_ = content;
    }

    override string content() const
    {
        return content_;
    }
}

/**
Tree node class for nonterminal.
*/
final class DynamicParseTreeNonterminal(Location, alias LocationRangeImpl = LocationRangeStartLength)
    : DynamicParseTree!(Location, LocationRangeImpl)
{
    private DynamicParseTree!(Location, LocationRangeImpl)[] childs_;

    /**
    Creates tree node for nonterminal.

    Params:
        nonterminalID = ID for nonterminal of this tree node matching grammarInfo.
        productionID = ID for production of this tree node matching grammarInfo.
        childs = Childs of this tree node. The number of childs should match the production.
        grammarInfo = Information about the grammar this nonterminal belongs to.
    */
    this(SymbolID nonterminalID, ProductionID productionID,
            DynamicParseTree!(Location, LocationRangeImpl)[] childs, immutable GrammarInfo* grammarInfo)
    {
        super(nonterminalID, productionID, NodeType.nonterminal, grammarInfo);
        this.childs_ = childs;
    }

    override string name() const
    {
        return grammarInfo.allNonterminals[nonterminalID - grammarInfo.startNonterminalID].name;
    }

    override inout(DynamicParseTree!(Location, LocationRangeImpl)[]) childs() inout
    {
        return childs_;
    }
}

/**
Tree node class for array.
*/
final class DynamicParseTreeArray(Location, alias LocationRangeImpl = LocationRangeStartLength)
    : DynamicParseTree!(Location, LocationRangeImpl)
{
    private DynamicParseTree!(Location, LocationRangeImpl)[] childs_;

    /**
    Creates tree node for array.

    Params:
        childs = Childs of this tree node.
        grammarInfo = Information about the grammar this array belongs to.
    */
    this(DynamicParseTree!(Location, LocationRangeImpl)[] childs, immutable GrammarInfo* grammarInfo)
    {
        super(SymbolID.max, ProductionID.max, NodeType.array, grammarInfo);
        this.childs_ = childs;
    }

    override string name() const
    {
        return "[]";
    }

    override inout(DynamicParseTree!(Location, LocationRangeImpl)[]) childs() inout
    {
        return childs_;
    }
}

/**
Tree node class for merged nodes.
*/
final class DynamicParseTreeMerged(Location, alias LocationRangeImpl = LocationRangeStartLength)
    : DynamicParseTree!(Location, LocationRangeImpl)
{
    private DynamicParseTree!(Location, LocationRangeImpl)[] childs_;

    /**
    Creates tree node for merged nodes.

    Params:
        nonterminalID = ID for nonterminal of this tree node matching grammarInfo.
        childs = Childs of this tree node. The number of childs should match the production.
        grammarInfo = Information about the grammar this nonterminal belongs to.
    */
    this(SymbolID nonterminalID,
            DynamicParseTree!(Location, LocationRangeImpl)[] childs, immutable GrammarInfo* grammarInfo)
    {
        super(nonterminalID, ProductionID.max, NodeType.merged, grammarInfo);
        this.childs_ = childs;
    }

    override string name() const
    {
        return grammarInfo.allNonterminals[nonterminalID - grammarInfo.startNonterminalID].name;
    }

    override inout(DynamicParseTree!(Location, LocationRangeImpl)[]) childs() inout
    {
        return childs_;
    }
}

/**
Type for temporarily storing array of parse trees during parsing. The array
will later be stored as DynamicParseTreeArray.
*/
struct DynamicParseTreeTmpArray(Location, alias LocationRangeImpl = LocationRangeStartLength)
{
    alias LocationDiff = typeof(Location.init - Location.init);
    DynamicParseTree!(Location, LocationRangeImpl)[] trees;
    Location end;
    alias trees this;
    enum isValid = true;
    enum specialArrayType = true;
}

/**
Convert tree to string.
*/
void treeToString(Location, alias LocationRangeImpl = LocationRangeStartLength)(
        const DynamicParseTree!(Location, LocationRangeImpl) tree, ref Appender!string app)
{
    if (tree is null)
    {
        app.put("null");
        return;
    }

    if (tree.nodeType == NodeType.token)
    {
        app.put("\"");
        foreach (dchar c; tree.content)
            app.put(escapeChar(c, false));
        app.put("\"");
    }
    else if (tree.nodeType == NodeType.array)
    {
        foreach (i, c; tree.childs)
        {
            if (i)
                app.put(", ");
            treeToString(c, app);
        }
    }
    else if (tree.nodeType == NodeType.nonterminal || tree.nodeType == NodeType.merged)
    {
        if (tree.nodeType == NodeType.merged)
            app.put("Merged:");
        app.put(tree.name);
        app.put("(");
        foreach (i, c; tree.childs)
        {
            if (!app.data.endsWith(", ") && !app.data.endsWith("("))
                app.put(", ");
            treeToString(c, app);
        }
        app.put(")");
    }
    else
        assert(false);
}

/// ditto
string treeToString(Location, alias LocationRangeImpl = LocationRangeStartLength)(
        const DynamicParseTree!(Location, LocationRangeImpl) tree)
{
    Appender!string app;
    treeToString(tree, app);
    return app.data;
}

enum PossibleNonterminalTypes
{
    none = 0,
    tree = 1,
    string = 2,
    array = 4,
    all = tree | string | array
}

template NonterminalUnionImpl(alias CreatorInstance)
{
    struct Union(PossibleNonterminalTypes possibleNonterminalTypes)
    {
        alias Location = CreatorInstance.Location;
        alias LocationRangeImpl = CreatorInstance.LocationRangeImpl;

        template NonterminalType(SymbolID nonterminalID)
                if ((nonterminalID >= CreatorInstance.startNonterminalID
                    && nonterminalID < CreatorInstance.endNonterminalID)
                    || nonterminalID == SymbolID.max)
        {
            alias NonterminalType = CreatorInstance.NonterminalType!nonterminalID;
        }

        union
        {
            static if (possibleNonterminalTypes & PossibleNonterminalTypes.array)
                CreatorInstance.NonterminalArray valueArray;
            static if (possibleNonterminalTypes & PossibleNonterminalTypes.string)
                string valueString;
            static if (possibleNonterminalTypes & PossibleNonterminalTypes.tree)
                CreatorInstance.NonterminalTree valueTree;
        }

        SymbolID nonterminalID = SymbolID.max;

        inout(NonterminalType!nonterminalID2) get(SymbolID nonterminalID2)() inout
        in
        {
            assert(nonterminalID2 == nonterminalID, text(nonterminalID2, "  ", nonterminalID));
        }
        do
        {
            static if (CreatorInstance.allNonterminals[nonterminalID2 - CreatorInstance.startNonterminalID].flags & NonterminalFlags.array)
                return valueArray;
            else static if (CreatorInstance.allNonterminals[nonterminalID2 - CreatorInstance.startNonterminalID].flags & NonterminalFlags.string)
                return valueString;
            else
                return valueTree;
        }

        auto get(nonterminalID2s...)() inout if (nonterminalID2s.length >= 2)
        {
            foreach (nonterminalID2; nonterminalID2s)
            {
                if (nonterminalID2 == nonterminalID)
                    return get!nonterminalID2();
            }
            assert(false);
        }

        static if (possibleNonterminalTypes & PossibleNonterminalTypes.tree)
            static Union create(SymbolID nonterminalID, CreatorInstance.NonterminalTree tree)
            in (CreatorInstance.isNonterminalTree(nonterminalID))
            {
                Union r;
                r.valueTree = tree;
                r.nonterminalID = nonterminalID;
                return r;
            }

        static if (possibleNonterminalTypes & PossibleNonterminalTypes.string)
            static Union create(SymbolID nonterminalID, string tree)
            in (CreatorInstance.isNonterminalString(nonterminalID))
            {
                Union r;
                r.valueString = tree;
                r.nonterminalID = nonterminalID;
                return r;
            }

        static if (possibleNonterminalTypes & PossibleNonterminalTypes.array)
            static Union create(SymbolID nonterminalID, CreatorInstance.NonterminalArray tree)
            in (CreatorInstance.isNonterminalArray(nonterminalID))
            {
                Union r;
                r.valueArray = tree;
                r.nonterminalID = nonterminalID;
                return r;
            }

        static Union create()(SymbolID nonterminalID)
        in (nonterminalID >= CreatorInstance.startNonterminalID && nonterminalID < CreatorInstance.endNonterminalID)
        {
            Union r;
            r.nonterminalID = nonterminalID;
            return r;
        }

        void opAssign(PossibleNonterminalTypes possibleNonterminalTypes2)(
                Union!(possibleNonterminalTypes2) rhs)
                if (possibleNonterminalTypes2 != possibleNonterminalTypes)
        {
            static if ((possibleNonterminalTypes & PossibleNonterminalTypes.tree) && (possibleNonterminalTypes2 & PossibleNonterminalTypes.tree))
                if (CreatorInstance.isNonterminalTree(rhs.nonterminalID))
                {
                    valueTree = rhs.valueTree;
                    nonterminalID = rhs.nonterminalID;
                    return;
                }
            static if ((possibleNonterminalTypes & PossibleNonterminalTypes.string) && (possibleNonterminalTypes2 & PossibleNonterminalTypes.string))
                if (CreatorInstance.isNonterminalString(rhs.nonterminalID))
                {
                    valueString = rhs.valueString;
                    nonterminalID = rhs.nonterminalID;
                    return;
                }
            static if ((possibleNonterminalTypes & PossibleNonterminalTypes.array) && (possibleNonterminalTypes2 & PossibleNonterminalTypes.array))
                if (CreatorInstance.isNonterminalArray(rhs.nonterminalID))
                {
                    valueArray = rhs.valueArray;
                    nonterminalID = rhs.nonterminalID;
                    return;
                }
            assert(0);
        }
    }

    template Union(alias nonterminalIDs)
    {
        alias Union = Union!(() {
            PossibleNonterminalTypes possibleNonterminalTypes;
            static foreach (n; nonterminalIDs)
            {
                static if (CreatorInstance.allNonterminals[n - CreatorInstance.startNonterminalID].flags & NonterminalFlags.array)
                    possibleNonterminalTypes |= PossibleNonterminalTypes.array;
                else static if (CreatorInstance.allNonterminals[n - CreatorInstance.startNonterminalID].flags & NonterminalFlags.string)
                    possibleNonterminalTypes |= PossibleNonterminalTypes.string;
                else
                    possibleNonterminalTypes |= PossibleNonterminalTypes.tree;
            }
            return possibleNonterminalTypes;
        }());
    }
}

/**
Class for creating trees during parsing.

Params:
    GrammarModule = Alias to the module with parser and information about the grammar.
    Location_ = Type of location in source file.
    LocationRangeImpl = Template for determining how location ranges are
        stored (start + length, start + end, ...).
*/
class DynamicParseTreeCreator(alias GrammarModule, Location_,
        alias LocationRangeImpl_ = LocationRangeStartLength)
{
    alias Location = Location_;
    alias LocationRangeImpl = LocationRangeImpl_;
    alias LocationDiff = typeof(Location.init - Location.init);
    alias allTokens = GrammarModule.allTokens;
    alias allNonterminals = GrammarModule.allNonterminals;
    alias allProductions = GrammarModule.allProductions;
    alias Type = DynamicParseTree!(Location, LocationRangeImpl);
    alias NonterminalArray = DynamicParseTreeTmpArray!(Location,
            LocationRangeImpl);
    alias NonterminalTree = DynamicParseTree!(Location,
            LocationRangeImpl);
    enum startNonterminalID = GrammarModule.startNonterminalID;
    enum endNonterminalID = GrammarModule.endNonterminalID;
    enum startProductionID = GrammarModule.startProductionID;
    enum endProductionID = GrammarModule.endProductionID;

    /**
    Type used for nonterminal with ID nonterminalID.
    */
    template NonterminalType(SymbolID nonterminalID)
    {
        static if (
            allNonterminals[nonterminalID - startNonterminalID].flags & NonterminalFlags.array)
            alias NonterminalType = NonterminalArray;
        else static if (
            allNonterminals[nonterminalID - startNonterminalID].flags & NonterminalFlags.string)
            alias NonterminalType = string;
        /*else static if (allNonterminals[nonterminalID - startNonterminalID].flags == NonterminalFlags.none
            || allNonterminals[nonterminalID - startNonterminalID].flags == NonterminalFlags.empty)
            alias NonterminalType = typeof(null);*/
        else
            alias NonterminalType = NonterminalTree;
    }

    static bool isNonterminalTree(SymbolID nonterminalID)
    {
        if (nonterminalID < startNonterminalID || nonterminalID >= endNonterminalID)
            return false;
        auto flags = allNonterminals[nonterminalID - startNonterminalID].flags;
        return (flags & (NonterminalFlags.array | NonterminalFlags.string)) == 0;
    }

    static bool isNonterminalArray(SymbolID nonterminalID)
    {
        if (nonterminalID < startNonterminalID || nonterminalID >= endNonterminalID)
            return false;
        auto flags = allNonterminals[nonterminalID - startNonterminalID].flags;
        return (flags & NonterminalFlags.array) != 0;
    }

    static bool isNonterminalString(SymbolID nonterminalID)
    {
        if (nonterminalID < startNonterminalID || nonterminalID >= endNonterminalID)
            return false;
        auto flags = allNonterminals[nonterminalID - startNonterminalID].flags;
        return (flags & (NonterminalFlags.array | NonterminalFlags.string)) == NonterminalFlags.string;
    }

    /**
    Determines if nonterminals with ID nonterminalID can be merged into
    a single tree node for ambiguities with the GLR parser. Function
    `mergeParseTrees` may be called for them.
    */
    template canMerge(SymbolID nonterminalID)
    {
        enum canMerge = is(NonterminalType!nonterminalID == DynamicParseTree!(Location,
                    LocationRangeImpl))
            || is(NonterminalType!nonterminalID == DynamicParseTreeTmpArray!(Location,
                    LocationRangeImpl));
    }

    /**
    Tagged union for different nonterminals, which is used internally by
    the parser. The union can allow more nonterminals than necessary,
    which can reduce template bloat.
    */
    alias NonterminalUnion = NonterminalUnionImpl!(DynamicParseTreeCreator).Union;

    /**
    Tagged union of all possible nonterminals, which is used internally by
    the parser.
    */
    alias NonterminalUnionAny = NonterminalUnionImpl!(DynamicParseTreeCreator).Union!(PossibleNonterminalTypes.all);

    /**
    Create a tree node for one production.

    Params:
        productionID = ID of the production starting at GrammarModule.startProductionID.
        firstParamStart = Location at the start of this subtree.
        lastParamEnd = Location at the end of this subtree.
        params = Childs for this subtree, which were previously also created by createParseTree.
    */
    NonterminalType!(allProductions[productionID - startProductionID].nonterminalID.id) createParseTree(
            SymbolID productionID, T...)(Location firstParamStart, Location lastParamEnd, T params)
            if (allProductions[productionID - startProductionID].symbols.length > 0)
    {
        enum nonterminalID = allProductions[productionID - startProductionID].nonterminalID.id;
        enum nonterminalName = allNonterminals[nonterminalID - startNonterminalID].name;
        enum nonterminalFlags = allNonterminals[nonterminalID - startNonterminalID].flags;
        assert(firstParamStart <= lastParamEnd);

        size_t numChilds;
        DynamicParseTree!(Location, LocationRangeImpl)[] childs;
        foreach (i, p; params)
        {
            static if (is(typeof(p.val) : DynamicParseTree!(Location, LocationRangeImpl)))
            {
                numChilds++;
            }
            else static if (is(typeof(p.val) : DynamicParseTreeTmpArray!(Location, LocationRangeImpl)))
            {
                static if (nonterminalFlags & NonterminalFlags.array)
                {
                    if (i == 0)
                        childs = p.val.trees;
                    numChilds += p.val.trees.length;
                }
                else
                {
                    numChilds++;
                }
            }
            else
            {
                numChilds++;
            }
        }
        childs.reserve(numChilds);
        foreach (i, p; params)
        {
            static if (is(typeof(p.val) : DynamicParseTree!(Location, LocationRangeImpl)))
            {
                childs ~= p.val;
                if (childs[$ - 1]!is null)
                {
                    static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                        childs[$ - 1].startFromParent = p.start - firstParamStart;
                    //childs[$ - 1].symbolInstanceAnnotations = allProductions[productionID - startProductionID].symbols[i].annotations;
                }
            }
            else static if (is(typeof(p.val) : DynamicParseTreeTmpArray!(Location, LocationRangeImpl)))
            {
                static if (nonterminalFlags & NonterminalFlags.array)
                {
                    if (i != 0)
                        childs ~= p.val.trees;
                    static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                    {
                        foreach (x; p.val.trees)
                        {
                            if (x !is null)
                            {
                                x.startFromParent = x.startFromParent + (p.start - firstParamStart);
                            }
                        }
                    }
                }
                else
                {
                    childs ~= new DynamicParseTreeArray!(Location, LocationRangeImpl)(p.val.trees,
                            &GrammarModule.grammarInfo);
                    static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                    {
                        childs[$ - 1].startFromParent = p.start - firstParamStart;
                        if (p.val.end == Location.invalid || p.start > p.val.end)
                            childs[$ - 1].inputLength = LocationDiff();
                        else
                            childs[$ - 1].inputLength = p.val.end - p.start;
                    }
                    else
                    {
                        childs[$ - 1].setStartEnd(p.start, p.val.end);
                    }
                }
            }
            else
            {
                string t = text(p.val);
                childs ~= new DynamicParseTreeToken!(Location, LocationRangeImpl)(t,
                        &GrammarModule.grammarInfo);
                static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                {
                    childs[$ - 1].startFromParent = p.start - firstParamStart;
                    childs[$ - 1].inputLength = LocationDiff.fromStr(t);
                }
                else
                {
                    if (t == "")
                        childs[$ - 1].setStartEnd(Location.invalid, Location.invalid);
                    else
                        childs[$ - 1].setStartEnd(p.start, p.end);
                }
            }
        }

        static if (nonterminalFlags & NonterminalFlags.array)
        {
            return DynamicParseTreeTmpArray!(Location, LocationRangeImpl)(childs, lastParamEnd);
        }
        else static if (nonterminalFlags & NonterminalFlags.string)
        {
            string r;
            foreach (c; childs)
                r ~= c.content;
            return r;
        }
        else
        {
            auto r = new DynamicParseTreeNonterminal!(Location, LocationRangeImpl)(
                    nonterminalID, productionID,
                    childs, &GrammarModule.grammarInfo);
            static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
            {
                // r.startFromParent will be set later
                r.inputLength = lastParamEnd - firstParamStart;
            }
            else
            {
                r.setStartEnd(firstParamStart, lastParamEnd);
            }
            //r.annotations = nonterminalAnnotations;
            return r;
        }
    }

    /// ditto
    NonterminalType!(allProductions[productionID - startProductionID].nonterminalID.id) createParseTree(SymbolID productionID)(
            Location firstParamStart, Location lastParamEnd)
            if (allProductions[productionID - startProductionID].symbols.length == 0)
    {
        //enum nonterminalID = allProductions[productionID - startProductionID].nonterminalID;
        //enum nonterminalName = allNonterminals[nonterminalID - startNonterminalID].name;

        static if (is(typeof(return) : DynamicParseTreeTmpArray!(Location, LocationRangeImpl)))
        {
            return DynamicParseTreeTmpArray!(Location, LocationRangeImpl)([], Location.invalid);
        }
        else
            return null;
    }

    /**
    Create a tree node for multiple productions, which are treated as the
    same. This is used with the generator option --combinedreduce.

    Params:
        nonterminalID = ID of the nonterminal starting at GrammarModule.startNonterminalID.
        productionIDs = IDs of the productions starting at GrammarModule.startProductionID.
            all have to be for the nonterminal with ID nonterminalID.
        firstParamStart = Location at the start of this subtree.
        lastParamEnd = Location at the end of this subtree.
        params = Childs for this subtree, which were previously also created by createParseTree.
    */
    template createParseTreeCombined(SymbolID nonterminalID, productionIDs...)
    {
        NonterminalType!(allProductions[productionIDs[0] - startProductionID].nonterminalID.id) createParseTreeCombined(
                T...)(Location firstParamStart, Location lastParamEnd, T params)
        {
            NonterminalType!(allProductions[productionIDs[0] - startProductionID].nonterminalID.id) r = createParseTree!(
                    productionIDs[0])(firstParamStart, lastParamEnd, params);
            static if (__traits(hasMember, r, "nonterminalID"))
                r.nonterminalID = nonterminalID;
            return r;
        }
    }

    /**
    Called for the outermost tree node after parsing. It adjusts
    the start location if it is stored as the offset from the parent node.

    Params:
        result = Outermost tree node.
        start = Start location of the tree.
    */
    void adjustStart(T)(T result, Location start)
    {
        static if (!is(typeof(result.start)))
            if (result !is null)
                result.startFromParent = start - Location();
    }

    private DynamicParseTree!(Location, LocationRangeImpl) mergeParseTreesImpl(
            SymbolID nonterminalID, Location firstParamStart, Location lastParamEnd, ParseStackElem!(Location,
            DynamicParseTree!(Location, LocationRangeImpl))[] trees)
    {
        //enum nonterminalName = allNonterminals[nonterminalID - startNonterminalID].name;
        //assert(firstParamStart <= lastParamEnd);

        DynamicParseTree!(Location, LocationRangeImpl)[] childs;
        foreach (i, p; trees)
        {
            childs ~= p.val;
            if (childs[$ - 1]!is null)
            {
                static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                    childs[$ - 1].startFromParent = p.start - firstParamStart;
            }
        }

        auto r = new DynamicParseTreeMerged!(Location, LocationRangeImpl)(
                nonterminalID, childs, &GrammarModule.grammarInfo);
        static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
        {
            // r.startFromParent will be set later
            r.inputLength = lastParamEnd - firstParamStart;
        }
        else
        {
            r.setStartEnd(firstParamStart, lastParamEnd);
        }
        //r.annotations = allNonterminals[nonterminalID - startNonterminalID].annotations;
        return r;
    }

    private DynamicParseTreeTmpArray!(Location, LocationRangeImpl) mergeParseTreesImplArray(
            SymbolID nonterminalID, Location firstParamStart, Location lastParamEnd, ParseStackElem!(Location,
            DynamicParseTreeTmpArray!(Location, LocationRangeImpl))[] trees)
    {
        //enum nonterminalName = allNonterminals[nonterminalID - startNonterminalID].name;
        //assert(firstParamStart <= lastParamEnd);

        size_t commonPrefix;
        outer: while (true)
        {
            foreach (p; trees)
            {
                if (p.val.trees.length <= commonPrefix)
                    break outer;
            }
            foreach (i, p; trees[0 .. $ - 1])
            {
                if (trees[i].val.trees[commonPrefix] !is trees[i + 1].val.trees[commonPrefix])
                    break outer;
            }
            commonPrefix++;
        }

        DynamicParseTree!(Location, LocationRangeImpl)[] childs;
        foreach (i, p; trees)
        {
            childs ~= new DynamicParseTreeArray!(Location, LocationRangeImpl)(
                    p.val.trees[commonPrefix .. $], &GrammarModule.grammarInfo);
            Location start = p.start;
            foreach (c; p.val.trees[commonPrefix .. $])
            {
                if (c !is null)
                {
                    static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
                        start = p.start + c.startFromParent;
                    else
                        start = c.start;
                    break;
                }
            }
            static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
            {
                childs[$ - 1].startFromParent = start - firstParamStart;
                if (p.val.end == Location.invalid || start > p.val.end)
                    childs[$ - 1].inputLength = LocationDiff();
                else
                    childs[$ - 1].inputLength = p.val.end - p.start;
            }
            else
            {
                childs[$ - 1].setStartEnd(p.start, p.val.end);
            }
        }

        auto r = new DynamicParseTreeMerged!(Location, LocationRangeImpl)(
                nonterminalID, childs, &GrammarModule.grammarInfo);
        static if (isLocationRangeStartDiffLength!(LocationRangeImpl!Location))
        {
            // r.startFromParent will be set later
            r.inputLength = lastParamEnd - firstParamStart;
        }
        else
        {
            r.setStartEnd(firstParamStart, lastParamEnd);
        }
        //r.annotations = allNonterminals[nonterminalID - startNonterminalID].annotations;
        return DynamicParseTreeTmpArray!(Location, LocationRangeImpl)(
                trees[0].val.trees[0 .. commonPrefix] ~ r, lastParamEnd);
    }

    /**
    Creates a special tree node, which contains different ambiguous trees
    as childs. This is used by GLR parsers. It will only be called by the
    parser if canMerge!nonterminalID is true.

    Params:
        nonterminalID = ID of the nonterminal starting at GrammarModule.startNonterminalID.
        firstParamStart = Location at the start of this subtree.
        lastParamEnd = Location at the end of this subtree.
        trees = Childs for this subtree.
        mergeInfo = Name for this tree node or empty for automatically
            generated name.
    */
    NonterminalType!(nonterminalID) mergeParseTrees(SymbolID nonterminalID)(Location firstParamStart, Location lastParamEnd,
            ParseStackElem!(Location, NonterminalType!nonterminalID)[] trees)
    {
        static if (is(NonterminalType!nonterminalID == DynamicParseTreeTmpArray!(Location,
                LocationRangeImpl)))
            return mergeParseTreesImplArray(nonterminalID, firstParamStart, lastParamEnd, trees);
        else
            return mergeParseTreesImpl(nonterminalID, firstParamStart, lastParamEnd, trees);
    }
}

private void printTree(Location, alias LocationRangeImpl)
    (imported!"std.stdio".File file, DynamicParseTree!(Location, LocationRangeImpl) tree, ref Appender!(char[]) appIndent, bool isLast, bool verbose)
{
    import std.stdio;

    write(appIndent.data);
    write("+-");
    if (tree is null)
    {
        writeln("null");
        return;
    }
    if (tree.nodeType == NodeType.token)
        write("\"", tree.content.escapeD, "\"");
    else
    {
        if (tree.nodeType == NodeType.merged)
            write("Merged:");
        write(tree.name);
    }
    if (tree.start == Location.invalid)
        writeln(" <???>");
    else
        writeln(" <", tree.start.toPrettyString, ">");
    size_t indentLength = appIndent.data.length;
    if (!isLast)
        appIndent.put("| ");
    else
        appIndent.put("  ");
    if (verbose)
    {
        foreach (i, child; tree.childs)
        {
            printTree(file, child, appIndent, i + 1 >= tree.childs.length, verbose);
        }
    }
    else
    {
        typeof(tree) lastChild;
        foreach (child; tree.childs)
        {
            if (child is null)
                continue;
            if (child.nodeType == NodeType.array)
            {
                foreach (child2; child.childs)
                    if (child2 !is null)
                        lastChild = child2;
            }
            else
                lastChild = child;
        }
        foreach (i, child; tree.childs)
        {
            if (child is null)
                continue;
            if (child.nodeType == NodeType.array)
            {
                foreach (child2; child.childs)
                    if (child2 !is null)
                        printTree(file, child2, appIndent, child2 is lastChild, verbose);
            }
            else
                printTree(file, child, appIndent, child is lastChild, verbose);
        }
    }
    appIndent.shrinkTo(indentLength);
}

/**
Print the tree to a file.

Params:
    file = File for output.
    tree = The tree to print.
    verbose = Include all nodes in the tree.
*/
void printTree(Location, alias LocationRangeImpl)
    (imported!"std.stdio".File file, DynamicParseTree!(Location, LocationRangeImpl) tree, bool verbose = false)
{
    Appender!(char[]) appIndent;
    printTree(file, tree, appIndent, true, verbose);
}
