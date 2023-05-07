import testhelpers;

unittest
{
    import P = grammartags6;

    alias L = imported!"grammartags6_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1xy1", q{S("1", X("x", Y("y1")))});
    test("2xy2", q{S("2", X("x", Y("y2")))});
    test("3xy1", q{S("3", X("x", Y("y1")))});
    test("3xy2", q{S("3", X("x", Y("y2")))});
    test("1xy2", q{null}, IGNORE_VALUE);
    test("2xy1", q{null}, IGNORE_VALUE);
}
