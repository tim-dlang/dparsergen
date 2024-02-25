import testhelpers;

static import grammarexprs1_lexer;

unittest
{
    import P = grammarexprs1;

    alias L = grammarexprs1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("expr x*2+24*x*32", q{S(P(V("x"), Z("2")), "+", P(P(Z("24"), V("x")), Z("32")))});

    test("x", q{V("x")});
    test("12340", q{Z("12340")});

    test("x+1*2", q{S(V("x"), "+", P(Z("1"), Z("2")))});
    test("expr x*1+2", q{S(P(V("x"), Z("1")), "+", Z("2"))});
    test("expr x*(1+2)", q{P(V("x"), F("(", S(Z("1"), "+", Z("2")), ")"))});
    test("(x+1)*2", q{P(F("(", S(V("x"), "+", Z("1")), ")"), Z("2"))});
    test("f()", q{C(V("f"), "(", null, ")")});
    test("en ( )", q{C(V("en"), "(", null, ")")});
    test("(x) y", q{null}, "input left after parse");
    test("forward(1)", q{Z("1")});
    test("forward test", q{C("test")});
    test("null", q{Null()});

    test("[]", q{C("[", "]")});
    test("[1]", q{C("[", Z("1"), "]")});
    test("[1, 2]", q{C("[", Z("1"), Z("2"), "]")});
    test("[1, 2, 3]", q{C("[", Z("1"), Z("2"), Z("3"), "]")});
    test("[1,]", q{C("[", Z("1"), "]")});
    test("[1, 2,]", q{C("[", Z("1"), Z("2"), "]")});
    test("[1, 2, 3,]", q{C("[", Z("1"), Z("2"), Z("3"), "]")});
    test("<1>", q{C("<", Z("1"), ">")});
    test("<1, 2>", q{C("<", Z("1"), Z("2"), ">")});
    test("<1, 2, 3>", q{C("<", Z("1"), Z("2"), Z("3"), ">")});
    test("{1}", q{C("{", ArrElemsX(Z("1")), "}")});
    test("{1, 2}", q{C("{", ArrElemsX(Z("1"), Z("2")), "}")});
    test("{1, 2, 3}", q{C("{", ArrElemsX(Z("1"), Z("2"), Z("3")), "}")});
    test("QEN+0", q{S(V("QEN"), "+", Z("0"))});

    test("if(1)return 2;", q{IfStmt(Z("1"), ReturnStmt(Z("2")))});
    test("if(1)return 2;else return 3;", q{IfElseStmt(Z("1"), ReturnStmt(Z("2")), ReturnStmt(Z("3")))});
    test("if(1)if(2)return 3;", q{IfStmt(Z("1"), IfStmt(Z("2"), ReturnStmt(Z("3"))))});
    test("if(1)if(2)return 3;else return 4;", q{IfStmt(Z("1"), IfElseStmt(Z("2"), ReturnStmt(Z("3")), ReturnStmt(Z("4"))))});
    test("if(1)if(2)return 3;else return 4;else return 5;", q{IfElseStmt(Z("1"), IfElseStmt(Z("2"), ReturnStmt(Z("3")), ReturnStmt(Z("4"))), ReturnStmt(Z("5")))});

    test("x[1]", q{C(V("x"), "[", Z("1"), "]")});

    test("T x;", q{Declaration(SimpleType("T"), "x")});
    test("T[2] x;", q{Declaration(ArrayType(SimpleType("T"), Z("2")), "x")});

    //test("z * X ;", q{Declaration(PointerType(SimpleType("z")), "X")});
    test("O4 ( 14779 )", q{C(V("O4"), "(", Params(Z("14779")), ")")});
    test("expr forward Ge * 0 * [ 0 ]", q{P(P(C("Ge"), Z("0")), C("[", Z("0"), "]"))});
}

unittest
{
    enum printCode = false;

    alias L = grammarexprs1_lexer.Lexer!LocationBytes;

    alias test = testLexer!(L, printCode);

    test("", []);
    test("  ", []);
    test("if(1)return 2;", [
            Token("if", L.tokenID!"\"if\"", 0, 2),
            Token("(", L.tokenID!"\"(\"", 2, 3),
            Token("1", L.tokenID!"Number", 3, 4),
            Token(")", L.tokenID!"\")\"", 4, 5),
            Token("return", L.tokenID!"\"return\"", 5, 11),
            Token("2", L.tokenID!"Number", 12, 13),
            Token(";", L.tokenID!"\";\"", 13, 14),
            ]);
}

// Running at CTFE requires a new compiler, because of https://issues.dlang.org/show_bug.cgi?id=24316
static if (__VERSION__ >= 2108L || __traits(compiles, {
            import P = grammarexprs1;
            immutable grammarInfo = &P.grammarInfo;
            enum dummy = grammarInfo.allNonterminals.length;
        }))
    enum ctfeResult = () {
        import P = grammarexprs1;

        alias L = grammarexprs1_lexer.Lexer!LocationBytes;
        alias test = testOnce!(P, L);

        test("expr x*2+24*x*32", q{S(P(V("x"), Z("2")), "+", P(P(Z("24"), V("x")), Z("32")))});

        return true;
    }();
else
    pragma(msg, "Warning: Skipping CTFE test for old compiler");
