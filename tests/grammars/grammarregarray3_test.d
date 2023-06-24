import testhelpers;

static import grammarregarray3_lexer;

unittest
{
    import P = grammarregarray3;

    alias L = grammarregarray3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("class {}", q{ClassDeclaration("class", "{", "}")});
    test("class : TX {}", q{ClassDeclaration("class", ":", BasicType("T", "X"), "{", "}")});
    test("class : TX, TX {}", q{ClassDeclaration("class", ":", BasicType("T", "X"), ",", BasicType("T", "X"), "{", "}")});
}
