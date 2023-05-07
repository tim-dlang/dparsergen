
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.location;
import dparsergen.core.utils;
import std.algorithm;
import std.conv;

/**
Flags specifying at compile time what should be stored in a location.
*/
enum LocationTypeFlags
{
    /// No flags.
    none = 0,
    /// This is the difference between two locations.
    diff = 1,
    /// The number of bytes should be stored.
    bytes = 2,
    /// The number of lines should be stored.
    lines = 4,
    /// The offset of bytes from the current line beginning should be stored.
    lineOffset = 8
}

/**
Implementation of location in source file, which can store different
data based on compile time flags.

Params:
    flags = Configuration of available fields.
    T = Type used for numbers in the location.
*/
struct LocationImpl(LocationTypeFlags flags, T = int)
{
    static assert(flags & LocationTypeFlags.bytes, "Location without byte positon not implemented");

    /**
    Number of bytes.
    */
    static if (flags & LocationTypeFlags.bytes)
        T bytePos;

    /**
    Number of lines
    */
    static if (flags & LocationTypeFlags.lines)
        T line;

    /**
    Number of bytes since beginning of line.
    */
    static if (flags & LocationTypeFlags.lineOffset)
        T offset;

    /**
    Create location.
    */
    this(AliasSeqIf!((flags & LocationTypeFlags.bytes) != 0, T) bytePos,
            AliasSeqIf!((flags & LocationTypeFlags.lines) != 0, T) line,
            AliasSeqIf!((flags & LocationTypeFlags.lineOffset) != 0, T) offset)
    {
        static if (flags & LocationTypeFlags.bytes)
            this.bytePos = bytePos[0];
        static if (flags & LocationTypeFlags.lines)
            this.line = line[0];
        static if (flags & LocationTypeFlags.lineOffset)
            this.offset = offset[0];
    }

    /**
    Maximum value.
    */
    enum max = () {
        LocationImpl r;
        static if (flags & LocationTypeFlags.bytes)
            r.bytePos = T.max;
        static if (flags & LocationTypeFlags.lines)
            r.line = T.max;
        static if (flags & LocationTypeFlags.lineOffset)
            r.offset = T.max;
        return r;
    }();

    /**
    Special invalid value.
    */
    enum invalid = () {
        LocationImpl r;
        static if (flags & LocationTypeFlags.bytes)
            r.bytePos = T.min;
        static if (flags & LocationTypeFlags.lines)
            r.line = T.min;
        static if (flags & LocationTypeFlags.lineOffset)
            r.offset = T.min;
        return r;
    }();

    /**
    Location for beginning of file or zero difference.
    */
    enum zero = () {
        LocationImpl r;
        static if (flags & LocationTypeFlags.bytes)
            r.bytePos = 0;
        static if (flags & LocationTypeFlags.lines)
            r.line = 0;
        static if (flags & LocationTypeFlags.lineOffset)
            r.offset = 0;
        return r;
    }();

    /**
    Same type, but as absolute difference from beginning.
    */
    alias LocationAbs = LocationImpl!(flags & ~LocationTypeFlags.diff, T);

    /**
    Same type, but as difference between locations.
    */
    alias LocationDiff = LocationImpl!(flags | LocationTypeFlags.diff, T);

    /**
    Check if the location is valid.
    */
    bool isValid() const
    {
        static if (flags & LocationTypeFlags.bytes)
            if (bytePos == T.min)
                return false;
        static if (flags & LocationTypeFlags.lines)
            if (line == T.min)
                return false;
        static if (flags & LocationTypeFlags.lineOffset)
            if (offset == T.min)
                return false;
        return true;
    }

    /**
    Substract absolute locations.
    */
    LocationDiff opBinary(string op)(const LocationImpl rhs) const
            if (op == "-" && !(flags & LocationTypeFlags.diff))
    {
        if (!isValid || !rhs.isValid)
            return LocationDiff.invalid;
        LocationDiff r;
        static if (flags & LocationTypeFlags.bytes)
        {
            r.bytePos = bytePos - rhs.bytePos;
        }
        static if (flags & LocationTypeFlags.lines)
        {
            r.line = line - rhs.line;
        }
        static if (flags & LocationTypeFlags.lineOffset)
        {
            if (r.line == 0)
            {
                r.offset = offset - rhs.offset;
            }
            else
                r.offset = offset;
        }
        return r;
    }

    /**
    Substract difference from absolute location.
    */
    LocationImpl opBinary(string op)(const LocationDiff rhs) const
            if (op == "-" && !(flags & LocationTypeFlags.diff))
    {
        if (!isValid || !rhs.isValid)
            return invalid;
        LocationImpl r;
        static if (flags & LocationTypeFlags.bytes)
        {
            assert(bytePos >= rhs.bytePos);
            r.bytePos = bytePos - rhs.bytePos;
        }
        static if (flags & LocationTypeFlags.lines)
        {
            assert(line >= rhs.line);
            r.line = line - rhs.line;
        }
        static if (flags & LocationTypeFlags.lineOffset)
        {
            if (rhs.line == 0)
            {
                assert(offset >= rhs.offset);
                r.offset = offset - rhs.offset;
            }
            else
            {
                assert(false);
                r.offset = size_t.max;
            }
        }
        return r;
    }

