
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.utils;
import std.algorithm;
import std.conv;
import std.range;
import std.string;
import std.typetuple;
import std.uni;
import std.utf;

/**
Adds elements to dst, which are not already in dst.
*/
bool addOnce(T)(ref T[] dst, T[] src)
{
    bool r = false;
    foreach (s; src)
    {
        if (!canFind(dst, s))
        {
            dst ~= s;
            r = true;
        }
    }
    return r;
}

/// ditto
bool addOnce(T)(ref T[] dst, T s)
{
    bool r = false;
    if (!canFind(dst, s))
    {
        dst ~= s;
        r = true;
    }
    return r;
}

/**
Creates an alias sequence with all members of array a.
*/
template arrayToAliasSeq(alias a)
{
    static if (a.length == 0)
        alias arrayToAliasSeq = AliasSeq!();
    else static if (a.length == 1)
        alias arrayToAliasSeq = AliasSeq!(a[0]);
    else
        alias arrayToAliasSeq = AliasSeq!(arrayToAliasSeq!(a[0 .. $ / 2]),
                arrayToAliasSeq!(a[$ / 2 .. $]));
}

/**
Creates an alias sequence containing T if b is true. An empty alias sequence
is created otherwise.
*/
template AliasSeqIf(bool b, T...)
{
    static if (b)
        alias AliasSeqIf = T;
    else
        alias AliasSeqIf = AliasSeq!();
}

private immutable char[2][] escapeSequences = [
    ['\\', '\\'],
    ['\"', '\"'],
    ['\'', '\''],
    ['\n', 'n'],
    ['\t', 't'],
    ['\r', 'r'],
    ['\f', 'f'],
    ['\0', '0'],
    ['\a', 'a'],
    ['\b', 'b'],
    ['\v', 'v'],
];

/**
Escapes character c for use in a D string literal.

Params:
    c = The character to be escaped.
    alwaysEscape = Selects if every character should be escaped.
*/
string escapeChar(dchar c, bool alwaysEscape)
{
    foreach (s; escapeSequences)
    {
        if (c == s[0])
            return text("\\", s[1]);
    }
    if (c < 0x20 || c == 0x7f)
        return format("\\x%02X", c);
    if (c > 0xff && c <= 0xffff)
        return format("\\u%04X", c);
    if (c > 0xffff)
        return format("\\U%08X", c);
    if (alwaysEscape)
        return text("\\", c);
    else
        return text(c);
}

/**
Escapes every character in s for use in a D string literal.
*/
string escapeD(const(char)[] s)
{
    string r;
    foreach (dchar c; s)
    {
        r ~= escapeChar(c, false);
    }
    return r;
}

/**
Generates a D string literal for s.
*/
string toDStringLiteral(const(char)[] s)
{
    return text("\"", s.escapeD, "\"");
}

/**
Escape string for HTML.
*/
string escapeHTML(const(char)[] s)
{
    Appender!string app;
    foreach (char c; s)
    {
        if (c == '&')
            app.put("&amp;");
        else if (c == '\"')
            app.put("&quot;");
        else if (c == '$')
            app.put("&#36;");
        else if (c == '<')
            app.put("&lt;");
        else if (c == '>')
            app.put("&gt;");
        else
            app.put(c);
    }
    return app.data;
}

/**
Unescaped character.
*/
struct UnescapedChar
{
    /**
    The unescaped character.
    */
    dchar c;

    /**
    Was the character escaped?
    */
    bool isEscaped;
}

/**
Iterate string by unescaped character.
*/
auto byUnescapedDchar(R)(R range) if (isInputRange!R && is(ElementType!R == dchar))
{
    static struct X
    {
        R range;

        UnescapedChar front;

        bool empty;

        void popFront()
        {
            if (range.empty)
            {
                empty = true;
                return;
            }
            dchar next = range.front;
            range.popFront;
            bool isEscaped = false;
            if (next == '\\')
            {
                isEscaped = true;
                if (range.empty)
                    throw new Exception(text("missing escape sequence "));
                next = range.front;
                range.popFront;

                if (next == 'x' || next == 'u' || next == 'U')
                {
                    ubyte len = 0;
                    if (next == 'x')
                        len = 2;
                    else if (next == 'u')
                        len = 4;
                    else if (next == 'U')
                        len = 8;
                    dchar[8] unicodeHex;
                    foreach (i; 0 .. len)
                    {
                        if (range.empty)
                            throw new Exception(text("missing hex value for \"\\", next, "\""));
                        unicodeHex[i] = range.front;
                        range.popFront;
                    }
                    dchar[] unicodeHexRef = unicodeHex[0 .. len];
                    next = cast(dchar) parse!uint(unicodeHexRef, 16);
                    if (len == 2 && !isValidCodepoint(cast(char) next))
                    {
                        throw new Exception(text("Invalid UTF character \\x", unicodeHex[0 .. len]));
                    }
                    if (len == 4 && !isValidCodepoint(cast(wchar) next))
                    {
                        throw new Exception(text("Invalid UTF character \\u", unicodeHex[0 .. len]));
                    }
                    if (len == 8 && !isValidCodepoint(cast(dchar) next))
                    {
                        throw new Exception(text("Invalid UTF character \\U", unicodeHex[0 .. len]));
                    }
                    if (unicodeHexRef.length)
                        throw new Exception(text("escape sequence ", next, " ",
                                unicodeHex[0 .. len], "not completely parsed"));
                }
                else
                {
                    foreach (s; escapeSequences)
                    {
                        if (next == s[1])
                            next = s[0];
                    }
                }
                /*else
                    throw new Exception(text("unknown escape sequence \"\\", next, "\""));*/
            }
            front = UnescapedChar(next, isEscaped);
        }
    }

    X x = X(range);
    x.popFront;
    return x;
}

