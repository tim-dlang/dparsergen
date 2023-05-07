import testhelpers;

unittest
{
    import P = grammarneglookahead2;

    alias L = imported!"grammarneglookahead2_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("+", q{Test1("+")});
    test("-", q{Test1(Operator("-"))});
    test("*", q{null}, q{unexpected Token "*"  ""*""});

    test("if", q{Test2(IfStatement("if"))});
    test("while", q{Test2(Statement(WhileStatement("while")))});
    test("for", q{null}, q{unexpected Token "for"  ""for""});

    test("A", q{Test3(A("A"))});
    test("B", q{Test3(X(B("B")))});
    test("C", q{null}, q{EOF});
    test("D", q{Test3(Y(D("D")))});
    test("E", q{Test3(Z(X(E("E"))))});
    test("Asuffix", q{Test3(X(A("A")), "suffix")});
    test("Bsuffix", q{Test3(X(B("B")), "suffix")});
    test("Csuffix", q{Test3(X(C("C")), "suffix")});
    test("Dsuffix", q{Test3(X(D("D")), "suffix")});
    test("Esuffix", q{Test3(X(E("E")), "suffix")});
}
