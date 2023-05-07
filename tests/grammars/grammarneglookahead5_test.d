import testhelpers;

static import grammarneglookahead5_lexer;

unittest
{
    import P = grammarneglookahead5;

    alias L = grammarneglookahead5_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("a", q{S(A("a"))});
    test("y", q{null}, IGNORE_VALUE);
    //test("x", q{S(A(Y(X("x"))))}); // TODO
    test("b", q{S(B("b"))});
}
