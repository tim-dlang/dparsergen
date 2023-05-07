import testhelpers;

unittest
{
    import P = grammarlookahead8;

    alias L = imported!"grammarlookahead8_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x", q{null}, IGNORE_VALUE);
    test("xa", q{X(X1("x"), "a")});
    test("xb", q{X(Y(X3("x"), L3("b")))});
    version (glr)
    {
    }
    else
        test("xbb", q{X(Y(X2("x"), "b", "b"))});
    test("xbbb", q{X(Y(X3("x"), L3(L3(L3("b"), "b"), "b")))});
}
