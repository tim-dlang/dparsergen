import testhelpers;

static import grammardirectunwrap4_lexer;

unittest
{
    import P = grammardirectunwrap4;

    alias L = grammardirectunwrap4_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("{}", q{StructInitializer("{", "}")});
    test("{a}", q{StructInitializer("{", IdentifierExpression("a"), "}")});
    test("{a,b}", q{StructInitializer("{", IdentifierExpression("a"), ",", IdentifierExpression("b"), "}")});
    test("{a:b}", q{StructInitializer("{", StructMemberInitializer(IdentifierExpression("a"), ":", NonVoidInitializer("b")), "}")});
    test("{a:b,c}", q{StructInitializer("{", StructMemberInitializer(IdentifierExpression("a"), ":", NonVoidInitializer("b")), ",", IdentifierExpression("c"), "}")});
    test("{a:b,c:d}", q{StructInitializer("{", StructMemberInitializer(IdentifierExpression("a"), ":", NonVoidInitializer("b")), ",", StructMemberInitializer(IdentifierExpression("c"), ":", NonVoidInitializer("d")), "}")});
}
