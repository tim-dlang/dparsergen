import testhelpers;

static import grammaroptdescent1_lexer;

unittest
{
    import P = grammaroptdescent1;

    alias L = grammaroptdescent1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("in const(int)", q{Parameter(ParameterStorageClass("in"), BasicType(TypeCtor("const"), "(", FundamentalType("int"), ")"))});
}
