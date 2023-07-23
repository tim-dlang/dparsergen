import testhelpers;

static import grammardirectunwrap3_lexer;

unittest
{
    import P = grammardirectunwrap3;

    alias L = grammardirectunwrap3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("a1", q{S(A("a"), "1")});
    test("a2", q{S(A("a"), "2")});
    test("b1", q{null}, IGNORE_VALUE);
    test("b2", q{S(B("b"), "2")});

    test("aa1", q{S(A(A("a"), "a"), "1")});
    test("aa2", q{S(A(A("a"), "a"), "2")});
    test("bb1", q{null}, IGNORE_VALUE);
    test("bb2", q{S(B(B("b"), "b"), "2")});

    test("ab1", q{null}, IGNORE_VALUE);
    test("ab2", q{S(B(A("a"), "b"), "2")});
    test("ba1", q{null}, IGNORE_VALUE);
    test("ba2", q{null}, IGNORE_VALUE);
}
