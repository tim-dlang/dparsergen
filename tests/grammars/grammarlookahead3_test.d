import testhelpers;

unittest
{
    import P = grammarlookahead3;

    alias L = imported!"grammarlookahead3_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("i", q{S(PrimaryExpression("i"))});
    test("~i", q{S(UnaryExpression("~", PrimaryExpression("i")))});
    test("i !is i", q{S(BinaryExpression(PrimaryExpression("i"), "!", "is", PrimaryExpression("i")))});
    test("i !in i", q{S(BinaryExpression(PrimaryExpression("i"), "!", "in", PrimaryExpression("i")))});
    test("i!i", q{S(PostfixExpression(PrimaryExpression("i"), "!", PrimaryExpression("i")))});
    test("i!()", q{S(PostfixExpression(PrimaryExpression("i"), "!", "(", ")"))});
    test("~i !is i", q{S(BinaryExpression(UnaryExpression("~", PrimaryExpression("i")), "!", "is", PrimaryExpression("i")))});
    test("~i !in i", q{S(BinaryExpression(UnaryExpression("~", PrimaryExpression("i")), "!", "in", PrimaryExpression("i")))});
    test("~i!i", q{S(UnaryExpression("~", PostfixExpression(PrimaryExpression("i"), "!", PrimaryExpression("i"))))});
    test("~i!()", q{S(UnaryExpression("~", PostfixExpression(PrimaryExpression("i"), "!", "(", ")")))});
}
