import testhelpers;

static import grammarlistlookahead1_lexer;

unittest
{
    import P = grammarlistlookahead1;

    alias L = grammarlistlookahead1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{null});
    test("a", q{S(repeat(A)(null, A("a")), null)});
    test("aa", q{S(repeat(A)(repeat(A)(null, A("a")), A("a")), null)});
    test("aaa", q{S(repeat(A)(repeat(A)(repeat(A)(null, A("a")), A("a")), A("a")), null)});
    test("ax", q{S(null, repeat(X)(null, X(A("a"), "x")))});
    test("axax", q{S(null, repeat(X)(repeat(X)(null, X(A("a"), "x")), X(A("a"), "x")))});
    test("axaxax", q{S(null, repeat(X)(repeat(X)(repeat(X)(null, X(A("a"), "x")), X(A("a"), "x")), X(A("a"), "x")))});
    test("aax", q{S(repeat(A)(null, A("a")), repeat(X)(null, X(A("a"), "x")))});
    test("aaxax", q{S(repeat(A)(null, A("a")), repeat(X)(repeat(X)(null, X(A("a"), "x")), X(A("a"), "x")))});
    test("aaax", q{S(repeat(A)(repeat(A)(null, A("a")), A("a")), repeat(X)(null, X(A("a"), "x")))});
    test("aaaxax", q{S(repeat(A)(repeat(A)(null, A("a")), A("a")), repeat(X)(repeat(X)(null, X(A("a"), "x")), X(A("a"), "x")))});
}
