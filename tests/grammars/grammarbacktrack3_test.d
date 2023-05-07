import testhelpers;

unittest
{
    import P = grammarbacktrack3;

    alias L = imported!"grammarbacktrack3_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("id:", q{S(LabelStatement(LabelId("id"), ":"))});
    test("id id;", q{S(Statement(Decl(Type("id"), "id"), ";"))});
    version (glr)
        test("id* id;", q{S(Merged:Statement(Statement(Decl(PointerType(Type("id"), "*"), "id"), ";"), Statement(MulExpr(PrimaryExpr("id"), "*", PrimaryExpr("id")), ";")))});
    else
        test("id* id;", q{S(Statement(Decl(PointerType(Type("id"), "*"), "id"), ";"))});
    test("id[] id;", q{S(Statement(Decl(ArrayType(Type("id"), "[", "]"), "id"), ";"))});
    test("[];", q{S(Statement(PrimaryExpr("[", "]"), ";"))});
}
