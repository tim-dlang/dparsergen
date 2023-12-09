// Generated with DParserGen.
module dparsergen.generator.grammarebnf;
import dparsergen.core.grammarinfo;
import dparsergen.core.parseexception;
import dparsergen.core.parsestackelem;
import dparsergen.core.utils;
import std.algorithm;
import std.conv;
import std.meta;
import std.stdio;
import std.traits;

enum SymbolID startTokenID = 0;
static assert(allTokens.length < SymbolID.max - startTokenID);
enum SymbolID endTokenID = startTokenID + allTokens.length;

enum SymbolID startNonterminalID = 0;
static assert(allNonterminals.length < SymbolID.max - startNonterminalID);
enum SymbolID endNonterminalID = startNonterminalID + allNonterminals.length;

enum ProductionID startProductionID = 0;
static assert(allProductions.length < ProductionID.max - startProductionID);
enum ProductionID endProductionID = startProductionID + allProductions.length;

private enum nonterminalIDForImpl(string name) = staticIndexOf!(name,
    "EBNF",
    "Declaration",
    "SymbolDeclaration",
    "DeclarationType",
    "MacroParametersPart",
    "MacroParameters",
    "MacroParameter",
    "OptionDeclaration",
    "Import",
    "MatchDeclaration",
    "Annotation",
    "AnnotationParams",
    "AnnotationParamsPart",
    "NegativeLookahead",
    "Expression",
    "Alternation",
    "Concatenation",
    "ProductionAnnotation",
    "TokenMinus",
    "AnnotatedExpression",
    "ExpressionAnnotation",
    "ExpressionName",
    "ExpressionPrefix",
    "PostfixExpression",
    "Optional",
    "Repetition",
    "RepetitionPlus",
    "AtomExpression",
    "Symbol",
    "Name",
    "Token",
    "UnpackVariadicList",
    "SubToken",
    "MacroInstance",
    "ParenExpression",
    "ExpressionList",
    "Tuple",
    "Declaration+",
    "DeclarationType?",
    "MacroParametersPart?",
    "Annotation+",
    "Annotation*",
    "MacroParameters?",
    "AnnotationParams?",
    "AnnotationParamsPart+",
    "AnnotationParamsPart*",
    "TokenMinus+",
    "ProductionAnnotation+",
    "@regArray_ProductionAnnotation*",
    "@regArray_ProductionAnnotation+",
    "ExpressionAnnotation+",
    "@regArray_ExpressionAnnotation*",
    "ExpressionName?",
    "ExpressionPrefix+",
    "ExpressionPrefix*",
    "ExpressionList?",
    "$regarray_0",
    "$regarray_1",
    "$regarrayedge_0_1",
    "$regarrayedge_1_1",
    );
template nonterminalIDFor(string name) if (nonterminalIDForImpl!name >= 0)
{
    enum nonterminalIDFor = startNonterminalID + nonterminalIDForImpl!name;
}

struct Parser(CreatorInstance, alias L)
{
    alias Lexer = L;
    alias Location = typeof(Lexer.init.front.currentLocation);
    alias LocationDiff = typeof(Location.init - Location.init);

    CreatorInstance creator;
    Lexer* lexer;
    ParseException lastError;

    template NonterminalType(size_t nonterminalID)
            if (nonterminalID >= startNonterminalID && nonterminalID < endNonterminalID)
    {
        alias NonterminalType = CreatorInstance.NonterminalType!nonterminalID;
    }

    alias Token = typeof(lexer.front.content);

    Location lastTokenEnd;

