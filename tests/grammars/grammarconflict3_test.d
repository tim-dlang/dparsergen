import testhelpers;

static import grammarconflict3_lexer;

unittest
{
    import P = grammarconflict3;

    alias L = grammarconflict3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    version (glr)
    {
        test("xyza", q{S(A(B("x")), "y", "z", "a")});
        test("xyzc", q{S(C("x", Y("y"), "z", "c"))});
    }
    else
    {
        test("xyza", q{null}, IGNORE_VALUE);
        test("xyzc", q{null}, IGNORE_VALUE);
    }
}
