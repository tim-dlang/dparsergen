import std.conv;
import testhelpers;

unittest
{
    import P = grammarlexertest1;

    bool[string] nonterminals;
    foreach (m; P.allNonterminals)
        nonterminals[m.name] = true;
    bool[string] tokens;
    foreach (t; P.allTokens)
        tokens[t.name] = true;

    bool[2][string] expected = [
        "Start": [true, false],
        "Identifier": [false, true],
        "Number": [false, true],
        "NotReachable": [false, false],
        "NotToken": [true, false],
        "\"key\"": [false, true],
        "eps": [false, false],
        "NotReachable2": [false, false],
        "\"notreachable\"": [false, false],
    ];

    foreach (k, v; expected)
    {
        assert(!!(k in nonterminals) == v[0], text(k, " nonterminal ", !!(k in nonterminals), " ", v[0]));
        assert(!!(k in tokens) == v[1], text(k, " token ", !!(k in tokens), " ", v[1]));
    }
}

unittest
{
    import grammarlexertest1_lexer;

    enum printCode = false;
    alias L = Lexer!LocationBytes;
    alias test = testLexer!(L, printCode);

    test("test == 1234 key", [
            Token("test", L.tokenID!"Identifier", 0, 4),
            Token("==", L.tokenID!"EqualOperator", 5, 7),
            Token("1234", L.tokenID!"Number", 8, 12),
            Token("key", L.tokenID!"\"key\"", 13, 16),
            ]);
    test("", []);
    test("0", [Token("0", L.tokenID!"Number", 0, 1)]);
    test("1", [Token("1", L.tokenID!"Number", 0, 1)]);
    test("1234", [Token("1234", L.tokenID!"Number", 0, 4)]);
    test("key", [Token("key", L.tokenID!"\"key\"", 0, 3)]);
    test("notreachable", [Token("notreachable", L.tokenID!"Identifier", 0, 12)]);
    test("lo", [Token("lo", L.tokenID!"Identifier", 0, 2)]);
    test("loop", [Token("loop", L.tokenID!"RealLoop", 0, 4)]);
    test("looplo", [Token("looplo", L.tokenID!"Identifier", 0, 6)]);
    test("looploop", [Token("looploop", L.tokenID!"RealLoop", 0, 8)]);
    test("\"\"", [Token("\"\"", L.tokenID!"StringLiteral", 0, 2)]);
    test("\"uiae\"", [Token("\"uiae\"", L.tokenID!"StringLiteral", 0, 6)]);
    test("\"key\"", [Token("\"key\"", L.tokenID!"StringLiteral", 0, 5)]);
    test("\"\\/\"", [Token("\"\\/\"", L.tokenID!"StringLiteral", 0, 4)]);
    test("\"\\xaf\"", [Token("\"\\xaf\"", L.tokenID!"StringLiteral", 0, 6)]);
    test("\"\\xzz\"", [], "Error unexpected 'z', expected [0-9A-Fa-f]");
    test("\"\\u1234\"", [], "Error unexpected 'u', expected [^Uu]");
    test("\"üöä\"", [Token("\"üöä\"", L.tokenID!"StringLiteral", 0, 8)]);
    test("==", [Token("==", L.tokenID!"EqualOperator", 0, 2)]);
    test("üöä", [Token("üöä", L.tokenID!"\"üöä\"", 0, 6)]);
    test("looploop loop looplo", [
            Token("looploop", L.tokenID!"RealLoop", 0, 8),
            Token("loop", L.tokenID!"RealLoop", 9, 13),
            Token("looplo", L.tokenID!"Identifier", 14, 20),
            ]);
    test("  ", []);
    test(" //uiae", []);
    test("test//uiae", [Token("test", L.tokenID!"Identifier", 0, 4)]);
    test(" test //uiae", [Token("test", L.tokenID!"Identifier", 1, 5)]);
    test(" test //uiae\n", [Token("test", L.tokenID!"Identifier", 1, 5)]);
    test(" test //uiae\n1234", [
            Token("test", L.tokenID!"Identifier", 1, 5),
            Token("1234", L.tokenID!"Number", 13, 17),
            ]);
    test(" test //uiae\n 1234", [
            Token("test", L.tokenID!"Identifier", 1, 5),
            Token("1234", L.tokenID!"Number", 14, 18),
            ]);
    test(" test //uiae\n 1234\n", [
            Token("test", L.tokenID!"Identifier", 1, 5),
            Token("1234", L.tokenID!"Number", 14, 18),
            ]);
    test("/", [Token("/", L.tokenID!"\"/\"", 0, 1)]);
    test(" /", [Token("/", L.tokenID!"\"/\"", 1, 2)]);
    test(" / ", [Token("/", L.tokenID!"\"/\"", 1, 2)]);
    test("/**/", []);
    test("/*  */", []);
    test("/*text*/", []);
    test("/*text*/id", [Token("id", L.tokenID!"Identifier", 8, 10)]);
    test("id/*text*/123", [
            Token("id", L.tokenID!"Identifier", 0, 2),
            Token("123", L.tokenID!"Number", 10, 13),
            ]);
    test("/**/id*/", [
            Token("id", L.tokenID!"Identifier", 4, 6),
            Token("*", L.tokenID!"\"*\"", 6, 7),
            Token("/", L.tokenID!"\"/\"", 7, 8),
            ]);
    test("/*text*/id*/", [
            Token("id", L.tokenID!"Identifier", 8, 10),
            Token("*", L.tokenID!"\"*\"", 10, 11),
            Token("/", L.tokenID!"\"/\"", 11, 12),
            ]);
    test("/***/id*/", [
            Token("id", L.tokenID!"Identifier", 5, 7),
            Token("*", L.tokenID!"\"*\"", 7, 8),
            Token("/", L.tokenID!"\"/\"", 8, 9),
            ]);
    test("/*/*/id*/", [
            Token("id", L.tokenID!"Identifier", 5, 7),
            Token("*", L.tokenID!"\"*\"", 7, 8),
            Token("/", L.tokenID!"\"/\"", 8, 9),
            ]);
    test("/****/id*/", [
            Token("id", L.tokenID!"Identifier", 6, 8),
            Token("*", L.tokenID!"\"*\"", 8, 9),
            Token("/", L.tokenID!"\"/\"", 9, 10),
            ]);
    test("/*//*/id*/", [
            Token("id", L.tokenID!"Identifier", 6, 8),
            Token("*", L.tokenID!"\"*\"", 8, 9),
            Token("/", L.tokenID!"\"/\"", 9, 10),
            ]);
    test("/*/**/id*/", [
            Token("id", L.tokenID!"Identifier", 6, 8),
            Token("*", L.tokenID!"\"*\"", 8, 9),
            Token("/", L.tokenID!"\"/\"", 9, 10),
            ]);
    test("/**/*/id*/", [
            Token("*", L.tokenID!"\"*\"", 4, 5),
            Token("/", L.tokenID!"\"/\"", 5, 6),
            Token("id", L.tokenID!"Identifier", 6, 8),
            Token("*", L.tokenID!"\"*\"", 8, 9),
            Token("/", L.tokenID!"\"/\"", 9, 10),
            ]);
}
