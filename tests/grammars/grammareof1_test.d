import testhelpers;

static import grammareof1_lexer;

unittest
{
    import P = grammareof1;

    alias L = grammareof1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("", q{S()});
    test("l\n", q{S(Line(NormalLine("", "l", "")))});
    test("  l ", q{S(Line(NormalLine("  ", "l", " ")))});
    test(" l \n l ", q{S(Line(NormalLine(" ", "l", " ")), Line(NormalLine(" ", "l", " ")))});
    test("begin\n l \n l \n end", q{S(Line(Block(BeginLine("", "begin", ""), Line(NormalLine(" ", "l", " ")), Line(NormalLine(" ", "l", " ")), EndLine(" ", "end", ""))))});
}