    ParseStackElem!(Location, Token) popToken()
    {
        if (lexer.front.currentLocation - lastTokenEnd != LocationDiff.invalid)
            assert(lexer.front.currentLocation >= lastTokenEnd,
                    text(lastTokenEnd, " ", lexer.front.currentLocation));

        lastTokenEnd = lexer.front.currentTokenEnd;
        auto tok = lexer.front.content;
        auto pos = lexer.front.currentLocation;
        lexer.popFront;

        assert(lastTokenEnd >= pos);

        if (!lexer.empty)
        {
            assert(lexer.front.currentLocation >= lastTokenEnd,
                    text(lastTokenEnd, " ", lexer.front.currentLocation));
        }

        return ParseStackElem!(Location, Token)(pos, tok);
    }
    auto reduce0/*Declaration+ @array = Declaration [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!1) stack1)
    {
        NonterminalType!(37/*Declaration+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(0)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(37/*Declaration+*/))(parseStart, pt);
    }

    auto reduce1/*Declaration+ @array = Declaration+ Declaration [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!37) stack2, ParseStackElem!(Location, NonterminalType!1) stack1)
    {
        NonterminalType!(37/*Declaration+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(1)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(37/*Declaration+*/))(parseStart, pt);
    }

    auto reduce2_EBNF/*EBNF = Declaration+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!37) stack1)
    {
        NonterminalType!(0/*EBNF*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(2)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(0/*EBNF*/))(parseStart, pt);
    }

    auto reduce3_Declaration/*Declaration = <SymbolDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!2) stack1)
    {
        NonterminalType!(1/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(1/*Declaration*/))(parseStart, pt);
    }

    auto reduce4_Declaration/*Declaration = <MatchDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!9) stack1)
    {
        NonterminalType!(1/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(1/*Declaration*/))(parseStart, pt);
    }

    auto reduce5_Declaration/*Declaration = <Import*/(Location parseStart, ParseStackElem!(Location, NonterminalType!8) stack1)
    {
        NonterminalType!(1/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(1/*Declaration*/))(parseStart, pt);
    }

    auto reduce6_Declaration/*Declaration = <OptionDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!7) stack1)
    {
        NonterminalType!(1/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(1/*Declaration*/))(parseStart, pt);
    }

    auto reduce7/*DeclarationType? = <DeclarationType [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!3) stack1)
    {
        NonterminalType!(38/*DeclarationType?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(38/*DeclarationType?*/))(parseStart, pt);
    }

    auto reduce8/*DeclarationType? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(38/*DeclarationType?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(38/*DeclarationType?*/))(parseStart, pt);
    }

    auto reduce9/*MacroParametersPart? = <MacroParametersPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!4) stack1)
    {
        NonterminalType!(39/*MacroParametersPart?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(39/*MacroParametersPart?*/))(parseStart, pt);
    }

    auto reduce10/*MacroParametersPart? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(39/*MacroParametersPart?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(39/*MacroParametersPart?*/))(parseStart, pt);
    }

    auto reduce11/*Annotation+ @array = Annotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(40/*Annotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(11)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(40/*Annotation+*/))(parseStart, pt);
    }

    auto reduce12/*Annotation+ @array = Annotation+ Annotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!40) stack2, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(40/*Annotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(12)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(40/*Annotation+*/))(parseStart, pt);
    }

    auto reduce13/*Annotation* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(41/*Annotation**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(41/*Annotation**/))(parseStart, pt);
    }

    auto reduce14/*Annotation* @array = Annotation+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!40) stack1)
    {
        NonterminalType!(41/*Annotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(14)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(41/*Annotation**/))(parseStart, pt);
    }

    auto reduce15_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!38) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!39) stack3, ParseStackElem!(Location, NonterminalType!41) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(2/*SymbolDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(15)(parseStart, end, stack5, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(2/*SymbolDeclaration*/))(parseStart, pt);
    }

    auto reduce16_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!38) stack7, ParseStackElem!(Location, Token) stack6, ParseStackElem!(Location, NonterminalType!39) stack5, ParseStackElem!(Location, NonterminalType!41) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!14) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(2/*SymbolDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(16)(parseStart, end, stack7, stack6, stack5, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(2/*SymbolDeclaration*/))(parseStart, pt);
    }

    auto reduce17_DeclarationType/*DeclarationType = "fragment"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(3/*DeclarationType*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(17)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(3/*DeclarationType*/))(parseStart, pt);
    }

    auto reduce18_DeclarationType/*DeclarationType = "token"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(3/*DeclarationType*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(18)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(3/*DeclarationType*/))(parseStart, pt);
    }

    auto reduce19/*MacroParameters? = <MacroParameters [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(42/*MacroParameters?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(42/*MacroParameters?*/))(parseStart, pt);
    }

    auto reduce20/*MacroParameters? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(42/*MacroParameters?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(42/*MacroParameters?*/))(parseStart, pt);
    }

    auto reduce21_MacroParametersPart/*MacroParametersPart = "(" MacroParameters? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!42) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(4/*MacroParametersPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(21)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(4/*MacroParametersPart*/))(parseStart, pt);
    }

    auto reduce22_MacroParameters/*MacroParameters @array = MacroParameter*/(Location parseStart, ParseStackElem!(Location, NonterminalType!6) stack1)
    {
        NonterminalType!(5/*MacroParameters*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(22)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(5/*MacroParameters*/))(parseStart, pt);
    }

    auto reduce23_MacroParameters/*MacroParameters @array = MacroParameters "," MacroParameter*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!6) stack1)
    {
        NonterminalType!(5/*MacroParameters*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(23)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(5/*MacroParameters*/))(parseStart, pt);
    }

    auto reduce24_MacroParameter/*MacroParameter = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(6/*MacroParameter*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(24)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(6/*MacroParameter*/))(parseStart, pt);
    }

    auto reduce25_MacroParameter/*MacroParameter = Identifier "..."*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(6/*MacroParameter*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(25)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(6/*MacroParameter*/))(parseStart, pt);
    }

    auto reduce26_OptionDeclaration/*OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"*/(Location parseStart/*, ParseStackElem!(Location, Token) stack5*/, ParseStackElem!(Location, Token) stack4/*, ParseStackElem!(Location, Token) stack3*/, ParseStackElem!(Location, Token) stack2/*, ParseStackElem!(Location, Token) stack1*/)
    {
        NonterminalType!(7/*OptionDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(26)(parseStart, end, stack4, stack2);
        }
        return ParseStackElem!(Location, NonterminalType!(7/*OptionDeclaration*/))(parseStart, pt);
    }

    auto reduce27_Import/*Import = "import" StringLiteral ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(8/*Import*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(27)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(8/*Import*/))(parseStart, pt);
    }

    auto reduce28_MatchDeclaration/*MatchDeclaration = "match" Symbol Symbol ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!28) stack3, ParseStackElem!(Location, NonterminalType!28) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(9/*MatchDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(28)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(9/*MatchDeclaration*/))(parseStart, pt);
    }

    auto reduce29/*AnnotationParams? = <AnnotationParams [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!11) stack1)
    {
        NonterminalType!(43/*AnnotationParams?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(43/*AnnotationParams?*/))(parseStart, pt);
    }

    auto reduce30/*AnnotationParams? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(43/*AnnotationParams?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(43/*AnnotationParams?*/))(parseStart, pt);
    }

    auto reduce31_Annotation/*Annotation = "@" Identifier AnnotationParams?*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!43) stack1)
    {
        NonterminalType!(10/*Annotation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(31)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*Annotation*/))(parseStart, pt);
    }

    auto reduce32/*AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!12) stack1)
    {
        NonterminalType!(44/*AnnotationParamsPart+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(32)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(44/*AnnotationParamsPart+*/))(parseStart, pt);
    }

    auto reduce33/*AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!44) stack2, ParseStackElem!(Location, NonterminalType!12) stack1)
    {
        NonterminalType!(44/*AnnotationParamsPart+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(33)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(44/*AnnotationParamsPart+*/))(parseStart, pt);
    }

    auto reduce34/*AnnotationParamsPart* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(45/*AnnotationParamsPart**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(45/*AnnotationParamsPart**/))(parseStart, pt);
    }

    auto reduce35/*AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!44) stack1)
    {
        NonterminalType!(45/*AnnotationParamsPart**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(35)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(45/*AnnotationParamsPart**/))(parseStart, pt);
    }

    auto reduce36_AnnotationParams/*AnnotationParams = "(" AnnotationParamsPart* ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!45) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(11/*AnnotationParams*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(36)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(11/*AnnotationParams*/))(parseStart, pt);
    }

    auto reduce37_AnnotationParamsPart/*AnnotationParamsPart = StringLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(37)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce38_AnnotationParamsPart/*AnnotationParamsPart = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(38)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce39_AnnotationParamsPart/*AnnotationParamsPart = CharacterSetLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(39)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce40_AnnotationParamsPart/*AnnotationParamsPart = IntegerLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(40)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce41_AnnotationParamsPart/*AnnotationParamsPart = "(" AnnotationParamsPart* ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!45) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(41)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce42_AnnotationParamsPart/*AnnotationParamsPart = "="*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(42)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce43_AnnotationParamsPart/*AnnotationParamsPart = ":"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(43)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce44_AnnotationParamsPart/*AnnotationParamsPart = ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(44)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce45_AnnotationParamsPart/*AnnotationParamsPart = ","*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(45)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce46_AnnotationParamsPart/*AnnotationParamsPart = "{"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(46)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce47_AnnotationParamsPart/*AnnotationParamsPart = "}"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(47)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce48_AnnotationParamsPart/*AnnotationParamsPart = "?"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(48)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce49_AnnotationParamsPart/*AnnotationParamsPart = "!"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(49)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce50_AnnotationParamsPart/*AnnotationParamsPart = "<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(50)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce51_AnnotationParamsPart/*AnnotationParamsPart = ">"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(51)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce52_AnnotationParamsPart/*AnnotationParamsPart = "*"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(52)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce53_AnnotationParamsPart/*AnnotationParamsPart = ">>"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(53)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce54_AnnotationParamsPart/*AnnotationParamsPart = "<<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(54)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce55_AnnotationParamsPart/*AnnotationParamsPart = "-"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(55)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce56_NegativeLookahead/*NegativeLookahead = "!" Symbol*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!28) stack1)
    {
        NonterminalType!(13/*NegativeLookahead*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(56)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(13/*NegativeLookahead*/))(parseStart, pt);
    }

    auto reduce57_NegativeLookahead/*NegativeLookahead = "!" "anytoken"*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(13/*NegativeLookahead*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(57)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(13/*NegativeLookahead*/))(parseStart, pt);
    }

    auto reduce58_Expression/*Expression = <Alternation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!15) stack1)
    {
        NonterminalType!(14/*Expression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(14/*Expression*/))(parseStart, pt);
    }

    auto reduce59_Alternation/*Alternation = <Concatenation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!16) stack1)
    {
        NonterminalType!(15/*Alternation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(15/*Alternation*/))(parseStart, pt);
    }

    auto reduce60_Alternation/*Alternation = Alternation "|" Concatenation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!15) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!16) stack1)
    {
        NonterminalType!(15/*Alternation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(60)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(15/*Alternation*/))(parseStart, pt);
    }

    auto reduce61_Concatenation/*Concatenation = <TokenMinus*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack1)
    {
        NonterminalType!(16/*Concatenation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(16/*Concatenation*/))(parseStart, pt);
    }

    auto reduce62/*TokenMinus+ @array = TokenMinus [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack1)
    {
        NonterminalType!(46/*TokenMinus+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(62)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(46/*TokenMinus+*/))(parseStart, pt);
    }

    auto reduce63/*TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!46) stack2, ParseStackElem!(Location, NonterminalType!18) stack1)
    {
        NonterminalType!(46/*TokenMinus+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(63)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(46/*TokenMinus+*/))(parseStart, pt);
    }

    auto reduce64/*ProductionAnnotation+ @array = ProductionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!17) stack1)
    {
        NonterminalType!(47/*ProductionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(64)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(47/*ProductionAnnotation+*/))(parseStart, pt);
    }

    auto reduce65/*ProductionAnnotation+ @array = ProductionAnnotation+ ProductionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!47) stack2, ParseStackElem!(Location, NonterminalType!17) stack1)
    {
        NonterminalType!(47/*ProductionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(65)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(47/*ProductionAnnotation+*/))(parseStart, pt);
    }

    auto reduce68_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack3, ParseStackElem!(Location, NonterminalType!46) stack2, ParseStackElem!(Location, NonterminalType!48) stack1)
    {
        NonterminalType!(16/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(68)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(16/*Concatenation*/))(parseStart, pt);
    }

    auto reduce71_Concatenation/*Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack2, ParseStackElem!(Location, NonterminalType!49) stack1)
    {
        NonterminalType!(16/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(71)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(16/*Concatenation*/))(parseStart, pt);
    }

    auto reduce72_Concatenation/*Concatenation = @regArray @regArray_ProductionAnnotation+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!49) stack1)
    {
        NonterminalType!(16/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(72)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(16/*Concatenation*/))(parseStart, pt);
    }

    auto reduce73_ProductionAnnotation/*ProductionAnnotation @directUnwrap = <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(17/*ProductionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(17/*ProductionAnnotation*/))(parseStart, pt);
    }

    auto reduce74_ProductionAnnotation/*ProductionAnnotation @directUnwrap = <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!13) stack1)
    {
        NonterminalType!(17/*ProductionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(17/*ProductionAnnotation*/))(parseStart, pt);
    }

    auto reduce75_TokenMinus/*TokenMinus = <AnnotatedExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!19) stack1)
    {
        NonterminalType!(18/*TokenMinus*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(18/*TokenMinus*/))(parseStart, pt);
    }

    auto reduce76_TokenMinus/*TokenMinus = TokenMinus "-" AnnotatedExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!19) stack1)
    {
        NonterminalType!(18/*TokenMinus*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(76)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(18/*TokenMinus*/))(parseStart, pt);
    }

    auto reduce77/*ExpressionAnnotation+ @array = ExpressionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!20) stack1)
    {
        NonterminalType!(50/*ExpressionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(77)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(50/*ExpressionAnnotation+*/))(parseStart, pt);
    }

    auto reduce78/*ExpressionAnnotation+ @array = ExpressionAnnotation+ ExpressionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!50) stack2, ParseStackElem!(Location, NonterminalType!20) stack1)
    {
        NonterminalType!(50/*ExpressionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(78)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(50/*ExpressionAnnotation+*/))(parseStart, pt);
    }

    auto reduce81/*ExpressionName? = <ExpressionName [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!21) stack1)
    {
        NonterminalType!(52/*ExpressionName?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(52/*ExpressionName?*/))(parseStart, pt);
    }

    auto reduce82/*ExpressionName? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(52/*ExpressionName?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(52/*ExpressionName?*/))(parseStart, pt);
    }

    auto reduce83/*ExpressionPrefix+ @array = ExpressionPrefix [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!22) stack1)
    {
        NonterminalType!(53/*ExpressionPrefix+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(83)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(53/*ExpressionPrefix+*/))(parseStart, pt);
    }

    auto reduce84/*ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!53) stack2, ParseStackElem!(Location, NonterminalType!22) stack1)
    {
        NonterminalType!(53/*ExpressionPrefix+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(84)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(53/*ExpressionPrefix+*/))(parseStart, pt);
    }

    auto reduce85/*ExpressionPrefix* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(54/*ExpressionPrefix**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(54/*ExpressionPrefix**/))(parseStart, pt);
    }

    auto reduce86/*ExpressionPrefix* @array = ExpressionPrefix+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!53) stack1)
    {
        NonterminalType!(54/*ExpressionPrefix**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(86)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(54/*ExpressionPrefix**/))(parseStart, pt);
    }

    auto reduce87_AnnotatedExpression/*AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!51) stack4, ParseStackElem!(Location, NonterminalType!52) stack3, ParseStackElem!(Location, NonterminalType!54) stack2, ParseStackElem!(Location, NonterminalType!23) stack1)
    {
        NonterminalType!(19/*AnnotatedExpression*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(87)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(19/*AnnotatedExpression*/))(parseStart, pt);
    }

    auto reduce88_ExpressionAnnotation/*ExpressionAnnotation @directUnwrap = <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(20/*ExpressionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(20/*ExpressionAnnotation*/))(parseStart, pt);
    }

    auto reduce89_ExpressionAnnotation/*ExpressionAnnotation @directUnwrap = <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!13) stack1)
    {
        NonterminalType!(20/*ExpressionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(20/*ExpressionAnnotation*/))(parseStart, pt);
    }

    auto reduce90_ExpressionName/*ExpressionName = Identifier ":"*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(21/*ExpressionName*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(90)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(21/*ExpressionName*/))(parseStart, pt);
    }

    auto reduce91_ExpressionPrefix/*ExpressionPrefix = "<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(22/*ExpressionPrefix*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(91)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(22/*ExpressionPrefix*/))(parseStart, pt);
    }

    auto reduce92_ExpressionPrefix/*ExpressionPrefix = "^"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(22/*ExpressionPrefix*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(92)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(22/*ExpressionPrefix*/))(parseStart, pt);
    }

    auto reduce93_PostfixExpression/*PostfixExpression = <Optional*/(Location parseStart, ParseStackElem!(Location, NonterminalType!24) stack1)
    {
        NonterminalType!(23/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(23/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce94_PostfixExpression/*PostfixExpression = <Repetition*/(Location parseStart, ParseStackElem!(Location, NonterminalType!25) stack1)
    {
        NonterminalType!(23/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(23/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce95_PostfixExpression/*PostfixExpression = <RepetitionPlus*/(Location parseStart, ParseStackElem!(Location, NonterminalType!26) stack1)
    {
        NonterminalType!(23/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(23/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce96_PostfixExpression/*PostfixExpression = <AtomExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!27) stack1)
    {
        NonterminalType!(23/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(23/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce97_Optional/*Optional = PostfixExpression "?"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!23) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(24/*Optional*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(97)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(24/*Optional*/))(parseStart, pt);
    }

    auto reduce98_Repetition/*Repetition = PostfixExpression "*"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!23) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(25/*Repetition*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(98)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(25/*Repetition*/))(parseStart, pt);
    }

    auto reduce99_RepetitionPlus/*RepetitionPlus = PostfixExpression "+"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!23) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(26/*RepetitionPlus*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(99)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(26/*RepetitionPlus*/))(parseStart, pt);
    }

    auto reduce100_AtomExpression/*AtomExpression = <Symbol*/(Location parseStart, ParseStackElem!(Location, NonterminalType!28) stack1)
    {
        NonterminalType!(27/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(27/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce101_AtomExpression/*AtomExpression = <ParenExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!34) stack1)
    {
        NonterminalType!(27/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(27/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce102_AtomExpression/*AtomExpression = <SubToken*/(Location parseStart, ParseStackElem!(Location, NonterminalType!32) stack1)
    {
        NonterminalType!(27/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(27/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce103_AtomExpression/*AtomExpression = <UnpackVariadicList*/(Location parseStart, ParseStackElem!(Location, NonterminalType!31) stack1)
    {
        NonterminalType!(27/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(27/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce104_AtomExpression/*AtomExpression = <Tuple*/(Location parseStart, ParseStackElem!(Location, NonterminalType!36) stack1)
    {
        NonterminalType!(27/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(27/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce105_Symbol/*Symbol = <Name*/(Location parseStart, ParseStackElem!(Location, NonterminalType!29) stack1)
    {
        NonterminalType!(28/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(28/*Symbol*/))(parseStart, pt);
    }

    auto reduce106_Symbol/*Symbol = <Token*/(Location parseStart, ParseStackElem!(Location, NonterminalType!30) stack1)
    {
        NonterminalType!(28/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(28/*Symbol*/))(parseStart, pt);
    }

    auto reduce107_Symbol/*Symbol = <MacroInstance*/(Location parseStart, ParseStackElem!(Location, NonterminalType!33) stack1)
    {
        NonterminalType!(28/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(28/*Symbol*/))(parseStart, pt);
    }

    auto reduce108_Name/*Name = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(29/*Name*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(108)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(29/*Name*/))(parseStart, pt);
    }

    auto reduce109_Token/*Token = StringLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(30/*Token*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(109)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(30/*Token*/))(parseStart, pt);
    }

    auto reduce110_Token/*Token = CharacterSetLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(30/*Token*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(110)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(30/*Token*/))(parseStart, pt);
    }

    auto reduce111_UnpackVariadicList/*UnpackVariadicList = Identifier "..."*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(31/*UnpackVariadicList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(111)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(31/*UnpackVariadicList*/))(parseStart, pt);
    }

    auto reduce112_SubToken/*SubToken = Symbol ">>" Symbol*/(Location parseStart, ParseStackElem!(Location, NonterminalType!28) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!28) stack1)
    {
        NonterminalType!(32/*SubToken*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(112)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(32/*SubToken*/))(parseStart, pt);
    }

    auto reduce113_SubToken/*SubToken = Symbol ">>" ParenExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!28) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!34) stack1)
    {
        NonterminalType!(32/*SubToken*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(113)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(32/*SubToken*/))(parseStart, pt);
    }

    auto reduce114/*ExpressionList? = <ExpressionList [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!35) stack1)
    {
        NonterminalType!(55/*ExpressionList?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(55/*ExpressionList?*/))(parseStart, pt);
    }

    auto reduce115/*ExpressionList? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(55/*ExpressionList?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(55/*ExpressionList?*/))(parseStart, pt);
    }

    auto reduce116_MacroInstance/*MacroInstance = Identifier "(" ExpressionList? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!55) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(33/*MacroInstance*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(116)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(33/*MacroInstance*/))(parseStart, pt);
    }

    auto reduce117_ParenExpression/*ParenExpression = "{" Expression "}"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!14) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(34/*ParenExpression*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(117)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(34/*ParenExpression*/))(parseStart, pt);
    }

    auto reduce118_ExpressionList/*ExpressionList @array = Expression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!14) stack1)
    {
        NonterminalType!(35/*ExpressionList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(118)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(35/*ExpressionList*/))(parseStart, pt);
    }

    auto reduce119_ExpressionList/*ExpressionList @array = ExpressionList "," Expression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!35) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14) stack1)
    {
        NonterminalType!(35/*ExpressionList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(119)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(35/*ExpressionList*/))(parseStart, pt);
    }

    auto reduce120_Tuple/*Tuple = "t(" ExpressionList? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!55) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(36/*Tuple*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(120)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(36/*Tuple*/))(parseStart, pt);
    }

    auto reduce121/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack2, ParseStackElem!(Location, NonterminalType!59) stack1)
    {
        NonterminalType!(57/*$regarray_1*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(121)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(57/*$regarray_1*/))(parseStart, pt);
    }

    auto reduce122/*$regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(58/*$regarrayedge_0_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(58/*$regarrayedge_0_1*/))(parseStart, pt);
    }

    auto reduce123/*$regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!13) stack1)
    {
        NonterminalType!(58/*$regarrayedge_0_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(58/*$regarrayedge_0_1*/))(parseStart, pt);
    }

    auto reduce124/*$regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(59/*$regarrayedge_1_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(59/*$regarrayedge_1_1*/))(parseStart, pt);
    }

    auto reduce125/*$regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!13) stack1)
    {
        NonterminalType!(59/*$regarrayedge_1_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(59/*$regarrayedge_1_1*/))(parseStart, pt);
    }

    auto reduce126/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!58) stack1)
    {
        NonterminalType!(57/*$regarray_1*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(126)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(57/*$regarray_1*/))(parseStart, pt);
    }

    auto reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(51/*@regArray_ExpressionAnnotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(127)(parseStart, end);
        }
        return ParseStackElem!(Location, NonterminalType!(51/*@regArray_ExpressionAnnotation**/))(parseStart, pt);
    }

    auto reduce128/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray =*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(48/*@regArray_ProductionAnnotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(128)(parseStart, end);
        }
        return ParseStackElem!(Location, NonterminalType!(48/*@regArray_ProductionAnnotation**/))(parseStart, pt);
    }

    auto reduce129/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(51/*@regArray_ExpressionAnnotation**/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(51/*@regArray_ExpressionAnnotation**/))(parseStart, pt);
    }

    auto reduce130/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(48/*@regArray_ProductionAnnotation**/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(48/*@regArray_ProductionAnnotation**/))(parseStart, pt);
    }

    auto reduce131/*@regArray_ProductionAnnotation+ @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(49/*@regArray_ProductionAnnotation+*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(49/*@regArray_ProductionAnnotation+*/))(parseStart, pt);
    }

    // path: EBNF
    // type: unknown
    //  EBNF              -> .EBNF {$end} startElement
    //  EBNF              -> .Declaration+ {$end}
    //  Declaration       -> .SymbolDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       -> .OptionDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       -> .Import {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       -> .MatchDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration -> .DeclarationType? Identifier MacroParametersPart? Annotation* ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration -> .DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  DeclarationType   -> ."fragment" {Identifier}
    //  DeclarationType   -> ."token" {Identifier}
    //  OptionDeclaration -> ."option" Identifier "=" IntegerLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Import            -> ."import" StringLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  MatchDeclaration  -> ."match" Symbol Symbol ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration+      -> .Declaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration+      -> .Declaration+ Declaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  DeclarationType?  -> . {Identifier}
    //  DeclarationType? ---> DeclarationType
    int parseEBNF/*0*/(ref NonterminalType!(0) result, ref Location resultLocation)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 1, 2, 3, 7, 8, 9, 37, 38]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"fragment"})
        {
            auto next = popToken();
            NonterminalType!(3) r;
            Location rl;
            gotoParent = parse124(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(3/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"token"})
        {
            auto next = popToken();
            NonterminalType!(3) r;
            Location rl;
            gotoParent = parse126(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(3/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"option"})
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse128(r, rl, currentStart/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(7/*OptionDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"import"})
        {
            auto next = popToken();
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse133(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(8/*Import*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"match"})
        {
            auto next = popToken();
            NonterminalType!(9) r;
            Location rl;
            gotoParent = parse136(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(9/*MatchDeclaration*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce8/*DeclarationType? = [virtual]*/();
            currentResult = ParseResultIn.create(38/*DeclarationType?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*EBNF*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*EBNF*/)(currentResultLocation, currentResult.get!(0/*EBNF*/)());
                NonterminalType!(0) r;
                Location rl;
                gotoParent = parse1(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                auto tree = r;
                result = tree;
                resultLocation = rl;
                return 0;
            }
            else if (currentResult.nonterminalID == 1/*Declaration*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!1/*Declaration*/)(currentResultLocation, currentResult.get!(1/*Declaration*/)());
                NonterminalType!(37) r;
                Location rl;
                gotoParent = parse2(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(37/*Declaration+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 2/*SymbolDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(2/*SymbolDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 3/*DeclarationType*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/)(currentResultLocation, currentResult.get!(3/*DeclarationType*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(2/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 7/*OptionDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(7/*OptionDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 8/*Import*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(8/*Import*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 9/*MatchDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(9/*MatchDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 37/*Declaration+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!37/*Declaration+*/)(currentResultLocation, currentResult.get!(37/*Declaration+*/)());
                CreatorInstance.NonterminalUnion!([0, 37]) r;
                Location rl;
                gotoParent = parse140(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 38/*DeclarationType?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/)(currentResultLocation, currentResult.get!(38/*DeclarationType?*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(2/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        auto tree = currentResult.get!(0);
        result = tree;
        resultLocation = currentResultLocation;
        return 0;
    }
    // path: EBNF EBNF
    // type: unknown
    //  EBNF ->  EBNF. {$end} startElement
    private int parse1(ref NonterminalType!(0) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!0/*EBNF*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            result = stack1.val;
            resultLocation = stack1.start;
            return 1;
        }
    }
    // path: EBNF Declaration
    // type: unknown
    //  Declaration+ ->  Declaration. {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse2(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!1/*Declaration*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce0/*Declaration+ @array = Declaration [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType?.Identifier MacroParametersPart? Annotation* ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration ->  DeclarationType?.Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse4(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(2) r;
            Location rl;
            gotoParent = parse5(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier
    // type: unknown
    //  SymbolDeclaration    ->  DeclarationType? Identifier.MacroParametersPart? Annotation* ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration    ->  DeclarationType? Identifier.MacroParametersPart? Annotation* "=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  MacroParametersPart  ->                             ."(" MacroParameters? ")" {";", "=", "@"}
    //  MacroParametersPart? ->                             . {";", "=", "@"}
    //  MacroParametersPart? ---> MacroParametersPart
    private int parse5(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2, 4, 39]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(4) r;
            Location rl;
            gotoParent = parse114(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(4/*MacroParametersPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce10/*MacroParametersPart? = [virtual]*/();
            currentResult = ParseResultIn.create(39/*MacroParametersPart?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 4/*MacroParametersPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/)(currentResultLocation, currentResult.get!(4/*MacroParametersPart*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse6(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*MacroParametersPart?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/)(currentResultLocation, currentResult.get!(39/*MacroParametersPart?*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse6(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(2/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart?.Annotation* ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart?.Annotation* "=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Annotation        ->                                                  ."@" Identifier AnnotationParams? {";", "=", "@"}
    //  Annotation+       ->                                                  .Annotation {";", "=", "@"}
    //  Annotation+       ->                                                  .Annotation+ Annotation {";", "=", "@"}
    //  Annotation*       ->                                                  . {";", "="}
    //  Annotation*       ->                                                  .Annotation+ {";", "="}
    private int parse6(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2, 10, 40, 41]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce13/*Annotation* @array = [virtual]*/();
            currentResult = ParseResultIn.create(41/*Annotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!10/*Annotation*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(40) r;
                Location rl;
                gotoParent = parse7(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(40/*Annotation+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 40/*Annotation+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!40/*Annotation+*/)(currentResultLocation, currentResult.get!(40/*Annotation+*/)());
                CreatorInstance.NonterminalUnion!([40, 41]) r;
                Location rl;
                gotoParent = parse38(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 41/*Annotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!41/*Annotation**/)(currentResultLocation, currentResult.get!(41/*Annotation**/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse40(r, rl, parseStart3, stack3, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(2/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation
    // type: unknown
    //  Annotation+ ->  Annotation. {";", "=", "@"}
    private int parse7(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!10/*Annotation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce11/*Annotation+ @array = Annotation [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@"
    // type: unknown
    //  Annotation ->  "@".Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse8(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse9(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier
    // type: unknown
    //  Annotation        ->  "@" Identifier.AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  AnnotationParams  ->                ."(" AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  AnnotationParams? ->                . {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  AnnotationParams? ---> AnnotationParams
    private int parse9(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 11, 43]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(11) r;
            Location rl;
            gotoParent = parse10(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(11/*AnnotationParams*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce30/*AnnotationParams? = [virtual]*/();
            currentResult = ParseResultIn.create(43/*AnnotationParams?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 11/*AnnotationParams*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!43/*AnnotationParams?*/)(currentResultLocation, currentResult.get!(11/*AnnotationParams*/)());
                NonterminalType!(10) r;
                Location rl;
                gotoParent = parse37(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 43/*AnnotationParams?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!43/*AnnotationParams?*/)(currentResultLocation, currentResult.get!(43/*AnnotationParams?*/)());
                NonterminalType!(10) r;
                Location rl;
                gotoParent = parse37(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(10/*Annotation*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "("
    // type: unknown
    //  AnnotationParams      ->  "(".AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  AnnotationParamsPart  ->     .Identifier {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .IntegerLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .";" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."=" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."(" AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."," {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .":" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."{" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."}" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."?" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."!" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .">" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."*" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .">>" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."<<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."-" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart+ AnnotationParamsPart {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart* ->     . {")"}
    //  AnnotationParamsPart* ->     .AnnotationParamsPart+ {")"}
    private int parse10(ref NonterminalType!(11) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([11, 12, 44, 45]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse11(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse12(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse13(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse14(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse15(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse16(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse17(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse18(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse20(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse21(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse22(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse23(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse24(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse25(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse26(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse27(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse29(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce34/*AnnotationParamsPart* @array = [virtual]*/();
            currentResult = ParseResultIn.create(45/*AnnotationParamsPart**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 12/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(12/*AnnotationParamsPart*/)());
                NonterminalType!(44) r;
                Location rl;
                gotoParent = parse19(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(44/*AnnotationParamsPart+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 44/*AnnotationParamsPart+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!44/*AnnotationParamsPart+*/)(currentResultLocation, currentResult.get!(44/*AnnotationParamsPart+*/)());
                CreatorInstance.NonterminalUnion!([44, 45]) r;
                Location rl;
                gotoParent = parse31(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 45/*AnnotationParamsPart**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/)(currentResultLocation, currentResult.get!(45/*AnnotationParamsPart**/)());
                NonterminalType!(11) r;
                Location rl;
                gotoParent = parse35(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(11/*AnnotationParams*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" Identifier
    // type: unknown
    //  AnnotationParamsPart ->  Identifier. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse11(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce38_AnnotationParamsPart/*AnnotationParamsPart = Identifier*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" StringLiteral
    // type: unknown
    //  AnnotationParamsPart ->  StringLiteral. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse12(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce37_AnnotationParamsPart/*AnnotationParamsPart = StringLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" CharacterSetLiteral
    // type: unknown
    //  AnnotationParamsPart ->  CharacterSetLiteral. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse13(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce39_AnnotationParamsPart/*AnnotationParamsPart = CharacterSetLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" IntegerLiteral
    // type: unknown
    //  AnnotationParamsPart ->  IntegerLiteral. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse14(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce40_AnnotationParamsPart/*AnnotationParamsPart = IntegerLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" ";"
    // type: unknown
    //  AnnotationParamsPart ->  ";". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse15(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce44_AnnotationParamsPart/*AnnotationParamsPart = ";"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "="
    // type: unknown
    //  AnnotationParamsPart ->  "=". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse16(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce42_AnnotationParamsPart/*AnnotationParamsPart = "="*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "("
    // type: unknown
    //  AnnotationParamsPart  ->  "(".AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .Identifier {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .IntegerLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .";" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."=" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."(" AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."," {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .":" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."{" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."}" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."?" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."!" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .">" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."*" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     .">>" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."<<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->     ."-" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart+ AnnotationParamsPart {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart* ->     . {")"}
    //  AnnotationParamsPart* ->     .AnnotationParamsPart+ {")"}
    private int parse17(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([12, 44, 45]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse11(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse12(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse13(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse14(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse15(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse16(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse17(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse18(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse20(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse21(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse22(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse23(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse24(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse25(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse26(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse27(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse29(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce34/*AnnotationParamsPart* @array = [virtual]*/();
            currentResult = ParseResultIn.create(45/*AnnotationParamsPart**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 12/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(12/*AnnotationParamsPart*/)());
                NonterminalType!(44) r;
                Location rl;
                gotoParent = parse19(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(44/*AnnotationParamsPart+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 44/*AnnotationParamsPart+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!44/*AnnotationParamsPart+*/)(currentResultLocation, currentResult.get!(44/*AnnotationParamsPart+*/)());
                CreatorInstance.NonterminalUnion!([44, 45]) r;
                Location rl;
                gotoParent = parse31(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 45/*AnnotationParamsPart**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/)(currentResultLocation, currentResult.get!(45/*AnnotationParamsPart**/)());
                NonterminalType!(12) r;
                Location rl;
                gotoParent = parse33(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(12/*AnnotationParamsPart*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" ","
    // type: unknown
    //  AnnotationParamsPart ->  ",". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse18(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce45_AnnotationParamsPart/*AnnotationParamsPart = ","*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" AnnotationParamsPart
    // type: unknown
    //  AnnotationParamsPart+ ->  AnnotationParamsPart. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse19(ref NonterminalType!(44) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce32/*AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" ":"
    // type: unknown
    //  AnnotationParamsPart ->  ":". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse20(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce43_AnnotationParamsPart/*AnnotationParamsPart = ":"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "{"
    // type: unknown
    //  AnnotationParamsPart ->  "{". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse21(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce46_AnnotationParamsPart/*AnnotationParamsPart = "{"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "}"
    // type: unknown
    //  AnnotationParamsPart ->  "}". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse22(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce47_AnnotationParamsPart/*AnnotationParamsPart = "}"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "?"
    // type: unknown
    //  AnnotationParamsPart ->  "?". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse23(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce48_AnnotationParamsPart/*AnnotationParamsPart = "?"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "!"
    // type: unknown
    //  AnnotationParamsPart ->  "!". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse24(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce49_AnnotationParamsPart/*AnnotationParamsPart = "!"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "<"
    // type: unknown
    //  AnnotationParamsPart ->  "<". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse25(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce50_AnnotationParamsPart/*AnnotationParamsPart = "<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" ">"
    // type: unknown
    //  AnnotationParamsPart ->  ">". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse26(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce51_AnnotationParamsPart/*AnnotationParamsPart = ">"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "*"
    // type: unknown
    //  AnnotationParamsPart ->  "*". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse27(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce52_AnnotationParamsPart/*AnnotationParamsPart = "*"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" ">>"
    // type: unknown
    //  AnnotationParamsPart ->  ">>". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse28(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce53_AnnotationParamsPart/*AnnotationParamsPart = ">>"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "<<"
    // type: unknown
    //  AnnotationParamsPart ->  "<<". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse29(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce54_AnnotationParamsPart/*AnnotationParamsPart = "<<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" "-"
    // type: unknown
    //  AnnotationParamsPart ->  "-". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse30(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce55_AnnotationParamsPart/*AnnotationParamsPart = "-"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" AnnotationParamsPart+
    // type: unknown
    //  AnnotationParamsPart+ ->  AnnotationParamsPart+.AnnotationParamsPart {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart* ->  AnnotationParamsPart+. {")"}
    //  AnnotationParamsPart  ->                       .Identifier {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .IntegerLiteral {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .";" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."=" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."(" AnnotationParamsPart* ")" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."," {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .":" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."{" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."}" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."?" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."!" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .">" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."*" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       .">>" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."<<" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    //  AnnotationParamsPart  ->                       ."-" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse31(ref CreatorInstance.NonterminalUnion!([44, 45]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!44/*AnnotationParamsPart+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([12, 44, 45]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse11(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse12(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse13(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse14(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse15(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse16(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse17(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse18(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse20(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse21(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse22(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse23(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse24(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse25(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse26(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse27(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse29(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(12/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce35/*AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(45/*AnnotationParamsPart**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 12/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(12/*AnnotationParamsPart*/)());
                NonterminalType!(44) r;
                Location rl;
                gotoParent = parse32(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(44/*AnnotationParamsPart+*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" AnnotationParamsPart+ AnnotationParamsPart
    // type: unknown
    //  AnnotationParamsPart+ ->  AnnotationParamsPart+ AnnotationParamsPart. {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse32(ref NonterminalType!(44) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!44/*AnnotationParamsPart+*/) stack2, ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce33/*AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" AnnotationParamsPart*
    // type: unknown
    //  AnnotationParamsPart ->  "(" AnnotationParamsPart*.")" {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse33(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([12]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(12) r;
            Location rl;
            gotoParent = parse34(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" "(" AnnotationParamsPart* ")"
    // type: unknown
    //  AnnotationParamsPart ->  "(" AnnotationParamsPart* ")". {Identifier, StringLiteral, CharacterSetLiteral, IntegerLiteral, ";", "=", "(", ")", ",", ":", "{", "}", "?", "!", "<", ">", "*", ">>", "<<", "-"}
    private int parse34(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce41_AnnotationParamsPart/*AnnotationParamsPart = "(" AnnotationParamsPart* ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" AnnotationParamsPart*
    // type: unknown
    //  AnnotationParams ->  "(" AnnotationParamsPart*.")" {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse35(ref NonterminalType!(11) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([11]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(11) r;
            Location rl;
            gotoParent = parse36(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier "(" AnnotationParamsPart* ")"
    // type: unknown
    //  AnnotationParams ->  "(" AnnotationParamsPart* ")". {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse36(ref NonterminalType!(11) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!45/*AnnotationParamsPart**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce36_AnnotationParams/*AnnotationParams = "(" AnnotationParamsPart* ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart "@" Identifier AnnotationParams
    // type: unknown
    //  Annotation ->  "@" Identifier AnnotationParams?. {Identifier, StringLiteral, CharacterSetLiteral, ";", "=", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse37(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!43/*AnnotationParams?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce31_Annotation/*Annotation = "@" Identifier AnnotationParams?*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation+
    // type: unknown
    //  Annotation+ ->  Annotation+.Annotation {";", "=", "@"}
    //  Annotation* ->  Annotation+. {";", "="}
    //  Annotation  ->             ."@" Identifier AnnotationParams? {";", "=", "@"}
    private int parse38(ref CreatorInstance.NonterminalUnion!([40, 41]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!40/*Annotation+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 40, 41]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce14/*Annotation* @array = Annotation+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(41/*Annotation**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!10/*Annotation*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(40) r;
                Location rl;
                gotoParent = parse39(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(40/*Annotation+*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation+ Annotation
    // type: unknown
    //  Annotation+ ->  Annotation+ Annotation. {";", "=", "@"}
    private int parse39(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!40/*Annotation+*/) stack2, ParseStackElem!(Location, NonterminalType!10/*Annotation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce12/*Annotation+ @array = Annotation+ Annotation [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation*
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation*.";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation*."=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse40(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack2, ParseStackElem!(Location, NonterminalType!41/*Annotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(2) r;
            Location rl;
            gotoParent = parse41(r, rl, parseStart4, stack4, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(2) r;
            Location rl;
            gotoParent = parse42(r, rl, parseStart4, stack4, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* ";"
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* ";". {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse41(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart5, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack3, ParseStackElem!(Location, NonterminalType!41/*Annotation**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce15_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"*/(parseStart5, stack5, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 4;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "="
    // type: unknown
    //  SymbolDeclaration               ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=".Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Annotation                      ->                                                                  ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                                                                  ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                                                                  ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "|", "^", "t("}
    //  Expression                      ->                                                                  .Alternation {";"}
    //  Alternation                     ->                                                                  .Alternation "|" Concatenation {";", "|"}
    //  Alternation                     ->                                                                  .Concatenation {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus @regArray_ProductionAnnotation+ {";", "|"}
    //  Concatenation                   ->                                                                  .@regArray_ProductionAnnotation+ {";", "|"}
    //  TokenMinus                      ->                                                                  .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->                                                                  .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->                                                                  .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->                                                                  . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->                                                                  .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->                                                                  .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", "@", "{", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse42(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart5, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack3, ParseStackElem!(Location, NonterminalType!41/*Annotation**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2, 10, 13, 14, 15, 16, 18, 19, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Expression*/)(currentResultLocation, currentResult.get!(14/*Expression*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse44(r, rl, parseStart5, stack5, stack4, stack3, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 15/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Alternation*/)(currentResultLocation, currentResult.get!(15/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([14, 15]) r;
                Location rl;
                gotoParent = parse46(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(15/*Alternation*/, currentResult.get!(16/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(2/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Annotation
    // type: unknown
    //  $regarray_1 ->  $regarrayedge_0_1. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse43(ref NonterminalType!(57) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce126/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Expression
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression.";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse44(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart6, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack6, ParseStackElem!(Location, Token) stack5, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack4, ParseStackElem!(Location, NonterminalType!41/*Annotation**/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([2]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(2) r;
            Location rl;
            gotoParent = parse45(r, rl, parseStart6, stack6, stack5, stack4, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Expression ";"
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";". {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse45(ref NonterminalType!(2) result, ref Location resultLocation, Location parseStart7, ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/) stack7, ParseStackElem!(Location, Token) stack6, ParseStackElem!(Location, NonterminalType!39/*MacroParametersPart?*/) stack5, ParseStackElem!(Location, NonterminalType!41/*Annotation**/) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce16_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"*/(parseStart7, stack7, stack6, stack5, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 6;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation
    // type: unknown
    //  Expression  ->  Alternation. {";", ")", ",", "}"}
    //  Alternation ->  Alternation."|" Concatenation {";", ")", ",", "}", "|"}
    private int parse46(ref CreatorInstance.NonterminalUnion!([14, 15]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!15/*Alternation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([14, 15]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto next = popToken();
            NonterminalType!(15) r;
            Location rl;
            gotoParent = parse47(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(15/*Alternation*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce58_Expression/*Expression = <Alternation*/(parseStart1, stack1);
            result = ThisParseResult.create(14/*Expression*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|"
    // type: unknown
    //  Alternation                     ->  Alternation "|".Concatenation {";", ")", ",", "}", "|"}
    //  Annotation                      ->                 ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                 ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                 ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Concatenation                   ->                 .TokenMinus {";", ")", ",", "}", "|"}
    //  Concatenation                   ->                 .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {";", ")", ",", "}", "|"}
    //  Concatenation                   ->                 .TokenMinus @regArray_ProductionAnnotation+ {";", ")", ",", "}", "|"}
    //  Concatenation                   ->                 .@regArray_ProductionAnnotation+ {";", ")", ",", "}", "|"}
    //  TokenMinus                      ->                 .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->                 .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->                 .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->                 . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->                 .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->                 .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse47(ref NonterminalType!(15) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!15/*Alternation*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 15, 16, 18, 19, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!16/*Concatenation*/)(currentResultLocation, currentResult.get!(16/*Concatenation*/)());
                NonterminalType!(15) r;
                Location rl;
                gotoParent = parse48(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(15/*Alternation*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" Concatenation
    // type: unknown
    //  Alternation ->  Alternation "|" Concatenation. {";", ")", ",", "}", "|"}
    private int parse48(ref NonterminalType!(15) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!15/*Alternation*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!16/*Concatenation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce60_Alternation/*Alternation = Alternation "|" Concatenation*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus
    // type: unknown
    //  Concatenation                   ->  TokenMinus. {";", ")", ",", "}", "|"}
    //  Concatenation                   ->  TokenMinus.TokenMinus+ @regArray_ProductionAnnotation* {";", ")", ",", "}", "|"}
    //  Concatenation                   ->  TokenMinus.@regArray_ProductionAnnotation+ {";", ")", ",", "}", "|"}
    //  TokenMinus                      ->  TokenMinus."-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  Annotation                      ->            ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->            ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->            ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  TokenMinus                      ->            .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->            .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->            .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus+                     ->            .TokenMinus {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  TokenMinus+                     ->            .TokenMinus+ TokenMinus {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->            . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->            .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->            .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse49(ref CreatorInstance.NonterminalUnion!([16, 18]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 16, 18, 19, 46, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{"}"} || lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto tmp = reduce61_Concatenation/*Concatenation = <TokenMinus*/(parseStart1, stack1);
            result = ThisParseResult.create(16/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(18) r;
            Location rl;
            gotoParent = parse51(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(18/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([18, 46]) r;
                Location rl;
                gotoParent = parse50(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 46/*TokenMinus+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!46/*TokenMinus+*/)(currentResultLocation, currentResult.get!(46/*TokenMinus+*/)());
                CreatorInstance.NonterminalUnion!([16, 46]) r;
                Location rl;
                gotoParent = parse109(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse113(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus
    // type: unknown
    //  TokenMinus  ->  TokenMinus."-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus+ ->  TokenMinus. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse50(ref CreatorInstance.NonterminalUnion!([18, 46]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([18, 46]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(18) r;
            Location rl;
            gotoParent = parse51(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(18/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce62/*TokenMinus+ @array = TokenMinus [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(46/*TokenMinus+*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-"
    // type: unknown
    //  TokenMinus                      ->  TokenMinus "-".AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  Annotation                      ->                ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  NegativeLookahead               ->                ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  NegativeLookahead               ->                ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  AnnotatedExpression             ->                .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->                . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->                .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  $regarray_1                     ->                .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse51(ref NonterminalType!(18) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 18, 19, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!19/*AnnotatedExpression*/)(currentResultLocation, currentResult.get!(19/*AnnotatedExpression*/)());
                NonterminalType!(18) r;
                Location rl;
                gotoParent = parse52(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([19, 57]) r;
                Location rl;
                gotoParent = parse108(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(18/*TokenMinus*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" AnnotatedExpression
    // type: unknown
    //  TokenMinus ->  TokenMinus "-" AnnotatedExpression. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    private int parse52(ref NonterminalType!(18) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!19/*AnnotatedExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce76_TokenMinus/*TokenMinus = TokenMinus "-" AnnotatedExpression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!"
    // type: unknown
    //  NegativeLookahead ->  "!".Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead ->  "!"."anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Symbol            ->     .Name {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Symbol            ->     .Token {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Symbol            ->     .MacroInstance {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Name              ->     .Identifier {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Token             ->     .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Token             ->     .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  MacroInstance     ->     .Identifier "(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse53(ref NonterminalType!(13) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([13, 28, 29, 30, 33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([29, 33]) r;
            Location rl;
            gotoParent = parse54(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse75(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse76(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"anytoken"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse107(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 28/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*Symbol*/)(currentResultLocation, currentResult.get!(28/*Symbol*/)());
                NonterminalType!(13) r;
                Location rl;
                gotoParent = parse106(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 29/*Name*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(29/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 30/*Token*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(30/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 33/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(33/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(13/*NegativeLookahead*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier
    // type: unknown
    //  Name          ->  Identifier. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  MacroInstance ->  Identifier."(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse54(ref CreatorInstance.NonterminalUnion!([29, 33]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([29, 33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(33) r;
            Location rl;
            gotoParent = parse55(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(33/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce108_Name/*Name = Identifier*/(parseStart1, stack1);
            result = ThisParseResult.create(29/*Name*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "("
    // type: unknown
    //  MacroInstance                   ->  Identifier "(".ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Annotation                      ->                ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  Expression                      ->                .Alternation {")", ","}
    //  Alternation                     ->                .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->                .Concatenation {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  TokenMinus                      ->                .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->                .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->                .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  ExpressionList                  ->                .Expression {")", ","}
    //  ExpressionList                  ->                .ExpressionList "," Expression {")", ","}
    //  @regArray_ExpressionAnnotation* ->                . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionList?                 ->                . {")"}
    //  $regarray_1                     ->                .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->                .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  ExpressionList? ---> ExpressionList
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse55(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 14, 15, 16, 18, 19, 33, 35, 51, 55, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto tmp = reduce115/*ExpressionList? = [virtual]*/();
            currentResult = ParseResultIn.create(55/*ExpressionList?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Expression*/)(currentResultLocation, currentResult.get!(14/*Expression*/)());
                NonterminalType!(35) r;
                Location rl;
                gotoParent = parse56(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(35/*ExpressionList*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 15/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Alternation*/)(currentResultLocation, currentResult.get!(15/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([14, 15]) r;
                Location rl;
                gotoParent = parse46(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(15/*Alternation*/, currentResult.get!(16/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 35/*ExpressionList*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(35/*ExpressionList*/)());
                CreatorInstance.NonterminalUnion!([33, 35]) r;
                Location rl;
                gotoParent = parse59(r, rl, parseStart2, stack2, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 55/*ExpressionList?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/)(currentResultLocation, currentResult.get!(55/*ExpressionList?*/)());
                NonterminalType!(33) r;
                Location rl;
                gotoParent = parse105(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(33/*MacroInstance*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" Expression
    // type: unknown
    //  ExpressionList ->  Expression. {")", ","}
    private int parse56(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce118_ExpressionList/*ExpressionList @array = Expression*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList
    // type: unknown
    //  MacroInstance  ->  Identifier "(" ExpressionList?.")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  ExpressionList ->                  ExpressionList."," Expression {")", ","}
    private int parse59(ref CreatorInstance.NonterminalUnion!([33, 35]) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([33, 35]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(33) r;
            Location rl;
            gotoParent = parse60(r, rl, parseStart3, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(33/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(35) r;
            Location rl;
            gotoParent = parse61(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(35/*ExpressionList*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList ")"
    // type: unknown
    //  MacroInstance ->  Identifier "(" ExpressionList? ")". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    private int parse60(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce116_MacroInstance/*MacroInstance = Identifier "(" ExpressionList? ")"*/(parseStart4, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList ","
    // type: unknown
    //  ExpressionList                  ->  ExpressionList ",".Expression {")", ","}
    //  Annotation                      ->                    ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                    ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                    ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  Expression                      ->                    .Alternation {")", ","}
    //  Alternation                     ->                    .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->                    .Concatenation {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                    .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  TokenMinus                      ->                    .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->                    .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->                    .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->                    . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->                    .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->                    .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse61(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!35/*ExpressionList*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 14, 15, 16, 18, 19, 35, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Expression*/)(currentResultLocation, currentResult.get!(14/*Expression*/)());
                NonterminalType!(35) r;
                Location rl;
                gotoParent = parse62(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 15/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Alternation*/)(currentResultLocation, currentResult.get!(15/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([14, 15]) r;
                Location rl;
                gotoParent = parse46(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(15/*Alternation*/, currentResult.get!(16/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(35/*ExpressionList*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," Expression
    // type: unknown
    //  ExpressionList ->  ExpressionList "," Expression. {")", ","}
    private int parse62(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!35/*ExpressionList*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce119_ExpressionList/*ExpressionList @array = ExpressionList "," Expression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation*
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  ExpressionName      ->                                 .Identifier ":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName?     ->                                 . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName? ---> ExpressionName
    private int parse63(ref NonterminalType!(19) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([19, 21, 52]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(21) r;
                Location rl;
                gotoParent = parse64(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(21/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("}))
            {
                auto tmp = reduce82/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
                currentResultLocation = tmp.start;
                gotoParent = 0;
            }
            else
            {
                lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                    tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                return -1;
            }
        }
        else
        {
            auto tmp = reduce82/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 21/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(21/*ExpressionName*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 52/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(52/*ExpressionName?*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(19/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* Identifier
    // type: unknown
    //  ExpressionName ->  Identifier.":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse64(ref NonterminalType!(21) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([21]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(21) r;
            Location rl;
            gotoParent = parse65(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* Identifier ":"
    // type: unknown
    //  ExpressionName ->  Identifier ":". {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse65(ref NonterminalType!(21) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce90_ExpressionName/*ExpressionName = Identifier ":"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName?.ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  ExpressionPrefix    ->                                                 ."<" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix    ->                                                 ."^" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix+   ->                                                 .ExpressionPrefix {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix+   ->                                                 .ExpressionPrefix+ ExpressionPrefix {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix*   ->                                                 . {Identifier, StringLiteral, CharacterSetLiteral, "{", "t("}
    //  ExpressionPrefix*   ->                                                 .ExpressionPrefix+ {Identifier, StringLiteral, CharacterSetLiteral, "{", "t("}
    private int parse66(ref NonterminalType!(19) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/) stack2, ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([19, 22, 53, 54]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(22) r;
            Location rl;
            gotoParent = parse68(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(22/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"^"})
        {
            auto next = popToken();
            NonterminalType!(22) r;
            Location rl;
            gotoParent = parse69(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(22/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce85/*ExpressionPrefix* @array = [virtual]*/();
            currentResult = ParseResultIn.create(54/*ExpressionPrefix**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 22/*ExpressionPrefix*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!22/*ExpressionPrefix*/)(currentResultLocation, currentResult.get!(22/*ExpressionPrefix*/)());
                NonterminalType!(53) r;
                Location rl;
                gotoParent = parse67(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(53/*ExpressionPrefix+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 53/*ExpressionPrefix+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!53/*ExpressionPrefix+*/)(currentResultLocation, currentResult.get!(53/*ExpressionPrefix+*/)());
                CreatorInstance.NonterminalUnion!([53, 54]) r;
                Location rl;
                gotoParent = parse70(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 54/*ExpressionPrefix**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!54/*ExpressionPrefix**/)(currentResultLocation, currentResult.get!(54/*ExpressionPrefix**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(19/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix
    // type: unknown
    //  ExpressionPrefix+ ->  ExpressionPrefix. {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse67(ref NonterminalType!(53) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!22/*ExpressionPrefix*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce83/*ExpressionPrefix+ @array = ExpressionPrefix [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName "<"
    // type: unknown
    //  ExpressionPrefix ->  "<". {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse68(ref NonterminalType!(22) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce91_ExpressionPrefix/*ExpressionPrefix = "<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName "^"
    // type: unknown
    //  ExpressionPrefix ->  "^". {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse69(ref NonterminalType!(22) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce92_ExpressionPrefix/*ExpressionPrefix = "^"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix+
    // type: unknown
    //  ExpressionPrefix+ ->  ExpressionPrefix+.ExpressionPrefix {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix* ->  ExpressionPrefix+. {Identifier, StringLiteral, CharacterSetLiteral, "{", "t("}
    //  ExpressionPrefix  ->                   ."<" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionPrefix  ->                   ."^" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse70(ref CreatorInstance.NonterminalUnion!([53, 54]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!53/*ExpressionPrefix+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([22, 53, 54]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(22) r;
            Location rl;
            gotoParent = parse68(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(22/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"^"})
        {
            auto next = popToken();
            NonterminalType!(22) r;
            Location rl;
            gotoParent = parse69(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(22/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce86/*ExpressionPrefix* @array = ExpressionPrefix+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(54/*ExpressionPrefix**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 22/*ExpressionPrefix*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!22/*ExpressionPrefix*/)(currentResultLocation, currentResult.get!(22/*ExpressionPrefix*/)());
                NonterminalType!(53) r;
                Location rl;
                gotoParent = parse71(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(53/*ExpressionPrefix+*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix+ ExpressionPrefix
    // type: unknown
    //  ExpressionPrefix+ ->  ExpressionPrefix+ ExpressionPrefix. {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    private int parse71(ref NonterminalType!(53) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!53/*ExpressionPrefix+*/) stack2, ParseStackElem!(Location, NonterminalType!22/*ExpressionPrefix*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce84/*ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix*
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix*.PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  PostfixExpression   ->                                                                   .Optional {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  PostfixExpression   ->                                                                   .Repetition {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  PostfixExpression   ->                                                                   .RepetitionPlus {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  PostfixExpression   ->                                                                   .AtomExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Optional            ->                                                                   .PostfixExpression "?" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Repetition          ->                                                                   .PostfixExpression "*" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  RepetitionPlus      ->                                                                   .PostfixExpression "+" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  AtomExpression      ->                                                                   .Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  AtomExpression      ->                                                                   .UnpackVariadicList {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  AtomExpression      ->                                                                   .SubToken {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  AtomExpression      ->                                                                   .ParenExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  AtomExpression      ->                                                                   .Tuple {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Symbol              ->                                                                   .Name {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Symbol              ->                                                                   .Token {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Symbol              ->                                                                   .MacroInstance {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Name                ->                                                                   .Identifier {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Token               ->                                                                   .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  Token               ->                                                                   .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  UnpackVariadicList  ->                                                                   .Identifier "..." {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  SubToken            ->                                                                   .Symbol ">>" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  SubToken            ->                                                                   .Symbol ">>" ParenExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  MacroInstance       ->                                                                   .Identifier "(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  ParenExpression     ->                                                                   ."{" Expression "}" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Tuple               ->                                                                   ."t(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse72(ref NonterminalType!(19) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/) stack3, ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/) stack2, ParseStackElem!(Location, NonterminalType!54/*ExpressionPrefix**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([19, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([29, 31, 33]) r;
            Location rl;
            gotoParent = parse73(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse75(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse76(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(34) r;
            Location rl;
            gotoParent = parse77(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(34/*ParenExpression*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto next = popToken();
            NonterminalType!(36) r;
            Location rl;
            gotoParent = parse99(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(36/*Tuple*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 23/*PostfixExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!23/*PostfixExpression*/)(currentResultLocation, currentResult.get!(23/*PostfixExpression*/)());
                CreatorInstance.NonterminalUnion!([19, 24, 25, 26]) r;
                Location rl;
                gotoParent = parse82(r, rl, parseStart3, stack3, stack2, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 24/*Optional*/)
            {
                currentResult = ParseResultIn.create(23/*PostfixExpression*/, currentResult.get!(24/*Optional*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 25/*Repetition*/)
            {
                currentResult = ParseResultIn.create(23/*PostfixExpression*/, currentResult.get!(25/*Repetition*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 26/*RepetitionPlus*/)
            {
                currentResult = ParseResultIn.create(23/*PostfixExpression*/, currentResult.get!(26/*RepetitionPlus*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 27/*AtomExpression*/)
            {
                currentResult = ParseResultIn.create(23/*PostfixExpression*/, currentResult.get!(27/*AtomExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 28/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*Symbol*/)(currentResultLocation, currentResult.get!(28/*Symbol*/)());
                CreatorInstance.NonterminalUnion!([27, 32]) r;
                Location rl;
                gotoParent = parse90(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 29/*Name*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(29/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 30/*Token*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(30/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 31/*UnpackVariadicList*/)
            {
                currentResult = ParseResultIn.create(27/*AtomExpression*/, currentResult.get!(31/*UnpackVariadicList*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 32/*SubToken*/)
            {
                currentResult = ParseResultIn.create(27/*AtomExpression*/, currentResult.get!(32/*SubToken*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 33/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(33/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 34/*ParenExpression*/)
            {
                currentResult = ParseResultIn.create(27/*AtomExpression*/, currentResult.get!(34/*ParenExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 36/*Tuple*/)
            {
                currentResult = ParseResultIn.create(27/*AtomExpression*/, currentResult.get!(36/*Tuple*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(19/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Identifier
    // type: unknown
    //  Name               ->  Identifier. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    //  UnpackVariadicList ->  Identifier."..." {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  MacroInstance      ->  Identifier."(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    private int parse73(ref CreatorInstance.NonterminalUnion!([29, 31, 33]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([29, 31, 33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(33) r;
            Location rl;
            gotoParent = parse55(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(33/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"..."})
        {
            auto next = popToken();
            NonterminalType!(31) r;
            Location rl;
            gotoParent = parse74(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(31/*UnpackVariadicList*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce108_Name/*Name = Identifier*/(parseStart1, stack1);
            result = ThisParseResult.create(29/*Name*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Identifier "..."
    // type: unknown
    //  UnpackVariadicList ->  Identifier "...". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse74(ref NonterminalType!(31) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce111_UnpackVariadicList/*UnpackVariadicList = Identifier "..."*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* StringLiteral
    // type: unknown
    //  Token ->  StringLiteral. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    private int parse75(ref NonterminalType!(30) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce109_Token/*Token = StringLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* CharacterSetLiteral
    // type: unknown
    //  Token ->  CharacterSetLiteral. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    private int parse76(ref NonterminalType!(30) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce110_Token/*Token = CharacterSetLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{"
    // type: unknown
    //  ParenExpression                 ->  "{".Expression "}" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Annotation                      ->     ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->     ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->     ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Expression                      ->     .Alternation {"}"}
    //  Alternation                     ->     .Alternation "|" Concatenation {"}", "|"}
    //  Alternation                     ->     .Concatenation {"}", "|"}
    //  Concatenation                   ->     .TokenMinus {"}", "|"}
    //  Concatenation                   ->     .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {"}", "|"}
    //  Concatenation                   ->     .TokenMinus @regArray_ProductionAnnotation+ {"}", "|"}
    //  Concatenation                   ->     .@regArray_ProductionAnnotation+ {"}", "|"}
    //  TokenMinus                      ->     .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->     .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->     .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ExpressionAnnotation* ->     . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->     .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->     .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "}", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse77(ref NonterminalType!(34) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 14, 15, 16, 18, 19, 34, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Expression*/)(currentResultLocation, currentResult.get!(14/*Expression*/)());
                NonterminalType!(34) r;
                Location rl;
                gotoParent = parse78(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 15/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Alternation*/)(currentResultLocation, currentResult.get!(15/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([14, 15]) r;
                Location rl;
                gotoParent = parse46(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(15/*Alternation*/, currentResult.get!(16/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(34/*ParenExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" Expression
    // type: unknown
    //  ParenExpression ->  "{" Expression."}" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse78(ref NonterminalType!(34) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([34]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(34) r;
            Location rl;
            gotoParent = parse79(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" Expression "}"
    // type: unknown
    //  ParenExpression ->  "{" Expression "}". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse79(ref NonterminalType!(34) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!14/*Expression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce117_ParenExpression/*ParenExpression = "{" Expression "}"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" $regarray_1
    // type: unknown
    //  Concatenation       ->  @regArray_ProductionAnnotation+. {";", ")", ",", "}", "|"}
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  $regarray_1         ->                      $regarray_1.$regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Annotation          ->                                 ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                 ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                 ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  ExpressionName      ->                                 .Identifier ":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName?     ->                                 . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse80(ref CreatorInstance.NonterminalUnion!([16, 19, 57]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 16, 19, 21, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(21) r;
                Location rl;
                gotoParent = parse64(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(21/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("}))
            {
                auto tmp = reduce82/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
                currentResultLocation = tmp.start;
                gotoParent = 0;
            }
            else
            {
                lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                    tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                return -1;
            }
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce82/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{"}"} || lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto tmp = reduce72_Concatenation/*Concatenation = @regArray @regArray_ProductionAnnotation+*/(parseStart1, stack1);
            result = ThisParseResult.create(16/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 21/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(21/*ExpressionName*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 52/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(52/*ExpressionName?*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" $regarray_1 Annotation
    // type: unknown
    //  $regarray_1 ->  $regarray_1 $regarrayedge_1_1. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse81(ref NonterminalType!(57) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!57/*$regarray_1*/) stack2, ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce121/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  Optional            ->                                                                    PostfixExpression."?" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Repetition          ->                                                                    PostfixExpression."*" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  RepetitionPlus      ->                                                                    PostfixExpression."+" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse82(ref CreatorInstance.NonterminalUnion!([19, 24, 25, 26]) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/) stack4, ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/) stack3, ParseStackElem!(Location, NonterminalType!54/*ExpressionPrefix**/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!23/*PostfixExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([19, 24, 25, 26]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(24) r;
            Location rl;
            gotoParent = parse83(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(24/*Optional*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(25) r;
            Location rl;
            gotoParent = parse84(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(25/*Repetition*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"+"})
        {
            auto next = popToken();
            NonterminalType!(26) r;
            Location rl;
            gotoParent = parse85(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(26/*RepetitionPlus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce87_AnnotatedExpression/*AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression*/(parseStart4, stack4, stack3, stack2, stack1);
            result = ThisParseResult.create(19/*AnnotatedExpression*/, tmp.val);
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "?"
    // type: unknown
    //  Optional ->  PostfixExpression "?". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse83(ref NonterminalType!(24) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!23/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce97_Optional/*Optional = PostfixExpression "?"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "*"
    // type: unknown
    //  Repetition ->  PostfixExpression "*". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse84(ref NonterminalType!(25) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!23/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce98_Repetition/*Repetition = PostfixExpression "*"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "+"
    // type: unknown
    //  RepetitionPlus ->  PostfixExpression "+". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse85(ref NonterminalType!(26) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!23/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce99_RepetitionPlus/*RepetitionPlus = PostfixExpression "+"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol
    // type: unknown
    //  AtomExpression ->  Symbol. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  SubToken       ->  Symbol.">>" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  SubToken       ->  Symbol.">>" ParenExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse90(ref CreatorInstance.NonterminalUnion!([27, 32]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([27, 32]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(32) r;
            Location rl;
            gotoParent = parse91(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(32/*SubToken*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce100_AtomExpression/*AtomExpression = <Symbol*/(parseStart1, stack1);
            result = ThisParseResult.create(27/*AtomExpression*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>"
    // type: unknown
    //  SubToken        ->  Symbol ">>".Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  SubToken        ->  Symbol ">>".ParenExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Symbol          ->             .Name {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Symbol          ->             .Token {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Symbol          ->             .MacroInstance {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Name            ->             .Identifier {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Token           ->             .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Token           ->             .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  MacroInstance   ->             .Identifier "(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  ParenExpression ->             ."{" Expression "}" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse91(ref NonterminalType!(32) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([28, 29, 30, 32, 33, 34]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([29, 33]) r;
            Location rl;
            gotoParent = parse54(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse75(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse76(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(34) r;
            Location rl;
            gotoParent = parse77(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(34/*ParenExpression*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 28/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*Symbol*/)(currentResultLocation, currentResult.get!(28/*Symbol*/)());
                NonterminalType!(32) r;
                Location rl;
                gotoParent = parse92(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 29/*Name*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(29/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 30/*Token*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(30/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 33/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(33/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 34/*ParenExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!34/*ParenExpression*/)(currentResultLocation, currentResult.get!(34/*ParenExpression*/)());
                NonterminalType!(32) r;
                Location rl;
                gotoParent = parse96(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(32/*SubToken*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>" Symbol
    // type: unknown
    //  SubToken ->  Symbol ">>" Symbol. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse92(ref NonterminalType!(32) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce112_SubToken/*SubToken = Symbol ">>" Symbol*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>" ParenExpression
    // type: unknown
    //  SubToken ->  Symbol ">>" ParenExpression. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse96(ref NonterminalType!(32) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!34/*ParenExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce113_SubToken/*SubToken = Symbol ">>" ParenExpression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t("
    // type: unknown
    //  Tuple                           ->  "t(".ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  Annotation                      ->      ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->      ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->      ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  Expression                      ->      .Alternation {")", ","}
    //  Alternation                     ->      .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->      .Concatenation {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->      .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  TokenMinus                      ->      .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->      .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->      .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "-", "|", "^", "t("}
    //  ExpressionList                  ->      .Expression {")", ","}
    //  ExpressionList                  ->      .ExpressionList "," Expression {")", ","}
    //  @regArray_ExpressionAnnotation* ->      . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionList?                 ->      . {")"}
    //  $regarray_1                     ->      .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->      .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ")", ",", "@", "{", "!", "<", "|", "^", "t("}
    //  ExpressionList? ---> ExpressionList
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse99(ref NonterminalType!(36) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 14, 15, 16, 18, 19, 35, 36, 51, 55, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto tmp = reduce115/*ExpressionList? = [virtual]*/();
            currentResult = ParseResultIn.create(55/*ExpressionList?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Expression*/)(currentResultLocation, currentResult.get!(14/*Expression*/)());
                NonterminalType!(35) r;
                Location rl;
                gotoParent = parse56(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(35/*ExpressionList*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 15/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Alternation*/)(currentResultLocation, currentResult.get!(15/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([14, 15]) r;
                Location rl;
                gotoParent = parse46(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(15/*Alternation*/, currentResult.get!(16/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([16, 18]) r;
                Location rl;
                gotoParent = parse49(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 35/*ExpressionList*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(35/*ExpressionList*/)());
                CreatorInstance.NonterminalUnion!([35, 36]) r;
                Location rl;
                gotoParent = parse100(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 55/*ExpressionList?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/)(currentResultLocation, currentResult.get!(55/*ExpressionList?*/)());
                NonterminalType!(36) r;
                Location rl;
                gotoParent = parse102(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(36/*Tuple*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList
    // type: unknown
    //  Tuple          ->  "t(" ExpressionList?.")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    //  ExpressionList ->        ExpressionList."," Expression {")", ","}
    private int parse100(ref CreatorInstance.NonterminalUnion!([35, 36]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([35, 36]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(36) r;
            Location rl;
            gotoParent = parse101(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(36/*Tuple*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(35) r;
            Location rl;
            gotoParent = parse61(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(35/*ExpressionList*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList ")"
    // type: unknown
    //  Tuple ->  "t(" ExpressionList? ")". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse101(ref NonterminalType!(36) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce120_Tuple/*Tuple = "t(" ExpressionList? ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList "," @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList?
    // type: unknown
    //  Tuple ->  "t(" ExpressionList?.")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", "-", "|", "^", "+", "t("}
    private int parse102(ref NonterminalType!(36) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([36]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(36) r;
            Location rl;
            gotoParent = parse101(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Identifier "(" ExpressionList?
    // type: unknown
    //  MacroInstance ->  Identifier "(" ExpressionList?.")" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "?", "!", "<", "*", ">>", "-", "|", "^", "+", "t("}
    private int parse105(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!55/*ExpressionList?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(33) r;
            Location rl;
            gotoParent = parse60(r, rl, parseStart3, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" Symbol
    // type: unknown
    //  NegativeLookahead ->  "!" Symbol. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse106(ref NonterminalType!(13) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce56_NegativeLookahead/*NegativeLookahead = "!" Symbol*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" "!" "anytoken"
    // type: unknown
    //  NegativeLookahead ->  "!" "anytoken". {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    private int parse107(ref NonterminalType!(13) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce57_NegativeLookahead/*NegativeLookahead = "!" "anytoken"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus "-" $regarray_1
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  $regarray_1         ->                      $regarray_1.$regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  Annotation          ->                                 ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  NegativeLookahead   ->                                 ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  NegativeLookahead   ->                                 ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, "@", "{", "!", "<", "^", "t("}
    //  ExpressionName      ->                                 .Identifier ":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName?     ->                                 . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse108(ref CreatorInstance.NonterminalUnion!([19, 57]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 19, 21, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(21) r;
                Location rl;
                gotoParent = parse64(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(21/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("}))
            {
                auto tmp = reduce82/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
                currentResultLocation = tmp.start;
                gotoParent = 0;
            }
            else
            {
                lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                    tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                return -1;
            }
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce82/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 21/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(21/*ExpressionName*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 52/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(52/*ExpressionName?*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus+
    // type: unknown
    //  Concatenation                   ->  TokenMinus TokenMinus+.@regArray_ProductionAnnotation* {";", ")", ",", "}", "|"}
    //  TokenMinus+                     ->             TokenMinus+.TokenMinus {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Annotation                      ->                        ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                        ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead               ->                        ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  TokenMinus                      ->                        .TokenMinus "-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  TokenMinus                      ->                        .AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  AnnotatedExpression             ->                        .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  @regArray_ProductionAnnotation* ->                        . {";", ")", ",", "}", "|"}
    //  @regArray_ExpressionAnnotation* ->                        . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  $regarray_1                     ->                        .$regarray_1 $regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  $regarray_1                     ->                        .$regarrayedge_0_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  @regArray_ProductionAnnotation* ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse109(ref CreatorInstance.NonterminalUnion!([16, 46]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!46/*TokenMinus+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 16, 18, 19, 46, 48, 51, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce127/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(51/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{"}"} || lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto tmp = reduce128/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(48/*@regArray_ProductionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse43(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 18/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/)(currentResultLocation, currentResult.get!(18/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([18, 46]) r;
                Location rl;
                gotoParent = parse110(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(18/*TokenMinus*/, currentResult.get!(19/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 48/*@regArray_ProductionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!48/*@regArray_ProductionAnnotation**/)(currentResultLocation, currentResult.get!(48/*@regArray_ProductionAnnotation**/)());
                NonterminalType!(16) r;
                Location rl;
                gotoParent = parse111(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(16/*Concatenation*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!51/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(51/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse63(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(19/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([16, 19, 57]) r;
                Location rl;
                gotoParent = parse112(r, rl, parseStart2, stack2, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus+ TokenMinus
    // type: unknown
    //  TokenMinus+ ->  TokenMinus+ TokenMinus. {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  TokenMinus  ->              TokenMinus."-" AnnotatedExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    private int parse110(ref CreatorInstance.NonterminalUnion!([18, 46]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!46/*TokenMinus+*/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([18, 46]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(18) r;
            Location rl;
            gotoParent = parse51(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(18/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce63/*TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]*/(parseStart2, stack2, stack1);
            result = ThisParseResult.create(46/*TokenMinus+*/, tmp.val);
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus+ @regArray_ProductionAnnotation*
    // type: unknown
    //  Concatenation ->  TokenMinus TokenMinus+ @regArray_ProductionAnnotation*. {";", ")", ",", "}", "|"}
    private int parse111(ref NonterminalType!(16) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack3, ParseStackElem!(Location, NonterminalType!46/*TokenMinus+*/) stack2, ParseStackElem!(Location, NonterminalType!48/*@regArray_ProductionAnnotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce68_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus TokenMinus+ $regarray_1
    // type: unknown
    //  Concatenation       ->  TokenMinus TokenMinus+ @regArray_ProductionAnnotation*. {";", ")", ",", "}", "|"}
    //  AnnotatedExpression ->                         @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  $regarray_1         ->                                             $regarray_1.$regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Annotation          ->                                                        ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                                        ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                                        ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  ExpressionName      ->                                                        .Identifier ":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName?     ->                                                        . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse112(ref CreatorInstance.NonterminalUnion!([16, 19, 57]) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack3, ParseStackElem!(Location, NonterminalType!46/*TokenMinus+*/) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 16, 19, 21, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(21) r;
                Location rl;
                gotoParent = parse64(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(21/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("}))
            {
                auto tmp = reduce82/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
                currentResultLocation = tmp.start;
                gotoParent = 0;
            }
            else
            {
                lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                    tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                return -1;
            }
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce82/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{"}"} || lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto tmp = reduce68_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(parseStart3, stack3, stack2, stack1);
            result = ThisParseResult.create(16/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 2;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 21/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(21/*ExpressionName*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 52/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(52/*ExpressionName?*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier MacroParametersPart Annotation* "=" Alternation "|" TokenMinus $regarray_1
    // type: unknown
    //  Concatenation       ->  TokenMinus @regArray_ProductionAnnotation+. {";", ")", ",", "}", "|"}
    //  AnnotatedExpression ->             @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "-", "|", "^", "t("}
    //  $regarray_1         ->                                 $regarray_1.$regarrayedge_1_1 {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  Annotation          ->                                            ."@" Identifier AnnotationParams? {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                            ."!" Symbol {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  NegativeLookahead   ->                                            ."!" "anytoken" {Identifier, StringLiteral, CharacterSetLiteral, ";", ")", ",", "@", "{", "}", "!", "<", "|", "^", "t("}
    //  ExpressionName      ->                                            .Identifier ":" {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName?     ->                                            . {Identifier, StringLiteral, CharacterSetLiteral, "{", "<", "^", "t("}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse113(ref CreatorInstance.NonterminalUnion!([16, 19, 57]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!18/*TokenMinus*/) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 13, 16, 19, 21, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(21) r;
                Location rl;
                gotoParent = parse64(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(21/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("}))
            {
                auto tmp = reduce82/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
                currentResultLocation = tmp.start;
                gotoParent = 0;
            }
            else
            {
                lastError = new SingleParseException!Location(text("unexpected Token \"", tmpLexer.front.content, "\"  \"", lexer.tokenName(tmpLexer.front.symbol), "\""),
                    tmpLexer.front.currentLocation, tmpLexer.front.currentTokenEnd);
                return -1;
            }
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral" || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto tmp = reduce82/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(52/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{"}"} || lexer.front.symbol == Lexer.tokenID!q{"|"})
        {
            auto tmp = reduce71_Concatenation/*Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+*/(parseStart2, stack2, stack1);
            result = ThisParseResult.create(16/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse8(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(13) r;
            Location rl;
            gotoParent = parse53(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(13/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(10/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 13/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(13/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse81(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 21/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(21/*ExpressionName*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 52/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*ExpressionName?*/)(currentResultLocation, currentResult.get!(52/*ExpressionName?*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse66(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(19/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier "("
    // type: unknown
    //  MacroParametersPart ->  "(".MacroParameters? ")" {";", "=", "@"}
    //  MacroParameters     ->     .MacroParameters "," MacroParameter {")", ","}
    //  MacroParameters     ->     .MacroParameter {")", ","}
    //  MacroParameter      ->     .Identifier {")", ","}
    //  MacroParameter      ->     .Identifier "..." {")", ","}
    //  MacroParameters?    ->     . {")"}
    //  MacroParameters? ---> MacroParameters
    private int parse114(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5, 6, 42]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(6) r;
            Location rl;
            gotoParent = parse115(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(6/*MacroParameter*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce20/*MacroParameters? = [virtual]*/();
            currentResult = ParseResultIn.create(42/*MacroParameters?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*MacroParameters*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(5/*MacroParameters*/)());
                CreatorInstance.NonterminalUnion!([4, 5]) r;
                Location rl;
                gotoParent = parse117(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 6/*MacroParameter*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!6/*MacroParameter*/)(currentResultLocation, currentResult.get!(6/*MacroParameter*/)());
                NonterminalType!(5) r;
                Location rl;
                gotoParent = parse121(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(5/*MacroParameters*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 42/*MacroParameters?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!42/*MacroParameters?*/)(currentResultLocation, currentResult.get!(42/*MacroParameters?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse122(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(4/*MacroParametersPart*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier "(" Identifier
    // type: unknown
    //  MacroParameter ->  Identifier. {")", ","}
    //  MacroParameter ->  Identifier."..." {")", ","}
    private int parse115(ref NonterminalType!(6) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([6]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"..."})
        {
            auto next = popToken();
            NonterminalType!(6) r;
            Location rl;
            gotoParent = parse116(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce24_MacroParameter/*MacroParameter = Identifier*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier "(" Identifier "..."
    // type: unknown
    //  MacroParameter ->  Identifier "...". {")", ","}
    private int parse116(ref NonterminalType!(6) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce25_MacroParameter/*MacroParameter = Identifier "..."*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameters
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters?.")" {";", "=", "@"}
    //  MacroParameters     ->       MacroParameters."," MacroParameter {")", ","}
    private int parse117(ref CreatorInstance.NonterminalUnion!([4, 5]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(4) r;
            Location rl;
            gotoParent = parse118(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(4/*MacroParametersPart*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse119(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(5/*MacroParameters*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameters ")"
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters? ")". {";", "=", "@"}
    private int parse118(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!42/*MacroParameters?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce21_MacroParametersPart/*MacroParametersPart = "(" MacroParameters? ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameters ","
    // type: unknown
    //  MacroParameters ->  MacroParameters ",".MacroParameter {")", ","}
    //  MacroParameter  ->                     .Identifier {")", ","}
    //  MacroParameter  ->                     .Identifier "..." {")", ","}
    private int parse119(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!5/*MacroParameters*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([5, 6]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(6) r;
            Location rl;
            gotoParent = parse115(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(6/*MacroParameter*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 6/*MacroParameter*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!6/*MacroParameter*/)(currentResultLocation, currentResult.get!(6/*MacroParameter*/)());
                NonterminalType!(5) r;
                Location rl;
                gotoParent = parse120(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(5/*MacroParameters*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameters "," MacroParameter
    // type: unknown
    //  MacroParameters ->  MacroParameters "," MacroParameter. {")", ","}
    private int parse120(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!5/*MacroParameters*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!6/*MacroParameter*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce23_MacroParameters/*MacroParameters @array = MacroParameters "," MacroParameter*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameter
    // type: unknown
    //  MacroParameters ->  MacroParameter. {")", ","}
    private int parse121(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!6/*MacroParameter*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce22_MacroParameters/*MacroParameters @array = MacroParameter*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF DeclarationType Identifier "(" MacroParameters?
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters?.")" {";", "=", "@"}
    private int parse122(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!42/*MacroParameters?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(4) r;
            Location rl;
            gotoParent = parse118(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "fragment"
    // type: unknown
    //  DeclarationType ->  "fragment". {Identifier}
    private int parse124(ref NonterminalType!(3) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce17_DeclarationType/*DeclarationType = "fragment"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF "token"
    // type: unknown
    //  DeclarationType ->  "token". {Identifier}
    private int parse126(ref NonterminalType!(3) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce18_DeclarationType/*DeclarationType = "token"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF "option"
    // type: unknown
    //  OptionDeclaration ->  "option".Identifier "=" IntegerLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse128(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart1/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([7]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse129(r, rl, parseStart1/*, stack1*/, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "option" Identifier
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier."=" IntegerLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse129(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart2/+, ParseStackElem!(Location, Token) stack2+/, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([7]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse130(r, rl, parseStart2/*, stack2*/, stack1/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "option" Identifier "="
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=".IntegerLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse130(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart3/+, ParseStackElem!(Location, Token) stack3+/, ParseStackElem!(Location, Token) stack2/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([7]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse131(r, rl, parseStart3/*, stack3*/, stack2/*, stack1*/, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "option" Identifier "=" IntegerLiteral
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=" IntegerLiteral.";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse131(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart4/+, ParseStackElem!(Location, Token) stack4+/, ParseStackElem!(Location, Token) stack3/+, ParseStackElem!(Location, Token) stack2+/, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([7]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse132(r, rl, parseStart4/*, stack4*/, stack3/*, stack2*/, stack1/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "option" Identifier "=" IntegerLiteral ";"
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=" IntegerLiteral ";". {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse132(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart5/+, ParseStackElem!(Location, Token) stack5+/, ParseStackElem!(Location, Token) stack4/+, ParseStackElem!(Location, Token) stack3+/, ParseStackElem!(Location, Token) stack2/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce26_OptionDeclaration/*OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"*/(parseStart5, /*dropped, */stack4, /*dropped, */stack2, /*dropped*/);
            result = tmp.val;
            resultLocation = tmp.start;
            return 4;
        }
    }
    // path: EBNF "import"
    // type: unknown
    //  Import ->  "import".StringLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse133(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([8]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse134(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "import" StringLiteral
    // type: unknown
    //  Import ->  "import" StringLiteral.";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse134(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([8]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse135(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "import" StringLiteral ";"
    // type: unknown
    //  Import ->  "import" StringLiteral ";". {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse135(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce27_Import/*Import = "import" StringLiteral ";"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF "match"
    // type: unknown
    //  MatchDeclaration ->  "match".Symbol Symbol ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Symbol           ->         .Name {Identifier, StringLiteral, CharacterSetLiteral}
    //  Symbol           ->         .Token {Identifier, StringLiteral, CharacterSetLiteral}
    //  Symbol           ->         .MacroInstance {Identifier, StringLiteral, CharacterSetLiteral}
    //  Name             ->         .Identifier {Identifier, StringLiteral, CharacterSetLiteral}
    //  Token            ->         .StringLiteral {Identifier, StringLiteral, CharacterSetLiteral}
    //  Token            ->         .CharacterSetLiteral {Identifier, StringLiteral, CharacterSetLiteral}
    //  MacroInstance    ->         .Identifier "(" ExpressionList? ")" {Identifier, StringLiteral, CharacterSetLiteral}
    private int parse136(ref NonterminalType!(9) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([9, 28, 29, 30, 33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([29, 33]) r;
            Location rl;
            gotoParent = parse54(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse75(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse76(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 28/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*Symbol*/)(currentResultLocation, currentResult.get!(28/*Symbol*/)());
                NonterminalType!(9) r;
                Location rl;
                gotoParent = parse137(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 29/*Name*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(29/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 30/*Token*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(30/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 33/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(33/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(9/*MatchDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF "match" Symbol
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol.Symbol ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Symbol           ->                .Name {";"}
    //  Symbol           ->                .Token {";"}
    //  Symbol           ->                .MacroInstance {";"}
    //  Name             ->                .Identifier {";"}
    //  Token            ->                .StringLiteral {";"}
    //  Token            ->                .CharacterSetLiteral {";"}
    //  MacroInstance    ->                .Identifier "(" ExpressionList? ")" {";"}
    private int parse137(ref NonterminalType!(9) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([9, 28, 29, 30, 33]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([29, 33]) r;
            Location rl;
            gotoParent = parse54(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse75(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse76(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Token*/, r);
            currentResultLocation = rl;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 28/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*Symbol*/)(currentResultLocation, currentResult.get!(28/*Symbol*/)());
                NonterminalType!(9) r;
                Location rl;
                gotoParent = parse138(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 29/*Name*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(29/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 30/*Token*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(30/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 33/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(28/*Symbol*/, currentResult.get!(33/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(9/*MatchDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF "match" Symbol Symbol
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol Symbol.";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse138(ref NonterminalType!(9) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack2, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([9]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(9) r;
            Location rl;
            gotoParent = parse139(r, rl, parseStart3, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
    }
    // path: EBNF "match" Symbol Symbol ";"
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol Symbol ";". {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse139(ref NonterminalType!(9) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack3, ParseStackElem!(Location, NonterminalType!28/*Symbol*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce28_MatchDeclaration/*MatchDeclaration = "match" Symbol Symbol ";"*/(parseStart4, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF Declaration+
    // type: unknown
    //  EBNF              ->  Declaration+. {$end}
    //  Declaration+      ->  Declaration+.Declaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       ->              .SymbolDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       ->              .OptionDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       ->              .Import {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Declaration       ->              .MatchDeclaration {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration ->              .DeclarationType? Identifier MacroParametersPart? Annotation* ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  SymbolDeclaration ->              .DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  DeclarationType   ->              ."fragment" {Identifier}
    //  DeclarationType   ->              ."token" {Identifier}
    //  OptionDeclaration ->              ."option" Identifier "=" IntegerLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  Import            ->              ."import" StringLiteral ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  MatchDeclaration  ->              ."match" Symbol Symbol ";" {$end, Identifier, "fragment", "token", "option", "import", "match"}
    //  DeclarationType?  ->              . {Identifier}
    //  DeclarationType? ---> DeclarationType
    private int parse140(ref CreatorInstance.NonterminalUnion!([0, 37]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!37/*Declaration+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 1, 2, 3, 7, 8, 9, 37, 38]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            auto tmp = reduce2_EBNF/*EBNF = Declaration+*/(parseStart1, stack1);
            result = ThisParseResult.create(0/*EBNF*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto tmp = reduce8/*DeclarationType? = [virtual]*/();
            currentResult = ParseResultIn.create(38/*DeclarationType?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"fragment"})
        {
            auto next = popToken();
            NonterminalType!(3) r;
            Location rl;
            gotoParent = parse124(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(3/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"token"})
        {
            auto next = popToken();
            NonterminalType!(3) r;
            Location rl;
            gotoParent = parse126(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(3/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"option"})
        {
            auto next = popToken();
            NonterminalType!(7) r;
            Location rl;
            gotoParent = parse128(r, rl, currentStart/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(7/*OptionDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"import"})
        {
            auto next = popToken();
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse133(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(8/*Import*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"match"})
        {
            auto next = popToken();
            NonterminalType!(9) r;
            Location rl;
            gotoParent = parse136(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(9/*MatchDeclaration*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce2_EBNF/*EBNF = Declaration+*/(parseStart1, stack1);
            result = ThisParseResult.create(0/*EBNF*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 1/*Declaration*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!1/*Declaration*/)(currentResultLocation, currentResult.get!(1/*Declaration*/)());
                NonterminalType!(37) r;
                Location rl;
                gotoParent = parse141(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(37/*Declaration+*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 2/*SymbolDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(2/*SymbolDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 3/*DeclarationType*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/)(currentResultLocation, currentResult.get!(3/*DeclarationType*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(2/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 7/*OptionDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(7/*OptionDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 8/*Import*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(8/*Import*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 9/*MatchDeclaration*/)
            {
                currentResult = ParseResultIn.create(1/*Declaration*/, currentResult.get!(9/*MatchDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*DeclarationType?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!38/*DeclarationType?*/)(currentResultLocation, currentResult.get!(38/*DeclarationType?*/)());
                NonterminalType!(2) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(2/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult;
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ Declaration
    // type: unknown
    //  Declaration+ ->  Declaration+ Declaration. {$end, Identifier, "fragment", "token", "option", "import", "match"}
    private int parse141(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!37/*Declaration+*/) stack2, ParseStackElem!(Location, NonterminalType!1/*Declaration*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce1/*Declaration+ @array = Declaration+ Declaration [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
}

immutable allTokens = [
    /* 0: */ immutable(Token)("$end", []),
    /* 1: */ immutable(Token)("Identifier", ["lowPrio"]),
    /* 2: */ immutable(Token)("StringLiteral", []),
    /* 3: */ immutable(Token)("CharacterSetLiteral", []),
    /* 4: */ immutable(Token)("IntegerLiteral", []),
    /* 5: */ immutable(Token)(q{";"}, []),
    /* 6: */ immutable(Token)(q{"="}, []),
    /* 7: */ immutable(Token)(q{"fragment"}, []),
    /* 8: */ immutable(Token)(q{"token"}, []),
    /* 9: */ immutable(Token)(q{"("}, []),
    /* 10: */ immutable(Token)(q{")"}, []),
    /* 11: */ immutable(Token)(q{","}, []),
    /* 12: */ immutable(Token)(q{"..."}, []),
    /* 13: */ immutable(Token)(q{"option"}, []),
    /* 14: */ immutable(Token)(q{"import"}, []),
    /* 15: */ immutable(Token)(q{"match"}, []),
    /* 16: */ immutable(Token)(q{"@"}, []),
    /* 17: */ immutable(Token)(q{":"}, []),
    /* 18: */ immutable(Token)(q{"{"}, []),
    /* 19: */ immutable(Token)(q{"}"}, []),
    /* 20: */ immutable(Token)(q{"?"}, []),
    /* 21: */ immutable(Token)(q{"!"}, []),
    /* 22: */ immutable(Token)(q{"<"}, []),
    /* 23: */ immutable(Token)(q{">"}, []),
    /* 24: */ immutable(Token)(q{"*"}, []),
    /* 25: */ immutable(Token)(q{">>"}, []),
    /* 26: */ immutable(Token)(q{"<<"}, []),
    /* 27: */ immutable(Token)(q{"-"}, []),
    /* 28: */ immutable(Token)(q{"anytoken"}, []),
    /* 29: */ immutable(Token)(q{"|"}, []),
    /* 30: */ immutable(Token)(q{"^"}, []),
    /* 31: */ immutable(Token)(q{"+"}, []),
    /* 32: */ immutable(Token)(q{"t("}, []),
];

immutable allNonterminals = [
    /* 0: */ immutable(Nonterminal)("EBNF", NonterminalFlags.nonterminal, [], [0]),
    /* 1: */ immutable(Nonterminal)("Declaration", NonterminalFlags.nonterminal, [], [2, 7, 8, 9]),
    /* 2: */ immutable(Nonterminal)("SymbolDeclaration", NonterminalFlags.nonterminal, [], [2]),
    /* 3: */ immutable(Nonterminal)("DeclarationType", NonterminalFlags.nonterminal, [], [3]),
    /* 4: */ immutable(Nonterminal)("MacroParametersPart", NonterminalFlags.nonterminal, [], [4]),
    /* 5: */ immutable(Nonterminal)("MacroParameters", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, ["array"], [6]),
    /* 6: */ immutable(Nonterminal)("MacroParameter", NonterminalFlags.nonterminal, [], [6]),
    /* 7: */ immutable(Nonterminal)("OptionDeclaration", NonterminalFlags.nonterminal, [], [7]),
    /* 8: */ immutable(Nonterminal)("Import", NonterminalFlags.nonterminal, [], [8]),
    /* 9: */ immutable(Nonterminal)("MatchDeclaration", NonterminalFlags.nonterminal, [], [9]),
    /* 10: */ immutable(Nonterminal)("Annotation", NonterminalFlags.nonterminal, [], [10]),
    /* 11: */ immutable(Nonterminal)("AnnotationParams", NonterminalFlags.nonterminal, [], [11]),
    /* 12: */ immutable(Nonterminal)("AnnotationParamsPart", NonterminalFlags.nonterminal, [], [12]),
    /* 13: */ immutable(Nonterminal)("NegativeLookahead", NonterminalFlags.nonterminal, [], [13]),
    /* 14: */ immutable(Nonterminal)("Expression", NonterminalFlags.nonterminal, [], [15, 16, 18, 19]),
    /* 15: */ immutable(Nonterminal)("Alternation", NonterminalFlags.nonterminal, [], [15, 16, 18, 19]),
    /* 16: */ immutable(Nonterminal)("Concatenation", NonterminalFlags.nonterminal, [], [16, 18, 19]),
    /* 17: */ immutable(Nonterminal)("ProductionAnnotation", NonterminalFlags.nonterminal, ["directUnwrap"], [10, 13]),
    /* 18: */ immutable(Nonterminal)("TokenMinus", NonterminalFlags.nonterminal, [], [18, 19]),
    /* 19: */ immutable(Nonterminal)("AnnotatedExpression", NonterminalFlags.nonterminal, [], [19]),
    /* 20: */ immutable(Nonterminal)("ExpressionAnnotation", NonterminalFlags.nonterminal, ["directUnwrap"], [10, 13]),
    /* 21: */ immutable(Nonterminal)("ExpressionName", NonterminalFlags.nonterminal, [], [21]),
    /* 22: */ immutable(Nonterminal)("ExpressionPrefix", NonterminalFlags.nonterminal, [], [22]),
    /* 23: */ immutable(Nonterminal)("PostfixExpression", NonterminalFlags.nonterminal, [], [24, 25, 26, 29, 30, 31, 32, 33, 34, 36]),
    /* 24: */ immutable(Nonterminal)("Optional", NonterminalFlags.nonterminal, [], [24]),
    /* 25: */ immutable(Nonterminal)("Repetition", NonterminalFlags.nonterminal, [], [25]),
    /* 26: */ immutable(Nonterminal)("RepetitionPlus", NonterminalFlags.nonterminal, [], [26]),
    /* 27: */ immutable(Nonterminal)("AtomExpression", NonterminalFlags.nonterminal, [], [29, 30, 31, 32, 33, 34, 36]),
    /* 28: */ immutable(Nonterminal)("Symbol", NonterminalFlags.nonterminal, [], [29, 30, 33]),
    /* 29: */ immutable(Nonterminal)("Name", NonterminalFlags.nonterminal, [], [29]),
    /* 30: */ immutable(Nonterminal)("Token", NonterminalFlags.nonterminal, [], [30]),
    /* 31: */ immutable(Nonterminal)("UnpackVariadicList", NonterminalFlags.nonterminal, [], [31]),
    /* 32: */ immutable(Nonterminal)("SubToken", NonterminalFlags.nonterminal, [], [32]),
    /* 33: */ immutable(Nonterminal)("MacroInstance", NonterminalFlags.nonterminal, [], [33]),
    /* 34: */ immutable(Nonterminal)("ParenExpression", NonterminalFlags.nonterminal, [], [34]),
    /* 35: */ immutable(Nonterminal)("ExpressionList", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, ["array"], [15, 16, 18, 19]),
    /* 36: */ immutable(Nonterminal)("Tuple", NonterminalFlags.nonterminal, [], [36]),
    /* 37: */ immutable(Nonterminal)("Declaration+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [2, 7, 8, 9]),
    /* 38: */ immutable(Nonterminal)("DeclarationType?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [3]),
    /* 39: */ immutable(Nonterminal)("MacroParametersPart?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [4]),
    /* 40: */ immutable(Nonterminal)("Annotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10]),
    /* 41: */ immutable(Nonterminal)("Annotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10]),
    /* 42: */ immutable(Nonterminal)("MacroParameters?", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, [], [6]),
    /* 43: */ immutable(Nonterminal)("AnnotationParams?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [11]),
    /* 44: */ immutable(Nonterminal)("AnnotationParamsPart+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [12]),
    /* 45: */ immutable(Nonterminal)("AnnotationParamsPart*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [12]),
    /* 46: */ immutable(Nonterminal)("TokenMinus+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [18, 19]),
    /* 47: */ immutable(Nonterminal)("ProductionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10, 13]),
    /* 48: */ immutable(Nonterminal)("@regArray_ProductionAnnotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [10, 13]),
    /* 49: */ immutable(Nonterminal)("@regArray_ProductionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [10, 13]),
    /* 50: */ immutable(Nonterminal)("ExpressionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10, 13]),
    /* 51: */ immutable(Nonterminal)("@regArray_ExpressionAnnotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [10, 13]),
    /* 52: */ immutable(Nonterminal)("ExpressionName?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [21]),
    /* 53: */ immutable(Nonterminal)("ExpressionPrefix+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [22]),
    /* 54: */ immutable(Nonterminal)("ExpressionPrefix*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [22]),
    /* 55: */ immutable(Nonterminal)("ExpressionList?", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, [], [15, 16, 18, 19]),
    /* 56: */ immutable(Nonterminal)("$regarray_0", NonterminalFlags.none, ["array", "directUnwrap"], []),
    /* 57: */ immutable(Nonterminal)("$regarray_1", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap"], [10, 13]),
    /* 58: */ immutable(Nonterminal)("$regarrayedge_0_1", NonterminalFlags.nonterminal, ["directUnwrap"], [10, 13]),
    /* 59: */ immutable(Nonterminal)("$regarrayedge_1_1", NonterminalFlags.nonterminal, ["directUnwrap"], [10, 13]),
];

immutable allProductions = [
    // 0: Declaration+ @array = Declaration [virtual]
    immutable(Production)(immutable(NonterminalID)(37), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 1), "", "", false, false, [], [])
            ], [], [], false, true),
    // 1: Declaration+ @array = Declaration+ Declaration [virtual]
    immutable(Production)(immutable(NonterminalID)(37), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 37), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 1), "", "", false, false, [], [])
            ], [], [], false, true),
    // 2: EBNF = Declaration+
    immutable(Production)(immutable(NonterminalID)(0), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 37), "", "", false, false, [], [])
            ], [], [], false, false),
    // 3: Declaration = <SymbolDeclaration
    immutable(Production)(immutable(NonterminalID)(1), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 2), "", "", true, false, [], [])
            ], [], [], false, false),
    // 4: Declaration = <MatchDeclaration
    immutable(Production)(immutable(NonterminalID)(1), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 9), "", "", true, false, [], [])
            ], [], [], false, false),
    // 5: Declaration = <Import
    immutable(Production)(immutable(NonterminalID)(1), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 8), "", "", true, false, [], [])
            ], [], [], false, false),
    // 6: Declaration = <OptionDeclaration
    immutable(Production)(immutable(NonterminalID)(1), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 7), "", "", true, false, [], [])
            ], [], [], false, false),
    // 7: DeclarationType? = <DeclarationType [virtual]
    immutable(Production)(immutable(NonterminalID)(38), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 3), "", "", true, false, [], [])
            ], [], [], false, true),
    // 8: DeclarationType? = [virtual]
    immutable(Production)(immutable(NonterminalID)(38), [], [], [], false, true),
    // 9: MacroParametersPart? = <MacroParametersPart [virtual]
    immutable(Production)(immutable(NonterminalID)(39), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 4), "", "", true, false, [], [])
            ], [], [], false, true),
    // 10: MacroParametersPart? = [virtual]
    immutable(Production)(immutable(NonterminalID)(39), [], [], [], false, true),
    // 11: Annotation+ @array = Annotation [virtual]
    immutable(Production)(immutable(NonterminalID)(40), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", false, false, [], [])
            ], [], [], false, true),
    // 12: Annotation+ @array = Annotation+ Annotation [virtual]
    immutable(Production)(immutable(NonterminalID)(40), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 40), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", false, false, [], [])
            ], [], [], false, true),
    // 13: Annotation* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(41), [], [], [], false, true),
    // 14: Annotation* @array = Annotation+ [virtual]
    immutable(Production)(immutable(NonterminalID)(41), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 40), "", "", false, false, [], [])
            ], [], [], false, true),
    // 15: SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"
    immutable(Production)(immutable(NonterminalID)(2), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 38), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 41), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 16: SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"
    immutable(Production)(immutable(NonterminalID)(2), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 38), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 41), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 17: DeclarationType = "fragment"
    immutable(Production)(immutable(NonterminalID)(3), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 7), "", "", false, false, [], [])
            ], [], [], false, false),
    // 18: DeclarationType = "token"
    immutable(Production)(immutable(NonterminalID)(3), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 8), "", "", false, false, [], [])
            ], [], [], false, false),
    // 19: MacroParameters? = <MacroParameters [virtual]
    immutable(Production)(immutable(NonterminalID)(42), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", true, false, [], [])
            ], [], [], false, true),
    // 20: MacroParameters? = [virtual]
    immutable(Production)(immutable(NonterminalID)(42), [], [], [], false, true),
    // 21: MacroParametersPart = "(" MacroParameters? ")"
    immutable(Production)(immutable(NonterminalID)(4), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 42), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 22: MacroParameters @array = MacroParameter
    immutable(Production)(immutable(NonterminalID)(5), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 6), "", "", false, false, [], [])
            ], [], [], false, false),
    // 23: MacroParameters @array = MacroParameters "," MacroParameter
    immutable(Production)(immutable(NonterminalID)(5), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 11), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 6), "", "", false, false, [], [])
            ], [], [], false, false),
    // 24: MacroParameter = Identifier
    immutable(Production)(immutable(NonterminalID)(6), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], [])
            ], [], [], false, false),
    // 25: MacroParameter = Identifier "..."
    immutable(Production)(immutable(NonterminalID)(6), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 12), "", "", false, false, [], [])
            ], [], [], false, false),
    // 26: OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"
    immutable(Production)(immutable(NonterminalID)(7), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 13), "", "", false, true, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, true, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 4), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, true, [], [])
            ], [], [], false, false),
    // 27: Import = "import" StringLiteral ";"
    immutable(Production)(immutable(NonterminalID)(8), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 14), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 28: MatchDeclaration = "match" Symbol Symbol ";"
    immutable(Production)(immutable(NonterminalID)(9), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 15), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 29: AnnotationParams? = <AnnotationParams [virtual]
    immutable(Production)(immutable(NonterminalID)(43), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 11), "", "", true, false, [], [])
            ], [], [], false, true),
    // 30: AnnotationParams? = [virtual]
    immutable(Production)(immutable(NonterminalID)(43), [], [], [], false, true),
    // 31: Annotation = "@" Identifier AnnotationParams?
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 16), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 43), "", "", false, false, [], [])
            ], [], [], false, false),
    // 32: AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]
    immutable(Production)(immutable(NonterminalID)(44), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 12), "", "", false, false, [], [])
            ], [], [], false, true),
    // 33: AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]
    immutable(Production)(immutable(NonterminalID)(44), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 44), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 12), "", "", false, false, [], [])
            ], [], [], false, true),
    // 34: AnnotationParamsPart* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(45), [], [], [], false, true),
    // 35: AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]
    immutable(Production)(immutable(NonterminalID)(45), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 44), "", "", false, false, [], [])
            ], [], [], false, true),
    // 36: AnnotationParams = "(" AnnotationParamsPart* ")"
    immutable(Production)(immutable(NonterminalID)(11), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 45), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 37: AnnotationParamsPart = StringLiteral
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], [])
            ], [], [], false, false),
    // 38: AnnotationParamsPart = Identifier
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], [])
            ], [], [], false, false),
    // 39: AnnotationParamsPart = CharacterSetLiteral
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 40: AnnotationParamsPart = IntegerLiteral
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 4), "", "", false, false, [], [])
            ], [], [], false, false),
    // 41: AnnotationParamsPart = "(" AnnotationParamsPart* ")"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 45), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 42: AnnotationParamsPart = "="
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, false, [], [])
            ], [], [], false, false),
    // 43: AnnotationParamsPart = ":"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 17), "", "", false, false, [], [])
            ], [], [], false, false),
    // 44: AnnotationParamsPart = ";"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 45: AnnotationParamsPart = ","
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 11), "", "", false, false, [], [])
            ], [], [], false, false),
    // 46: AnnotationParamsPart = "{"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 18), "", "", false, false, [], [])
            ], [], [], false, false),
    // 47: AnnotationParamsPart = "}"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 19), "", "", false, false, [], [])
            ], [], [], false, false),
    // 48: AnnotationParamsPart = "?"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 20), "", "", false, false, [], [])
            ], [], [], false, false),
    // 49: AnnotationParamsPart = "!"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 21), "", "", false, false, [], [])
            ], [], [], false, false),
    // 50: AnnotationParamsPart = "<"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 22), "", "", false, false, [], [])
            ], [], [], false, false),
    // 51: AnnotationParamsPart = ">"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 23), "", "", false, false, [], [])
            ], [], [], false, false),
    // 52: AnnotationParamsPart = "*"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 24), "", "", false, false, [], [])
            ], [], [], false, false),
    // 53: AnnotationParamsPart = ">>"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 25), "", "", false, false, [], [])
            ], [], [], false, false),
    // 54: AnnotationParamsPart = "<<"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 26), "", "", false, false, [], [])
            ], [], [], false, false),
    // 55: AnnotationParamsPart = "-"
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 27), "", "", false, false, [], [])
            ], [], [], false, false),
    // 56: NegativeLookahead = "!" Symbol
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 21), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], [])
            ], [], [], false, false),
    // 57: NegativeLookahead = "!" "anytoken"
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 21), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 28), "", "", false, false, [], [])
            ], [], [], false, false),
    // 58: Expression = <Alternation
    immutable(Production)(immutable(NonterminalID)(14), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 15), "", "", true, false, [], [])
            ], [], [], false, false),
    // 59: Alternation = <Concatenation
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 16), "", "", true, false, [], [])
            ], [], [], false, false),
    // 60: Alternation = Alternation "|" Concatenation
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 15), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 29), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 16), "", "", false, false, [], [])
            ], [], [], false, false),
    // 61: Concatenation = <TokenMinus
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", true, false, [], [])
            ], [], [], false, false),
    // 62: TokenMinus+ @array = TokenMinus [virtual]
    immutable(Production)(immutable(NonterminalID)(46), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], [])
            ], [], [], false, true),
    // 63: TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]
    immutable(Production)(immutable(NonterminalID)(46), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 46), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], [])
            ], [], [], false, true),
    // 64: ProductionAnnotation+ @array = ProductionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(47), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 17), "", "", false, false, [], [])
            ], [], [], false, true),
    // 65: ProductionAnnotation+ @array = ProductionAnnotation+ ProductionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(47), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 47), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 17), "", "", false, false, [], [])
            ], [], [], false, true),
    immutable(Production)(),
    immutable(Production)(),
    // 68: Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation*
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 46), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 48), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    immutable(Production)(),
    immutable(Production)(),
    // 71: Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    // 72: Concatenation = @regArray @regArray_ProductionAnnotation+
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    // 73: ProductionAnnotation @directUnwrap = <Annotation
    immutable(Production)(immutable(NonterminalID)(17), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", true, false, [], [])
            ], [], [], false, false),
    // 74: ProductionAnnotation @directUnwrap = <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(17), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 13), "", "", true, false, [], [])
            ], [], [], false, false),
    // 75: TokenMinus = <AnnotatedExpression
    immutable(Production)(immutable(NonterminalID)(18), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 19), "", "", true, false, [], [])
            ], [], [], false, false),
    // 76: TokenMinus = TokenMinus "-" AnnotatedExpression
    immutable(Production)(immutable(NonterminalID)(18), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 27), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 19), "", "", false, false, [], [])
            ], [], [], false, false),
    // 77: ExpressionAnnotation+ @array = ExpressionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(50), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], [])
            ], [], [], false, true),
    // 78: ExpressionAnnotation+ @array = ExpressionAnnotation+ ExpressionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(50), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 50), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], [])
            ], [], [], false, true),
    immutable(Production)(),
    immutable(Production)(),
    // 81: ExpressionName? = <ExpressionName [virtual]
    immutable(Production)(immutable(NonterminalID)(52), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 21), "", "", true, false, [], [])
            ], [], [], false, true),
    // 82: ExpressionName? = [virtual]
    immutable(Production)(immutable(NonterminalID)(52), [], [], [], false, true),
    // 83: ExpressionPrefix+ @array = ExpressionPrefix [virtual]
    immutable(Production)(immutable(NonterminalID)(53), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 22), "", "", false, false, [], [])
            ], [], [], false, true),
    // 84: ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]
    immutable(Production)(immutable(NonterminalID)(53), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 53), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 22), "", "", false, false, [], [])
            ], [], [], false, true),
    // 85: ExpressionPrefix* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(54), [], [], [], false, true),
    // 86: ExpressionPrefix* @array = ExpressionPrefix+ [virtual]
    immutable(Production)(immutable(NonterminalID)(54), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 53), "", "", false, false, [], [])
            ], [], [], false, true),
    // 87: AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression
    immutable(Production)(immutable(NonterminalID)(19), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 51), "", "", false, false, ["regArray"], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 54), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", false, false, [], [])
            ], [], [], false, false),
    // 88: ExpressionAnnotation @directUnwrap = <Annotation
    immutable(Production)(immutable(NonterminalID)(20), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", true, false, [], [])
            ], [], [], false, false),
    // 89: ExpressionAnnotation @directUnwrap = <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(20), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 13), "", "", true, false, [], [])
            ], [], [], false, false),
    // 90: ExpressionName = Identifier ":"
    immutable(Production)(immutable(NonterminalID)(21), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 17), "", "", false, false, [], [])
            ], [], [], false, false),
    // 91: ExpressionPrefix = "<"
    immutable(Production)(immutable(NonterminalID)(22), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 22), "", "", false, false, [], [])
            ], [], [], false, false),
    // 92: ExpressionPrefix = "^"
    immutable(Production)(immutable(NonterminalID)(22), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], [])
            ], [], [], false, false),
    // 93: PostfixExpression = <Optional
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 24), "", "", true, false, [], [])
            ], [], [], false, false),
    // 94: PostfixExpression = <Repetition
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 25), "", "", true, false, [], [])
            ], [], [], false, false),
    // 95: PostfixExpression = <RepetitionPlus
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 26), "", "", true, false, [], [])
            ], [], [], false, false),
    // 96: PostfixExpression = <AtomExpression
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 27), "", "", true, false, [], [])
            ], [], [], false, false),
    // 97: Optional = PostfixExpression "?"
    immutable(Production)(immutable(NonterminalID)(24), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 20), "", "", false, false, [], [])
            ], [], [], false, false),
    // 98: Repetition = PostfixExpression "*"
    immutable(Production)(immutable(NonterminalID)(25), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 24), "", "", false, false, [], [])
            ], [], [], false, false),
    // 99: RepetitionPlus = PostfixExpression "+"
    immutable(Production)(immutable(NonterminalID)(26), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 31), "", "", false, false, [], [])
            ], [], [], false, false),
    // 100: AtomExpression = <Symbol
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", true, false, [], [])
            ], [], [], false, false),
    // 101: AtomExpression = <ParenExpression
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 34), "", "", true, false, [], [])
            ], [], [], false, false),
    // 102: AtomExpression = <SubToken
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 32), "", "", true, false, [], [])
            ], [], [], false, false),
    // 103: AtomExpression = <UnpackVariadicList
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 31), "", "", true, false, [], [])
            ], [], [], false, false),
    // 104: AtomExpression = <Tuple
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 36), "", "", true, false, [], [])
            ], [], [], false, false),
    // 105: Symbol = <Name
    immutable(Production)(immutable(NonterminalID)(28), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 29), "", "", true, false, [], [])
            ], [], [], false, false),
    // 106: Symbol = <Token
    immutable(Production)(immutable(NonterminalID)(28), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 30), "", "", true, false, [], [])
            ], [], [], false, false),
    // 107: Symbol = <MacroInstance
    immutable(Production)(immutable(NonterminalID)(28), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 33), "", "", true, false, [], [])
            ], [], [], false, false),
    // 108: Name = Identifier
    immutable(Production)(immutable(NonterminalID)(29), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], [])
            ], [], [], false, false),
    // 109: Token = StringLiteral
    immutable(Production)(immutable(NonterminalID)(30), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], [])
            ], [], [], false, false),
    // 110: Token = CharacterSetLiteral
    immutable(Production)(immutable(NonterminalID)(30), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 111: UnpackVariadicList = Identifier "..."
    immutable(Production)(immutable(NonterminalID)(31), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 12), "", "", false, false, [], [])
            ], [], [], false, false),
    // 112: SubToken = Symbol ">>" Symbol
    immutable(Production)(immutable(NonterminalID)(32), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 25), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], [])
            ], [], [], false, false),
    // 113: SubToken = Symbol ">>" ParenExpression
    immutable(Production)(immutable(NonterminalID)(32), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 25), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 34), "", "", false, false, [], [])
            ], [], [], false, false),
    // 114: ExpressionList? = <ExpressionList [virtual]
    immutable(Production)(immutable(NonterminalID)(55), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 35), "", "", true, false, [], [])
            ], [], [], false, true),
    // 115: ExpressionList? = [virtual]
    immutable(Production)(immutable(NonterminalID)(55), [], [], [], false, true),
    // 116: MacroInstance = Identifier "(" ExpressionList? ")"
    immutable(Production)(immutable(NonterminalID)(33), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 55), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 117: ParenExpression = "{" Expression "}"
    immutable(Production)(immutable(NonterminalID)(34), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 19), "", "", false, false, [], [])
            ], [], [], false, false),
    // 118: ExpressionList @array = Expression
    immutable(Production)(immutable(NonterminalID)(35), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", false, false, [], [])
            ], [], [], false, false),
    // 119: ExpressionList @array = ExpressionList "," Expression
    immutable(Production)(immutable(NonterminalID)(35), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 35), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 11), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", false, false, [], [])
            ], [], [], false, false),
    // 120: Tuple = "t(" ExpressionList? ")"
    immutable(Production)(immutable(NonterminalID)(36), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 32), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 55), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 121: $regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1
    immutable(Production)(immutable(NonterminalID)(57), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", false, false, ["inheritAnyTag"], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 59), "", "", false, false, [], [])
            ], [], [], false, false),
    // 122: $regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <Annotation
    immutable(Production)(immutable(NonterminalID)(58), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 123: $regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(58), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 13), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 124: $regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <Annotation
    immutable(Production)(immutable(NonterminalID)(59), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 125: $regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(59), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 13), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 126: $regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1
    immutable(Production)(immutable(NonterminalID)(57), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 58), "", "", false, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 127: @regArray_ExpressionAnnotation* @array @directUnwrap @regArray =
    immutable(Production)(immutable(NonterminalID)(51), [], [], [], false, false),
    // 128: @regArray_ProductionAnnotation* @array @directUnwrap @regArray =
    immutable(Production)(immutable(NonterminalID)(48), [], [], [], false, false),
    // 129: @regArray_ExpressionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(51), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 130: @regArray_ProductionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(48), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 131: @regArray_ProductionAnnotation+ @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(49), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
];

