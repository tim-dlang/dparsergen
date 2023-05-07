import testhelpers;

static import grammareager2_lexer;

unittest
{
    import P = grammareager2;

    alias L = grammareager2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("i;", q{IdStmt(IdExpr("i"), ";")});
    test("type name;", q{Decl(IdExpr("type"), IdExpr("name"), ";")});
    test("{ f; g; h; }", q{Block("{", IdStmt(IdExpr("f"), ";"), IdStmt(IdExpr("g"), ";"), IdStmt(IdExpr("h"), ";"), "}")});
    test("{ f; type name; }", q{Block("{", IdStmt(IdExpr("f"), ";"), Decl(IdExpr("type"), IdExpr("name"), ";"), "}")});
    test("{ label1: }", q{Block("{", Label(IdExpr("label1"), ":", null), "}")});
    test("{ label1: f; }", q{Block("{", Label(IdExpr("label1"), ":", IdStmt(IdExpr("f"), ";")), "}")});
    test("{ label1: f; g; }", q{Block("{", Label(IdExpr("label1"), ":", IdStmt(IdExpr("f"), ";")), IdStmt(IdExpr("g"), ";"), "}")});
    test("{ label1: label2: f; }", q{Block("{", Label(IdExpr("label1"), ":", Label(IdExpr("label2"), ":", IdStmt(IdExpr("f"), ";"))), "}")});
    test("{ label1: label2: f; g; }", q{Block("{", Label(IdExpr("label1"), ":", Label(IdExpr("label2"), ":", IdStmt(IdExpr("f"), ";"))), IdStmt(IdExpr("g"), ";"), "}")});
    test("{ x; label1: label2: }", q{Block("{", IdStmt(IdExpr("x"), ";"), Label(IdExpr("label1"), ":", Label(IdExpr("label2"), ":", null)), "}")});
    test("{ x; label1: label2: f; }", q{Block("{", IdStmt(IdExpr("x"), ";"), Label(IdExpr("label1"), ":", Label(IdExpr("label2"), ":", IdStmt(IdExpr("f"), ";"))), "}")});
    test("{ x; label1: label2: f; g; }", q{Block("{", IdStmt(IdExpr("x"), ";"), Label(IdExpr("label1"), ":", Label(IdExpr("label2"), ":", IdStmt(IdExpr("f"), ";"))), IdStmt(IdExpr("g"), ";"), "}")});
    test("label1: i", q{null}, IGNORE_VALUE);
}
