import testhelpers;

unittest
{
    import P = grammarbacktrack1;

    alias L = imported!"grammarbacktrack1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("test1 xya", q{S(X(A("x"), LA("y", "a")))});
    test("test1 xyb", q{S(X(B("x"), LB("y", "b")))});

    test("test2 id id", q{S(DeclExpr(Decl(Type(ST(Id("id"))), Id("id"))))});
    test("test2 id[123] id", q{S(DeclExpr(Decl(Type(AT(Type(ST(Id("id"))), "[", Z("123"), "]")), Id("id"))))});
    test("test2 id[123][123] id", q{S(DeclExpr(Decl(Type(AT(Type(AT(Type(ST(Id("id"))), "[", Z("123"), "]")), "[", Z("123"), "]")), Id("id"))))});

    test("test2 123", q{S(DeclExpr(Expr(Z("123"))))});
    test("test2 id", q{S(DeclExpr(Expr(Var(Id("id")))))});
    test("test2 id[123]", q{S(DeclExpr(Expr(Var(Id("id")), "[", Z("123"), "]")))});
}
