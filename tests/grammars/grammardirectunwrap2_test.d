import testhelpers;

static import grammardirectunwrap2_lexer;

unittest
{
    import P = grammardirectunwrap2;

    alias L = grammardirectunwrap2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x", q{X("x")});
    test("y", q{Y("y")});
    test("z", q{Z("z")});
}
