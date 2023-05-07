import testhelpers;

unittest
{
    import P = grammarlambda1;

    alias L = imported!"grammarlambda1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("a", q{S("a")});
    test("(a)", q{S("(", S("a"), ")")});
    test("(a)=>x", q{Lambda(Type("a"), S("x"))});
    test("((a)=>x)", q{S("(", Lambda(Type("a"), S("x")), ")")});
    test("(X!(a))=>x", q{Lambda(Type("X", S("a")), S("x"))});
    test("(X!((a)=>b))=>x", q{Lambda(Type("X", Lambda(Type("a"), S("b"))), S("x"))});
    test("(a)=>(x)=>y", q{Lambda(Type("a"), Lambda(Type("x"), S("y")))});
    test("(a,X!((a)=>b),Y!(a))=>x", q{Lambda(Type("a"), Type("X", Lambda(Type("a"), S("b"))), Type("Y", S("a")), S("x"))});
}