immutable GrammarInfo grammarInfo = immutable(GrammarInfo)(
        startTokenID, startNonterminalID, startProductionID,
        allTokens, allNonterminals, allProductions);

Creator.Type parse(Creator, alias Lexer, string startNonterminal = "EBNF")(ref Lexer lexer, Creator creator)
{
    alias Location = typeof(Lexer.init.front.currentLocation);
    auto parser = Parser!(Creator, Lexer)(
            creator,
            &lexer);
    ParameterTypeTuple!(__traits(getMember, parser, "parse" ~ startNonterminal))[0] parseResult;
    Location parseResultLocation;
    int gotoParent = __traits(getMember, parser, "parse" ~ startNonterminal)(parseResult, parseResultLocation);
    if (gotoParent < 0)
    {
        assert(parser.lastError !is null);
        throw parser.lastError;
    }
    else
        assert(parser.lastError is null);
    auto result = parseResult;
    creator.adjustStart(result, parseResultLocation);
    return result;
}

Creator.Type parse(Creator, alias Lexer, string startNonterminal = "EBNF")(string input, Creator creator, typeof(Lexer.init.front.currentLocation) startLocation = typeof(Lexer.init.front.currentLocation).init)
{
    alias Location = typeof(Lexer.init.front.currentLocation);
    Lexer lexer = Lexer(input, startLocation);
    auto result = parse!(Creator, Lexer, startNonterminal)(lexer, creator);
    if (!lexer.empty)
    {
        throw new SingleParseException!Location("input left after parse",
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
    }
    return result;
}
