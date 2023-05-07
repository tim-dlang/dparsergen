import testhelpers;

static import grammarinline1_lexer;

unittest
{
    import P = grammarinline1;

    alias L = grammarinline1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1ixa", q{Test1(A(Identifier("i")), "x", "a")});
    test("1ixb", q{Test1(B(Identifier("i")), "x", "b")});

    test("2ixa", q{Test2(A4(A3(A2(A1(Identifier("i"))))), "x", "a")});
    test("2ixb", q{Test2(B4(B3(B2(B1(Identifier("i"))))), "x", "b")});

    test("3ixa", q{S("3", Test3(Test3A(Identifier("i")), "x", "a"))});
    test("3ixb", q{S("3", Test3(Test3B(Identifier("i")), "x", "b"))});
    test("3iixa", q{S("3", Test3(Test3A(Test3A(Identifier("i")), Identifier("i")), "x", "a"))});
    test("3iixb", q{S("3", Test3(Test3B(Test3B(Identifier("i")), Identifier("i")), "x", "b"))});

    test("4ixa", q{S("4", Test4(Test4A(Identifier("i")), "x", "a"))});
    test("4ixb", q{S("4", Test4(Test4B(Identifier("i")), "x", "b"))});
    test("4ixc", q{null}, q{unexpected Token "c"  ""c""});
    test("4iya", q{null}, q{unexpected Token "a"  ""a""});
    test("4iyb", q{S("4", Test4(Test4B(Identifier("i")), "y", "b"))});
    test("4iyc", q{S("4", Test4(Test4C(Identifier("i")), "y", "c"))});

    test("5ixa", q{S("5", Test5(Test5A2(Test5A1(Identifier("i"))), "x", "a"))});
    test("5ixb", q{S("5", Test5(Test5B(Identifier("i")), "x", "b"))});

    test("6ixa", q{Test6(Test6A2(Test6A1(Identifier("i"))), "x", "a")});
    test("6ixb", q{Test6(Test6B(Identifier("i")), Test6BX("x"), "b")});

    test("7ixa", q{Test7(Test7A(Identifier("i")), "x", "a")});
    test("7ixb", q{null}, q{unexpected Token "b"  ""b""});
    //test("7iixa",q{Merged(Test7(Test7A(Test7A(Identifier("i")), Identifier("i")), "x", "a"), Test7(Test7B(Identifier("i")), "i", "x", "a"))});
    test("7iixb", q{null}, q{unexpected Token "b"  ""b""});
}
