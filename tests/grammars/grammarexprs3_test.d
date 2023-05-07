import testhelpers;

static import grammarexprs3_lexer;

unittest
{
    import P = grammarexprs3;

    alias L = grammarexprs3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1*2-3/4>-5*6", q{Cmp(Add(Mult(Primary("1"), "*", Primary("2")), "-", Mult(Primary("3"), "/", Primary("4"))), ">", Mult(Prefix("-", Primary("5")), "*", Primary("6")))});
    test("-!1", q{Prefix("-", Prefix2("!", Primary("1")))});
    test("!-1", q{null}, IGNORE_VALUE);
    test("*1", q{null}, IGNORE_VALUE);
    test("**1", q{Prefix("*", "*", Primary("1"))});
    test("***1", q{null}, IGNORE_VALUE);
    test("****1", q{Prefix("*", "*", Prefix("*", "*", Primary("1")))});
}
