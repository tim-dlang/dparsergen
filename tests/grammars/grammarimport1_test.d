import testhelpers;

unittest
{
    import P = grammarimport1;

    alias L = imported!"grammarimport1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("a", q{A("a")});
    test("b", q{B("b")});
    test("c", q{C("c")});
}
