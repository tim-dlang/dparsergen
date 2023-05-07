import testhelpers;

static import grammarstoredtokens1_lexer;

unittest
{
    import P = grammarstoredtokens1;

    alias L = grammarstoredtokens1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("q\"END\ntest\nEND\"", q{S("q\"END\ntest\nEND\"")});
    test("q\"/test/\"", q{S("q\"/test/\"")});
    test("q\"END\ntest\nEND\"\nq\"END\ntest2\nEND\"", q{S("q\"END\ntest\nEND\"", "q\"END\ntest2\nEND\"")});
    test("q\"/test/\"\nq\"/test2/\"", q{S("q\"/test/\"", "q\"/test2/\"")});
    test("q\"END\ntest\nEND\"\nq\"/test2/\"", q{S("q\"END\ntest\nEND\"", "q\"/test2/\"")});
}
