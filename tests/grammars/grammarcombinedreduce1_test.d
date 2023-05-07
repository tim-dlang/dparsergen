import testhelpers;

unittest
{
    import P = grammarcombinedreduce1;

    alias L = imported!"grammarcombinedreduce1_lexer".Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test("[]", q{ArrayLiteral("[", "]")});
    version (glr)
    {
        test("[1]", q{Merged:Literal(ArrayLiteral("[", Expression("1"), "]"), AssocArrayLiteral("[", Expression("1"), "]"))});
        test("[1,]", q{Merged:Literal(ArrayLiteral("[", Expression("1"), ",", "]"), AssocArrayLiteral("[", Expression("1"), ",", "]"))});
        test("[1,2]", q{Merged:Literal(ArrayLiteral("[", Expression("1"), ",", Expression("2"), "]"), AssocArrayLiteral("[", Expression("1"), ",", Expression("2"), "]"))});
        test("[1,2,]", q{Merged:Literal(ArrayLiteral("[", Expression("1"), ",", Expression("2"), ",", "]"), AssocArrayLiteral("[", Expression("1"), ",", Expression("2"), ",", "]"))});
    }
    else
    {
        test("[1]", q{Combined:ArrayLiteral|AssocArrayLiteral("[", Expression("1"), "]")});
        test("[1,]", q{Combined:ArrayLiteral|AssocArrayLiteral("[", Expression("1"), ",", "]")});
        test("[1,2]", q{Combined:ArrayLiteral|AssocArrayLiteral("[", Expression("1"), ",", Expression("2"), "]")});
        test("[1,2,]", q{Combined:ArrayLiteral|AssocArrayLiteral("[", Expression("1"), ",", Expression("2"), ",", "]")});
    }
    test("[1:2]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), "]")});
    test("[1:2,]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), ",", "]")});
    test("[1:2,3]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), ",", Expression("3"), "]")});
    test("[1:2,3,]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), ",", Expression("3"), ",", "]")});
    test("[1,2:3]", q{AssocArrayLiteral("[", Expression("1"), ",", KeyValuePair(Expression("2"), ":", Expression("3")), "]")});
    test("[1,2:3,]", q{AssocArrayLiteral("[", Expression("1"), ",", KeyValuePair(Expression("2"), ":", Expression("3")), ",", "]")});
    test("[1:2,3:4]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), ",", KeyValuePair(Expression("3"), ":", Expression("4")), "]")});
    test("[1:2,3:4,]", q{AssocArrayLiteral("[", KeyValuePair(Expression("1"), ":", Expression("2")), ",", KeyValuePair(Expression("3"), ":", Expression("4")), ",", "]")});
}
