import testhelpers;

unittest
{
    import P = grammarlistab1;

    alias test = testOnce!(P, CharLexer);

    test("c", q{null}, IGNORE_VALUE);
    test("ac", q{null}, "input left after parse");
    test("a", q{S("a")});
    test("b", q{S("b")});
    test("aaa", q{S(S(S("a"), "a"), "a")});
    test("abab", q{S(S(S(S("a"), "b"), "a"), "b")});
}
