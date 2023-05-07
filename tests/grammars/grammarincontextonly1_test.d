import testhelpers;

static import grammarincontextonly1_lexer;

unittest
{
    import P = grammarincontextonly1;

    alias L = grammarincontextonly1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("<test>", q{S(Normal(WS(), Token("<"), Token("test"), Token(">")))});
    test("test", q{S(Normal(WS(), Token("test")))});
    test("<test", q{S(Normal(WS(), Token("<"), Token("test")))});
    test("<<><>>><", q{S(Normal(WS(), Token("<"), Token("<"), Token(">"), Token("<"), Token(">"), Token(">"), Token(">"), Token("<")))});
    test("#include <test>", q{S(Special(WS(), "#include", SysStringPart(WS(" "), "<test>"), WS()))});
    test("#include <test", q{null}, q{unexpected Token "<"  ""<""});
}
