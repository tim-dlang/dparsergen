module generatortests;
import dparsergen.generator.ebnf;
import dparsergen.generator.generator;
import dparsergen.generator.grammar;
import dparsergen.generator.production;
import std.algorithm;
import std.array;
import std.conv;

bool equalWithoutWhite(string a, string b)
{
    while (true)
    {
        while (!a.empty && (a.front == ' ' || a.front == '\t' || a.front == '\r'))
            a.popFront;
        while (!b.empty && (b.front == ' ' || b.front == '\t' || b.front == '\r'))
            b.popFront;
        if (a.empty && b.empty)
            return true;
        if (a.empty || b.empty)
            return false;
        if (a.front != b.front)
            return false;
        a.popFront;
        b.popFront;
    }
}

struct FirstSetTest
{
    string name;
    string[] firstSet;
}

unittest
{
    EBNFGrammar test(string gr, string expected, FirstSetTest[] firstSets = [],
            string filename = __FILE__, size_t line = __LINE__)
    {
        EBNFGrammar grammar = gr.parseEBNF2("").createGrammar();
        string grammartext = text(grammar);
        assert(equalWithoutWhite(grammartext, expected), text(filename, ":", line,
                "\n", "got: \"", grammartext, "\"\nexpected: \"", expected, "\""));
        foreach (t; firstSets)
        {
            SymbolInstance[] s = [SymbolInstance(grammar.nonterminals.getID(t.name))];
            auto f = grammar.firstSet(s);
            string[] f2;
            foreach (x; f.bitsSet)
            {
                f2 ~= grammar.getSymbolName(x);
            }
            assert(f2 == t.firstSet, text(t.name, " ", f2, " ", t.firstSet));
        }

        return grammar;
    }

    test(q{S = "x"| "y" S;},
    q{EBNFGrammar
        S = "x"
        S = "y" S
    });

    test(q{S = X?; X = "x";},
    q{EBNFGrammar
        X? = <X [virtual]
        X? = [virtual]
        S = X?
        X = "x"
    });

    test(q{S = id("a");id(b) = b;},
    q{EBNFGrammar
        id("a") = "a"
        S = id("a")
    });

    test(q{S = list(X);list(b) = b|list(b) b;X = "x";},
    q{EBNFGrammar
        list(X) = X
        list(X) = list(X) X
        S = list(X)
        X = "x"
    });

    test(q{S = list(X,",");list(e,s) = e|list(e,s) s e;X = "x";},
    q{EBNFGrammar
        list(X, ",") = X
        list(X, ",") = list(X, ",") "," X
        S = list(X, ",")
        X = "x"
    });

    test(q{S = list(X,",");list(e,s) = e|list(e,s) ^s e;X = "x";},
    q{EBNFGrammar
        list(X, ",") = X
        list(X, ",") = list(X, ",") ^"," X
        S = list(X, ",")
        X = "x"
    });

    test(q{S @a = @b "x" @c "y" @d;},
    q{EBNFGrammar
        S @a = @b "x" @c "y" @d
    });

    test(q{S = "s" | "if" "(" S ")" S | "if" "(" S ")" S "else" S;},
    q{EBNFGrammar
        S = "s"
        S = "if" "(" S ")" S
        S = "if" "(" S ")" S "else" S
    });

    test(q{S = "s" | "if" "(" S ")" S !"else" | "if" "(" S ")" S "else" S;},
    q{EBNFGrammar
        S = "s"
        S = "if" "(" S ")" S !"else"
        S = "if" "(" S ")" S "else" S
    });

    test(q{S = A? B?;A = "@" "a";B = "@" "b";},
    q{EBNFGrammar
        A? = <A [virtual]
        A? = [virtual]
        B? = <B [virtual]
        B? = [virtual]
        S = A? B?
        A = "@" "a"
        B = "@" "b"
    });

    test(q{
        Module = star("A") | star("B");
        star(e) = @empty | star(e) e;
    },
    q{EBNFGrammar
        star("A") = @empty
        star("A") = star("A") "A"
        Module = star("A")
        star("B") = @empty
        star("B") = star("B") "B"
        Module = star("B")
    });

    test(q{
        Module = repeat("A" "B");
        star(e) = @empty | star(e) e;
        repeat(e) = e star(e);
    },
    q{EBNFGrammar
        {"A"_"B"} = "A" "B"
        star({"A" "B"}) = @empty
        star({"A" "B"}) = star({"A" "B"}) {"A"_"B"}
        repeat({"A" "B"}) = {"A"_"B"} star({"A" "B"})
        Module = repeat({"A" "B"})
    });

    test(q{
        Module = repeat("A"|"B");
        star(e) = @empty | star(e) e;
        repeat(e) = e star(e);
    },
    q{EBNFGrammar
        {"A"_|_"B"} = "A"
        {"A"_|_"B"} = "B"
        star({"A" | "B"}) = @empty
        star({"A" | "B"}) = star({"A" | "B"}) {"A"_|_"B"}
        repeat({"A" | "B"}) = {"A"_|_"B"} star({"A" | "B"})
        Module = repeat({"A" | "B"})
    });

    test(q{
        PostfixExp = PrimaryExpression
                   star( FieldAccessExp
                   | TemplateFuncExp );

        FieldAccessExp = "_" "id";

        TemplateFuncExp = "!" "id";
        star(e) @array = @empty | star(e) e;
        PrimaryExpression = "primary";
    },
    q{EBNFGrammar
          star({FieldAccessExp | TemplateFuncExp}) @array = @empty
          {FieldAccessExp_|_TemplateFuncExp} = FieldAccessExp
          {FieldAccessExp_|_TemplateFuncExp} = TemplateFuncExp
          star({FieldAccessExp | TemplateFuncExp}) @array = star({FieldAccessExp | TemplateFuncExp}) {FieldAccessExp_|_TemplateFuncExp}
          PostfixExp = PrimaryExpression star({FieldAccessExp | TemplateFuncExp})
          FieldAccessExp = "_" "id"
          TemplateFuncExp = "!" "id"
          PrimaryExpression = "primary"
    },[
        FirstSetTest("TemplateFuncExp",["\"!\""]),
        FirstSetTest("{FieldAccessExp_|_TemplateFuncExp}",["\"_\"","\"!\""]),
        FirstSetTest("PostfixExp",["\"primary\""]),
        FirstSetTest("star({FieldAccessExp | TemplateFuncExp})",["$end","\"_\"","\"!\""]),
    ]);

    auto grammarTags1 = test(q{
        S = A | B;
        A = @rejectTag(T1) Y;
        B = @needTag(T1) Y;
        Y = @inheritTag(T1) @inheritTag(T2) @inheritTag(T3) X;
        X = "x1" @tag(T1)
          | "x2" @tag(T2)
          | "x3" @tag(T3);
    },
    q{EBNFGrammar
          S = A
          S = B
          A = @rejectTag(T1) Y
          B = @needTag(T1) Y
          Y = @inheritTag(T1) @inheritTag(T2) @inheritTag(T3) X
          X = "x1" @tag(T1)
          X = "x2" @tag(T2)
          X = "x3" @tag(T3)
    }, [
        FirstSetTest("X", ["\"x1\"", "\"x2\"", "\"x3\""]),
        FirstSetTest("Y", ["\"x1\"", "\"x2\"", "\"x3\""]),
        FirstSetTest("A", ["\"x2\"", "\"x3\""]),
        // TODO FirstSetTest("B", ["\"x1\""]),
        FirstSetTest("S", ["\"x1\"", "\"x2\"", "\"x3\""]),
    ]);

    static string tagsString(EBNFGrammar grammar, immutable(TagID)[] tags)
    {
        string[] strings;
        foreach (tag; tags)
        {
            strings ~= grammar.tags[tag].name;
        }
        strings.sort();
        return strings.join(" ");
    }

    assert(tagsString(grammarTags1, grammarTags1.nonterminals.get("S").possibleTags) == "");
    assert(tagsString(grammarTags1, grammarTags1.nonterminals.get("A").possibleTags) == "");
    assert(tagsString(grammarTags1, grammarTags1.nonterminals.get("B").possibleTags) == "");
    assert(tagsString(grammarTags1, grammarTags1.nonterminals.get("Y").possibleTags) == "T1 T2 T3");
    assert(tagsString(grammarTags1, grammarTags1.nonterminals.get("X").possibleTags) == "T1 T2 T3");

    test(q{
        EOF = !anytoken @empty;
    },
    q{EBNFGrammar
        EOF = !anytoken @empty
    });
    test(q{
        S = Identifier | Test;
        token Identifier = [a - zA - Z_] [a - zA - Z0 - 9]*;
        Test = Identifier>>"test";
    },
    q{EBNFGrammar
        S = Identifier
        S = Test
        Test = Identifier>>"test"
    });

    test(q{
        Module = or("A","B");
        or(e) = e;
        or(e1, e2, r...) = e1 | or(e2, r...);
    },
    q{EBNFGrammar
       or("A", "B") = "A"
       or("B") = "B"
       or("A", "B") = or("B")
       Module = or("A", "B")
    });

    test(q{
        Module = or("A","B");
        or(e) = e;
        or(r..., e1, e2) = e1 | or(r..., e2);
    },
    q{EBNFGrammar
       or("A", "B") = "A"
       or("B") = "B"
       or("A", "B") = or("B")
       Module = or("A", "B")
    });

    test(q{
        Module = or("A","B");
        or(e) = e;
        or(e1, r..., e2) = e1 | or(r..., e2);
    },
    q{EBNFGrammar
       or("A", "B") = "A"
       or("B") = "B"
       or("A", "B") = or("B")
       Module = or("A", "B")
    });

    test(q{
        Module = or("A","B","C","D");
        or(e) = e;
        or(e1, e2, r...) = e1 | or(e2, r...);
    },
    q{EBNFGrammar
       or("A", "B", "C", "D") = "A"
       or("B", "C", "D") = "B"
       or("C", "D") = "C"
       or("D") = "D"
       or("C", "D") = or("D")
       or("B", "C", "D") = or("C", "D")
       or("A", "B", "C", "D") = or("B", "C", "D")
       Module = or("A", "B", "C", "D")
    });

    test(q{
        Module = test(t("A","B"), t("C","D"));
        test(a, b) = or(a...) or(b...);
        or(e) = e;
        or(e1, e2, r...) = e1 | or(e2, r...);
    },
    q{EBNFGrammar
       or("A", "B") = "A"
       or("B") = "B"
       or("A", "B") = or("B")
       or("C", "D") = "C"
       or("D") = "D"
       or("C", "D") = or("D")
       test(t("A", "B"), t("C", "D")) = or("A", "B") or("C", "D")
       Module = test(t("A", "B"), t("C", "D"))
    });

    test(q{
        Module = listof("A","B");
        listof() = @empty;
        listof(e, r...) = listof(e, r...) or(e, r...) | listof2(t(), e, r...);
        listof2(done, e) = listof(done...) e;
        listof2(done, e, e2, r...) = listof(done..., e2, r...) e | listof2(t(done..., e), e2, r...);
        or(e) = e;
        or(e1, e2, r...) = e1 | or(e2, r...);
    },
    q{EBNFGrammar
        or("A", "B") = "A"
        or("B") = "B"
        or("A", "B") = or("B")
        listof("A", "B") = listof("A", "B") or("A", "B")
        listof("B") = listof("B") or("B")
        listof() = @empty
        listof2(t(), "B") = listof() "B"
        listof("B") = listof2(t(), "B")
        listof2(t(), "A", "B") = listof("B") "A"
        or("A") = "A"
        listof("A") = listof("A") or("A")
        listof2(t(), "A") = listof() "A"
        listof("A") = listof2(t(), "A")
        listof2(t("A"), "B") = listof("A") "B"
        listof2(t(), "A", "B") = listof2(t("A"), "B")
        listof("A", "B") = listof2(t(), "A", "B")
        Module = listof("A", "B")
        listof = @empty
    });

    test(q{
        S = As | Bs | Cs | Ds;
        As = "a"*;
        Bs = B*;
        B = "b";
        Cs = "c" "C"*;
        Ds = D D*;
        D = "d";
    },
    q{EBNFGrammar
        S = As
        S = Bs
        S = Cs
        S = Ds
        "a"+ @array = "a" [virtual]
        "a"+ @array = "a"+ "a" [virtual]
        "a"* @array = [virtual]
        "a"* @array = "a"+ [virtual]
        As = "a"*
        B+ @array = B [virtual]
        B+ @array = B+ B [virtual]
        B* @array = [virtual]
        B* @array = B+ [virtual]
        Bs = B*
        B = "b"
        "C"+ @array = "C" [virtual]
        "C"+ @array = "C"+ "C" [virtual]
        "C"* @array = [virtual]
        "C"* @array = "C"+ [virtual]
        Cs = "c" "C"*
        D+ @array = D [virtual]
        D+ @array = D+ D [virtual]
        D* @array = [virtual]
        D* @array = D+ [virtual]
        Ds = D D*
        D = "d"
    });

    test(q{
        S = As | Bs | Cs | Ds;
        As = "a"+;
        Bs = B+;
        B = "b";
        Cs = "c" "C"+;
        Ds = D D+;
        D = "d";
    },
    q{EBNFGrammar
        S = As
        S = Bs
        S = Cs
        S = Ds
        "a"+ @array = "a" [virtual]
        "a"+ @array = "a"+ "a" [virtual]
        As = "a"+
        B+ @array = B [virtual]
        B+ @array = B+ B [virtual]
        Bs = B+
        B = "b"
        "C"+ @array = "C" [virtual]
        "C"+ @array = "C"+ "C" [virtual]
        Cs = "c" "C"+
        D+ @array = D [virtual]
        D+ @array = D+ D [virtual]
        Ds = D D+
        D = "d"
    });

    test(q{
        S = As | Bs;
        As = "a"?;
        Bs = B?;
        B = "b";
    },
    q{EBNFGrammar
        S = As
        S = Bs
        "a"? = <"a" [virtual]
        "a"? = [virtual]
        As = "a"?
        B? = <B [virtual]
        B? = [virtual]
        Bs = B?
        B = "b"
    });
}

unittest
{
    void test(string gr, string expected)
    {
        auto ebnf = gr.parseEBNF2("");
        EBNFGrammar grammar = ebnf.createGrammar();
        grammar = createOptEmptyGrammar(ebnf, grammar);
        string grammartext = text(grammar);
        assert(equalWithoutWhite(grammartext, expected),
              text("got: \"", grammartext, "\"\nexpected: \"", expected, "\""));
    }

    test(q{
        S = T;
        T = A? B? C?;
        A = "a";
        B = "b";
        C = "c";
    },
    q{EBNFGrammar
        A? = <A [virtual]
        B? = <B [virtual]
        C? = <C [virtual]
        A = "a"
        B = "b"
        C = "c"
        S = T
        T = C?
        T = B?
        T = B? C?
        T = A?
        T = A? C?
        T = A? B?
        T = A? B? C?
    });

    test(q{
        S = T;
        T = A? B C?;
        A = "a";
        B = @empty;
        C = "c";
    },
    q{EBNFGrammar
        A? = <A [virtual]
        C? = <C [virtual]
        A = "a"
        C = "c"
        S = T
        T = C?
        T = A?
        T = A? C?
    });
}
