import testhelpers;

unittest
{
    import P = grammarlrn1;

    alias L = imported!"grammarlrn1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    /*test("xya",q{S(A("x"), "y", "a")});
    test("xyb",q{S(B("x"), "y", "b")});
    test([Change(0,0,"x y a",q{S(A("x"), "y", "a")}),
          Change(4,1,"b",q{})]);
    test([Change(0,0,"x y b",q{S(B("x"), "y", "b")}),
          Change(4,1,"a",q{})]);*/
}
