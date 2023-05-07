import testhelpers;

static import grammarregarray2_lexer;

unittest
{
    import P = grammarregarray2;

    alias L = grammarregarray2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("int x", q{Variable("int", "x")});
    test("class x", q{Class("class", "x")});
    test("const int x", q{Variable(Const("const"), "int", "x")});
    test("const class x", q{Class(Const("const"), "class", "x")});
    test("final int x", q{null}, IGNORE_VALUE);
    test("final class x", q{Class(Final("final"), "class", "x")});
    test("const final int x", q{null}, IGNORE_VALUE);
    test("const final class x", q{Class(Const("const"), Final("final"), "class", "x")});
    test("final const int x", q{null}, IGNORE_VALUE);
    test("final const class x", q{Class(Final("final"), Const("const"), "class", "x")});
    test("const const int x", q{Variable(Const("const"), Const("const"), "int", "x")});
    test("const const class x", q{Class(Const("const"), Const("const"), "class", "x")});
    test("const const const int x", q{Variable(Const("const"), Const("const"), Const("const"), "int", "x")});
    test("const const const class x", q{Class(Const("const"), Const("const"), Const("const"), "class", "x")});
}
