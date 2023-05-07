
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.nonterminalunion;
import dparsergen.core.grammarinfo;
import dparsergen.core.utils;
import std.conv;
import std.typetuple;

private ptrdiff_t simpleCountUntil(const SymbolID[] haystack, SymbolID needle)
{
    foreach (i, x; haystack)
        if (x == needle)
            return i;
    return -1;
}

template GenericNonterminalUnion(alias CreatorInstance)
{
    /**
    Tagged union of types for nonterminals. Used internally by the parser.
    The tree creator can also choose a custom implementation.
    */
    struct Union(SymbolID singleNonterminalID, size_t maxSize)
    {
        alias Location = CreatorInstance.Location;

        template NonterminalType(SymbolID nonterminalID)
                if ((nonterminalID >= CreatorInstance.startNonterminalID
                    && nonterminalID < CreatorInstance.endNonterminalID)
                    || nonterminalID == SymbolID.max)
        {
            alias NonterminalType = CreatorInstance.NonterminalType!nonterminalID;
        }

        static if (singleNonterminalID == SymbolID.max)
        {
            static immutable nonterminalIDs = () {
                SymbolID[] r;
                static foreach (i; CreatorInstance.startNonterminalID
                        .. CreatorInstance.endNonterminalID)
                {
                    if (NonterminalType!i.sizeof <= maxSize)
                        r ~= i;
                }
                return r;
            }();
            union
            {
                staticMap!(NonterminalType, arrayToAliasSeq!(nonterminalIDs)) values;
            }

            SymbolID nonterminalID = SymbolID.max;
        }
        else
        {
            AliasSeq!(NonterminalType!(singleNonterminalID)) values;
            enum nonterminalID = singleNonterminalID;
            static immutable nonterminalIDs = [singleNonterminalID];
        }

        inout(NonterminalType!nonterminalID2) get(SymbolID nonterminalID2)() inout
        in
        {
            assert(nonterminalID2 == nonterminalID, text(nonterminalID2, "  ", nonterminalID));
        }
        do
        {
            enum k = simpleCountUntil(nonterminalIDs, nonterminalID2);
            static assert(k != -1, text(nonterminalID2, " ", nonterminalIDs,
                    " ", singleNonterminalID, " ", maxSize));
            return values[k];
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

        inout(T) getT(T)() inout
        {
            static foreach (k, nonterminalID2; nonterminalIDs)
            {
                static if (is(const(typeof(values[k])) : const(T)))
                {
                    if (nonterminalID2 == nonterminalID)
                        return get!nonterminalID2();
                }
            }
            assert(false);
        }

        void setT(T)(T data, SymbolID nonterminalID3)
        {
            static foreach (k, nonterminalID2; nonterminalIDs)
            {
                static if (is(const(typeof(values[k])) : const(T)))
                {
                    if (nonterminalID2 == nonterminalID3)
                    {
                        nonterminalID = nonterminalID3;
                        values[k] = data;
                        return;
                    }
                }
            }
            assert(false);
        }

        bool isType(T)() const
        {
            static foreach (k, nonterminalID2; nonterminalIDs)
            {
                static if (is(const(typeof(values[k])) : const(T)))
                {
                    if (nonterminalID2 == nonterminalID)
                        return true;
                }
            }
            return false;
        }

        static Union create(T)(SymbolID nonterminalID, T tree)
        {
            Union r;
            enum i = staticIndexOf!(T, typeof(values));
            r.values[i] = tree;

            static if (singleNonterminalID == SymbolID.max)
                r.nonterminalID = nonterminalID;
            else
                assert(r.nonterminalID == nonterminalID, text(nonterminalID, nonterminalIDs));
            return r;
        }

        static Union create()(SymbolID nonterminalID)
        {
            Union r;
            static if (singleNonterminalID == SymbolID.max)
            {
                r.nonterminalID = nonterminalID;
                bool found;
                static foreach (i, nonterminalID2; nonterminalIDs)
                {
                    if (nonterminalID2 == nonterminalID)
                    {
                        r.values[i] = typeof(r.values[i]).init;
                        found = true;
                    }
                }
                assert(found, text(nonterminalID, " ", nonterminalIDs));
            }
            else
            {
                assert(r.nonterminalID == nonterminalID, text(nonterminalID, nonterminalIDs));
                r.values[0] = typeof(r.values[0]).init;
            }
            return r;
        }

        void opAssign(SymbolID singleNonterminalID2, size_t maxSize2)(
                Union!(singleNonterminalID2, maxSize2) rhs)
                if (singleNonterminalID2 != singleNonterminalID || maxSize2 != maxSize)
        {
            static if (singleNonterminalID2 == SymbolID.max)
            {
                if (rhs.nonterminalID == SymbolID.max)
                {
                    static if (singleNonterminalID == SymbolID.max)
                    {
                        this.nonterminalID = SymbolID.max;
                        return;
                    }
                    else
                    {
                        assert(false);
                    }
                }
            }
            static foreach (i; 0 .. rhs.nonterminalIDs.length)
            {
                {
                    enum n = rhs.nonterminalIDs[i];
                    enum j = simpleCountUntil(nonterminalIDs, n);
                    static if (j >= 0)
                        if (n == rhs.nonterminalID)
                        {
                            values[j] = rhs.get!n;

                            static if (nonterminalIDs.length != 1)
                                nonterminalID = n;
                            return;
                        }
                }
            }
            assert(0);
        }
    }

    /// ditto
    template Union(alias nonterminalIDs)
    {
        static assert(nonterminalIDs.length > 0);
        alias Union = Union!(Params!(nonterminalIDs));
    }

    private template Params(alias nonterminalIDs)
    {
        alias Params = AliasSeq!(
                (nonterminalIDs.length == 1) ? nonterminalIDs[0] : SymbolID.max, () {
            size_t max = 0;
            static foreach (i; 0 .. nonterminalIDs.length)
            {
                {
                    enum n = nonterminalIDs[i];
                    if (CreatorInstance.NonterminalType!n.sizeof > max)
                        max = CreatorInstance.NonterminalType!n.sizeof;
                }
            }
            return max;
        }());
    }
}
