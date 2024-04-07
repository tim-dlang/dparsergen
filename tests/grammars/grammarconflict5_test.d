import testhelpers;

static import grammarconflict5_lexer;

unittest
{
    import P = grammarconflict5;

    alias L = grammarconflict5_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("sizeof x;", q{Start(InitializerClause(UnaryExpression("sizeof", IdExpression("x"))), ";")});
    version (glr)
    {
        test("sizeof(x);", q{Start(InitializerClause(Merged:UnaryExpression(UnaryExpression("sizeof", PrimaryExpression("(", IdExpression("x"), ")")), UnaryExpression("sizeof", "(", TypeId("x"), ")"))), ";")});
    }
    else
    {
        test("sizeof(x);", q{null}, IGNORE_VALUE);
    }
}
