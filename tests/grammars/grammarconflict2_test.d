import testhelpers;

static import grammarconflict2_lexer;

unittest
{
    import P = grammarconflict2;

    alias L = grammarconflict2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    version (glr)
    {
        test("xyza", q{S(A(B("x")), "y", "z", "a")});
        test("xyzc", q{S(C("x", "y", "z", "c"))});
    }
    else
    {
        test("xyza", q{null}, IGNORE_VALUE);
        test("xyzc", q{null}, IGNORE_VALUE);
    }
}
