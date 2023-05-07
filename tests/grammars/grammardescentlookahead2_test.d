import testhelpers;

static import grammardescentlookahead2_lexer;

unittest
{
    import P = grammardescentlookahead2;

    alias L = grammardescentlookahead2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{null}, IGNORE_VALUE);
    test("a", q{null}, IGNORE_VALUE);
    test("aa", q{S(As(repeat2(A)(A("a"))), "a")});
    test("aaa", q{S(As(repeat2(A)(repeat2(A)(A("a")), A("a"))), "a")});
    test("aaaa", q{S(As(repeat2(A)(repeat2(A)(repeat2(A)(A("a")), A("a")), A("a"))), "a")});
    test("aaaaa", q{S(As(repeat2(A)(repeat2(A)(repeat2(A)(repeat2(A)(A("a")), A("a")), A("a")), A("a"))), "a")});
}
