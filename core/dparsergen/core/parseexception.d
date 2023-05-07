
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.parseexception;
import std.algorithm;
import std.conv;

/**
Flags for toString of ParseException.
*/
enum ExceptionStringFlags
{
    none = 0,
    noBacktrace = 1,
    noLocation = 2,
}

/**
Base class for exceptions of parser and lexer.
*/
class ParseException : Exception
{
    /**
    Construct exception.
    */
    this(string msg, string file = __FILE__, size_t line = __LINE__)
    {
        super(msg, file, line);
    }

    /**
    Generate string for this exception.
    */
    alias toString = Exception.toString;

    /// ditto
    void toString(string inputString, scope void delegate(in char[]) sink,
            ExceptionStringFlags flags = ExceptionStringFlags.none) const
    {
        if (flags & ExceptionStringFlags.noBacktrace)
            sink(text("Parse Error: ", msg, "\n"));
        else
            toString(sink);
    }

    /**
    Get message for this exception.
    */
    string simpleMsg() const
    {
        return msg;
    }

    /**
    Get exception with maximum end location for exceptions representing
    multiple exceptions.
    */
    const(ParseException) maxEndException() const
    {
        return this;
    }

    bool allowBacktrack() const
    {
        return msg.startsWith("unexpected") || msg.startsWith("EOF");
    }

    bool laterEnd(const ParseException other) const
    {
        return false;
    }
}

/**
Exception type used by parser and lexer.
*/
class SingleParseException(Location) : ParseException
{
    /**
    Start location for error.
    */
    Location markStart;

    /**
    End location for error.
    */
    Location markEnd;

    /**
    Construct exception.
    */
    this(string msg, Location markStart, Location markEnd,
            string file = __FILE__, size_t line = __LINE__)
    {
        this.markStart = markStart;
        this.markEnd = markEnd;
        assert(markStart <= markEnd);
        super(msg, file, line);
    }

    override void toString(scope void delegate(in char[]) sink) const
    {
        assert(markStart <= markEnd);
        sink("Parse Error(");
        static if (__traits(hasMember, Location, "toPrettyString"))
            sink(markStart.toPrettyString);
        else
            sink(text(markStart));
        sink("): ");
        sink(msg);
        sink("\n");
        super.toString(sink);
    }

    override void toString(string inputString, scope void delegate(in char[]) sink,
            ExceptionStringFlags flags = ExceptionStringFlags.none) const
    {
        assert(markStart <= markEnd);

        if ((flags & ExceptionStringFlags.noLocation) == 0)
        {
            sink("Parse Error(");
            static if (__traits(hasMember, Location, "toPrettyString"))
                sink(markStart.toPrettyString);
            else
                sink(text(markStart));
            sink("): ");
        }

        sink(msg);
        sink("\n");

        if ((flags & ExceptionStringFlags.noBacktrace) == 0)
            super.toString(sink);
    }

    override const(ParseException) maxEndException() const
    {
        return this;
    }

    override bool laterEnd(const ParseException other) const
    {
        auto singleOther = cast(const(SingleParseException)) other;
        if (singleOther is null)
            return false;
        return markEnd > singleOther.markEnd;
    }
}

/**
Exception used by backtracking in the parser.
*/
class BacktrackParseException : ParseException
{
    ParseException[] nextErrors;
    string[] prods;

    /**
    Construct exception.
    */
    this(string msg, string[] prods, ParseException[] nextErrors,
            string file = __FILE__, size_t line = __LINE__)
    {
        this.nextErrors = nextErrors;
        this.prods = prods;
        super(msg, file, line);
    }

    override void toString(scope void delegate(in char[]) sink) const
    {
        foreach (i, e; nextErrors)
        {
            sink(prods[i]);
            sink("\n");
            if (e !is null)
                e.toString(sink);
            else
                sink("null???");
            sink("\n");
        }
        super.toString(sink);
    }

    override void toString(string inputString, scope void delegate(in char[]) sink,
            ExceptionStringFlags flags = ExceptionStringFlags.none) const
    {
        foreach (i, e; nextErrors)
        {
            sink(prods[i]);
            sink("\n");
            if (e !is null)
                e.toString(inputString, sink, flags);
            else
                sink("null???");
            sink("\n");
        }
        super.toString(sink);
    }

    override const(ParseException) maxEndException() const
    {
        import std.typecons;

        Rebindable!(const(ParseException)) max;
        foreach (i, e; nextErrors)
        {
            auto e2 = e.maxEndException();
            if (max is null || e2.laterEnd(max))
            {
                max = e2;
            }
        }
        return max;
    }

    override string simpleMsg() const
    {
        return maxEndException().msg;
    }

    override bool allowBacktrack() const
    {
        foreach (e; nextErrors)
        {
            if (!e.allowBacktrack())
                return false;
        }
        return true;
    }
}

/**
Exception used to combine multiple other exceptions in GLR parser.
*/
class MultiParseException : ParseException
{
    ParseException[] nextErrors;
    string[] prods;

    /**
    Construct exception.
    */
    this(string msg, ParseException[] nextErrors, string file = __FILE__, size_t line = __LINE__)
    {
        assert(nextErrors.length);
        this.nextErrors = nextErrors;
        super(msg, file, line);
    }

    override void toString(scope void delegate(in char[]) sink) const
    {
        sink("MultiParseException\n");
        foreach (i, e; nextErrors)
        {
            if (e !is null)
                e.toString(sink);
            else
                sink("null???");
            sink("\n");
        }
        //super.toString(sink);
    }

    override void toString(string inputString, scope void delegate(in char[]) sink,
            ExceptionStringFlags flags = ExceptionStringFlags.none) const
    {
        sink("MultiParseException\n");
        foreach (i, e; nextErrors)
        {
            if (e !is null)
                e.toString(inputString, sink, flags);
            else
                sink("null???");
            sink("\n");
        }
        //super.toString(sink);
    }

    override const(ParseException) maxEndException() const
    {
        import std.typecons;

        Rebindable!(const(ParseException)) max;
        foreach (i, e; nextErrors)
        {
            auto e2 = e.maxEndException();
            if (max is null || e2.laterEnd(max))
            {
                max = e2;
            }
        }
        return max;
    }

    override string simpleMsg() const
    {
        string r;
        r ~= "MultiParseException: ";
        foreach (i, e; nextErrors)
        {
            if (i > 0)
                r ~= " | ";
            if (e !is null)
                r ~= e.simpleMsg;
            else
                r ~= "null???";
        }
        return r;
    }
}
