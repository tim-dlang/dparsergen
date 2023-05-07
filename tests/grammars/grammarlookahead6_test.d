import testhelpers;

unittest
{
    import P = grammarlookahead6;

    alias L = imported!"grammarlookahead6_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("xyz1", q{L(L1("x", Y("y"), "z"), "1")});
    test("xyz2", q{L(L2("x", "y", "z"), "2")});
    test("xyz3", q{L(L3(L3S("x"), "y", "z"), "3")});
    test("xYz1", q{L(L1("x", Y("Y"), "z"), "1")});
    test("xYz2", q{L(L2("x", "Y", "z"), "2")});
    test("xYz3", q{L(L3(L3S("x"), "Y", "z"), "3")});
}
