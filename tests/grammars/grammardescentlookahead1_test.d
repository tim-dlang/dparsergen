import testhelpers;

static import grammardescentlookahead1_lexer;

unittest
{
    import P = grammardescentlookahead1;

    alias L = grammardescentlookahead1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{null}, IGNORE_VALUE);
    test("a", q{null}, IGNORE_VALUE);
    test("aa", q{S(repeat2(A)(A("a")), "a")});
    test("aaa", q{S(repeat2(A)(repeat2(A)(A("a")), A("a")), "a")});
    test("aaaa", q{S(repeat2(A)(repeat2(A)(repeat2(A)(A("a")), A("a")), A("a")), "a")});
    test("aaaaa", q{S(repeat2(A)(repeat2(A)(repeat2(A)(repeat2(A)(A("a")), A("a")), A("a")), A("a")), "a")});
}
