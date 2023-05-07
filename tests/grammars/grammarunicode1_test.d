import testhelpers;

static import grammarunicode1_lexer;

unittest
{
    enum printCode = false;
    alias L = grammarunicode1_lexer.Lexer!LocationBytes;
    alias test = testLexer!(L, printCode);

    test("¹²³", [
            Token("¹", L.tokenID!"[¹²³]", 0, 2),
            Token("²", L.tokenID!"[¹²³]", 2, 4),
            Token("³", L.tokenID!"[¹²³]", 4, 6),
            ]);
    test("≤", [Token("≤", L.tokenID!"\"≤\"", 0, 3)]);
    test("≥", [Token("≥", L.tokenID!"\"≥\"", 0, 3)]);
    test("≠", [Token("≠", L.tokenID!"\"≠\"", 0, 3)]);
    test("∀", [Token("∀", L.tokenID!"\"\\u2200\"", 0, 3)]);
    test("😃", [Token("😃", L.tokenID!"\"😃\"", 0, 4)]);
    test("♩", [Token("♩", L.tokenID!"\"♩\"", 0, 3)]);
    test("🎼", [Token("🎼", L.tokenID!"\"\\U0001F3BC\"", 0, 4)]);
    test("𝕂𝔼𝕐𝕎𝕆ℝ𝔻", [Token("𝕂𝔼𝕐𝕎𝕆ℝ𝔻", L.tokenID!"\"𝕂𝔼𝕐𝕎𝕆ℝ𝔻\"", 0, 27)]);
    test("test", [Token("test", L.tokenID!"AsciiWord", 0, 4)]);
    test("testöüäÄÜÖßẞtest", [Token("testöüäÄÜÖßẞtest", L.tokenID!"GermanWord", 0, 25)]);
    test("test😃test", [
            Token("test", L.tokenID!"AsciiWord", 0, 4),
            Token("😃", L.tokenID!"\"😃\"", 4, 8),
            Token("test", L.tokenID!"AsciiWord", 8, 12),
            ]);
    test("x≤y", [
            Token("x", L.tokenID!"AsciiWord", 0, 1),
            Token("≤", L.tokenID!"\"≤\"", 1, 4),
            Token("y", L.tokenID!"AsciiWord", 4, 5),
            ]);
    test("０", [Token("０", L.tokenID!"FullWidthHexNumber", 0, 3)]);
    test("１", [Token("１", L.tokenID!"FullWidthHexNumber", 0, 3)]);
    test("１２３４５６７８９ＡＢＣＤＥＦ", [Token("１２３４５６７８９ＡＢＣＤＥＦ", L.tokenID!"FullWidthHexNumber", 0, 45)]);
    test("１２３４５６７８９ａｂｃｄｅｆ", [Token("１２３４５６７８９ａｂｃｄｅｆ", L.tokenID!"FullWidthHexNumber", 0, 45)]);
    test("１０", [Token("１０", L.tokenID!"FullWidthHexNumber", 0, 6)]);
    test("０１", [
            Token("０", L.tokenID!"FullWidthHexNumber", 0, 3),
            Token("１", L.tokenID!"FullWidthHexNumber", 3, 6),
            ]);
}
