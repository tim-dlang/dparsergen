import testhelpers;

static import grammarnestedtokens2_lexer;

unittest
{
    import grammarnestedtokens2_lexer;

    enum printCode = false;
    alias L = Lexer!(LocationBytes, true);
    alias test = testLexer!(L, printCode);

    test(" \t/**//*test*//*abc/*def*/q{} ", [
            Token(" \t", L.tokenID!"WhiteSpace", 0, 2),
            Token("/**/", L.tokenID!"Comment", 2, 6),
            Token("/*test*/", L.tokenID!"Comment", 6, 14),
            Token("/*abc/*def*/", L.tokenID!"Comment", 14, 26),
            Token("q{}", L.tokenID!"TokenString", 26, 29),
            Token(" ", L.tokenID!"WhiteSpace", 29, 30),
            ]);
    test(" \t/++//+test+//+abc/+def+/ghi+/q{} ", [
            Token(" \t", L.tokenID!"WhiteSpace", 0, 2),
            Token("/++/", L.tokenID!"Comment", 2, 6),
            Token("/+test+/", L.tokenID!"Comment", 6, 14),
            Token("/+abc/+def+/ghi+/", L.tokenID!"Comment", 14, 31),
            Token("q{}", L.tokenID!"TokenString", 31, 34),
            Token(" ", L.tokenID!"WhiteSpace", 34, 35),
            ]);
    test(" // test/*abc*/\n/*def*/", [
            Token(" ", L.tokenID!"WhiteSpace", 0, 1),
            Token("// test/*abc*/\n", L.tokenID!"Comment", 1, 16),
            Token("/*def*/", L.tokenID!"Comment", 16, 23),
            ]);
    test("q{abc/*def*/ghi}", [
            Token("q{abc/*def*/ghi}", L.tokenID!"TokenString", 0, 16)
            ]);
}
