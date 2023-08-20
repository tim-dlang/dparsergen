import testhelpers;

static import grammarsubtoken1_lexer;

unittest
{
    import P = grammarsubtoken1;

    alias L = grammarsubtoken1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("f()", q{Call("f", "(", ")")});
    test("type()", q{Call("type", "(", ")")});
    test("type x = f()", q{Alias("type", "x", "=", Call("f", "(", ")"))});
}
