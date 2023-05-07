import testhelpers;

unittest
{
    import P = grammartags2;

    alias L = imported!"grammartags2_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("xz1", q{S(Z(Y(X("x")), "z1"))});
    test("xz2", q{null}, IGNORE_VALUE);
}
