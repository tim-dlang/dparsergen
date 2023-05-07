import testhelpers;

static import grammarnestedtokens1_lexer;

unittest
{
    import P = grammarnestedtokens1;

    alias L = grammarnestedtokens1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S()});
    test("x", q{S("x")});
    test("(x)", q{S("(x)")});
    test("((x))", q{S("((x))")});
    //test("(x",q{null}, q{EOF, expected [)]});
    test("x)", q{null}, q{Error unexpected ')', expected [(/qx]});
    test("((x)", q{null}, q{EOF, expected [)]});
    test("(x))", q{null}, q{Error unexpected ')', expected [(/qx]});

    test("/+test+/", q{S("/+test+/")});
    test("/+/+test+/+/", q{S("/+/+test+/+/")});
    test("/+test", q{null}, q{EOF, expected [^]});
    test("test+/", q{null}, q{Error unexpected 't', expected [(/qx]});
    test("/+/+test+/", q{null}, q{EOF, expected [^]});
    test("/+test+/+/", q{null}, q{Error unexpected '+', expected [(/qx]});

    test("q{}", q{S("q{}")});
    test("q{{}}", q{S("q{{}}")});
    test("q{", q{null}, "EOF, expected [^]");
    test("q}", q{null}, "Error unexpected '}', expected [{]");
    test("q{{}", q{null}, q{EOF, expected [^]});
    test("q{}}", q{null}, "Error unexpected '}', expected [(/qx]");

    test("q{}/+test+/((((x))))", q{S("q{}", "/+test+/", "((((x))))")});
}
