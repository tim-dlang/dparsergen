
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.production;
public import dparsergen.core.grammarinfo;
import std.array;

struct TagID
{
    ubyte id;

    int opCmp(TagID other) const pure nothrow
    {
        if (id < other.id)
            return -1;
        if (id > other.id)
            return 1;
        return 0;
    }
}

enum StdAnnotations = [
    "empty",
    "array",
    "backtrack",
    "deactivated",
    "directUnwrap",
    "flatten",
    "ignoreInConflict",
    "ignoreToken",
    "inContextOnly",
    "lookahead",
    "lowPrio",
    "regArray",
    "start",
    "string",
    "regexLookahead",
    "store",
    "compareTrue",
    "compareFalse",
    "eager",
    "eagerEnd",
    "recursiveLexer",
    "inheritAnyTag",
    "minimalMatch",
    "noOptDescent"
];

mixin(() {
    import std.string;

    string r = "enum AnnotationFlags {";
    r ~= "NONE = 0, ";
    foreach (i, a; StdAnnotations)
        r ~= format("%s = %d, ", a, 1 << i);
    r ~= format("ALL = %d", (1 >> StdAnnotations.length) - 1);
    r ~= "}";
    return r;
}());

struct Annotations
{
    AnnotationFlags stdAnnotations;
    immutable(string)[] otherAnnotations;
    this(immutable(string)[] annotations)
    {
        add(annotations);
    }

    void add(string annotation)
    {
        import std.algorithm;

        mixin(() {
            import std.string;

            string r = "";
            foreach (i, a; StdAnnotations)
                r ~= format("%sif(annotation == \"%s\") stdAnnotations |= AnnotationFlags.%s;",
                    (i) ? "else " : "", a, a);
            r ~= "else if (!std.algorithm.canFind(otherAnnotations, annotation)) otherAnnotations ~= annotation;";
            return r;
        }());
    }

    void add(immutable(string)[] annotations)
    {
        foreach (annotation; annotations)
        {
            add(annotation);
        }
    }

    void add(const Annotations annotations)
    {
        stdAnnotations |= annotations.stdAnnotations;
        foreach (annotation; annotations.otherAnnotations)
        {
            add(annotation);
        }
    }

    bool canFind(string annotation) const pure nothrow
    {
        mixin(() {
            import std.string;

            string r = "";
            foreach (i, a; StdAnnotations)
                r ~= format("if (annotation == \"%s\") return (stdAnnotations & AnnotationFlags.%s) != 0;",
                    a, a);
            return r;
        }());
        import std.algorithm;

        return std.algorithm.canFind(otherAnnotations, annotation);
    }

    bool contains(string annotation)() const pure nothrow
    {
        mixin(() {
            import std.string;

            foreach (i, a; StdAnnotations)
                if (a == annotation)
                    return format("return (stdAnnotations & AnnotationFlags.%s) != 0;", a);
            string r;
            r ~= "import std.algorithm;";
            r ~= "return std.algorithm.canFind(otherAnnotations, annotation);";
            return r;
        }());
    }

    string toString() const
    {
        import std.conv;
        import std.string;

        string r = "[";
        foreach (i, a; StdAnnotations)
            if (stdAnnotations & (1 << i))
                r ~= text("\"", a, "\", ");
        foreach (a; otherAnnotations)
            r ~= text("\"", a, "\", ");
        if (r.endsWith(", "))
            r = r[0 .. $ - 2];
        r ~= "]";
        return r;
    }

    string toStringCode(bool spaceAfter = false) const
    {
        Appender!string app;
        toStringCode(app, spaceAfter);
        return app.data;
    }

    void toStringCode(ref Appender!string app, bool spaceAfter = false) const
    {
        foreach (i, a; StdAnnotations)
            if (stdAnnotations & (1 << i))
            {
                if (!spaceAfter)
                    app.put(" ");
                app.put("@");
                app.put(a);
                if (spaceAfter)
                    app.put(" ");
            }
        foreach (a; otherAnnotations)
        {
            if (!spaceAfter)
                app.put(" ");
            app.put("@");
            app.put(a);
            if (spaceAfter)
                app.put(" ");
        }
    }

    bool empty() const
    {
        return stdAnnotations == AnnotationFlags.NONE && otherAnnotations.length == 0;
    }
}

struct TagUsage
{
    TagID tag;
    bool inherit;
    bool needed;
    bool reject;

    int opCmp(TagUsage other) const pure nothrow
    {
        if (tag.id < other.tag.id)
            return -1;
        if (tag.id > other.tag.id)
            return 1;
        return 0;
    }
}

struct Token
{
    string name;
    Annotations annotations;
}

struct Nonterminal
{
    string name;
    NonterminalFlags flags;
    Annotations annotations;
    immutable(SymbolID)[] buildNonterminals;
    immutable(TagID)[] possibleTags;
}

struct Tag
{
    string name;
}

struct SymbolInstance
{
    Symbol symbol;
    alias symbol this;
    string subToken;
    string symbolInstanceName;
    bool unwrapProduction;
    bool dropNode;
    Annotations annotations;
    immutable(Symbol)[] negLookaheads;
    immutable(TagUsage)[] tags;
}

struct Production
{
    NonterminalID nonterminalID = NonterminalID(SymbolID.max);
    immutable(SymbolInstance)[] symbols;
    ProductionID productionID = ProductionID.max;
    Annotations annotations;
    Symbol[] negLookaheads;
    bool negLookaheadsAnytoken;
    bool isVirtual;
    RewriteRule[] rewriteRules;
    immutable(TagID)[] tags;

    immutable(Production*) idup() const
    {
        immutable(RewriteRule)[] newRewriteRules;
        foreach (rule; rewriteRules)
            newRewriteRules ~= immutable(RewriteRule)(rule.applyProduction.idup,
                    rule.parameters.idup, rule.startOf, rule.newPos);
        return new immutable(Production)(nonterminalID, symbols, productionID, annotations,
                negLookaheads.idup, negLookaheadsAnytoken, isVirtual, newRewriteRules, tags);
    }

    Production* dup() const
    {
        RewriteRule[] newRewriteRules;
        foreach (rule; rewriteRules)
            newRewriteRules ~= RewriteRule(rule.applyProduction,
                    rule.parameters.dup, rule.startOf, rule.newPos);
        return new Production(nonterminalID, symbols, productionID, annotations,
                negLookaheads.dup, negLookaheadsAnytoken, isVirtual, newRewriteRules, tags);
    }
}

struct RewriteRule
{
    const Production* applyProduction;
    size_t[] parameters;
    size_t startOf = size_t.max; // copy start Location from here
    size_t newPos;
}
