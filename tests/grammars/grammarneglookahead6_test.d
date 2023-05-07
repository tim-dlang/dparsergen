import testhelpers;

static import grammarneglookahead6_lexer;

unittest
{
    import P = grammarneglookahead6;

    alias L = grammarneglookahead6_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("identifier;", q{ScopeStatement(Expression("identifier"), ";")});
    test("(identifier);", q{ScopeStatement(Expression("(", Expression("identifier"), ")"), ";")});
    test("class identifier;", q{ClassDeclaration("class", "identifier", ";")});
    test("static class identifier;", q{ClassDeclaration(Attribute("static"), "class", "identifier", ";")});
    test("synchronized class identifier;", q{ClassDeclaration(Synchronized("synchronized"), "class", "identifier", ";")});
    test("synchronized identifier;", q{SynchronizedStatement(Synchronized("synchronized"), ScopeStatement(Expression("identifier"), ";"))});
    test("synchronized (identifier);", q{null}, IGNORE_VALUE);
    test("synchronized (identifier) identifier;", q{SynchronizedStatement(Synchronized("synchronized"), "(", Expression("identifier"), ")", ScopeStatement(Expression("identifier"), ";"))});
    test("synchronized (identifier) class identifier;", q{SynchronizedStatement(Synchronized("synchronized"), "(", Expression("identifier"), ")", ClassDeclaration("class", "identifier", ";"))});
}
