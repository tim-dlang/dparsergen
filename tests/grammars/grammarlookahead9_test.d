import testhelpers;

unittest
{
    import P = grammarlookahead9;

    alias L = imported!"grammarlookahead9_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("i;", q{S(Expr("i", ";"))});
    test("ii;", q{S(Decl("i", "i", ";"))});
    test("i:", q{S(Label("i", ":", null))});
    test("i:i;", q{S(Label("i", ":", Expr("i", ";")))});
    test("i:ii;", q{S(Label("i", ":", Decl("i", "i", ";")))});
}
