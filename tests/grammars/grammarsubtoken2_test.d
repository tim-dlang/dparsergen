import testhelpers;

static import grammarsubtoken2_lexer;

unittest
{
    import P = grammarsubtoken2;

    alias L = grammarsubtoken2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("@disable", q{AtAttribute("@", "disable")});
    test("@x", q{AtAttribute("@", IdentifierExpression("x"))});
}
