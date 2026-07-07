
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.parsestackelem;

/**
Value for nonterminal or token with start location stored on parse stack.
*/
struct ParseStackElem(Location, T)
{
    alias LocationDiff = typeof(Location.init - Location.init);

    /**
    Start location.
    */
    Location start;

    /**
    Value for nonterminal or token.
    */
    T val;

    /**
    Constructor.
    */
    this(Location start, T val)
    {
        this.start = start;
        this.val = val;
    }

    /**
    Length of the value.
    */
    LocationDiff inputLength()() const
    {
        static if (is(typeof(val.inputLength)))
        {
            static if (__traits(compiles, val is null))
                if (val is null)
                    return LocationDiff();
            return val.inputLength;
        }
        else static if (is(T == string))
        {
            return LocationDiff.fromStr(val);
        }
        else static if (is(T == X[], X))
        {
            assert(false);
        }
        else static if (is(T == typeof(null)))
            return LocationDiff();
        else
            static assert(0, T.stringof);
    }

    /**
    End location for the location.
    */
    Location end()() const
    {
        static if (is(typeof(val.end)))
        {
            static if (__traits(compiles, val is null))
                if (val is null)
                    return Location.invalid;
            return val.end;
        }
        else
            return start + inputLength;
    }
}

unittest
{
    import dparsergen.core.location;

    auto e1 = ParseStackElem!(LocationBytes, string)(LocationBytes(5), null);
    assert(e1.inputLength == LocationBytes.LocationDiff());
    assert(e1.end == LocationBytes(5));

    auto e2 = ParseStackElem!(LocationBytes, string)(LocationBytes(10), "test");
    assert(e2.inputLength == LocationBytes.LocationDiff(4));
    assert(e2.end == LocationBytes(14));
}

unittest
{
    import dparsergen.core.location;

    class Tree1
    {
        LocationBytes.LocationDiff inputLength;
        this(LocationBytes.LocationDiff inputLength)
        {
            this.inputLength = inputLength;
        }
    }

    auto e1 = ParseStackElem!(LocationBytes, Tree1)(LocationBytes(5), null);
    assert(e1.inputLength == LocationBytes.LocationDiff());
    assert(e1.end == LocationBytes(5));

    auto e2 = ParseStackElem!(LocationBytes, Tree1)(LocationBytes(10), new Tree1(LocationBytes.LocationDiff(2)));
    assert(e2.inputLength == LocationBytes.LocationDiff(2));
    assert(e2.end == LocationBytes(12));
}

unittest
{
    import dparsergen.core.location;

    class Tree2
    {
        LocationBytes end;
        this(LocationBytes end)
        {
            this.end = end;
        }
    }

    auto e1 = ParseStackElem!(LocationBytes, Tree2)(LocationBytes(5), null);
    //assert(e1.inputLength == LocationBytes.LocationDiff());
    assert(e1.end == LocationBytes.invalid);

    auto e2 = ParseStackElem!(LocationBytes, Tree2)(LocationBytes(10), new Tree2(LocationBytes(12)));
    //assert(e2.inputLength == LocationBytes.LocationDiff(2));
    assert(e2.end == LocationBytes(12));
}

unittest
{
    import dparsergen.core.location;

    struct Tree3
    {
        LocationBytes.LocationDiff inputLength;
        this(LocationBytes.LocationDiff inputLength)
        {
            this.inputLength = inputLength;
        }
    }

    auto e1 = ParseStackElem!(LocationBytes, Tree3)(LocationBytes(5), Tree3.init);
    assert(e1.inputLength == LocationBytes.LocationDiff());
    assert(e1.end == LocationBytes(5));

    auto e2 = ParseStackElem!(LocationBytes, Tree3)(LocationBytes(10), Tree3(LocationBytes.LocationDiff(2)));
    assert(e2.inputLength == LocationBytes.LocationDiff(2));
    assert(e2.end == LocationBytes(12));
}

unittest
{
    import dparsergen.core.location;

    struct Tree4
    {
        LocationBytes end;
        this(LocationBytes end)
        {
            this.end = end;
        }
    }

    auto e1 = ParseStackElem!(LocationBytes, Tree4)(LocationBytes(5), Tree4.init);
    //assert(e1.inputLength == LocationBytes.LocationDiff());
    assert(e1.end == LocationBytes.init);

    auto e2 = ParseStackElem!(LocationBytes, Tree4)(LocationBytes(10), Tree4(LocationBytes(12)));
    //assert(e2.inputLength == LocationBytes.LocationDiff(2));
    assert(e2.end == LocationBytes(12));
}
