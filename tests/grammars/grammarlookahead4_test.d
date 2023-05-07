import testhelpers;

unittest
{
    import P = grammarlookahead4;

    alias L = imported!"grammarlookahead4_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("int i;", q{VarDecl(Type("int"), "i", ";")});
    test("int i = i;", q{VarDecl(Type("int"), "i", "=", "i", ";")});
    test("int i() = i;", q{VarDecl(Type("int"), "i", TemplateParameters("(", ")"), "=", "i", ";")});
    test("int i(i) = i;", q{VarDecl(Type("int"), "i", TemplateParameters("(", TemplateParameter("i"), ")"), "=", "i", ";")});
    test("int i(i,i) = i;", q{VarDecl(Type("int"), "i", TemplateParameters("(", TemplateParameter("i"), ",", TemplateParameter("i"), ")"), "=", "i", ";")});
    test("int i(){}", q{FuncDecl(Type("int"), "i", Parameters("(", ")"), "{", "}")});
    test("int i(i){}", q{FuncDecl(Type("int"), "i", Parameters("(", Parameter(Type("i")), ")"), "{", "}")});
    test("int i(i,i){}", q{FuncDecl(Type("int"), "i", Parameters("(", Parameter(Type("i")), ",", Parameter(Type("i")), ")"), "{", "}")});
    test("int i()(i){}", q{FuncDecl(Type("int"), "i", TemplateParameters("(", ")"), Parameters("(", Parameter(Type("i")), ")"), "{", "}")});
    test("int i(i)(i){}", q{FuncDecl(Type("int"), "i", TemplateParameters("(", TemplateParameter("i"), ")"), Parameters("(", Parameter(Type("i")), ")"), "{", "}")});
}
