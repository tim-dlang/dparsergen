import testhelpers;

static import grammarvariadic2_lexer;

unittest
{
    import P = grammarvariadic2;

    alias L = grammarvariadic2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{TestN()});
    test("a", q{TestA(A("a"))});
    test("aa", q{TestA(A("a"), A("a"))});
    test("b", q{TestB(B("b"))});
    test("bb", q{TestB(B("b"), B("b"))});
    test("aba", q{TestAB(A("a"), B("b"), A("a"))});
    test("bab", q{TestAB(B("b"), A("a"), B("b"))});
    test("bcb", q{TestBC(B("b"), C("c"), B("b"))});
    test("cdcd", q{TestCD(C("c"), D("d"), C("c"), D("d"))});
    test("ac", q{null}, q{input left after parse});
    test("bd", q{null}, q{input left after parse});
    test("ad", q{null}, q{input left after parse});
}
