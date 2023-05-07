import testhelpers;

unittest
{
    import P = grammarlookahead2;

    alias L = imported!"grammarlookahead2_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S(null)});
    test("x()a", q{S(X3(A("x"), "(", null, ")", "a"))});
    test("x()b", q{S(X3(B("x"), "(", null, ")", "b"))});
    test("x(x()a)a", q{S(X3(A("x"), "(", X3(A("x"), "(", null, ")", "a"), ")", "a"))});
    test("x(x()a)b", q{S(X3(B("x"), "(", X3(A("x"), "(", null, ")", "a"), ")", "b"))});
    test("x(x()b)a", q{S(X3(A("x"), "(", X3(B("x"), "(", null, ")", "b"), ")", "a"))});
    test("x(x()b)b", q{S(X3(B("x"), "(", X3(B("x"), "(", null, ")", "b"), ")", "b"))});
}
