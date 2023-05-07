import testhelpers;

unittest
{
    import P = grammarundefined1;

    alias L = imported!"grammarundefined1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x", q{S(X("x"))});
    test("y", q{null}, q{EOF});
    test("z", q{null}, q{Error unexpected 'z', expected [x-y]});
}
