import testhelpers;

static import grammarcombinedreduce2_lexer;

unittest
{
    import P = grammarcombinedreduce2;

    alias L = grammarcombinedreduce2_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("1 test", q{S("1", IdentifierExpression("test"))});
    test("1 test[x]", q{S("1", QualifiedIdentifier(IdentifierExpression("test"), QualifiedArraySuffix("[", "x", "]")))});
    test("2 int()", q{S("2", PostfixExpression(BasicType("int"), "(", ")"))});
    test("2 test()", q{null}, IGNORE_VALUE);
    test("2 test[x]()", q{null}, IGNORE_VALUE);
    test("2 int()[x]", q{S("2", PostfixExpression(PostfixExpression(BasicType("int"), "(", ")"), "[", "x", "]"))});
    test("3 int", q{S("3", BasicType("int"))});
    test("3 int[x]", q{S("3", PostfixType(BasicType("int"), ArrayTypeSuffix("[", "x", "]")))});
    test("3 int[]", q{S("3", PostfixType(BasicType("int"), ArrayTypeSuffix("[", "]")))});
}
