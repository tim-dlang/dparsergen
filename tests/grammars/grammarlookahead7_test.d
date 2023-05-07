import testhelpers;

unittest
{
    import P = grammarlookahead7;

    alias L = imported!"grammarlookahead7_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x", q{null}, IGNORE_VALUE);
    test("xa", q{X(X1("x"), L1("a"))});
    test("xb", q{X(X2("x"), L2("b"))});
    version (glr)
    {
    }
    else
    {
        test("xab", q{null}, IGNORE_VALUE);
        test("xabb", q{null}, IGNORE_VALUE);
    }
    test("xaab", q{X(X2("x"), L2("a", L2("a", L2("b"))))});
    test("xaabb", q{null}, q{input left after parse});
}
