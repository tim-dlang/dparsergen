import testhelpers;

static import grammartokenminus1_lexer;

unittest
{
    import P = grammartokenminus1;

    alias L = grammartokenminus1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("keyword id", q{S("keyword", "id")});
    test("keyword2", q{null}, "Error unexpected '2', expected [\\t-\\n\\r /-13-79A-Z_a-z]");
    test("0", q{S("0")});
    test("2", q{null}, "Error unexpected '2', expected [\\t-\\n\\r /-13-79A-Z_a-z]");
    test("/**/", q{S("/**/")});
    test("/*test*/", q{S("/*test*/")});
    test("/*te*st*/", q{S("/*te*st*/")});
    test("/*te*st*//**/", q{S("/*te*st*/", "/**/")});
}
