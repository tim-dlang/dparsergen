
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
            static if (__traits(compiles, tree is null))
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
            static if (__traits(compiles, tree is null))
                if (val is null)
                    return Location.invalid;
            return val.end;
        }
        else
            return start + inputLength;
    }
}
