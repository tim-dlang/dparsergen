import testhelpers;

static import grammarconflict1_lexer;

unittest
{
    import P = grammarconflict1;

    alias L = grammarconflict1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("@a", q{S(A("@", "a"), null)});
    test("@a@b", q{S(A("@", "a"), B("@", "b"))});
    test("@b", q{S(null, B("@", "b"))});
    test("@b@a", q{null}, q{input left after parse});
}
