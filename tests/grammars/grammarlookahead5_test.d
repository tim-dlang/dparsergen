import testhelpers;

static import grammarlookahead5_lexer;

unittest
{
    import P = grammarlookahead5;

    alias L = grammarlookahead5_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("ia", q{S(A(Unary("i")), "a")});
    test("ib", q{S(B(Unary("i")), "b")});
    test("-ia", q{S(A(Unary("-", Unary("i"))), "a")});
    test("-ib", q{S(B(Unary("-", Unary("i"))), "b")});
    test("i*i==i+-i&&i!=ia", q{S(A(And(Cmp(Mul(Unary("i"), "*", Unary("i")), "==", Add(Unary("i"), "+", Unary("-", Unary("i")))), "&&", Cmp(Unary("i"), "!=", Unary("i")))), "a")});
    test("i*i==i+-i&&i!=ib", q{S(B(And(Cmp(Mul(Unary("i"), "*", Unary("i")), "==", Add(Unary("i"), "+", Unary("-", Unary("i")))), "&&", Cmp(Unary("i"), "!=", Unary("i")))), "b")});
}
