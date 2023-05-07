import testhelpers;

static import grammarbacktrack4_lexer;

unittest
{
    import P = grammarbacktrack4;

    alias L = grammarbacktrack4_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("a", q{A("a")});
    test("bxyc", q{C("b", XC("x"), "y", "c")});
    test("bxyd", q{D("b", XD("x"), "y", "d")});
}
