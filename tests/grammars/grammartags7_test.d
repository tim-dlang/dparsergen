import testhelpers;

static import grammartags7_lexer;

unittest
{
    import P = grammartags7;

    alias L = grammartags7_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("enum x : y {}", q{EnumDeclaration("enum", IdentifierExpression("x"), ":", IdentifierExpression("y"), EnumBody("{", "}"))});
    test("enum x y;", q{EnumVarDeclaration("enum", IdentifierExpression("x"), IdentifierExpression("y"), ";")});
    test("enum x y, z;", q{EnumVarDeclaration("enum", IdentifierExpression("x"), IdentifierExpression("y"), ",", DeclaratorIdentifier("z"), ";")});
    test("x y;", q{VarDeclarations(IdentifierExpression("x"), IdentifierExpression("y"), ";")});
    test("x y, z;", q{VarDeclarations(IdentifierExpression("x"), IdentifierExpression("y"), ",", DeclaratorIdentifier("z"), ";")});
    test("x y : l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", IdentifierExpression("l")), ";")});
    test("x y : l, z;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", IdentifierExpression("l")), ",", DeclaratorIdentifier("z"), ";")});
    test("x y : l, z : l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", IdentifierExpression("l")), ",", BitfieldDeclarator("z", ":", IdentifierExpression("l")), ";")});
    test("x y, z : l;", q{VarDeclarations(IdentifierExpression("x"), IdentifierExpression("y"), ",", BitfieldDeclarator("z", ":", IdentifierExpression("l")), ";")});
    test("x : l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator(":", IdentifierExpression("l")), ";")});
    test("x* y;", q{VarDeclarations(PostfixType(IdentifierExpression("x"), "*"), IdentifierExpression("y"), ";")});
    test("x** y;", q{VarDeclarations(PostfixType(PostfixType(IdentifierExpression("x"), "*"), "*"), IdentifierExpression("y"), ";")});
    test("x*** y;", q{VarDeclarations(PostfixType(PostfixType(PostfixType(IdentifierExpression("x"), "*"), "*"), "*"), IdentifierExpression("y"), ";")});
    test("x y : l * l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", MulExpression(IdentifierExpression("l"), "*", IdentifierExpression("l"))), ";")});
    test("x y : l * *l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", MulExpression(IdentifierExpression("l"), "*", UnaryExpression("*", IdentifierExpression("l")))), ";")});
    test("x y : l * **l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", MulExpression(IdentifierExpression("l"), "*", UnaryExpression("*", UnaryExpression("*", IdentifierExpression("l"))))), ";")});
    test("x y : l * ***l;", q{VarDeclarations(IdentifierExpression("x"), BitfieldDeclarator("y", ":", MulExpression(IdentifierExpression("l"), "*", UnaryExpression("*", UnaryExpression("*", UnaryExpression("*", IdentifierExpression("l")))))), ";")});
    test("enum x : y* {}", q{EnumDeclaration("enum", IdentifierExpression("x"), ":", PostfixType(IdentifierExpression("y"), "*"), EnumBody("{", "}"))});
    test("enum x : y** {}", q{EnumDeclaration("enum", IdentifierExpression("x"), ":", PostfixType(PostfixType(IdentifierExpression("y"), "*"), "*"), EnumBody("{", "}"))});
    test("enum x : y*** {}", q{EnumDeclaration("enum", IdentifierExpression("x"), ":", PostfixType(PostfixType(PostfixType(IdentifierExpression("y"), "*"), "*"), "*"), EnumBody("{", "}"))});

    test("enum x : y * z;", q{null}, q{unexpected Token "z"  "Identifier"});
    test("enum x : y * *z;", q{null}, q{unexpected Token "z"  "Identifier"});
    //test("enum x y, z : l;", q{null}, q{});
}
