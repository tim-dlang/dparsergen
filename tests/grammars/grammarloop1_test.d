import testhelpers;

static import grammarloop1_lexer;

unittest
{
    import P = grammarloop1;

    alias L = grammarloop1_lexer.Lexer!LocationBytes;
    alias test = testOnce!(P, L);

    test(q{l}, q{S("l", null)});
    test(q{ll}, q{S("l", LoopLeft(null, "l"))});
    test(q{lll}, q{S("l", LoopLeft(LoopLeft(null, "l"), "l"))});
    test(q{r}, q{S("r", null)});
    test(q{rr}, q{S("r", LoopRight("r", null))});
    test(q{rrr}, q{S("r", LoopRight("r", LoopRight("r", null)))});
    test(q{a}, q{S("a", null)});
    test(q{aa}, q{S("a", LoopLeftA(null, "a"))});
    test(q{aba}, q{S("a", LoopLeftA(LoopLeftB(null, "b"), "a"))});
    test(q{aaba}, q{S("a", LoopLeftA(LoopLeftB(LoopLeftA(null, "a"), "b"), "a"))});
    test(q{ababa}, q{S("a", LoopLeftA(LoopLeftB(LoopLeftA(LoopLeftB(null, "b"), "a"), "b"), "a"))});
    test(q{c}, q{S("c", null)});
    test(q{cc}, q{S("c", LoopRightC("c", null))});
    test(q{ccd}, q{S("c", LoopRightC("c", LoopRightD("d", null)))});
    test(q{ccdc}, q{S("c", LoopRightC("c", LoopRightD("d", LoopRightC("c", null))))});
    test(q{ccdcd}, q{S("c", LoopRightC("c", LoopRightD("d", LoopRightC("c", LoopRightD("d", null)))))});
}
