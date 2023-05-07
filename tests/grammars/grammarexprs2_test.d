import testhelpers;

unittest
{
    import P = grammarexprs2;

    alias L = imported!"grammarexprs2_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1", q{Primary("1")});
    test("-1", q{Unary("-", Primary("1"))});
    test("1&&2&&3", q{And(And(Primary("1"), "&&", Primary("2")), "&&", Primary("3"))});
    test("1||2||3", q{Or(Or(Primary("1"), "||", Primary("2")), "||", Primary("3"))});
    test("1*-2+3/4", q{Add(Mul(Primary("1"), "*", Unary("-", Primary("2"))), "+", Mul(Primary("3"), "/", Primary("4")))});
    test("4<(3+7)", q{Comparison(Primary("4"), "<", Primary("(", Add(Primary("3"), "+", Primary("7")), ")"))});
    test("1<2&&3<4", q{And(Comparison(Primary("1"), "<", Primary("2")), "&&", Comparison(Primary("3"), "<", Primary("4")))});
    test("1*-2+3/4<(5>6)&&7>8", q{And(Comparison(Add(Mul(Primary("1"), "*", Unary("-", Primary("2"))), "+", Mul(Primary("3"), "/", Primary("4"))), "<", Primary("(", Comparison(Primary("5"), ">", Primary("6")), ")")), "&&", Comparison(Primary("7"), ">", Primary("8")))});

    test("1&&2||3", q{null}, q{input left after parse});
    test("1||2&&3", q{null}, q{input left after parse});
    test("1<2<3", q{null}, q{input left after parse});
    test("1<2>3", q{null}, q{input left after parse});
}
