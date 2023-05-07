import testhelpers;

static import grammareager1_lexer;

unittest
{
    import P = grammareager1;

    alias L = grammareager1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("i", q{Id("i")});
    test("i+i*i", q{Add(Id("i"), "+", Mult(Id("i"), "*", Id("i")))});
    test("i*i+i", q{Add(Mult(Id("i"), "*", Id("i")), "+", Id("i"))});
    test("i=>i", q{Lambda("i", "=>", Id("i"))});
    test("i=>i+i", q{Lambda("i", "=>", Add(Id("i"), "+", Id("i")))});
    test("i=>i*i", q{Lambda("i", "=>", Mult(Id("i"), "*", Id("i")))});
    test("i=>i+i*i+i", q{Lambda("i", "=>", Add(Add(Id("i"), "+", Mult(Id("i"), "*", Id("i"))), "+", Id("i")))});
    test("i=>i*i+i*i", q{Lambda("i", "=>", Add(Mult(Id("i"), "*", Id("i")), "+", Mult(Id("i"), "*", Id("i"))))});
    test("i+i*i=>i*i+i*i", q{Add(Id("i"), "+", Mult(Id("i"), "*", Lambda("i", "=>", Add(Mult(Id("i"), "*", Id("i")), "+", Mult(Id("i"), "*", Id("i"))))))});
    test("i+i=>i", q{Add(Id("i"), "+", Lambda("i", "=>", Id("i")))});
    test("i*i=>i", q{Mult(Id("i"), "*", Lambda("i", "=>", Id("i")))});
    test("i=>i=>i+i", q{Lambda("i", "=>", Lambda("i", "=>", Add(Id("i"), "+", Id("i"))))});
    test("(i=>i)+i", q{Add(Parens("(", Lambda("i", "=>", Id("i")), ")"), "+", Id("i"))});
}
