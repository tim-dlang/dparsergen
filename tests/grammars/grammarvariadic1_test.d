import testhelpers;

static import grammarvariadic1_lexer;

unittest
{
    import P = grammarvariadic1;

    alias L = grammarvariadic1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1a", q{Test1("1", A("a"))});
    test("1b", q{Test1("1", B("b"))});
    test("1c", q{null}, q{unexpected Token "c"  ""c""});
    test("1d", q{null}, q{unexpected Token "d"  ""d""});

    test("2a", q{Test2("2", A("a"))});
    test("2b", q{Test2("2", B("b"))});
    test("2c", q{Test2("2", C("c"))});
    test("2d", q{Test2("2", D("d"))});

    test("3a", q{null}, q{unexpected Token "a"  ""a""});
    test("3b", q{Test3("3", B("b"))});
    test("3c", q{Test3("3", C("c"))});
    test("3d", q{Test3("3", D("d"))});

    test("4ax", q{Test4("4", A("a"), "x")});
    test("4bx", q{Test4("4", B("b"), "x")});
    test("4cx", q{null}, q{unexpected Token "x"  ""x""});
    test("4dx", q{null}, q{unexpected Token "x"  ""x""});

    test("4ay", q{null}, q{unexpected Token "y"  ""y""});
    test("4by", q{null}, q{unexpected Token "y"  ""y""});
    test("4cy", q{Test4("4", C("c"), "y")});
    test("4dy", q{Test4("4", D("d"), "y")});
}
