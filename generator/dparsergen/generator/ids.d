
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.ids;
import std.algorithm;
import std.bitmanip;
import std.conv;
import std.range;

struct IDMap(I, T, string idMember = "name")
{
    T[] vals;
    alias IdType = typeof(__traits(getMember, T, idMember));
    typeof(I.init.id)[IdType] ids;

    I id(IdType val)
    {
        if (val in ids)
            return I(ids[val]);
        typeof(I.init.id) newID = vals.length.to!(typeof(I.init.id));
        T x;
        __traits(getMember, x, idMember) = val;
        vals ~= x;
        ids[val] = newID;
        return I(newID);
    }

    I getID(IdType val) const
    {
        assert(val in ids);
        return I(ids[val]);
    }

    const(T) opIndex(I i) const
    {
        return vals[i.id];
    }

    ref T opIndex(I i)
    {
        return vals[i.id];
    }

    const(T) get(IdType val) const
    {
        return vals[getID(val).id];
    }

    auto allIDs() const
    {
        return iota(0, vals.length).map!(i => I(i.to!(typeof(I.init.id))));
    }

    IDMap dup() const
    {
        IDMap r;
        r.vals = vals.dup;
        foreach (k, v; ids)
            r.ids[k] = v;
        return r;
    }
}

struct BitSet(I)
{
    BitArray arr;
    this(size_t l)
    {
        assert(l < typeof(I.init.id).max);
        arr.length = l;
    }

    private this(BitArray arr)
    {
        assert(arr.length < typeof(I.init.id).max);
        this.arr = arr;
    }

    bool opIndex(I i) const
    {
        assert(i.id < typeof(I.init.id).max);
        if (i.id >= arr.length)
            return false;
        return arr[i.id];
    }

    void opIndexAssign(bool value, I i)
    {
        assert(i.id < typeof(I.init.id).max);
        if (i.id >= arr.length)
            arr.length = i.id + 1;
        arr[i.id] = value;
    }

    void opOpAssign(string op)(const BitSet!I rhs)
    {
        static if (op == "|")
        {
            if (arr.length == 0)
            {
                arr = rhs.arr.dup;
                return;
            }
            if (rhs.arr.length == 0)
            {
                return;
            }
        }
        mixin("arr " ~ op ~ "= rhs.arr;");
    }

    BitSet!I opBinary(string op)(const BitSet!I rhs) const
    {
        mixin("return BitSet!I(arr " ~ op ~ " rhs.arr);");
    }

    BitSet!I dup() const
    {
        BitSet!I r;
        r.arr = arr.dup;
        return r;
    }

    auto bitsSet() const
    {
        return arr.bitsSet.map!(x => I(x.to!(typeof(I.init.id))));
    }

    void length(size_t l)
    {
        arr.length = l;
    }

    size_t length() const
    {
        return arr.length;
    }

    bool addOnce(I)(BitSet!I src)
    {
        bool r = false;
        foreach (s; src.bitsSet)
        {
            if (!this[s])
            {
                this[s] = true;
                r = true;
            }
        }
        return r;
    }

    bool addOnce(I i)
    {
        assert(i.id < typeof(I.init.id).max);
        bool r = false;
        if (!this[i])
        {
            this[i] = true;
            r = true;
        }
        return r;
    }
}
