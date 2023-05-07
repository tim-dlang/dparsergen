import testhelpers;

unittest
{
    import P = grammardanglingelse4;

    alias L = imported!"grammardanglingelse4_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S()});
    test("s", q{null}, q{EOF});
    test("s;", q{S(Stmt("s", ";"))});
    test("{}s;", q{S(Stmt("{", "}"), Stmt("s", ";"))});
    test("if()s;", q{S(IfStmt("if", "(", ")", Stmt("s", ";")))});
    test("if()s;else s;", q{S(IfStmt("if", "(", ")", Stmt("s", ";"), "else", Stmt("s", ";")))});
    test("if()if()s;else s;", q{null}, IGNORE_VALUE);
    test("if(){if()s;else s;}", q{S(IfStmt("if", "(", ")", Stmt("{", IfStmt("if", "(", ")", Stmt("s", ";"), "else", Stmt("s", ";")), "}")))});
    test("if(){if()s;}else s;", q{S(IfStmt("if", "(", ")", Stmt("{", IfStmt("if", "(", ")", Stmt("s", ";")), "}"), "else", Stmt("s", ";")))});
    test("if()if()s;else s;else s;", q{S(IfStmt("if", "(", ")", IfStmt("if", "(", ")", Stmt("s", ";"), "else", Stmt("s", ";")), "else", Stmt("s", ";")))});
    test("if(){if()s;else s;}else s;", q{S(IfStmt("if", "(", ")", Stmt("{", IfStmt("if", "(", ")", Stmt("s", ";"), "else", Stmt("s", ";")), "}"), "else", Stmt("s", ";")))});
}
