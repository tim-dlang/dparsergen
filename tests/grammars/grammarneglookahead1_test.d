import testhelpers;

unittest
{
    import P = grammarneglookahead1;

    alias L = imported!"grammarneglookahead1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("xa", q{S(X(A("x")), "a")});
    test("xb", q{S(X(B("x")), "b")});
    test("x a", q{S(X(A("x")), "a")});
    test("x b", q{S(X(B("x")), "b")});
    /*test([Change(0,0,"x a",q{S(X(A("x")), "a")}),
          Change(2,1,"b",q{S+(X(B+("x")), "b"+)})]);
    test([Change(0,0,"x b",q{S(X(B("x")), "b")}),
          Change(2,1,"a",q{S+(X(A+("x")), "a"+)})]);*/
}
