import testhelpers;

static import grammarneglookahead3_lexer;

unittest
{
    import P = grammarneglookahead3;

    alias L = grammarneglookahead3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("i", q{ConditionalExpression("i")});
    test("i=i", q{AssignExpression(ConditionalExpression("i"), "=", ConditionalExpression("i"))});
    test("i=>i", q{Lambda("i", "=>", ConditionalExpression("i"))});
    test("i=i=>i", q{AssignExpression(ConditionalExpression("i"), "=", Lambda("i", "=>", ConditionalExpression("i")))});
    test("i=>i=i", q{Lambda("i", "=>", AssignExpression(ConditionalExpression("i"), "=", ConditionalExpression("i")))});
}
