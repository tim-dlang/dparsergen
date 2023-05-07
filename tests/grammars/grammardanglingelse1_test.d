import testhelpers;

unittest
{
    import P = grammardanglingelse1;

    alias L = imported!"grammardanglingelse1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S()});
    test("s", q{null}, q{EOF});
    test("s;", q{S(Stmt("s", ";"))});
    test("{}s;", q{S(Stmt("{", "}"), Stmt("s", ";"))});
    test("if()s;", q{S(IfStmt("if", "(", ")", Stmt("s", ";")))});
    version (glr)
    {}
    else
    {
        test("if()s;else s;", q{null}, IGNORE_VALUE);
        test("if()if()s;else s;", q{null}, IGNORE_VALUE);
        test("if(){if()s;else s;}", q{null}, IGNORE_VALUE);
        test("if(){if()s;}else s;", q{null}, IGNORE_VALUE);
        test("if()if()s;else s;else s;", q{null}, IGNORE_VALUE);
        test("if(){if()s;else s;}else s;", q{null}, IGNORE_VALUE);
    }
}
