import testhelpers;

static import grammardeep1_lexer;

unittest
{
    import P = grammardeep1;

    alias L = grammardeep1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("aaa", q{S(A(B(D(E(F(X("a"), Y("a"), Z("a")))))))});
    test("bbb", q{S(A(B(D(E(F(X("b"), Y("b"), Z("b")))))))});
    test("aba", q{S(A(B(D(E(F(X("a"), Y("b"), Z("a")))))))});
    test("bab", q{S(A(B(D(E(F(X("b"), Y("a"), Z("b")))))))});
    test("aab", q{S(A(B(D(E(F(X("a"), Y("a"), Z("b")))))))});
    test("bba", q{S(A(B(D(E(F(X("b"), Y("b"), Z("a")))))))});
    test("baa", q{S(A(B(D(E(F(X("b"), Y("a"), Z("a")))))))});
    test("abb", q{S(A(B(D(E(F(X("a"), Y("b"), Z("b")))))))});
}
