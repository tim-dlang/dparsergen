import testhelpers;

static import grammarstoredtokens2_lexer;

unittest
{
    import P = grammarstoredtokens2;

    alias L = grammarstoredtokens2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("id", q{S("id")});
    test("q\"üöä\ntest\nüöä\"", q{S("q\"üöä\ntest\nüöä\"")});
    test("q\"üöä\nüöä \nüöä\"", q{S("q\"üöä\nüöä \nüöä\"")});
    test("q\"üöä\n üöä\nüöä\"", q{S("q\"üöä\n üöä\nüöä\"")});
    test("q\"/test/\"", q{S("q\"/test/\"")});
    test("q\"(test)\"", q{S("q\"(test)\"")});
    test("q\"/12/34/\"", q{S("q\"/12/34/\"")});
    test("q\"\"12\"34\"\"", q{S("q\"\"12\"34\"\"")});
}
