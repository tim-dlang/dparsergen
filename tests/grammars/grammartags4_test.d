import testhelpers;

unittest
{
    import P = grammartags4;

    alias L = imported!"grammartags4_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("ayxy", q{S("a", Y("y", XA("x"), "y"))});
    test("byxy", q{S("b", Y("y", XB("x"), "y"))});
}
