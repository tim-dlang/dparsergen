import testhelpers;

static import grammarsubtoken3_lexer;

unittest
{
    import P = grammarsubtoken3;

    alias L = grammarsubtoken3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("0", q{B("0")});
    test("b", q{B("b")});
    version(glr)
        test("a", q{A("a")});
    else
        test("a", q{null}, IGNORE_VALUE);
}
