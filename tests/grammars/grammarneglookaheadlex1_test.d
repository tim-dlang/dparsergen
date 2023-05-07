import testhelpers;

static import grammarneglookaheadlex1_lexer;

unittest
{
    import P = grammarneglookaheadlex1;

    alias L = grammarneglookaheadlex1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1", q{S(X("1"))});
    test("1.2", q{S(X("1.2"))});
    test(".3", q{S(X(".3"))});
    test("4.", q{S(X("4."))});
    test("1 .. 2", q{S(X("1"), X(".."), X("2"))});
    test("1. .2", q{S(X("1."), X(".2"))});
}