    /**
    Add difference to absolute location.
    */
    LocationImpl opBinary(string op)(const LocationDiff rhs) const if (op == "+")
    {
        if (!isValid || !rhs.isValid)
            return invalid;
        LocationImpl r;
        static if (flags & LocationTypeFlags.bytes)
            r.bytePos = bytePos + rhs.bytePos;
        static if (flags & LocationTypeFlags.lines)
            r.line = line + rhs.line;
        static if (flags & LocationTypeFlags.lineOffset)
        {
            if (rhs.line == 0)
                r.offset = offset + rhs.offset;
            else
                r.offset = rhs.offset;
        }
        return r;
    }

    // Dangerous, because this may be rvalue.
    // see https://issues.dlang.org/show_bug.cgi?id=15231
    /+void opOpAssign(string op)(const LocationDiff rhs) if (op == "+")
    {
        static if (flags & LocationTypeFlags.bytes)
            bytePos += rhs.bytePos;
        static if (flags & LocationTypeFlags.lines)
            line += rhs.line;
        static if (flags & LocationTypeFlags.lineOffset)
        {
            if (rhs.line == 0)
                offset += rhs.offset;
            else
                offset = rhs.offset;
        }
    }+/
    /*void opOpAssign(string op)(const LocationImpl rhs) if (op == "-")
    {
        static if (flags & LocationTypeFlags.bytes)
            bytePos -= rhs.bytePos;
    }*/

    /**
    Compare locations.
    */
    int opCmp(const LocationImpl rhs) const
    {
        static if (flags & LocationTypeFlags.bytes)
        {
            int r1;
            if (bytePos < rhs.bytePos)
                r1 = -1;
            else if (bytePos > rhs.bytePos)
                r1 = 1;
            else
                r1 = 0;
        }

        static if (flags & LocationTypeFlags.bytes)
            return r1;
    }

    /**
    Add location difference from string.
    */
    void advance(string str)
    {
        if (!isValid)
            return;
        static if (flags & LocationTypeFlags.bytes)
            bytePos += str.length;
        foreach (char c; str)
        {
            static if (flags & LocationTypeFlags.lineOffset)
                offset++;
            if (c == '\n')
            {
                static if (flags & LocationTypeFlags.lines)
                    line++;
                static if (flags & LocationTypeFlags.lineOffset)
                    offset = 0;
            }
        }
    }

    /**
    Calculate location difference from string.
    */
    static LocationImpl fromStr(string str)
    {
        LocationImpl r;
        r.advance(str);
        return r;
    }

    /**
    Represent location as string.
    */
    string toString() const
    {
        string r = "Location";
        static if (flags & LocationTypeFlags.diff)
            r ~= "Diff";
        r ~= "(";
        static if (flags & LocationTypeFlags.bytes)
            r ~= text("byte=", bytePos, ", ");
        static if (flags & LocationTypeFlags.lines)
            r ~= text("line=", line, ", ");
        static if (flags & LocationTypeFlags.lineOffset)
            r ~= text("offset=", offset, ", ");
        if (r.endsWith(", "))
            r = r[0 .. $ - 2];
        r ~= ")";
        return r;
    }

    /**
    Represent location as string.
    */
    string toPrettyString() const
    {
        static if ((flags & LocationTypeFlags.lines) && (flags & LocationTypeFlags.lineOffset))
            return text(line + 1, ":", offset);
        else static if (flags & LocationTypeFlags.lines)
            return text(line + 1);
        else static if (flags & LocationTypeFlags.bytes)
            return text(bytePos + 1);
        else
            return "noloc";
    }
}

/**
Location storing only byte positions.
*/
alias LocationBytes = LocationImpl!(LocationTypeFlags.bytes);

/**
Location storing bytes, lines and offsets from the line beginnings.
*/
alias LocationAll = LocationImpl!(LocationTypeFlags.bytes | LocationTypeFlags.lines | LocationTypeFlags.lineOffset);

/**
Store offset of tree from parent tree and length for tree.
*/
struct LocationRangeStartDiffLength(Location)
{
    alias LocationDiff = typeof(Location.init - Location.init);

    /**
    Offset of start location from parent tree.
    */
    LocationDiff startFromParent;

    /**
    Length for this tree.
    */
    LocationDiff inputLength;
}

/**
Store start and length for tree.
*/
struct LocationRangeStartLength(Location)
{
    alias LocationDiff = typeof(Location.init - Location.init);

    /**
    Start location for this tree.
    */
    Location start;

    /**
    Length for this tree.
    */
    LocationDiff inputLength;

    /**
    End location for this tree.
    */
    Location end() const
    {
        return start + inputLength;
    }

    /**
    Set start and end location.
    */
    void setStartEnd(Location start, Location end)
    {
        this.start = start;
        if (end == Location.invalid || start > end)
            this.inputLength = LocationDiff();
        else
            this.inputLength = end - start;
    }
}

/**
Store start and end locations for tree.
*/
struct LocationRangeStartEnd(Location)
{
    alias LocationDiff = typeof(Location.init - Location.init);

    /**
    Start location for this tree.
    */
    Location start;

    /**
    End location for this tree.
    */
    Location end;

    /**
    Length for this tree.
    */
    LocationDiff inputLength() const
    {
        return end - start;
    }

    /// ditto
    void inputLength(LocationDiff n)
    {
        end = start + n;
    }

    /**
    Set start and end location.
    */
    void setStartEnd(Location start, Location end)
    {
        this.start = start;
        this.end = end;
    }
}

/**
Check if the location range stores the start as the offset from the parent tree.
*/
template isLocationRangeStartDiffLength(alias LocationRange)
{
    enum isLocationRangeStartDiffLength = __traits(hasMember, LocationRange, "startFromParent");
}
