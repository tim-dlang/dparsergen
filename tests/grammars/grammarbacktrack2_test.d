import testhelpers;

static import grammarbacktrack2_lexer;

unittest
{
    import P = grammarbacktrack2;

    alias L = grammarbacktrack2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("(id*)", q{S(Args("(", PointerType(Type("id"), "*"), ")"))});
    test("(id**)", q{S(Args("(", PointerType(PointerType(Type("id"), "*"), "*"), ")"))});
    test("(id[])", q{S(Args("(", ArrayType(Type("id"), "[", "]"), ")"))});
    test("(id[]*)", q{S(Args("(", PointerType(ArrayType(Type("id"), "[", "]"), "*"), ")"))});
    test("(id*id)", q{S(Args("(", MulExpr(PrimaryExpr("id"), "*", PrimaryExpr("id")), ")"))});
    test("(id**id)", q{S(Args("(", MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", PrimaryExpr("id"))), ")"))});
    test("(id***id)", q{S(Args("(", MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", UnaryExpr("*", PrimaryExpr("id")))), ")"))});
    test("(id*[]*id)", q{S(Args("(", MulExpr(MulExpr(PrimaryExpr("id"), "*", PrimaryExpr("[", "]")), "*", PrimaryExpr("id")), ")"))});
    test("(id**[]*id)", q{S(Args("(", MulExpr(MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", PrimaryExpr("[", "]"))), "*", PrimaryExpr("id")), ")"))});
    test("(id**[]**id)", q{S(Args("(", MulExpr(MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", PrimaryExpr("[", "]"))), "*", UnaryExpr("*", PrimaryExpr("id"))), ")"))});
    test("(id*id*id)", q{S(Args("(", MulExpr(MulExpr(PrimaryExpr("id"), "*", PrimaryExpr("id")), "*", PrimaryExpr("id")), ")"))});
    test("(**id***id***id)", q{S(Args("(", MulExpr(MulExpr(UnaryExpr("*", UnaryExpr("*", PrimaryExpr("id"))), "*", UnaryExpr("*", UnaryExpr("*", PrimaryExpr("id")))), "*", UnaryExpr("*", UnaryExpr("*", PrimaryExpr("id")))), ")"))});

    version (glr)
    {
        test("(id)", q{S(Args("(", Merged:TypeOrExpr(Type("id"), PrimaryExpr("id")), ")"))});
        test("(id,)", q{S(Args("(", Merged:TypeOrExpr(Type("id"), PrimaryExpr("id")), ",", ")"))});
        test("(id,id)", q{S(Args("(", Merged:TypeOrExpr(Type("id"), PrimaryExpr("id")), ",", Merged:TypeOrExpr(Type("id"), PrimaryExpr("id")), ")"))});
        test("(id*[])", q{S(Args("(", Merged:TypeOrExpr(ArrayType(PointerType(Type("id"), "*"), "[", "]"), MulExpr(PrimaryExpr("id"), "*", PrimaryExpr("[", "]"))), ")"))});
        test("(id**[])", q{S(Args("(", Merged:TypeOrExpr(ArrayType(PointerType(PointerType(Type("id"), "*"), "*"), "[", "]"), MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", PrimaryExpr("[", "]")))), ")"))});
        test("(id***[])", q{S(Args("(", Merged:TypeOrExpr(ArrayType(PointerType(PointerType(PointerType(Type("id"), "*"), "*"), "*"), "[", "]"), MulExpr(PrimaryExpr("id"), "*", UnaryExpr("*", UnaryExpr("*", PrimaryExpr("[", "]"))))), ")"))});
    }
    else
    {
        test("(id)", q{S(Args("(", Type("id"), ")"))});
        test("(id,)", q{S(Args("(", Type("id"), ",", ")"))});
        test("(id,id)", q{S(Args("(", Type("id"), ",", Type("id"), ")"))});
        test("(id*[])", q{S(Args("(", ArrayType(PointerType(Type("id"), "*"), "[", "]"), ")"))});
        test("(id**[])", q{S(Args("(", ArrayType(PointerType(PointerType(Type("id"), "*"), "*"), "[", "]"), ")"))});
        test("(id***[])", q{S(Args("(", ArrayType(PointerType(PointerType(PointerType(Type("id"), "*"), "*"), "*"), "[", "]"), ")"))});
    }
}
