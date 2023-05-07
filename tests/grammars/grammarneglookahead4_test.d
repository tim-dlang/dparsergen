import testhelpers;

static import grammarneglookahead4_lexer;

unittest
{
    import P = grammarneglookahead4;

    alias L = grammarneglookahead4_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("assert();", q{S(AssertExpression("assert", "(", ")"), ";")});
    test("static assert();", q{StaticAssert("static", "assert", "(", ")", ";")});
    test("identifier identifier;", q{Declaration(PostfixExpression("identifier"), "identifier", ";")});
    test("static identifier identifier;", q{Declaration(StorageClass("static"), PostfixExpression("identifier"), "identifier", ";")});
    test("assert() identifier;", q{null}, IGNORE_VALUE);
    test("static assert() identifier;", q{null}, IGNORE_VALUE);
}
