import testhelpers;

static import grammaroptdescent2_lexer;

unittest
{
    import P = grammaroptdescent2;

    alias L = grammaroptdescent2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1x", q{S("1", E("x"))});
    test("1x+", q{S("1", E(E("x"), "+"))});
    test("1x++", q{S("1", E(E(E("x"), "+"), "+"))});
    test("1x+++", q{S("1", E(E(E(E("x"), "+"), "+"), "+"))});
    test("2x+", q{S("2", E("x"), "+")});
    test("2x++", q{S("2", E(E("x"), "+"), "+")});
    test("2x+++", q{S("2", E(E(E("x"), "+"), "+"), "+")});
}
