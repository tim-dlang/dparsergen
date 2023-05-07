import testhelpers;

static import grammarbacktrack5_lexer;

unittest
{
    import P = grammarbacktrack5;

    alias L = grammarbacktrack5_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("x11", q{X(X1(X11("x", "1", "1")))});
    test("x12", q{X(X1(X12("x", "1", "2")))});
    test("x21", q{X(X2(X21("x", "2", "1")))});
    test("x22", q{X(X2(X22("x", "2", "2")))});
    test("y11", q{Y(Y1("y", Y11("1", "1")))});
    test("y12", q{Y(Y1("y", Y12("1", "2")))});
    test("y21", q{Y(Y2("y", Y21("2", "1")))});
    test("y22", q{Y(Y2("y", Y22("2", "2")))});
}
