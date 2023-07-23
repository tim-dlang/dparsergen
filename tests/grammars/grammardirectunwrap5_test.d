import testhelpers;

static import grammardirectunwrap5_lexer;

unittest
{
    import P = grammardirectunwrap5;

    alias L = grammardirectunwrap5_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("aa", q{S(A("a"), "a")});
    test("ca", q{S(C("c"), "a")});
    test("cb", q{S(C("c"), "b")});
}
