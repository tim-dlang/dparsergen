import testhelpers;

static import grammarstoredtokens4_lexer;

unittest
{
    import P = grammarstoredtokens4;

    alias L = grammarstoredtokens4_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test(q{R"()"}, q{S("R\"()\"")});
    test(q{R"( )"}, q{S("R\"( )\"")});
    test(q{R"( )x " )y" )) )"}, q{S("R\"( )x \" )y\" )) )\"")});
    test(q{R"( )x " )y" )) ))"}, q{S("R\"( )x \" )y\" )) ))\"")});
    test(q{R"x()x"}, q{S("R\"x()x\"")});
    test(q{R"x( )x"}, q{S("R\"x( )x\"")});
    test(q{R"x( )) )x"}, q{S("R\"x( )) )x\"")});
    test(q{R"x( )x " )y" )) )x"}, q{S("R\"x( )x \" )y\" )) )x\"")});
    test(q{R"x( )x " )y" )) ))x"}, q{S("R\"x( )x \" )y\" )) ))x\"")});
    test(q{R"xyz()xyz"}, q{S("R\"xyz()xyz\"")});
    test(q{R"xyz( )xyz"}, q{S("R\"xyz( )xyz\"")});
}
