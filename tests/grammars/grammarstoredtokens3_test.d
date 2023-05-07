import testhelpers;

static import grammarstoredtokens3_lexer;

unittest
{
    import P = grammarstoredtokens3;

    alias L = grammarstoredtokens3_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test(q{R"()"}, q{Start(S("R\"()\""))});
    test(q{R"( )"}, q{Start(S("R\"( )\""))});
    test(q{R"( )x " )y" )) )"}, q{Start(S("R\"( )x \" )y\" )) )\""))});
    test(q{R"( )x " )y" )) ))"}, q{Start(S("R\"( )x \" )y\" )) ))\""))});
    test(q{R"x()x"}, q{Start(S("R\"x()x\""))});
    test(q{R"x( )x"}, q{Start(S("R\"x( )x\""))});
    test(q{R"x( )) )x"}, q{Start(S("R\"x( )) )x\""))});
    test(q{R"x( )x " )y" )) )x"}, q{Start(S("R\"x( )x \" )y\" )) )x\""))});
    test(q{R"x( )x " )y" )) ))x"}, q{Start(S("R\"x( )x \" )y\" )) ))x\""))});
    test(q{R"xyz()xyz"}, q{Start(S("R\"xyz()xyz\""))});
    test(q{R"xyz( )xyz"}, q{Start(S("R\"xyz( )xyz\""))});
    test(q{R""(test)""}, q{Start(S("R\"\"(test)\"\""))});
    test(q{R"""(test)"""}, q{Start(S("R\"\"\"(test)\"\"\""))});
    test(q{R"x( )x"R"x( )x"}, q{Start(S("R\"x( )x\""), S("R\"x( )x\""))});
}