/**
Generates sorted array of all keys in associative array.
*/
K[] sortedKeys(alias less = "a < b", K, V)(V[K] aa)
{
    K[] r;
    foreach (k, _; aa)
        r ~= k;
    sort!less(r);
    return r;
}

/// ditto
const(K)[] sortedKeys(alias less = "a < b", K, V)(const V[K] aa)
{
    K[] r;
    foreach (k, _; aa)
        r ~= k;
    sort!less(r);
    return r;
}

/**
Helper for list of todo items, which can be added while iterating.
*/
class TodoList(K)
{
    private Appender!(K[]) app;
    private size_t[K] byKey;

    /**
    Add item `key` if not already in list.
    */
    void put(K key)
    {
        if (key in byKey)
            return;
        size_t i = app.data.length;
        app.put(key);
        byKey[key] = i;
    }

    /**
    Add items `keys` if not already in list.
    */
    void put(K[] keys)
    {
        app.reserve(app.data.length + keys.length);
        foreach (key; keys)
            put(key);
    }

    static struct Range
    {
        TodoList!K todoList;
        size_t i;
        bool empty() const
        {
            return i >= todoList.app.data.length;
        }

        K front()
        {
            return todoList.app.data[i];
        }

        void popFront()
        {
            i++;
        }
    }

    /**
    Iterate over all items including items added while iterating.
    */
    Range keys()
    {
        return Range(this, 0);
    }

    /**
    Returns the current list of items.
    */
    K[] data()
    {
        return app.data;
    }
}

/**
Escape codepoint.

Params:
    codepoint = The codepoint to be escaped.
    isSet = Additionally escape the characters "[]^-", so it can be used
        in a codepoint set.
*/
string escapeCodePoint(uint codepoint, bool inSet)
{
    bool alwaysEscape = false;

    if (inSet && (codepoint == '[' || codepoint == ']' || codepoint == '^' || codepoint == '-'))
        alwaysEscape = true;
    return escapeChar(cast(dchar) codepoint, alwaysEscape);
}

/**
Parse representation of codepoint set.

Params:
    spec = Specification of the codepoint set. Can contain a list of
        single codepoints and ranges seperated by '-'. The set can be
        inverted by starting the specification with '^'. Characters can
        also be escaped using '\'.
*/
CodepointSet codepointSetFromStr(string spec)
{
    CodepointSet set;
    auto chars = spec.byDchar.byUnescapedDchar;

    bool invert;
    if (!chars.empty && !chars.front.isEscaped && chars.front.c == '^')
    {
        invert = true;
        chars.popFront;
    }

    while (!chars.empty)
    {
        dchar current = chars.front.c;
        if (current == '-' && !chars.front.isEscaped)
            throw new Exception("'-' at wrong place");
        if (current == '−')
            throw new Exception("Unexpected '−'. Did you mean '-'?");
        try
        {
            chars.popFront;
        }
        catch (Exception e)
        {
            throw new Exception("Error parsing codepoint set \"" ~ spec ~ "\": " ~ e.msg);
        }

        if (chars.front.c == '−')
            throw new Exception("Unexpected '−'. Did you mean '-'?");

        if (!chars.empty && !chars.front.isEscaped && chars.front.c == '-')
        {
            chars.popFront;
            if (chars.empty)
                throw new Exception("'-' at end " ~ spec);
            if (chars.front.c == '−')
                throw new Exception("Unexpected '−'. Did you mean '-'?");

            dchar end = chars.front.c;
            if (end == '-' && !chars.front.isEscaped)
                throw new Exception("'-' after another '-'" ~ "  " ~ spec);
            chars.popFront;

            if (end < current)
                throw new Exception(text("illegal interval [", spec, "] ",
                        current.escapeCodePoint(true), " - ", end.escapeCodePoint(true)));

            set |= CodepointSet(current, end + 1);
        }
        else
        {
            set |= CodepointSet(current, current + 1);
        }
    }
    if (invert)
        return set.inverted;
    else
        return set;
}

