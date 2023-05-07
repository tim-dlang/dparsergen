import testhelpers;

static import grammartypes1_lexer;

unittest
{
    import P = grammartypes1;

    alias L = grammartypes1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{null}, q{EOF});

    test("e1 ", q{S(null)});
    test("e2 empty2", q{S(Empty2())});
    test("m1 nonempty1", q{S(NonEmpty1("nonempty1"))});
    test("m2 nonempty2a", q{S(NonEmpty2A("nonempty2a"))});
    test("o1 ", q{S(null)});
    test("o1 opt1", q{S(Opt1("opt1"))});
    test("o2 ", q{S("")});
    test("o2 opt2", q{S("opt2")});
    test("o3 ", q{S("")});
    test("o3 opt3", q{S("opt3")});
    test("s1 string1", q{S("string1")});
    test("s2 ", q{S("")});
    test("s2 string2", q{S("string2")});
    test("s3 string3", q{S("string3")});
    test("a1 ", q{S()});
    test("a1 array1", q{S("array1")});
    test("a1 array1array1", q{S("array1", "array1")});
    test("a2 ", q{S()});
    test("a2 array2m", q{S(Array2M("array2m"))});
    test("a2 array2marray2m", q{S(Array2M("array2m"), Array2M("array2m"))});
    test("a3 ", q{S()});
    test("a3 array3m", q{S(Array3M("array3m"))});
    test("a3 array3", q{S("array3")});
    test("a3 array3marray3m", q{S(Array3M("array3m"), Array3M("array3m"))});
    test("a3 array3array3", q{S("array3", "array3")});
    test("a3 array3array3m", q{S("array3", Array3M("array3m"))});
    test("a3 array3marray3", q{S(Array3M("array3m"), "array3")});

    import dparsergen.core.grammarinfo;
    static assert(P.allNonterminals[P.nonterminalIDFor!"S" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Empty1" - P.startNonterminalID].flags == NonterminalFlags.empty);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Empty2" - P.startNonterminalID].flags == NonterminalFlags.nonterminal); // TODO?
    static assert(P.allNonterminals[P.nonterminalIDFor!"NonEmpty1" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"NonEmpty2" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"NonEmpty2A" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt1" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt2" - P.startNonterminalID].flags == NonterminalFlags.string);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt3" - P.startNonterminalID].flags == NonterminalFlags.string);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt1?" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.nonterminal));
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt2?" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.string));
    static assert(P.allNonterminals[P.nonterminalIDFor!"Opt3?" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.string));
    static assert(P.allNonterminals[P.nonterminalIDFor!"String1" - P.startNonterminalID].flags == NonterminalFlags.string);
    static assert(P.allNonterminals[P.nonterminalIDFor!"String2" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.string));
    static assert(P.allNonterminals[P.nonterminalIDFor!"String3" - P.startNonterminalID].flags == NonterminalFlags.string);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Array1" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfString));
    static assert(P.allNonterminals[P.nonterminalIDFor!"Array2M" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Array2" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal));
    static assert(P.allNonterminals[P.nonterminalIDFor!"Array3M" - P.startNonterminalID].flags == NonterminalFlags.nonterminal);
    static assert(P.allNonterminals[P.nonterminalIDFor!"Array3" - P.startNonterminalID].flags == (NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString));
}
