import testhelpers;

static import grammarconflict4_lexer;

unittest
{
    import P = grammarconflict4;

    alias L = grammarconflict4_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    version (glr)
    {
        test("xyzwa", q{S(A(B("x", "y")), "z", "w", "a")});
        test("xyzwc", q{S(C("x", YZ("y", "z"), "w", "c"))});
    }
    else
    {
        test("xyzwa", q{null}, IGNORE_VALUE);
        test("xyzwc", q{null}, IGNORE_VALUE);
    }
}