/**
Check if character `c` belongs to the set specified by `spec`. See
[codepointSetFromStr] for the syntax of spec.
*/
bool inCharSet(const(char)[] spec)(dchar c)
{
    mixin(() {
        auto set = codepointSetFromStr(spec);
        string code;

        foreach (interval; set.byInterval)
        {
            code ~= text("if (c >= '", interval[0].escapeCodePoint(false), "' && c <= '",
                (interval[1] - 1).escapeCodePoint(false), "') return true;\n");
        }

        code ~= "return false;";
        return code;
    }());
}

///
unittest
{
    assert('a'.inCharSet!"a-z0-9");
    assert('x'.inCharSet!"a-z0-9");
    assert('z'.inCharSet!"a-z0-9");
    assert('0'.inCharSet!"a-z0-9");
    assert('5'.inCharSet!"a-z0-9");
    assert('0'.inCharSet!"a-z0-9");

    assert(!'\0'.inCharSet!"a-z0-9");
    assert(!'A'.inCharSet!"a-z0-9");
    assert(!'-'.inCharSet!"a-z0-9");

    assert(!'a'.inCharSet!"^a-z0-9");
    assert('#'.inCharSet!"^a-z0-9");
}

string repeatChar(char c)(size_t num)
{
    static Appender!(immutable(char)[]) app;
    while (app.data.length < num)
        app.put(c);
    return app.data[0 .. num];
}

/**
Allocator for array, which is used internally for temporary data.
*/
struct SimpleArrayAllocator(T, size_t blockSize = 4 * 1024 - 32)
{
    enum classSize = T.sizeof;
    enum classesPerBlock = blockSize / classSize;

    private T[] data;
    private T[][] usedData;
    private size_t usedBlocks;

    private void nextBlock()
    {
        if (usedBlocks < usedData.length)
        {
            data = usedData[usedBlocks];
            usedBlocks++;
            return;
        }
        assert(usedBlocks == usedData.length);
        data = new T[classesPerBlock];
        usedData ~= data;
        usedBlocks++;
    }

    /**
    Allocate array.

    Params:
        value = Initial value used for every element.
        num = Length of array.
    */
    T[] allocate(U)(U value, size_t num)
    {
        if (data.length < num)
        {
            if ((data.length < 100 || data.length < classesPerBlock / 2) && num <= classesPerBlock)
            {
                nextBlock();
            }
            else
            {
                T[] r;
                r.length = num;
                r[] = value;
                return r;
            }
        }
        auto r = data[0 .. num];
        data = data[num .. $];
        r[] = value;
        return r;
    }

    /**
    Clear all referenced data, so it can be reused.
    */
    void clearAll()
    {
        foreach (i; 0 .. usedBlocks)
        {
            usedData[i][] = T.init;
        }
        usedBlocks = 0;
        data = [];
    }
}

/**
Convert enum to string by interpreting the members as flags.
*/
string flagsToString(E)(E e) if (is(E == enum))
{
    string r;
    E unknown = e;
    string noneEntry = "0";
    foreach (name; __traits(allMembers, E))
    {
        static if (__traits(getMember, E, name) == 0)
            noneEntry = name;
        else if ((e & __traits(getMember, E, name)) == __traits(getMember, E, name))
        {
            if (r.length)
                r ~= "|";
            r ~= name;
            unknown &= ~__traits(getMember, E, name);
        }
    }
    if (unknown)
    {
        if (r.length)
            r ~= "|";
        r ~= text(cast(uint) unknown);
    }
    if (r.length == 0)
        r = noneEntry;
    return r;
}

///
unittest
{
    enum EnumTest
    {
        a = 1,
        b = 2,
        c = 6,
        d = 24
    }

    assert(flagsToString(EnumTest.a) == "a");
    assert(flagsToString(EnumTest.b) == "b");
    assert(flagsToString(EnumTest.c) == "b|c");
    assert(flagsToString(EnumTest.d) == "d");
    assert(flagsToString(EnumTest.a | EnumTest.b) == "a|b");
    assert(flagsToString(EnumTest.a | EnumTest.c) == "a|b|c");
    assert(flagsToString(EnumTest.a | EnumTest.d) == "a|d");
    assert(flagsToString(EnumTest.b | EnumTest.d) == "b|d");
    assert(flagsToString(EnumTest.c | EnumTest.d) == "b|c|d");
    assert(flagsToString(EnumTest.a | EnumTest.c | EnumTest.d) == "a|b|c|d");
    assert(flagsToString(EnumTest.c & ~EnumTest.b) == "4");
    assert(flagsToString(cast(EnumTest) 8) == "8");
    assert(flagsToString(cast(EnumTest) 9) == "a|8");
}

/**
Returns member of object, which is not null, and the default value for
null objects.
*/
auto memberOrDefault(string name, T)(T obj) if (is(T == class))
{
    if (obj is null)
        return typeof({ return __traits(getMember, obj, name); }()).init;
    else
        return __traits(getMember, obj, name);
}
