import testhelpers;

static import grammarregarray1_lexer;

unittest
{
    import P = grammarregarray1;

    alias L = grammarregarray1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S()});
    test("a", q{S(A("a"))});
    test("aa", q{S(A("a"), A("a"))});
    test("ab", q{S(A("a"), B("b"))});
    test("ba", q{S(B("b"), A("a"))});
    test("bc", q{S(B("b"), C("c"))});
    test("cb", q{S(C("c"), B("b"))});
    test("d", q{S(D("d"))});
    test("ada", q{S(A("a"), D("d"), A("a"))});

    test("2", q{S()});
    test("2e", q{S(E("e"))});
    test("2ey", q{S(Y(E("e"), "y"))});
    test("2ee", q{S(E("e"), E("e"))});
    test("2eye", q{S(Y(E("e"), "y"), E("e"))});
    test("2eye", q{S(Y(E("e"), "y"), E("e"))});

    test("3", q{null}, q{EOF});
    test("3m", q{S(m("m"))});
    test("3m,", q{null}, q{EOF});
    test("3m,m", q{S(m("m"), Comma(","), m("m"))});
    test("3M,m", q{S(M("M"), Comma(","), m("m"))});

    test("4", q{null}, q{EOF});
    test("4m", q{S(m("m"))});
    test("4m,", q{null}, q{EOF});
    test("4m,m", q{S(m("m"), Comma(","), m("m"))});
    test("4M,m", q{S(M("M"), Comma(","), m("m"))});

    test("5", q{null}, q{EOF});
    test("5m", q{S("5", m("m"))});
    test("5m,", q{null}, q{EOF});
    test("5,m", q{null}, q{unexpected Token ","  "",""});
    test("5l,m", q{S("5", l("l"), Comma(","), m("m"))});
    test("5m,r", q{S("5", m("m"), Comma(","), r("r"))});
    test("5l,m,r", q{S("5", l("l"), Comma(","), m("m"), Comma(","), r("r"))});
    test("5r,m", q{null}, q{unexpected Token "r"  ""r""});
    test("5m,l", q{null}, q{unexpected Token "l"  ""l""});

    version (glr)
    {
    }
    else
    {
        test("ac", q{null}, q{input left after parse});
        test("adda", q{null}, q{input left after parse});
        test("bdb", q{null}, q{input left after parse});
        test("3mm", q{null}, q{input left after parse});
        test("3Mm", q{null}, q{input left after parse});
        test("4mm", q{null}, q{input left after parse});
        test("4Mm", q{null}, q{input left after parse});
    }
}
