import testhelpers;

static import grammardirectunwrap1_lexer;

unittest
{
    import P = grammardirectunwrap1;

    alias L = grammardirectunwrap1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x", q{S(X("x"))});
    test("xa", q{S(A(X("x"), "a"))});
    test("xb", q{S(B(X("x"), "b"))});
}
