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
    "@regArray_ExpressionAnnotation*",
    "@regArray_ProductionAnnotation*",
    "@regArray_ProductionAnnotation+",
    "Alternation",
    "AnnotatedExpression",
    "Annotation",
    "Annotation*",
    "Annotation+",
    "AnnotationParams",
    "AnnotationParams?",
    "AnnotationParamsPart",
    "AnnotationParamsPart*",
    "AnnotationParamsPart+",
    "AtomExpression",
    "Concatenation",
    "Declaration",
    "Declaration+",
    "DeclarationType",
    "DeclarationType?",
    "EBNF",
    "Expression",
    "ExpressionAnnotation",
    "ExpressionAnnotation+",
    "ExpressionList",
    "ExpressionList?",
    "ExpressionName",
    "ExpressionName?",
    "ExpressionPrefix",
    "ExpressionPrefix*",
    "ExpressionPrefix+",
    "Import",
    "MacroInstance",
    "MacroParameter",
    "MacroParameters",
    "MacroParameters?",
    "MacroParametersPart",
    "MacroParametersPart?",
    "MatchDeclaration",
    "Name",
    "NegativeLookahead",
    "OptionDeclaration",
    "Optional",
    "ParenExpression",
    "PostfixExpression",
    "ProductionAnnotation",
    "ProductionAnnotation+",
    "Repetition",
    "RepetitionPlus",
    "SubToken",
    "Symbol",
    "SymbolDeclaration",
    "Token",
    "TokenMinus",
    "TokenMinus+",
    "Tuple",
    "UnpackVariadicList",
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
    auto reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(0/*@regArray_ExpressionAnnotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(0)(parseStart, end);
        }
        return ParseStackElem!(Location, NonterminalType!(0/*@regArray_ExpressionAnnotation**/))(parseStart, pt);
    }

    auto reduce1/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(0/*@regArray_ExpressionAnnotation**/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(0/*@regArray_ExpressionAnnotation**/))(parseStart, pt);
    }

    auto reduce2/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray =*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(1/*@regArray_ProductionAnnotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(2)(parseStart, end);
        }
        return ParseStackElem!(Location, NonterminalType!(1/*@regArray_ProductionAnnotation**/))(parseStart, pt);
    }

    auto reduce3/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(1/*@regArray_ProductionAnnotation**/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(1/*@regArray_ProductionAnnotation**/))(parseStart, pt);
    }

    auto reduce4/*@regArray_ProductionAnnotation+ @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack1)
    {
        NonterminalType!(2/*@regArray_ProductionAnnotation+*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(2/*@regArray_ProductionAnnotation+*/))(parseStart, pt);
    }

    auto reduce5_Alternation/*Alternation = <Concatenation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!14) stack1)
    {
        NonterminalType!(3/*Alternation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(3/*Alternation*/))(parseStart, pt);
    }

    auto reduce6_Alternation/*Alternation = Alternation "|" Concatenation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!3) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14) stack1)
    {
        NonterminalType!(3/*Alternation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(6)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(3/*Alternation*/))(parseStart, pt);
    }

    auto reduce7_AnnotatedExpression/*AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!0) stack4, ParseStackElem!(Location, NonterminalType!26) stack3, ParseStackElem!(Location, NonterminalType!28) stack2, ParseStackElem!(Location, NonterminalType!43) stack1)
    {
        NonterminalType!(4/*AnnotatedExpression*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(7)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(4/*AnnotatedExpression*/))(parseStart, pt);
    }

    auto reduce8_Annotation/*Annotation = "@" Identifier AnnotationParams?*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!9) stack1)
    {
        NonterminalType!(5/*Annotation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(8)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(5/*Annotation*/))(parseStart, pt);
    }

    auto reduce9/*Annotation* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(6/*Annotation**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(6/*Annotation**/))(parseStart, pt);
    }

    auto reduce10/*Annotation* @array = Annotation+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!7) stack1)
    {
        NonterminalType!(6/*Annotation**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(10)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(6/*Annotation**/))(parseStart, pt);
    }

    auto reduce11/*Annotation+ @array = Annotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(7/*Annotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(11)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(7/*Annotation+*/))(parseStart, pt);
    }

    auto reduce12/*Annotation+ @array = Annotation+ Annotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!7) stack2, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(7/*Annotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(12)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(7/*Annotation+*/))(parseStart, pt);
    }

    auto reduce13_AnnotationParams/*AnnotationParams = "(" AnnotationParamsPart* ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!11) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(8/*AnnotationParams*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(13)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(8/*AnnotationParams*/))(parseStart, pt);
    }

    auto reduce14/*AnnotationParams? = <AnnotationParams [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!8) stack1)
    {
        NonterminalType!(9/*AnnotationParams?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(9/*AnnotationParams?*/))(parseStart, pt);
    }

    auto reduce15/*AnnotationParams? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(9/*AnnotationParams?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(9/*AnnotationParams?*/))(parseStart, pt);
    }

    auto reduce16_AnnotationParamsPart/*AnnotationParamsPart = StringLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(16)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce17_AnnotationParamsPart/*AnnotationParamsPart = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(17)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce18_AnnotationParamsPart/*AnnotationParamsPart = CharacterSetLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(18)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce19_AnnotationParamsPart/*AnnotationParamsPart = IntegerLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(19)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce20_AnnotationParamsPart/*AnnotationParamsPart = "(" AnnotationParamsPart* ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!11) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(20)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce21_AnnotationParamsPart/*AnnotationParamsPart = "="*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(21)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce22_AnnotationParamsPart/*AnnotationParamsPart = ":"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(22)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce23_AnnotationParamsPart/*AnnotationParamsPart = ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(23)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce24_AnnotationParamsPart/*AnnotationParamsPart = ","*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(24)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce25_AnnotationParamsPart/*AnnotationParamsPart = "{"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(25)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce26_AnnotationParamsPart/*AnnotationParamsPart = "}"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(26)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce27_AnnotationParamsPart/*AnnotationParamsPart = "?"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(27)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce28_AnnotationParamsPart/*AnnotationParamsPart = "!"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(28)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce29_AnnotationParamsPart/*AnnotationParamsPart = "<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(29)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce30_AnnotationParamsPart/*AnnotationParamsPart = ">"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(30)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce31_AnnotationParamsPart/*AnnotationParamsPart = "*"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(31)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce32_AnnotationParamsPart/*AnnotationParamsPart = ">>"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(32)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce33_AnnotationParamsPart/*AnnotationParamsPart = "<<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(33)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce34_AnnotationParamsPart/*AnnotationParamsPart = "-"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(10/*AnnotationParamsPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(34)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(10/*AnnotationParamsPart*/))(parseStart, pt);
    }

    auto reduce35/*AnnotationParamsPart* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(11/*AnnotationParamsPart**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(11/*AnnotationParamsPart**/))(parseStart, pt);
    }

    auto reduce36/*AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!12) stack1)
    {
        NonterminalType!(11/*AnnotationParamsPart**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(36)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(11/*AnnotationParamsPart**/))(parseStart, pt);
    }

    auto reduce37/*AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(37)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart+*/))(parseStart, pt);
    }

    auto reduce38/*AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!12) stack2, ParseStackElem!(Location, NonterminalType!10) stack1)
    {
        NonterminalType!(12/*AnnotationParamsPart+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(38)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(12/*AnnotationParamsPart+*/))(parseStart, pt);
    }

    auto reduce39_AtomExpression/*AtomExpression = <Symbol*/(Location parseStart, ParseStackElem!(Location, NonterminalType!49) stack1)
    {
        NonterminalType!(13/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(13/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce40_AtomExpression/*AtomExpression = <ParenExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!42) stack1)
    {
        NonterminalType!(13/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(13/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce41_AtomExpression/*AtomExpression = <SubToken*/(Location parseStart, ParseStackElem!(Location, NonterminalType!48) stack1)
    {
        NonterminalType!(13/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(13/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce42_AtomExpression/*AtomExpression = <UnpackVariadicList*/(Location parseStart, ParseStackElem!(Location, NonterminalType!55) stack1)
    {
        NonterminalType!(13/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(13/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce43_AtomExpression/*AtomExpression = <Tuple*/(Location parseStart, ParseStackElem!(Location, NonterminalType!54) stack1)
    {
        NonterminalType!(13/*AtomExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(13/*AtomExpression*/))(parseStart, pt);
    }

    auto reduce44_Concatenation/*Concatenation = <TokenMinus*/(Location parseStart, ParseStackElem!(Location, NonterminalType!52) stack1)
    {
        NonterminalType!(14/*Concatenation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(14/*Concatenation*/))(parseStart, pt);
    }

    auto reduce45_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(Location parseStart, ParseStackElem!(Location, NonterminalType!52) stack3, ParseStackElem!(Location, NonterminalType!53) stack2, ParseStackElem!(Location, NonterminalType!1) stack1)
    {
        NonterminalType!(14/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(45)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(14/*Concatenation*/))(parseStart, pt);
    }

    auto reduce46_Concatenation/*Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!52) stack2, ParseStackElem!(Location, NonterminalType!2) stack1)
    {
        NonterminalType!(14/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(46)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(14/*Concatenation*/))(parseStart, pt);
    }

    auto reduce47_Concatenation/*Concatenation = @regArray @regArray_ProductionAnnotation+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!2) stack1)
    {
        NonterminalType!(14/*Concatenation*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(47)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(14/*Concatenation*/))(parseStart, pt);
    }

    auto reduce48_Declaration/*Declaration = <SymbolDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!50) stack1)
    {
        NonterminalType!(15/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(15/*Declaration*/))(parseStart, pt);
    }

    auto reduce49_Declaration/*Declaration = <MatchDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!37) stack1)
    {
        NonterminalType!(15/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(15/*Declaration*/))(parseStart, pt);
    }

    auto reduce50_Declaration/*Declaration = <Import*/(Location parseStart, ParseStackElem!(Location, NonterminalType!30) stack1)
    {
        NonterminalType!(15/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(15/*Declaration*/))(parseStart, pt);
    }

    auto reduce51_Declaration/*Declaration = <OptionDeclaration*/(Location parseStart, ParseStackElem!(Location, NonterminalType!40) stack1)
    {
        NonterminalType!(15/*Declaration*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(15/*Declaration*/))(parseStart, pt);
    }

    auto reduce52/*Declaration+ @array = Declaration [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!15) stack1)
    {
        NonterminalType!(16/*Declaration+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(52)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(16/*Declaration+*/))(parseStart, pt);
    }

    auto reduce53/*Declaration+ @array = Declaration+ Declaration [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!16) stack2, ParseStackElem!(Location, NonterminalType!15) stack1)
    {
        NonterminalType!(16/*Declaration+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(53)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(16/*Declaration+*/))(parseStart, pt);
    }

    auto reduce54_DeclarationType/*DeclarationType = "fragment"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(17/*DeclarationType*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(54)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(17/*DeclarationType*/))(parseStart, pt);
    }

    auto reduce55_DeclarationType/*DeclarationType = "token"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(17/*DeclarationType*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(55)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(17/*DeclarationType*/))(parseStart, pt);
    }

    auto reduce56/*DeclarationType? = <DeclarationType [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!17) stack1)
    {
        NonterminalType!(18/*DeclarationType?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(18/*DeclarationType?*/))(parseStart, pt);
    }

    auto reduce57/*DeclarationType? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(18/*DeclarationType?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(18/*DeclarationType?*/))(parseStart, pt);
    }

    auto reduce58_EBNF/*EBNF = Declaration+*/(Location parseStart, ParseStackElem!(Location, NonterminalType!16) stack1)
    {
        NonterminalType!(19/*EBNF*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(58)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(19/*EBNF*/))(parseStart, pt);
    }

    auto reduce59_Expression/*Expression = <Alternation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!3) stack1)
    {
        NonterminalType!(20/*Expression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(20/*Expression*/))(parseStart, pt);
    }

    auto reduce60_ExpressionAnnotation/*ExpressionAnnotation @directUnwrap = <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(21/*ExpressionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(21/*ExpressionAnnotation*/))(parseStart, pt);
    }

    auto reduce61_ExpressionAnnotation/*ExpressionAnnotation @directUnwrap = <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!39) stack1)
    {
        NonterminalType!(21/*ExpressionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(21/*ExpressionAnnotation*/))(parseStart, pt);
    }

    auto reduce62/*ExpressionAnnotation+ @array = ExpressionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!21) stack1)
    {
        NonterminalType!(22/*ExpressionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(62)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(22/*ExpressionAnnotation+*/))(parseStart, pt);
    }

    auto reduce63/*ExpressionAnnotation+ @array = ExpressionAnnotation+ ExpressionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!22) stack2, ParseStackElem!(Location, NonterminalType!21) stack1)
    {
        NonterminalType!(22/*ExpressionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(63)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(22/*ExpressionAnnotation+*/))(parseStart, pt);
    }

    auto reduce64_ExpressionList/*ExpressionList @array = Expression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!20) stack1)
    {
        NonterminalType!(23/*ExpressionList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(64)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(23/*ExpressionList*/))(parseStart, pt);
    }

    auto reduce65_ExpressionList/*ExpressionList @array = ExpressionList "," Expression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!23) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!20) stack1)
    {
        NonterminalType!(23/*ExpressionList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(65)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(23/*ExpressionList*/))(parseStart, pt);
    }

    auto reduce66/*ExpressionList? = <ExpressionList [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!23) stack1)
    {
        NonterminalType!(24/*ExpressionList?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(24/*ExpressionList?*/))(parseStart, pt);
    }

    auto reduce67/*ExpressionList? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(24/*ExpressionList?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(24/*ExpressionList?*/))(parseStart, pt);
    }

    auto reduce68_ExpressionName/*ExpressionName = Identifier ":"*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(25/*ExpressionName*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(68)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(25/*ExpressionName*/))(parseStart, pt);
    }

    auto reduce69/*ExpressionName? = <ExpressionName [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!25) stack1)
    {
        NonterminalType!(26/*ExpressionName?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(26/*ExpressionName?*/))(parseStart, pt);
    }

    auto reduce70/*ExpressionName? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(26/*ExpressionName?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(26/*ExpressionName?*/))(parseStart, pt);
    }

    auto reduce71_ExpressionPrefix/*ExpressionPrefix = "<"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(27/*ExpressionPrefix*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(71)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(27/*ExpressionPrefix*/))(parseStart, pt);
    }

    auto reduce72_ExpressionPrefix/*ExpressionPrefix = "^"*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(27/*ExpressionPrefix*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(72)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(27/*ExpressionPrefix*/))(parseStart, pt);
    }

    auto reduce73/*ExpressionPrefix* @array = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(28/*ExpressionPrefix**/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(28/*ExpressionPrefix**/))(parseStart, pt);
    }

    auto reduce74/*ExpressionPrefix* @array = ExpressionPrefix+ [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!29) stack1)
    {
        NonterminalType!(28/*ExpressionPrefix**/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(74)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(28/*ExpressionPrefix**/))(parseStart, pt);
    }

    auto reduce75/*ExpressionPrefix+ @array = ExpressionPrefix [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!27) stack1)
    {
        NonterminalType!(29/*ExpressionPrefix+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(75)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(29/*ExpressionPrefix+*/))(parseStart, pt);
    }

    auto reduce76/*ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!29) stack2, ParseStackElem!(Location, NonterminalType!27) stack1)
    {
        NonterminalType!(29/*ExpressionPrefix+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(76)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(29/*ExpressionPrefix+*/))(parseStart, pt);
    }

    auto reduce77_Import/*Import = "import" StringLiteral ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(30/*Import*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(77)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(30/*Import*/))(parseStart, pt);
    }

    auto reduce78_MacroInstance/*MacroInstance = Identifier "(" ExpressionList? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!24) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(31/*MacroInstance*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(78)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(31/*MacroInstance*/))(parseStart, pt);
    }

    auto reduce79_MacroParameter/*MacroParameter = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(32/*MacroParameter*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(79)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(32/*MacroParameter*/))(parseStart, pt);
    }

    auto reduce80_MacroParameter/*MacroParameter = Identifier "..."*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(32/*MacroParameter*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(80)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(32/*MacroParameter*/))(parseStart, pt);
    }

    auto reduce81_MacroParameters/*MacroParameters @array = MacroParameter*/(Location parseStart, ParseStackElem!(Location, NonterminalType!32) stack1)
    {
        NonterminalType!(33/*MacroParameters*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(81)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(33/*MacroParameters*/))(parseStart, pt);
    }

    auto reduce82_MacroParameters/*MacroParameters @array = MacroParameters "," MacroParameter*/(Location parseStart, ParseStackElem!(Location, NonterminalType!33) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!32) stack1)
    {
        NonterminalType!(33/*MacroParameters*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(82)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(33/*MacroParameters*/))(parseStart, pt);
    }

    auto reduce83/*MacroParameters? = <MacroParameters [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!33) stack1)
    {
        NonterminalType!(34/*MacroParameters?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(34/*MacroParameters?*/))(parseStart, pt);
    }

    auto reduce84/*MacroParameters? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(34/*MacroParameters?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(34/*MacroParameters?*/))(parseStart, pt);
    }

    auto reduce85_MacroParametersPart/*MacroParametersPart = "(" MacroParameters? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!34) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(35/*MacroParametersPart*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(85)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(35/*MacroParametersPart*/))(parseStart, pt);
    }

    auto reduce86/*MacroParametersPart? = <MacroParametersPart [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!35) stack1)
    {
        NonterminalType!(36/*MacroParametersPart?*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(36/*MacroParametersPart?*/))(parseStart, pt);
    }

    auto reduce87/*MacroParametersPart? = [virtual]*/()
    {
        Location parseStart = lastTokenEnd;
        NonterminalType!(36/*MacroParametersPart?*/) pt;
        pt = typeof(pt).init;
        return ParseStackElem!(Location, NonterminalType!(36/*MacroParametersPart?*/))(parseStart, pt);
    }

    auto reduce88_MatchDeclaration/*MatchDeclaration = "match" Symbol Symbol ";"*/(Location parseStart, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!49) stack3, ParseStackElem!(Location, NonterminalType!49) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(37/*MatchDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(88)(parseStart, end, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(37/*MatchDeclaration*/))(parseStart, pt);
    }

    auto reduce89_Name/*Name = Identifier*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(38/*Name*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(89)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(38/*Name*/))(parseStart, pt);
    }

    auto reduce90_NegativeLookahead/*NegativeLookahead = "!" Symbol*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!49) stack1)
    {
        NonterminalType!(39/*NegativeLookahead*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(90)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(39/*NegativeLookahead*/))(parseStart, pt);
    }

    auto reduce91_NegativeLookahead/*NegativeLookahead = "!" "anytoken"*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(39/*NegativeLookahead*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(91)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(39/*NegativeLookahead*/))(parseStart, pt);
    }

    auto reduce92_OptionDeclaration/*OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"*/(Location parseStart/*, ParseStackElem!(Location, Token) stack5*/, ParseStackElem!(Location, Token) stack4/*, ParseStackElem!(Location, Token) stack3*/, ParseStackElem!(Location, Token) stack2/*, ParseStackElem!(Location, Token) stack1*/)
    {
        NonterminalType!(40/*OptionDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(92)(parseStart, end, stack4, stack2);
        }
        return ParseStackElem!(Location, NonterminalType!(40/*OptionDeclaration*/))(parseStart, pt);
    }

    auto reduce93_Optional/*Optional = PostfixExpression "?"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!43) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(41/*Optional*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(93)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(41/*Optional*/))(parseStart, pt);
    }

    auto reduce94_ParenExpression/*ParenExpression = "{" Expression "}"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!20) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(42/*ParenExpression*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(94)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(42/*ParenExpression*/))(parseStart, pt);
    }

    auto reduce95_PostfixExpression/*PostfixExpression = <Optional*/(Location parseStart, ParseStackElem!(Location, NonterminalType!41) stack1)
    {
        NonterminalType!(43/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(43/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce96_PostfixExpression/*PostfixExpression = <Repetition*/(Location parseStart, ParseStackElem!(Location, NonterminalType!46) stack1)
    {
        NonterminalType!(43/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(43/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce97_PostfixExpression/*PostfixExpression = <RepetitionPlus*/(Location parseStart, ParseStackElem!(Location, NonterminalType!47) stack1)
    {
        NonterminalType!(43/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(43/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce98_PostfixExpression/*PostfixExpression = <AtomExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!13) stack1)
    {
        NonterminalType!(43/*PostfixExpression*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(43/*PostfixExpression*/))(parseStart, pt);
    }

    auto reduce99_ProductionAnnotation/*ProductionAnnotation @directUnwrap = <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(44/*ProductionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(44/*ProductionAnnotation*/))(parseStart, pt);
    }

    auto reduce100_ProductionAnnotation/*ProductionAnnotation @directUnwrap = <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!39) stack1)
    {
        NonterminalType!(44/*ProductionAnnotation*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(44/*ProductionAnnotation*/))(parseStart, pt);
    }

    auto reduce101/*ProductionAnnotation+ @array = ProductionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!44) stack1)
    {
        NonterminalType!(45/*ProductionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(101)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(45/*ProductionAnnotation+*/))(parseStart, pt);
    }

    auto reduce102/*ProductionAnnotation+ @array = ProductionAnnotation+ ProductionAnnotation [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!45) stack2, ParseStackElem!(Location, NonterminalType!44) stack1)
    {
        NonterminalType!(45/*ProductionAnnotation+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(102)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(45/*ProductionAnnotation+*/))(parseStart, pt);
    }

    auto reduce103_Repetition/*Repetition = PostfixExpression "*"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!43) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(46/*Repetition*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(103)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(46/*Repetition*/))(parseStart, pt);
    }

    auto reduce104_RepetitionPlus/*RepetitionPlus = PostfixExpression "+"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!43) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(47/*RepetitionPlus*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(104)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(47/*RepetitionPlus*/))(parseStart, pt);
    }

    auto reduce105_SubToken/*SubToken = Symbol ">>" Symbol*/(Location parseStart, ParseStackElem!(Location, NonterminalType!49) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!49) stack1)
    {
        NonterminalType!(48/*SubToken*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(105)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(48/*SubToken*/))(parseStart, pt);
    }

    auto reduce106_SubToken/*SubToken = Symbol ">>" ParenExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!49) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!42) stack1)
    {
        NonterminalType!(48/*SubToken*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(106)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(48/*SubToken*/))(parseStart, pt);
    }

    auto reduce107_Symbol/*Symbol = <Name*/(Location parseStart, ParseStackElem!(Location, NonterminalType!38) stack1)
    {
        NonterminalType!(49/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(49/*Symbol*/))(parseStart, pt);
    }

    auto reduce108_Symbol/*Symbol = <Token*/(Location parseStart, ParseStackElem!(Location, NonterminalType!51) stack1)
    {
        NonterminalType!(49/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(49/*Symbol*/))(parseStart, pt);
    }

    auto reduce109_Symbol/*Symbol = <MacroInstance*/(Location parseStart, ParseStackElem!(Location, NonterminalType!31) stack1)
    {
        NonterminalType!(49/*Symbol*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(49/*Symbol*/))(parseStart, pt);
    }

    auto reduce110_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!36) stack3, ParseStackElem!(Location, NonterminalType!6) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(50/*SymbolDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(110)(parseStart, end, stack5, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(50/*SymbolDeclaration*/))(parseStart, pt);
    }

    auto reduce111_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"*/(Location parseStart, ParseStackElem!(Location, NonterminalType!18) stack7, ParseStackElem!(Location, Token) stack6, ParseStackElem!(Location, NonterminalType!36) stack5, ParseStackElem!(Location, NonterminalType!6) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!20) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(50/*SymbolDeclaration*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(111)(parseStart, end, stack7, stack6, stack5, stack4, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(50/*SymbolDeclaration*/))(parseStart, pt);
    }

    auto reduce112_Token/*Token = StringLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(51/*Token*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(112)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(51/*Token*/))(parseStart, pt);
    }

    auto reduce113_Token/*Token = CharacterSetLiteral*/(Location parseStart, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(51/*Token*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(113)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(51/*Token*/))(parseStart, pt);
    }

    auto reduce114_TokenMinus/*TokenMinus = <AnnotatedExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!4) stack1)
    {
        NonterminalType!(52/*TokenMinus*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(52/*TokenMinus*/))(parseStart, pt);
    }

    auto reduce115_TokenMinus/*TokenMinus = TokenMinus "-" AnnotatedExpression*/(Location parseStart, ParseStackElem!(Location, NonterminalType!52) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!4) stack1)
    {
        NonterminalType!(52/*TokenMinus*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(115)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(52/*TokenMinus*/))(parseStart, pt);
    }

    auto reduce116/*TokenMinus+ @array = TokenMinus [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!52) stack1)
    {
        NonterminalType!(53/*TokenMinus+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(116)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(53/*TokenMinus+*/))(parseStart, pt);
    }

    auto reduce117/*TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]*/(Location parseStart, ParseStackElem!(Location, NonterminalType!53) stack2, ParseStackElem!(Location, NonterminalType!52) stack1)
    {
        NonterminalType!(53/*TokenMinus+*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(117)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(53/*TokenMinus+*/))(parseStart, pt);
    }

    auto reduce118_Tuple/*Tuple = "t(" ExpressionList? ")"*/(Location parseStart, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!24) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(54/*Tuple*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(118)(parseStart, end, stack3, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(54/*Tuple*/))(parseStart, pt);
    }

    auto reduce119_UnpackVariadicList/*UnpackVariadicList = Identifier "..."*/(Location parseStart, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        NonterminalType!(55/*UnpackVariadicList*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(119)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(55/*UnpackVariadicList*/))(parseStart, pt);
    }

    auto reduce120/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!57) stack2, ParseStackElem!(Location, NonterminalType!59) stack1)
    {
        NonterminalType!(57/*$regarray_1*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(120)(parseStart, end, stack2, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(57/*$regarray_1*/))(parseStart, pt);
    }

    auto reduce121/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1*/(Location parseStart, ParseStackElem!(Location, NonterminalType!58) stack1)
    {
        NonterminalType!(57/*$regarray_1*/) pt;
        {
            Location end = lastTokenEnd;
            if (end < parseStart)
                end = parseStart;

            pt = creator.createParseTree!(121)(parseStart, end, stack1);
        }
        return ParseStackElem!(Location, NonterminalType!(57/*$regarray_1*/))(parseStart, pt);
    }

    auto reduce122/*$regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(58/*$regarrayedge_0_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(58/*$regarrayedge_0_1*/))(parseStart, pt);
    }

    auto reduce123/*$regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!39) stack1)
    {
        NonterminalType!(58/*$regarrayedge_0_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(58/*$regarrayedge_0_1*/))(parseStart, pt);
    }

    auto reduce124/*$regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <Annotation*/(Location parseStart, ParseStackElem!(Location, NonterminalType!5) stack1)
    {
        NonterminalType!(59/*$regarrayedge_1_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(59/*$regarrayedge_1_1*/))(parseStart, pt);
    }

    auto reduce125/*$regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead*/(Location parseStart, ParseStackElem!(Location, NonterminalType!39) stack1)
    {
        NonterminalType!(59/*$regarrayedge_1_1*/) pt;
        pt = stack1.val;
        parseStart = stack1.start;
        return ParseStackElem!(Location, NonterminalType!(59/*$regarrayedge_1_1*/))(parseStart, pt);
    }

    // path: EBNF
    // type: unknown
    //  EBNF              -> .EBNF {$end} startElement
    //  EBNF              -> .Declaration+ {$end}
    //  Declaration       -> .Import {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       -> .MatchDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       -> .OptionDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       -> .SymbolDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration+      -> .Declaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration+      -> .Declaration+ Declaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  DeclarationType   -> ."fragment" {Identifier}
    //  DeclarationType   -> ."token" {Identifier}
    //  DeclarationType?  -> . {Identifier}
    //  Import            -> ."import" StringLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  MatchDeclaration  -> ."match" Symbol Symbol ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  OptionDeclaration -> ."option" Identifier "=" IntegerLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration -> .DeclarationType? Identifier MacroParametersPart? Annotation* ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration -> .DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  DeclarationType? ---> DeclarationType
    int parseEBNF/*0*/(ref NonterminalType!(19) result, ref Location resultLocation)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([15, 16, 17, 18, 19, 30, 37, 40, 50]);
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
            NonterminalType!(17) r;
            Location rl;
            gotoParent = parse123(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(17/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"import"})
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse124(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Import*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"match"})
        {
            auto next = popToken();
            NonterminalType!(37) r;
            Location rl;
            gotoParent = parse127(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(37/*MatchDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"option"})
        {
            auto next = popToken();
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse131(r, rl, currentStart/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(40/*OptionDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"token"})
        {
            auto next = popToken();
            NonterminalType!(17) r;
            Location rl;
            gotoParent = parse136(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(17/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce57/*DeclarationType? = [virtual]*/();
            currentResult = ParseResultIn.create(18/*DeclarationType?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 15/*Declaration*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Declaration*/)(currentResultLocation, currentResult.get!(15/*Declaration*/)());
                NonterminalType!(16) r;
                Location rl;
                gotoParent = parse1(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(16/*Declaration+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 16/*Declaration+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!16/*Declaration+*/)(currentResultLocation, currentResult.get!(16/*Declaration+*/)());
                CreatorInstance.NonterminalUnion!([16, 19]) r;
                Location rl;
                gotoParent = parse2(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 17/*DeclarationType*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/)(currentResultLocation, currentResult.get!(17/*DeclarationType*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(50/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 18/*DeclarationType?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/)(currentResultLocation, currentResult.get!(18/*DeclarationType?*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(50/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 19/*EBNF*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!19/*EBNF*/)(currentResultLocation, currentResult.get!(19/*EBNF*/)());
                NonterminalType!(19) r;
                Location rl;
                gotoParent = parse141(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                auto tree = r;
                result = tree;
                resultLocation = rl;
                return 0;
            }
            else if (currentResult.nonterminalID == 30/*Import*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(30/*Import*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 37/*MatchDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(37/*MatchDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 40/*OptionDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(40/*OptionDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 50/*SymbolDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(50/*SymbolDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        auto tree = currentResult.get!(19);
        result = tree;
        resultLocation = currentResultLocation;
        return 0;
    }
    // path: EBNF Declaration
    // type: unknown
    //  Declaration+ ->  Declaration. {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse1(ref NonterminalType!(16) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!15/*Declaration*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce52/*Declaration+ @array = Declaration [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+
    // type: unknown
    //  Declaration+      ->  Declaration+.Declaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  EBNF              ->  Declaration+. {$end}
    //  Declaration       ->              .Import {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       ->              .MatchDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       ->              .OptionDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Declaration       ->              .SymbolDeclaration {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  DeclarationType   ->              ."fragment" {Identifier}
    //  DeclarationType   ->              ."token" {Identifier}
    //  DeclarationType?  ->              . {Identifier}
    //  Import            ->              ."import" StringLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  MatchDeclaration  ->              ."match" Symbol Symbol ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  OptionDeclaration ->              ."option" Identifier "=" IntegerLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration ->              .DeclarationType? Identifier MacroParametersPart? Annotation* ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration ->              .DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  DeclarationType? ---> DeclarationType
    private int parse2(ref CreatorInstance.NonterminalUnion!([16, 19]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!16/*Declaration+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([15, 16, 17, 18, 19, 30, 37, 40, 50]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            auto tmp = reduce58_EBNF/*EBNF = Declaration+*/(parseStart1, stack1);
            result = ThisParseResult.create(19/*EBNF*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"fragment"})
        {
            auto next = popToken();
            NonterminalType!(17) r;
            Location rl;
            gotoParent = parse123(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(17/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"import"})
        {
            auto next = popToken();
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse124(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(30/*Import*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"match"})
        {
            auto next = popToken();
            NonterminalType!(37) r;
            Location rl;
            gotoParent = parse127(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(37/*MatchDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"option"})
        {
            auto next = popToken();
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse131(r, rl, currentStart/*, next*/);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(40/*OptionDeclaration*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"token"})
        {
            auto next = popToken();
            NonterminalType!(17) r;
            Location rl;
            gotoParent = parse136(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(17/*DeclarationType*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto tmp = reduce57/*DeclarationType? = [virtual]*/();
            currentResult = ParseResultIn.create(18/*DeclarationType?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else
        {
            auto tmp = reduce58_EBNF/*EBNF = Declaration+*/(parseStart1, stack1);
            result = ThisParseResult.create(19/*EBNF*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 15/*Declaration*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!15/*Declaration*/)(currentResultLocation, currentResult.get!(15/*Declaration*/)());
                NonterminalType!(16) r;
                Location rl;
                gotoParent = parse3(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(16/*Declaration+*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 17/*DeclarationType*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/)(currentResultLocation, currentResult.get!(17/*DeclarationType*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(50/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 18/*DeclarationType?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/)(currentResultLocation, currentResult.get!(18/*DeclarationType?*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse4(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(50/*SymbolDeclaration*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 30/*Import*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(30/*Import*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 37/*MatchDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(37/*MatchDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 40/*OptionDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(40/*OptionDeclaration*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 50/*SymbolDeclaration*/)
            {
                currentResult = ParseResultIn.create(15/*Declaration*/, currentResult.get!(50/*SymbolDeclaration*/));
                currentResultLocation = currentResultLocation;
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
    //  Declaration+ ->  Declaration+ Declaration. {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse3(ref NonterminalType!(16) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!16/*Declaration+*/) stack2, ParseStackElem!(Location, NonterminalType!15/*Declaration*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce53/*Declaration+ @array = Declaration+ Declaration [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType?.Identifier MacroParametersPart? Annotation* ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration ->  DeclarationType?.Identifier MacroParametersPart? Annotation* "=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse4(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([50]);
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
            NonterminalType!(50) r;
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
    // path: EBNF Declaration+ DeclarationType Identifier
    // type: unknown
    //  SymbolDeclaration    ->  DeclarationType? Identifier.MacroParametersPart? Annotation* ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration    ->  DeclarationType? Identifier.MacroParametersPart? Annotation* "=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  MacroParametersPart  ->                             ."(" MacroParameters? ")" {";", "=", "@"}
    //  MacroParametersPart? ->                             . {";", "=", "@"}
    //  MacroParametersPart? ---> MacroParametersPart
    private int parse5(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([35, 36, 50]);
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
            NonterminalType!(35) r;
            Location rl;
            gotoParent = parse6(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(35/*MacroParametersPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce87/*MacroParametersPart? = [virtual]*/();
            currentResult = ParseResultIn.create(36/*MacroParametersPart?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 35/*MacroParametersPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/)(currentResultLocation, currentResult.get!(35/*MacroParametersPart*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse15(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 36/*MacroParametersPart?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/)(currentResultLocation, currentResult.get!(36/*MacroParametersPart?*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse15(r, rl, parseStart2, stack2, stack1, next);
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

        result = currentResult.get!(50/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier "("
    // type: unknown
    //  MacroParametersPart ->  "(".MacroParameters? ")" {";", "=", "@"}
    //  MacroParameter      ->     .Identifier {")", ","}
    //  MacroParameter      ->     .Identifier "..." {")", ","}
    //  MacroParameters     ->     .MacroParameter {")", ","}
    //  MacroParameters     ->     .MacroParameters "," MacroParameter {")", ","}
    //  MacroParameters?    ->     . {")"}
    //  MacroParameters? ---> MacroParameters
    private int parse6(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([32, 33, 34, 35]);
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
            NonterminalType!(32) r;
            Location rl;
            gotoParent = parse7(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(32/*MacroParameter*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce84/*MacroParameters? = [virtual]*/();
            currentResult = ParseResultIn.create(34/*MacroParameters?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 32/*MacroParameter*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!32/*MacroParameter*/)(currentResultLocation, currentResult.get!(32/*MacroParameter*/)());
                NonterminalType!(33) r;
                Location rl;
                gotoParent = parse9(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(33/*MacroParameters*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 33/*MacroParameters*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(33/*MacroParameters*/)());
                CreatorInstance.NonterminalUnion!([33, 35]) r;
                Location rl;
                gotoParent = parse10(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 34/*MacroParameters?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!34/*MacroParameters?*/)(currentResultLocation, currentResult.get!(34/*MacroParameters?*/)());
                NonterminalType!(35) r;
                Location rl;
                gotoParent = parse14(r, rl, parseStart1, stack1, next);
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

        result = currentResult.get!(35/*MacroParametersPart*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" Identifier
    // type: unknown
    //  MacroParameter ->  Identifier. {")", ","}
    //  MacroParameter ->  Identifier."..." {")", ","}
    private int parse7(ref NonterminalType!(32) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([32]);
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
            NonterminalType!(32) r;
            Location rl;
            gotoParent = parse8(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce79_MacroParameter/*MacroParameter = Identifier*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" Identifier "..."
    // type: unknown
    //  MacroParameter ->  Identifier "...". {")", ","}
    private int parse8(ref NonterminalType!(32) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce80_MacroParameter/*MacroParameter = Identifier "..."*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameter
    // type: unknown
    //  MacroParameters ->  MacroParameter. {")", ","}
    private int parse9(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!32/*MacroParameter*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce81_MacroParameters/*MacroParameters @array = MacroParameter*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameters
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters?.")" {";", "=", "@"}
    //  MacroParameters     ->       MacroParameters."," MacroParameter {")", ","}
    private int parse10(ref CreatorInstance.NonterminalUnion!([33, 35]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
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
            NonterminalType!(35) r;
            Location rl;
            gotoParent = parse11(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(35/*MacroParametersPart*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(33) r;
            Location rl;
            gotoParent = parse12(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(33/*MacroParameters*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameters ")"
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters? ")". {";", "=", "@"}
    private int parse11(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!34/*MacroParameters?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce85_MacroParametersPart/*MacroParametersPart = "(" MacroParameters? ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameters ","
    // type: unknown
    //  MacroParameters ->  MacroParameters ",".MacroParameter {")", ","}
    //  MacroParameter  ->                     .Identifier {")", ","}
    //  MacroParameter  ->                     .Identifier "..." {")", ","}
    private int parse12(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!33/*MacroParameters*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([32, 33]);
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
            NonterminalType!(32) r;
            Location rl;
            gotoParent = parse7(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(32/*MacroParameter*/, r);
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
            if (currentResult.nonterminalID == 32/*MacroParameter*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!32/*MacroParameter*/)(currentResultLocation, currentResult.get!(32/*MacroParameter*/)());
                NonterminalType!(33) r;
                Location rl;
                gotoParent = parse13(r, rl, parseStart2, stack2, stack1, next);
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

        result = currentResult.get!(33/*MacroParameters*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameters "," MacroParameter
    // type: unknown
    //  MacroParameters ->  MacroParameters "," MacroParameter. {")", ","}
    private int parse13(ref NonterminalType!(33) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!33/*MacroParameters*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!32/*MacroParameter*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce82_MacroParameters/*MacroParameters @array = MacroParameters "," MacroParameter*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier "(" MacroParameters?
    // type: unknown
    //  MacroParametersPart ->  "(" MacroParameters?.")" {";", "=", "@"}
    private int parse14(ref NonterminalType!(35) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!34/*MacroParameters?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([35]);
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
            NonterminalType!(35) r;
            Location rl;
            gotoParent = parse11(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart?.Annotation* ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart?.Annotation* "=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  Annotation        ->                                                  ."@" Identifier AnnotationParams? {";", "=", "@"}
    //  Annotation*       ->                                                  . {";", "="}
    //  Annotation*       ->                                                  .Annotation+ {";", "="}
    //  Annotation+       ->                                                  .Annotation {";", "=", "@"}
    //  Annotation+       ->                                                  .Annotation+ Annotation {";", "=", "@"}
    private int parse15(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([5, 6, 7, 50]);
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
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce9/*Annotation* @array = [virtual]*/();
            currentResult = ParseResultIn.create(6/*Annotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!5/*Annotation*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(7) r;
                Location rl;
                gotoParent = parse16(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(7/*Annotation+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 6/*Annotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!6/*Annotation**/)(currentResultLocation, currentResult.get!(6/*Annotation**/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse17(r, rl, parseStart3, stack3, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 7/*Annotation+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!7/*Annotation+*/)(currentResultLocation, currentResult.get!(7/*Annotation+*/)());
                CreatorInstance.NonterminalUnion!([6, 7]) r;
                Location rl;
                gotoParent = parse121(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(50/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation
    // type: unknown
    //  Annotation+ ->  Annotation. {";", "=", "@"}
    private int parse16(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!5/*Annotation*/) stack1)
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation*
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation*.";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation*."=" Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse17(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack2, ParseStackElem!(Location, NonterminalType!6/*Annotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([50]);
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
            NonterminalType!(50) r;
            Location rl;
            gotoParent = parse18(r, rl, parseStart4, stack4, stack3, stack2, stack1, next);
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
            NonterminalType!(50) r;
            Location rl;
            gotoParent = parse19(r, rl, parseStart4, stack4, stack3, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* ";"
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* ";". {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse18(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart5, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack3, ParseStackElem!(Location, NonterminalType!6/*Annotation**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce110_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"*/(parseStart5, stack5, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 4;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "="
    // type: unknown
    //  SymbolDeclaration               ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=".Expression ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  @regArray_ExpressionAnnotation* ->                                                                  . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Alternation                     ->                                                                  .Alternation "|" Concatenation {";", "|"}
    //  Alternation                     ->                                                                  .Concatenation {";", "|"}
    //  AnnotatedExpression             ->                                                                  .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", "-", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                                                                  ."@" Identifier AnnotationParams? {"!", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->                                                                  .@regArray_ProductionAnnotation+ {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus @regArray_ProductionAnnotation+ {";", "|"}
    //  Concatenation                   ->                                                                  .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {";", "|"}
    //  Expression                      ->                                                                  .Alternation {";"}
    //  NegativeLookahead               ->                                                                  ."!" Symbol {"!", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                                                                  ."!" "anytoken" {"!", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                                                                  .AnnotatedExpression {"!", "-", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                                                                  .TokenMinus "-" AnnotatedExpression {"!", "-", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                                                                  .$regarray_1 $regarrayedge_1_1 {"!", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                                                                  .$regarrayedge_0_1 {"!", ";", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse19(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart5, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack5, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack3, ParseStackElem!(Location, NonterminalType!6/*Annotation**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 20, 39, 50, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 3/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!3/*Alternation*/)(currentResultLocation, currentResult.get!(3/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([3, 20]) r;
                Location rl;
                gotoParent = parse33(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(3/*Alternation*/, currentResult.get!(14/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 20/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!20/*Expression*/)(currentResultLocation, currentResult.get!(20/*Expression*/)());
                NonterminalType!(50) r;
                Location rl;
                gotoParent = parse119(r, rl, parseStart5, stack5, stack4, stack3, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(50/*SymbolDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation*
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName      ->                                 .Identifier ":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName?     ->                                 . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName? ---> ExpressionName
    private int parse20(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 25, 26]);
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
                NonterminalType!(25) r;
                Location rl;
                gotoParent = parse73(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(25/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral"))
            {
                auto tmp = reduce70/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
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
            auto tmp = reduce70/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 25/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(25/*ExpressionName*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 26/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(26/*ExpressionName?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
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

        result = currentResult.get!(4/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName?.ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix    ->                                                 ."<" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix    ->                                                 ."^" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix*   ->                                                 . {"t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix*   ->                                                 .ExpressionPrefix+ {"t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix+   ->                                                 .ExpressionPrefix {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix+   ->                                                 .ExpressionPrefix+ ExpressionPrefix {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse21(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/) stack2, ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 27, 28, 29]);
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
            NonterminalType!(27) r;
            Location rl;
            gotoParent = parse22(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(27/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"^"})
        {
            auto next = popToken();
            NonterminalType!(27) r;
            Location rl;
            gotoParent = parse23(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(27/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce73/*ExpressionPrefix* @array = [virtual]*/();
            currentResult = ParseResultIn.create(28/*ExpressionPrefix**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 27/*ExpressionPrefix*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!27/*ExpressionPrefix*/)(currentResultLocation, currentResult.get!(27/*ExpressionPrefix*/)());
                NonterminalType!(29) r;
                Location rl;
                gotoParent = parse24(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(29/*ExpressionPrefix+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 28/*ExpressionPrefix**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!28/*ExpressionPrefix**/)(currentResultLocation, currentResult.get!(28/*ExpressionPrefix**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse25(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 29/*ExpressionPrefix+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!29/*ExpressionPrefix+*/)(currentResultLocation, currentResult.get!(29/*ExpressionPrefix+*/)());
                CreatorInstance.NonterminalUnion!([28, 29]) r;
                Location rl;
                gotoParent = parse117(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(4/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName "<"
    // type: unknown
    //  ExpressionPrefix ->  "<". {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse22(ref NonterminalType!(27) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce71_ExpressionPrefix/*ExpressionPrefix = "<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName "^"
    // type: unknown
    //  ExpressionPrefix ->  "^". {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse23(ref NonterminalType!(27) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce72_ExpressionPrefix/*ExpressionPrefix = "^"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix
    // type: unknown
    //  ExpressionPrefix+ ->  ExpressionPrefix. {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse24(ref NonterminalType!(29) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!27/*ExpressionPrefix*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce75/*ExpressionPrefix+ @array = ExpressionPrefix [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix*
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix*.PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AtomExpression      ->                                                                   .ParenExpression {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AtomExpression      ->                                                                   .SubToken {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AtomExpression      ->                                                                   .Symbol {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AtomExpression      ->                                                                   .Tuple {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AtomExpression      ->                                                                   .UnpackVariadicList {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  MacroInstance       ->                                                                   .Identifier "(" ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Name                ->                                                                   .Identifier {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Optional            ->                                                                   .PostfixExpression "?" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ParenExpression     ->                                                                   ."{" Expression "}" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  PostfixExpression   ->                                                                   .AtomExpression {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  PostfixExpression   ->                                                                   .Optional {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  PostfixExpression   ->                                                                   .Repetition {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  PostfixExpression   ->                                                                   .RepetitionPlus {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Repetition          ->                                                                   .PostfixExpression "*" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  RepetitionPlus      ->                                                                   .PostfixExpression "+" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  SubToken            ->                                                                   .Symbol ">>" ParenExpression {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  SubToken            ->                                                                   .Symbol ">>" Symbol {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol              ->                                                                   .MacroInstance {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol              ->                                                                   .Name {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol              ->                                                                   .Token {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token               ->                                                                   .CharacterSetLiteral {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token               ->                                                                   .StringLiteral {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Tuple               ->                                                                   ."t(" ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  UnpackVariadicList  ->                                                                   .Identifier "..." {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse25(ref NonterminalType!(4) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/) stack3, ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/) stack2, ParseStackElem!(Location, NonterminalType!28/*ExpressionPrefix**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 13, 31, 38, 41, 42, 43, 46, 47, 48, 49, 51, 54, 55]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"t("})
        {
            auto next = popToken();
            NonterminalType!(54) r;
            Location rl;
            gotoParent = parse27(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(54/*Tuple*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(42) r;
            Location rl;
            gotoParent = parse97(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(42/*ParenExpression*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([31, 38, 55]) r;
            Location rl;
            gotoParent = parse100(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse90(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
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
            if (currentResult.nonterminalID == 13/*AtomExpression*/)
            {
                currentResult = ParseResultIn.create(43/*PostfixExpression*/, currentResult.get!(13/*AtomExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 31/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(31/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*Name*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(38/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 41/*Optional*/)
            {
                currentResult = ParseResultIn.create(43/*PostfixExpression*/, currentResult.get!(41/*Optional*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 42/*ParenExpression*/)
            {
                currentResult = ParseResultIn.create(13/*AtomExpression*/, currentResult.get!(42/*ParenExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 43/*PostfixExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!43/*PostfixExpression*/)(currentResultLocation, currentResult.get!(43/*PostfixExpression*/)());
                CreatorInstance.NonterminalUnion!([4, 41, 46, 47]) r;
                Location rl;
                gotoParent = parse104(r, rl, parseStart3, stack3, stack2, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 46/*Repetition*/)
            {
                currentResult = ParseResultIn.create(43/*PostfixExpression*/, currentResult.get!(46/*Repetition*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 47/*RepetitionPlus*/)
            {
                currentResult = ParseResultIn.create(43/*PostfixExpression*/, currentResult.get!(47/*RepetitionPlus*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 48/*SubToken*/)
            {
                currentResult = ParseResultIn.create(13/*AtomExpression*/, currentResult.get!(48/*SubToken*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 49/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!49/*Symbol*/)(currentResultLocation, currentResult.get!(49/*Symbol*/)());
                CreatorInstance.NonterminalUnion!([13, 48]) r;
                Location rl;
                gotoParent = parse111(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 51/*Token*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(51/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 54/*Tuple*/)
            {
                currentResult = ParseResultIn.create(13/*AtomExpression*/, currentResult.get!(54/*Tuple*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 55/*UnpackVariadicList*/)
            {
                currentResult = ParseResultIn.create(13/*AtomExpression*/, currentResult.get!(55/*UnpackVariadicList*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(4/*AnnotatedExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t("
    // type: unknown
    //  Tuple                           ->  "t(".ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->      . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Alternation                     ->      .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->      .Concatenation {")", ",", "|"}
    //  AnnotatedExpression             ->      .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->      ."@" Identifier AnnotationParams? {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->      .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->      .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Expression                      ->      .Alternation {")", ","}
    //  ExpressionList                  ->      .Expression {")", ","}
    //  ExpressionList                  ->      .ExpressionList "," Expression {")", ","}
    //  ExpressionList?                 ->      . {")"}
    //  NegativeLookahead               ->      ."!" Symbol {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->      ."!" "anytoken" {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->      .AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->      .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->      .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->      .$regarrayedge_0_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionList? ---> ExpressionList
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse27(ref NonterminalType!(54) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 20, 23, 24, 39, 52, 54, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto tmp = reduce67/*ExpressionList? = [virtual]*/();
            currentResult = ParseResultIn.create(24/*ExpressionList?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
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
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 3/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!3/*Alternation*/)(currentResultLocation, currentResult.get!(3/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([3, 20]) r;
                Location rl;
                gotoParent = parse33(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(3/*Alternation*/, currentResult.get!(14/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 20/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!20/*Expression*/)(currentResultLocation, currentResult.get!(20/*Expression*/)());
                NonterminalType!(23) r;
                Location rl;
                gotoParent = parse83(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(23/*ExpressionList*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 23/*ExpressionList*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(23/*ExpressionList*/)());
                CreatorInstance.NonterminalUnion!([23, 54]) r;
                Location rl;
                gotoParent = parse94(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 24/*ExpressionList?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/)(currentResultLocation, currentResult.get!(24/*ExpressionList?*/)());
                NonterminalType!(54) r;
                Location rl;
                gotoParent = parse96(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(54/*Tuple*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!"
    // type: unknown
    //  NegativeLookahead ->  "!".Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead ->  "!"."anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  MacroInstance     ->     .Identifier "(" ExpressionList? ")" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Name              ->     .Identifier {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol            ->     .MacroInstance {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol            ->     .Name {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol            ->     .Token {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token             ->     .CharacterSetLiteral {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token             ->     .StringLiteral {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse28(ref NonterminalType!(39) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 38, 39, 49, 51]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"anytoken"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse29(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = r;
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([31, 38]) r;
            Location rl;
            gotoParent = parse31(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse90(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
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
            if (currentResult.nonterminalID == 31/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(31/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*Name*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(38/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 49/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!49/*Symbol*/)(currentResultLocation, currentResult.get!(49/*Symbol*/)());
                NonterminalType!(39) r;
                Location rl;
                gotoParent = parse92(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*Token*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(51/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(39/*NegativeLookahead*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" "anytoken"
    // type: unknown
    //  NegativeLookahead ->  "!" "anytoken". {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse29(ref NonterminalType!(39) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce91_NegativeLookahead/*NegativeLookahead = "!" "anytoken"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" CharacterSetLiteral
    // type: unknown
    //  Token ->  CharacterSetLiteral. {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse30(ref NonterminalType!(51) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce113_Token/*Token = CharacterSetLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier
    // type: unknown
    //  MacroInstance ->  Identifier."(" ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Name          ->  Identifier. {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse31(ref CreatorInstance.NonterminalUnion!([31, 38]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 38]);
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
            NonterminalType!(31) r;
            Location rl;
            gotoParent = parse32(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(31/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce89_Name/*Name = Identifier*/(parseStart1, stack1);
            result = ThisParseResult.create(38/*Name*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "("
    // type: unknown
    //  MacroInstance                   ->  Identifier "(".ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->                . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Alternation                     ->                .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->                .Concatenation {")", ",", "|"}
    //  AnnotatedExpression             ->                .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                ."@" Identifier AnnotationParams? {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->                .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Expression                      ->                .Alternation {")", ","}
    //  ExpressionList                  ->                .Expression {")", ","}
    //  ExpressionList                  ->                .ExpressionList "," Expression {")", ","}
    //  ExpressionList?                 ->                . {")"}
    //  NegativeLookahead               ->                ."!" Symbol {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                ."!" "anytoken" {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                .AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                .$regarrayedge_0_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionList? ---> ExpressionList
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse32(ref NonterminalType!(31) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 20, 23, 24, 31, 39, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto tmp = reduce67/*ExpressionList? = [virtual]*/();
            currentResult = ParseResultIn.create(24/*ExpressionList?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
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
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 3/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!3/*Alternation*/)(currentResultLocation, currentResult.get!(3/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([3, 20]) r;
                Location rl;
                gotoParent = parse33(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(3/*Alternation*/, currentResult.get!(14/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 20/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!20/*Expression*/)(currentResultLocation, currentResult.get!(20/*Expression*/)());
                NonterminalType!(23) r;
                Location rl;
                gotoParent = parse83(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(23/*ExpressionList*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 23/*ExpressionList*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(23/*ExpressionList*/)());
                CreatorInstance.NonterminalUnion!([23, 31]) r;
                Location rl;
                gotoParent = parse84(r, rl, parseStart2, stack2, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 24/*ExpressionList?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/)(currentResultLocation, currentResult.get!(24/*ExpressionList?*/)());
                NonterminalType!(31) r;
                Location rl;
                gotoParent = parse88(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(31/*MacroInstance*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation
    // type: unknown
    //  Alternation ->  Alternation."|" Concatenation {")", ",", ";", "|", "}"}
    //  Expression  ->  Alternation. {")", ",", ";", "}"}
    private int parse33(ref CreatorInstance.NonterminalUnion!([3, 20]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!3/*Alternation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([3, 20]);
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
            NonterminalType!(3) r;
            Location rl;
            gotoParent = parse34(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(3/*Alternation*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce59_Expression/*Expression = <Alternation*/(parseStart1, stack1);
            result = ThisParseResult.create(20/*Expression*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|"
    // type: unknown
    //  Alternation                     ->  Alternation "|".Concatenation {")", ",", ";", "|", "}"}
    //  @regArray_ExpressionAnnotation* ->                 . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotatedExpression             ->                 .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                 ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->                 .@regArray_ProductionAnnotation+ {")", ",", ";", "|", "}"}
    //  Concatenation                   ->                 .TokenMinus {")", ",", ";", "|", "}"}
    //  Concatenation                   ->                 .TokenMinus @regArray_ProductionAnnotation+ {")", ",", ";", "|", "}"}
    //  Concatenation                   ->                 .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", ";", "|", "}"}
    //  NegativeLookahead               ->                 ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                 ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                 .AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                 .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                 .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                 .$regarrayedge_0_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse34(ref NonterminalType!(3) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!3/*Alternation*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 39, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!14/*Concatenation*/)(currentResultLocation, currentResult.get!(14/*Concatenation*/)());
                NonterminalType!(3) r;
                Location rl;
                gotoParent = parse37(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(3/*Alternation*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" Annotation
    // type: unknown
    //  $regarray_1 ->  $regarrayedge_0_1. {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse36(ref NonterminalType!(57) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce121/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" Concatenation
    // type: unknown
    //  Alternation ->  Alternation "|" Concatenation. {")", ",", ";", "|", "}"}
    private int parse37(ref NonterminalType!(3) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!3/*Alternation*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!14/*Concatenation*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce6_Alternation/*Alternation = Alternation "|" Concatenation*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@"
    // type: unknown
    //  Annotation ->  "@".Identifier AnnotationParams? {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse38(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([5]);
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
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse39(r, rl, parseStart1, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier
    // type: unknown
    //  Annotation        ->  "@" Identifier.AnnotationParams? {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotationParams  ->                ."(" AnnotationParamsPart* ")" {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotationParams? ->                . {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotationParams? ---> AnnotationParams
    private int parse39(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([5, 8, 9]);
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
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse40(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(8/*AnnotationParams*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce15/*AnnotationParams? = [virtual]*/();
            currentResult = ParseResultIn.create(9/*AnnotationParams?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 8/*AnnotationParams*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!9/*AnnotationParams?*/)(currentResultLocation, currentResult.get!(8/*AnnotationParams*/)());
                NonterminalType!(5) r;
                Location rl;
                gotoParent = parse67(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 9/*AnnotationParams?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!9/*AnnotationParams?*/)(currentResultLocation, currentResult.get!(9/*AnnotationParams?*/)());
                NonterminalType!(5) r;
                Location rl;
                gotoParent = parse67(r, rl, parseStart2, stack2, stack1, next);
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

        result = currentResult.get!(5/*Annotation*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "("
    // type: unknown
    //  AnnotationParams      ->  "(".AnnotationParamsPart* ")" {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotationParamsPart  ->     ."!" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."(" AnnotationParamsPart* ")" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."*" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."," {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."-" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .":" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .";" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."<<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."=" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .">" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .">>" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."?" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."{" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."}" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .CharacterSetLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .Identifier {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .IntegerLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .StringLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart* ->     . {")"}
    //  AnnotationParamsPart* ->     .AnnotationParamsPart+ {")"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart+ AnnotationParamsPart {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse40(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([8, 10, 11, 12]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse41(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse42(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse43(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse44(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse45(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse46(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse47(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse51(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse52(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse55(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse56(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse57(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse58(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse59(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse60(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse61(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse62(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse63(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse64(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce35/*AnnotationParamsPart* @array = [virtual]*/();
            currentResult = ParseResultIn.create(11/*AnnotationParamsPart**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!10/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(10/*AnnotationParamsPart*/)());
                NonterminalType!(12) r;
                Location rl;
                gotoParent = parse48(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(12/*AnnotationParamsPart+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 11/*AnnotationParamsPart**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/)(currentResultLocation, currentResult.get!(11/*AnnotationParamsPart**/)());
                NonterminalType!(8) r;
                Location rl;
                gotoParent = parse65(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 12/*AnnotationParamsPart+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart+*/)(currentResultLocation, currentResult.get!(12/*AnnotationParamsPart+*/)());
                CreatorInstance.NonterminalUnion!([11, 12]) r;
                Location rl;
                gotoParent = parse53(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(8/*AnnotationParams*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "!"
    // type: unknown
    //  AnnotationParamsPart ->  "!". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse41(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce28_AnnotationParamsPart/*AnnotationParamsPart = "!"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "("
    // type: unknown
    //  AnnotationParamsPart  ->  "(".AnnotationParamsPart* ")" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."!" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."(" AnnotationParamsPart* ")" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."*" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."," {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."-" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .":" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .";" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."<<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."=" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .">" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .">>" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."?" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."{" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     ."}" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .CharacterSetLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .Identifier {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .IntegerLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->     .StringLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart* ->     . {")"}
    //  AnnotationParamsPart* ->     .AnnotationParamsPart+ {")"}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart+ ->     .AnnotationParamsPart+ AnnotationParamsPart {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse42(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 11, 12]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse41(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse42(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse43(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse44(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse45(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse46(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse47(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse51(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse52(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse55(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse56(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse57(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse58(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse59(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse60(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse61(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse62(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse63(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse64(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce35/*AnnotationParamsPart* @array = [virtual]*/();
            currentResult = ParseResultIn.create(11/*AnnotationParamsPart**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!10/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(10/*AnnotationParamsPart*/)());
                NonterminalType!(12) r;
                Location rl;
                gotoParent = parse48(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(12/*AnnotationParamsPart+*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 11/*AnnotationParamsPart**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/)(currentResultLocation, currentResult.get!(11/*AnnotationParamsPart**/)());
                NonterminalType!(10) r;
                Location rl;
                gotoParent = parse49(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 12/*AnnotationParamsPart+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart+*/)(currentResultLocation, currentResult.get!(12/*AnnotationParamsPart+*/)());
                CreatorInstance.NonterminalUnion!([11, 12]) r;
                Location rl;
                gotoParent = parse53(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(10/*AnnotationParamsPart*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" "*"
    // type: unknown
    //  AnnotationParamsPart ->  "*". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse43(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce31_AnnotationParamsPart/*AnnotationParamsPart = "*"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" ","
    // type: unknown
    //  AnnotationParamsPart ->  ",". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse44(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce24_AnnotationParamsPart/*AnnotationParamsPart = ","*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" "-"
    // type: unknown
    //  AnnotationParamsPart ->  "-". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse45(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce34_AnnotationParamsPart/*AnnotationParamsPart = "-"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" ":"
    // type: unknown
    //  AnnotationParamsPart ->  ":". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse46(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce22_AnnotationParamsPart/*AnnotationParamsPart = ":"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" ";"
    // type: unknown
    //  AnnotationParamsPart ->  ";". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse47(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce23_AnnotationParamsPart/*AnnotationParamsPart = ";"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart
    // type: unknown
    //  AnnotationParamsPart+ ->  AnnotationParamsPart. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse48(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!10/*AnnotationParamsPart*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce37/*AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart*
    // type: unknown
    //  AnnotationParamsPart ->  "(" AnnotationParamsPart*.")" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse49(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/) stack1)
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
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse50(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart* ")"
    // type: unknown
    //  AnnotationParamsPart ->  "(" AnnotationParamsPart* ")". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse50(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce20_AnnotationParamsPart/*AnnotationParamsPart = "(" AnnotationParamsPart* ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" "<"
    // type: unknown
    //  AnnotationParamsPart ->  "<". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse51(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce29_AnnotationParamsPart/*AnnotationParamsPart = "<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" "<<"
    // type: unknown
    //  AnnotationParamsPart ->  "<<". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse52(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce33_AnnotationParamsPart/*AnnotationParamsPart = "<<"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+
    // type: unknown
    //  AnnotationParamsPart* ->  AnnotationParamsPart+. {")"}
    //  AnnotationParamsPart+ ->  AnnotationParamsPart+.AnnotationParamsPart {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."!" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."(" AnnotationParamsPart* ")" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."*" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."," {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."-" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .":" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .";" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."<<" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."=" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .">" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .">>" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."?" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."{" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       ."}" {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .CharacterSetLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .Identifier {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .IntegerLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    //  AnnotationParamsPart  ->                       .StringLiteral {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse53(ref CreatorInstance.NonterminalUnion!([11, 12]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([10, 11, 12]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse41(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"("})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse42(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse43(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse44(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse45(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{":"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse46(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{";"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse47(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse51(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<<"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse52(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"="})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse55(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse56(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{">>"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse57(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse58(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse59(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse60(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse61(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse62(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"IntegerLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse63(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(10) r;
            Location rl;
            gotoParent = parse64(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(10/*AnnotationParamsPart*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce36/*AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(11/*AnnotationParamsPart**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 10/*AnnotationParamsPart*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!10/*AnnotationParamsPart*/)(currentResultLocation, currentResult.get!(10/*AnnotationParamsPart*/)());
                NonterminalType!(12) r;
                Location rl;
                gotoParent = parse54(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(12/*AnnotationParamsPart+*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ AnnotationParamsPart
    // type: unknown
    //  AnnotationParamsPart+ ->  AnnotationParamsPart+ AnnotationParamsPart. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse54(ref NonterminalType!(12) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!12/*AnnotationParamsPart+*/) stack2, ParseStackElem!(Location, NonterminalType!10/*AnnotationParamsPart*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce38/*AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ "="
    // type: unknown
    //  AnnotationParamsPart ->  "=". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse55(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce21_AnnotationParamsPart/*AnnotationParamsPart = "="*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ ">"
    // type: unknown
    //  AnnotationParamsPart ->  ">". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse56(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce30_AnnotationParamsPart/*AnnotationParamsPart = ">"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ ">>"
    // type: unknown
    //  AnnotationParamsPart ->  ">>". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse57(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce32_AnnotationParamsPart/*AnnotationParamsPart = ">>"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ "?"
    // type: unknown
    //  AnnotationParamsPart ->  "?". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse58(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce27_AnnotationParamsPart/*AnnotationParamsPart = "?"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ "{"
    // type: unknown
    //  AnnotationParamsPart ->  "{". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse59(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce25_AnnotationParamsPart/*AnnotationParamsPart = "{"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ "}"
    // type: unknown
    //  AnnotationParamsPart ->  "}". {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse60(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce26_AnnotationParamsPart/*AnnotationParamsPart = "}"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ CharacterSetLiteral
    // type: unknown
    //  AnnotationParamsPart ->  CharacterSetLiteral. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse61(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce18_AnnotationParamsPart/*AnnotationParamsPart = CharacterSetLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ Identifier
    // type: unknown
    //  AnnotationParamsPart ->  Identifier. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse62(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce17_AnnotationParamsPart/*AnnotationParamsPart = Identifier*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ IntegerLiteral
    // type: unknown
    //  AnnotationParamsPart ->  IntegerLiteral. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse63(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce19_AnnotationParamsPart/*AnnotationParamsPart = IntegerLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" "(" AnnotationParamsPart+ StringLiteral
    // type: unknown
    //  AnnotationParamsPart ->  StringLiteral. {"!", "(", ")", "*", ",", "-", ":", ";", "<", "<<", "=", ">", ">>", "?", "{", "}", CharacterSetLiteral, Identifier, IntegerLiteral, StringLiteral}
    private int parse64(ref NonterminalType!(10) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce16_AnnotationParamsPart/*AnnotationParamsPart = StringLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" AnnotationParamsPart*
    // type: unknown
    //  AnnotationParams ->  "(" AnnotationParamsPart*.")" {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse65(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/) stack1)
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
        else if (lexer.front.symbol == Lexer.tokenID!q{")"})
        {
            auto next = popToken();
            NonterminalType!(8) r;
            Location rl;
            gotoParent = parse66(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier "(" AnnotationParamsPart* ")"
    // type: unknown
    //  AnnotationParams ->  "(" AnnotationParamsPart* ")". {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse66(ref NonterminalType!(8) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!11/*AnnotationParamsPart**/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce13_AnnotationParams/*AnnotationParams = "(" AnnotationParamsPart* ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" "@" Identifier AnnotationParams
    // type: unknown
    //  Annotation ->  "@" Identifier AnnotationParams?. {"!", ")", ",", ";", "<", "=", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse67(ref NonterminalType!(5) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!9/*AnnotationParams?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce8_Annotation/*Annotation = "@" Identifier AnnotationParams?*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus
    // type: unknown
    //  Concatenation                   ->  TokenMinus. {")", ",", ";", "|", "}"}
    //  Concatenation                   ->  TokenMinus.@regArray_ProductionAnnotation+ {")", ",", ";", "|", "}"}
    //  Concatenation                   ->  TokenMinus.TokenMinus+ @regArray_ProductionAnnotation* {")", ",", ";", "|", "}"}
    //  TokenMinus                      ->  TokenMinus."-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->            . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotatedExpression             ->            .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->            ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->            ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->            ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->            .AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->            .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus+                     ->            .TokenMinus {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus+                     ->            .TokenMinus+ TokenMinus {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->            .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->            .$regarrayedge_0_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse68(ref CreatorInstance.NonterminalUnion!([14, 52]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 4, 5, 14, 39, 52, 53, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{"|"} || lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto tmp = reduce44_Concatenation/*Concatenation = <TokenMinus*/(parseStart1, stack1);
            result = ThisParseResult.create(14/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"-"})
        {
            auto next = popToken();
            NonterminalType!(52) r;
            Location rl;
            gotoParent = parse69(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(52/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
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
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([52, 53]) r;
                Location rl;
                gotoParent = parse75(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 53/*TokenMinus+*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!53/*TokenMinus+*/)(currentResultLocation, currentResult.get!(53/*TokenMinus+*/)());
                CreatorInstance.NonterminalUnion!([14, 53]) r;
                Location rl;
                gotoParent = parse76(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse80(r, rl, parseStart1, stack1, currentStart, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-"
    // type: unknown
    //  TokenMinus                      ->  TokenMinus "-".AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->                . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  AnnotatedExpression             ->                .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                ."@" Identifier AnnotationParams? {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                ."!" Symbol {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                ."!" "anytoken" {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                .$regarray_1 $regarrayedge_1_1 {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                .$regarrayedge_0_1 {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse69(ref NonterminalType!(52) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 4, 5, 39, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!4/*AnnotatedExpression*/)(currentResultLocation, currentResult.get!(4/*AnnotatedExpression*/)());
                NonterminalType!(52) r;
                Location rl;
                gotoParent = parse70(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 57]) r;
                Location rl;
                gotoParent = parse71(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(52/*TokenMinus*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-" AnnotatedExpression
    // type: unknown
    //  TokenMinus ->  TokenMinus "-" AnnotatedExpression. {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse70(ref NonterminalType!(52) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!4/*AnnotatedExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce115_TokenMinus/*TokenMinus = TokenMinus "-" AnnotatedExpression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-" $regarray_1
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1         ->                      $regarray_1.$regarrayedge_1_1 {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation          ->                                 ."@" Identifier AnnotationParams? {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName      ->                                 .Identifier ":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName?     ->                                 . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                 ."!" Symbol {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                 ."!" "anytoken" {"!", "<", "@", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse71(ref CreatorInstance.NonterminalUnion!([4, 57]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5, 25, 26, 39, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(25) r;
                Location rl;
                gotoParent = parse73(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(25/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral"))
            {
                auto tmp = reduce70/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
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
            auto tmp = reduce70/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 25/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(25/*ExpressionName*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 26/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(26/*ExpressionName?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-" $regarray_1 Annotation
    // type: unknown
    //  $regarray_1 ->  $regarray_1 $regarrayedge_1_1. {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse72(ref NonterminalType!(57) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!57/*$regarray_1*/) stack2, ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce120/*$regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-" $regarray_1 Identifier
    // type: unknown
    //  ExpressionName ->  Identifier.":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse73(ref NonterminalType!(25) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([25]);
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
            NonterminalType!(25) r;
            Location rl;
            gotoParent = parse74(r, rl, parseStart1, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus "-" $regarray_1 Identifier ":"
    // type: unknown
    //  ExpressionName ->  Identifier ":". {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse74(ref NonterminalType!(25) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce68_ExpressionName/*ExpressionName = Identifier ":"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus TokenMinus
    // type: unknown
    //  TokenMinus  ->  TokenMinus."-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus+ ->  TokenMinus. {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse75(ref CreatorInstance.NonterminalUnion!([52, 53]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([52, 53]);
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
            NonterminalType!(52) r;
            Location rl;
            gotoParent = parse69(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(52/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce116/*TokenMinus+ @array = TokenMinus [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(53/*TokenMinus+*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus TokenMinus+
    // type: unknown
    //  Concatenation                   ->  TokenMinus TokenMinus+.@regArray_ProductionAnnotation* {")", ",", ";", "|", "}"}
    //  TokenMinus+                     ->             TokenMinus+.TokenMinus {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->                        . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ProductionAnnotation* ->                        . {")", ",", ";", "|", "}"}
    //  AnnotatedExpression             ->                        .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                        ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                        ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                        ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                        .AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                        .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                        .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                        .$regarrayedge_0_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ProductionAnnotation* ---> $regarray_1
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse76(ref CreatorInstance.NonterminalUnion!([14, 53]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!53/*TokenMinus+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 1, 4, 5, 14, 39, 52, 53, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{"|"} || lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto tmp = reduce2/*@regArray_ProductionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(1/*@regArray_ProductionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"Identifier" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
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
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 1/*@regArray_ProductionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!1/*@regArray_ProductionAnnotation**/)(currentResultLocation, currentResult.get!(1/*@regArray_ProductionAnnotation**/)());
                NonterminalType!(14) r;
                Location rl;
                gotoParent = parse77(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(14/*Concatenation*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([52, 53]) r;
                Location rl;
                gotoParent = parse78(r, rl, parseStart1, stack1, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse79(r, rl, parseStart2, stack2, stack1, currentStart, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus TokenMinus+ @regArray_ProductionAnnotation*
    // type: unknown
    //  Concatenation ->  TokenMinus TokenMinus+ @regArray_ProductionAnnotation*. {")", ",", ";", "|", "}"}
    private int parse77(ref NonterminalType!(14) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack3, ParseStackElem!(Location, NonterminalType!53/*TokenMinus+*/) stack2, ParseStackElem!(Location, NonterminalType!1/*@regArray_ProductionAnnotation**/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce45_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus TokenMinus+ TokenMinus
    // type: unknown
    //  TokenMinus+ ->  TokenMinus+ TokenMinus. {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus  ->              TokenMinus."-" AnnotatedExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse78(ref CreatorInstance.NonterminalUnion!([52, 53]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!53/*TokenMinus+*/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([52, 53]);
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
            NonterminalType!(52) r;
            Location rl;
            gotoParent = parse69(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(52/*TokenMinus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce117/*TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]*/(parseStart2, stack2, stack1);
            result = ThisParseResult.create(53/*TokenMinus+*/, tmp.val);
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus TokenMinus+ $regarray_1
    // type: unknown
    //  Concatenation       ->  TokenMinus TokenMinus+ @regArray_ProductionAnnotation*. {")", ",", ";", "|", "}"}
    //  AnnotatedExpression ->                         @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1         ->                                             $regarray_1.$regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation          ->                                                        ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName      ->                                                        .Identifier ":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName?     ->                                                        . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                                        ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                                        ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse79(ref CreatorInstance.NonterminalUnion!([4, 14, 57]) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack3, ParseStackElem!(Location, NonterminalType!53/*TokenMinus+*/) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5, 14, 25, 26, 39, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{"|"} || lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto tmp = reduce45_Concatenation/*Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation**/(parseStart3, stack3, stack2, stack1);
            result = ThisParseResult.create(14/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 2;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce70/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(25) r;
                Location rl;
                gotoParent = parse73(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(25/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral"))
            {
                auto tmp = reduce70/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
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
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 25/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(25/*ExpressionName*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 26/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(26/*ExpressionName?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" TokenMinus $regarray_1
    // type: unknown
    //  Concatenation       ->  TokenMinus @regArray_ProductionAnnotation+. {")", ",", ";", "|", "}"}
    //  AnnotatedExpression ->             @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1         ->                                 $regarray_1.$regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation          ->                                            ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName      ->                                            .Identifier ":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName?     ->                                            . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                            ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                            ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse80(ref CreatorInstance.NonterminalUnion!([4, 14, 57]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5, 14, 25, 26, 39, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{"|"} || lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto tmp = reduce46_Concatenation/*Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+*/(parseStart2, stack2, stack1);
            result = ThisParseResult.create(14/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce70/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(25) r;
                Location rl;
                gotoParent = parse73(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(25/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral"))
            {
                auto tmp = reduce70/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
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
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 25/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(25/*ExpressionName*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 26/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(26/*ExpressionName?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Alternation "|" $regarray_1
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation*.ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation       ->  @regArray_ProductionAnnotation+. {")", ",", ";", "|", "}"}
    //  $regarray_1         ->                      $regarray_1.$regarrayedge_1_1 {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation          ->                                 ."@" Identifier AnnotationParams? {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName      ->                                 .Identifier ":" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName?     ->                                 . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                 ."!" Symbol {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead   ->                                 ."!" "anytoken" {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionName? ---> ExpressionName
    //  $regarrayedge_1_1 ---> Annotation
    //  $regarrayedge_1_1 ---> NegativeLookahead
    private int parse81(ref CreatorInstance.NonterminalUnion!([4, 14, 57]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 5, 14, 25, 26, 39, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{")"} || lexer.front.symbol == Lexer.tokenID!q{","} || lexer.front.symbol == Lexer.tokenID!q{";"} || lexer.front.symbol == Lexer.tokenID!q{"|"} || lexer.front.symbol == Lexer.tokenID!q{"}"})
        {
            auto tmp = reduce47_Concatenation/*Concatenation = @regArray @regArray_ProductionAnnotation+*/(parseStart1, stack1);
            result = ThisParseResult.create(14/*Concatenation*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"<"} || lexer.front.symbol == Lexer.tokenID!q{"^"} || lexer.front.symbol == Lexer.tokenID!q{"t("} || lexer.front.symbol == Lexer.tokenID!q{"{"} || lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto tmp = reduce70/*ExpressionName? = [virtual]*/();
            currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            Lexer tmpLexer = *lexer;
            tmpLexer.popFront();
            if (!tmpLexer.empty && tmpLexer.front.symbol == Lexer.tokenID!q{":"})
            {
                auto next = popToken();
                NonterminalType!(25) r;
                Location rl;
                gotoParent = parse73(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(25/*ExpressionName*/, r);
                currentResultLocation = rl;
            }
            else if (!tmpLexer.empty && (tmpLexer.front.symbol == Lexer.tokenID!q{"!"} || tmpLexer.front.symbol == Lexer.tokenID!q{"("} || tmpLexer.front.symbol == Lexer.tokenID!q{")"} || tmpLexer.front.symbol == Lexer.tokenID!q{"*"} || tmpLexer.front.symbol == Lexer.tokenID!q{"+"} || tmpLexer.front.symbol == Lexer.tokenID!q{","} || tmpLexer.front.symbol == Lexer.tokenID!q{"-"} || tmpLexer.front.symbol == Lexer.tokenID!q{"..."} || tmpLexer.front.symbol == Lexer.tokenID!q{";"} || tmpLexer.front.symbol == Lexer.tokenID!q{"<"} || tmpLexer.front.symbol == Lexer.tokenID!q{">>"} || tmpLexer.front.symbol == Lexer.tokenID!q{"?"} || tmpLexer.front.symbol == Lexer.tokenID!q{"@"} || tmpLexer.front.symbol == Lexer.tokenID!q{"^"} || tmpLexer.front.symbol == Lexer.tokenID!q{"t("} || tmpLexer.front.symbol == Lexer.tokenID!q{"{"} || tmpLexer.front.symbol == Lexer.tokenID!q{"|"} || tmpLexer.front.symbol == Lexer.tokenID!q{"}"} || tmpLexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral" || tmpLexer.front.symbol == Lexer.tokenID!"Identifier" || tmpLexer.front.symbol == Lexer.tokenID!"StringLiteral"))
            {
                auto tmp = reduce70/*ExpressionName? = [virtual]*/();
                currentResult = ParseResultIn.create(26/*ExpressionName?*/, tmp.val);
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
            lastError = new SingleParseException!Location(text("unexpected Token \"", lexer.front.content, "\"  \"", lexer.tokenName(lexer.front.symbol), "\""),
                lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 25/*ExpressionName*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(25/*ExpressionName*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 26/*ExpressionName?*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/)(currentResultLocation, currentResult.get!(26/*ExpressionName?*/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse21(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(4/*AnnotatedExpression*/, r);
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!59/*$regarrayedge_1_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse72(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(57/*$regarray_1*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" Expression
    // type: unknown
    //  ExpressionList ->  Expression. {")", ","}
    private int parse83(ref NonterminalType!(23) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce64_ExpressionList/*ExpressionList @array = Expression*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" ExpressionList
    // type: unknown
    //  MacroInstance  ->  Identifier "(" ExpressionList?.")" {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionList ->                  ExpressionList."," Expression {")", ","}
    private int parse84(ref CreatorInstance.NonterminalUnion!([23, 31]) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([23, 31]);
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
            NonterminalType!(31) r;
            Location rl;
            gotoParent = parse85(r, rl, parseStart3, stack3, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(31/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(23) r;
            Location rl;
            gotoParent = parse86(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(23/*ExpressionList*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" ExpressionList ")"
    // type: unknown
    //  MacroInstance ->  Identifier "(" ExpressionList? ")". {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse85(ref NonterminalType!(31) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce78_MacroInstance/*MacroInstance = Identifier "(" ExpressionList? ")"*/(parseStart4, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" ExpressionList ","
    // type: unknown
    //  ExpressionList                  ->  ExpressionList ",".Expression {")", ","}
    //  @regArray_ExpressionAnnotation* ->                    . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Alternation                     ->                    .Alternation "|" Concatenation {")", ",", "|"}
    //  Alternation                     ->                    .Concatenation {")", ",", "|"}
    //  AnnotatedExpression             ->                    .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->                    ."@" Identifier AnnotationParams? {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->                    .@regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus @regArray_ProductionAnnotation+ {")", ",", "|"}
    //  Concatenation                   ->                    .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {")", ",", "|"}
    //  Expression                      ->                    .Alternation {")", ","}
    //  NegativeLookahead               ->                    ."!" Symbol {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->                    ."!" "anytoken" {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                    .AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->                    .TokenMinus "-" AnnotatedExpression {"!", ")", ",", "-", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                    .$regarray_1 $regarrayedge_1_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->                    .$regarrayedge_0_1 {"!", ")", ",", "<", "@", "^", "t(", "{", "|", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse86(ref NonterminalType!(23) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!23/*ExpressionList*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 20, 23, 39, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 3/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!3/*Alternation*/)(currentResultLocation, currentResult.get!(3/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([3, 20]) r;
                Location rl;
                gotoParent = parse33(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(3/*Alternation*/, currentResult.get!(14/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 20/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!20/*Expression*/)(currentResultLocation, currentResult.get!(20/*Expression*/)());
                NonterminalType!(23) r;
                Location rl;
                gotoParent = parse87(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(23/*ExpressionList*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" ExpressionList "," Expression
    // type: unknown
    //  ExpressionList ->  ExpressionList "," Expression. {")", ","}
    private int parse87(ref NonterminalType!(23) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!23/*ExpressionList*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce65_ExpressionList/*ExpressionList @array = ExpressionList "," Expression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Identifier "(" ExpressionList?
    // type: unknown
    //  MacroInstance ->  Identifier "(" ExpressionList?.")" {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse88(ref NonterminalType!(31) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31]);
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
            NonterminalType!(31) r;
            Location rl;
            gotoParent = parse85(r, rl, parseStart3, stack3, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" StringLiteral
    // type: unknown
    //  Token ->  StringLiteral. {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse90(ref NonterminalType!(51) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce112_Token/*Token = StringLiteral*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" "!" Symbol
    // type: unknown
    //  NegativeLookahead ->  "!" Symbol. {"!", ")", ",", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse92(ref NonterminalType!(39) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce90_NegativeLookahead/*NegativeLookahead = "!" Symbol*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList
    // type: unknown
    //  Tuple          ->  "t(" ExpressionList?.")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionList ->        ExpressionList."," Expression {")", ","}
    private int parse94(ref CreatorInstance.NonterminalUnion!([23, 54]) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, Location parseStart1, ParseStackElem!(Location, CreatorInstance.NonterminalArray) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([23, 54]);
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
            NonterminalType!(54) r;
            Location rl;
            gotoParent = parse95(r, rl, parseStart2, stack2, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(54/*Tuple*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{","})
        {
            auto next = popToken();
            NonterminalType!(23) r;
            Location rl;
            gotoParent = parse86(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(23/*ExpressionList*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList ")"
    // type: unknown
    //  Tuple ->  "t(" ExpressionList? ")". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse95(ref NonterminalType!(54) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce118_Tuple/*Tuple = "t(" ExpressionList? ")"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "t(" ExpressionList?
    // type: unknown
    //  Tuple ->  "t(" ExpressionList?.")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse96(ref NonterminalType!(54) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!24/*ExpressionList?*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([54]);
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
            NonterminalType!(54) r;
            Location rl;
            gotoParent = parse95(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{"
    // type: unknown
    //  ParenExpression                 ->  "{".Expression "}" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ->     . {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  Alternation                     ->     .Alternation "|" Concatenation {"|", "}"}
    //  Alternation                     ->     .Concatenation {"|", "}"}
    //  AnnotatedExpression             ->     .@regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression {"!", "-", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Annotation                      ->     ."@" Identifier AnnotationParams? {"!", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Concatenation                   ->     .@regArray_ProductionAnnotation+ {"|", "}"}
    //  Concatenation                   ->     .TokenMinus {"|", "}"}
    //  Concatenation                   ->     .TokenMinus @regArray_ProductionAnnotation+ {"|", "}"}
    //  Concatenation                   ->     .TokenMinus TokenMinus+ @regArray_ProductionAnnotation* {"|", "}"}
    //  Expression                      ->     .Alternation {"}"}
    //  NegativeLookahead               ->     ."!" Symbol {"!", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  NegativeLookahead               ->     ."!" "anytoken" {"!", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->     .AnnotatedExpression {"!", "-", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  TokenMinus                      ->     .TokenMinus "-" AnnotatedExpression {"!", "-", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->     .$regarray_1 $regarrayedge_1_1 {"!", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  $regarray_1                     ->     .$regarrayedge_0_1 {"!", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  @regArray_ExpressionAnnotation* ---> $regarray_1
    //  @regArray_ProductionAnnotation+ ---> $regarray_1
    //  $regarrayedge_0_1 ---> Annotation
    //  $regarrayedge_0_1 ---> NegativeLookahead
    private int parse97(ref NonterminalType!(42) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([0, 3, 4, 5, 14, 20, 39, 42, 52, 57]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"!"})
        {
            auto next = popToken();
            NonterminalType!(39) r;
            Location rl;
            gotoParent = parse28(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(39/*NegativeLookahead*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"@"})
        {
            auto next = popToken();
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce0/*@regArray_ExpressionAnnotation* @array @directUnwrap @regArray =*/();
            currentResult = ParseResultIn.create(0/*@regArray_ExpressionAnnotation**/, tmp.val);
            currentResultLocation = tmp.start;
            gotoParent = 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 0/*@regArray_ExpressionAnnotation**/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/)(currentResultLocation, currentResult.get!(0/*@regArray_ExpressionAnnotation**/)());
                NonterminalType!(4) r;
                Location rl;
                gotoParent = parse20(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(4/*AnnotatedExpression*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 3/*Alternation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!3/*Alternation*/)(currentResultLocation, currentResult.get!(3/*Alternation*/)());
                CreatorInstance.NonterminalUnion!([3, 20]) r;
                Location rl;
                gotoParent = parse33(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 4/*AnnotatedExpression*/)
            {
                currentResult = ParseResultIn.create(52/*TokenMinus*/, currentResult.get!(4/*AnnotatedExpression*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 14/*Concatenation*/)
            {
                currentResult = ParseResultIn.create(3/*Alternation*/, currentResult.get!(14/*Concatenation*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 20/*Expression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!20/*Expression*/)(currentResultLocation, currentResult.get!(20/*Expression*/)());
                NonterminalType!(42) r;
                Location rl;
                gotoParent = parse98(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 39/*NegativeLookahead*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!58/*$regarrayedge_0_1*/)(currentResultLocation, currentResult.get!(39/*NegativeLookahead*/)());
                NonterminalType!(57) r;
                Location rl;
                gotoParent = parse36(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = ParseResultIn.create(57/*$regarray_1*/, r);
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 52/*TokenMinus*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!52/*TokenMinus*/)(currentResultLocation, currentResult.get!(52/*TokenMinus*/)());
                CreatorInstance.NonterminalUnion!([14, 52]) r;
                Location rl;
                gotoParent = parse68(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else if (currentResult.nonterminalID == 57/*$regarray_1*/)
            {
                auto next = ParseStackElem!(Location, CreatorInstance.NonterminalArray)(currentResultLocation, currentResult.get!(57/*$regarray_1*/)());
                CreatorInstance.NonterminalUnion!([4, 14, 57]) r;
                Location rl;
                gotoParent = parse81(r, rl, currentStart, next);
                if (gotoParent < 0)
                    return gotoParent;
                currentResult = r;
                currentResultLocation = rl;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(42/*ParenExpression*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" Expression
    // type: unknown
    //  ParenExpression ->  "{" Expression."}" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse98(ref NonterminalType!(42) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([42]);
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
            NonterminalType!(42) r;
            Location rl;
            gotoParent = parse99(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* "{" Expression "}"
    // type: unknown
    //  ParenExpression ->  "{" Expression "}". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse99(ref NonterminalType!(42) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce94_ParenExpression/*ParenExpression = "{" Expression "}"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Identifier
    // type: unknown
    //  MacroInstance      ->  Identifier."(" ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Name               ->  Identifier. {"!", ")", "*", "+", ",", "-", ";", "<", ">>", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  UnpackVariadicList ->  Identifier."..." {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse100(ref CreatorInstance.NonterminalUnion!([31, 38, 55]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 38, 55]);
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
            NonterminalType!(31) r;
            Location rl;
            gotoParent = parse32(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(31/*MacroInstance*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"..."})
        {
            auto next = popToken();
            NonterminalType!(55) r;
            Location rl;
            gotoParent = parse101(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(55/*UnpackVariadicList*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce89_Name/*Name = Identifier*/(parseStart1, stack1);
            result = ThisParseResult.create(38/*Name*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Identifier "..."
    // type: unknown
    //  UnpackVariadicList ->  Identifier "...". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse101(ref NonterminalType!(55) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce119_UnpackVariadicList/*UnpackVariadicList = Identifier "..."*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression
    // type: unknown
    //  AnnotatedExpression ->  @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression. {"!", ")", ",", "-", ";", "<", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Optional            ->                                                                    PostfixExpression."?" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Repetition          ->                                                                    PostfixExpression."*" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  RepetitionPlus      ->                                                                    PostfixExpression."+" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse104(ref CreatorInstance.NonterminalUnion!([4, 41, 46, 47]) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, NonterminalType!0/*@regArray_ExpressionAnnotation**/) stack4, ParseStackElem!(Location, NonterminalType!26/*ExpressionName?*/) stack3, ParseStackElem!(Location, NonterminalType!28/*ExpressionPrefix**/) stack2, Location parseStart1, ParseStackElem!(Location, NonterminalType!43/*PostfixExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([4, 41, 46, 47]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"*"})
        {
            auto next = popToken();
            NonterminalType!(46) r;
            Location rl;
            gotoParent = parse105(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(46/*Repetition*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"+"})
        {
            auto next = popToken();
            NonterminalType!(47) r;
            Location rl;
            gotoParent = parse106(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(47/*RepetitionPlus*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"?"})
        {
            auto next = popToken();
            NonterminalType!(41) r;
            Location rl;
            gotoParent = parse107(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(41/*Optional*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce7_AnnotatedExpression/*AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression*/(parseStart4, stack4, stack3, stack2, stack1);
            result = ThisParseResult.create(4/*AnnotatedExpression*/, tmp.val);
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "*"
    // type: unknown
    //  Repetition ->  PostfixExpression "*". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse105(ref NonterminalType!(46) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!43/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce103_Repetition/*Repetition = PostfixExpression "*"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "+"
    // type: unknown
    //  RepetitionPlus ->  PostfixExpression "+". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse106(ref NonterminalType!(47) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!43/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce104_RepetitionPlus/*RepetitionPlus = PostfixExpression "+"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* PostfixExpression "?"
    // type: unknown
    //  Optional ->  PostfixExpression "?". {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse107(ref NonterminalType!(41) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!43/*PostfixExpression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce93_Optional/*Optional = PostfixExpression "?"*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol
    // type: unknown
    //  AtomExpression ->  Symbol. {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  SubToken       ->  Symbol.">>" ParenExpression {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  SubToken       ->  Symbol.">>" Symbol {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse111(ref CreatorInstance.NonterminalUnion!([13, 48]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([13, 48]);
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
            NonterminalType!(48) r;
            Location rl;
            gotoParent = parse112(r, rl, parseStart1, stack1, next);
            if (gotoParent < 0)
                return gotoParent;
            assert(gotoParent > 0);
            result = ThisParseResult.create(48/*SubToken*/, r);
            resultLocation = rl;
            return gotoParent - 1;
        }
        else
        {
            auto tmp = reduce39_AtomExpression/*AtomExpression = <Symbol*/(parseStart1, stack1);
            result = ThisParseResult.create(13/*AtomExpression*/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>"
    // type: unknown
    //  SubToken        ->  Symbol ">>".ParenExpression {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  SubToken        ->  Symbol ">>".Symbol {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  MacroInstance   ->             .Identifier "(" ExpressionList? ")" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Name            ->             .Identifier {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  ParenExpression ->             ."{" Expression "}" {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol          ->             .MacroInstance {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol          ->             .Name {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol          ->             .Token {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token           ->             .CharacterSetLiteral {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    //  Token           ->             .StringLiteral {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse112(ref NonterminalType!(48) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 38, 42, 48, 49, 51]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"{"})
        {
            auto next = popToken();
            NonterminalType!(42) r;
            Location rl;
            gotoParent = parse97(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(42/*ParenExpression*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([31, 38]) r;
            Location rl;
            gotoParent = parse31(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse90(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
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
            if (currentResult.nonterminalID == 31/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(31/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*Name*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(38/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 42/*ParenExpression*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!42/*ParenExpression*/)(currentResultLocation, currentResult.get!(42/*ParenExpression*/)());
                NonterminalType!(48) r;
                Location rl;
                gotoParent = parse113(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 49/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!49/*Symbol*/)(currentResultLocation, currentResult.get!(49/*Symbol*/)());
                NonterminalType!(48) r;
                Location rl;
                gotoParent = parse114(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*Token*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(51/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(48/*SubToken*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>" ParenExpression
    // type: unknown
    //  SubToken ->  Symbol ">>" ParenExpression. {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse113(ref NonterminalType!(48) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!42/*ParenExpression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce106_SubToken/*SubToken = Symbol ">>" ParenExpression*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix* Symbol ">>" Symbol
    // type: unknown
    //  SubToken ->  Symbol ">>" Symbol. {"!", ")", "*", "+", ",", "-", ";", "<", "?", "@", "^", "t(", "{", "|", "}", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse114(ref NonterminalType!(48) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce105_SubToken/*SubToken = Symbol ">>" Symbol*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix+
    // type: unknown
    //  ExpressionPrefix* ->  ExpressionPrefix+. {"t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix+ ->  ExpressionPrefix+.ExpressionPrefix {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix  ->                   ."<" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    //  ExpressionPrefix  ->                   ."^" {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse117(ref CreatorInstance.NonterminalUnion!([28, 29]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!29/*ExpressionPrefix+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([27, 28, 29]);
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
            NonterminalType!(27) r;
            Location rl;
            gotoParent = parse22(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(27/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!q{"^"})
        {
            auto next = popToken();
            NonterminalType!(27) r;
            Location rl;
            gotoParent = parse23(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(27/*ExpressionPrefix*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce74/*ExpressionPrefix* @array = ExpressionPrefix+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(28/*ExpressionPrefix**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 27/*ExpressionPrefix*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!27/*ExpressionPrefix*/)(currentResultLocation, currentResult.get!(27/*ExpressionPrefix*/)());
                NonterminalType!(29) r;
                Location rl;
                gotoParent = parse118(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(29/*ExpressionPrefix+*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" @regArray_ExpressionAnnotation* ExpressionName ExpressionPrefix+ ExpressionPrefix
    // type: unknown
    //  ExpressionPrefix+ ->  ExpressionPrefix+ ExpressionPrefix. {"<", "^", "t(", "{", CharacterSetLiteral, Identifier, StringLiteral}
    private int parse118(ref NonterminalType!(29) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!29/*ExpressionPrefix+*/) stack2, ParseStackElem!(Location, NonterminalType!27/*ExpressionPrefix*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce76/*ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]*/(parseStart2, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 1;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" Expression
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression.";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse119(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart6, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack6, ParseStackElem!(Location, Token) stack5, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack4, ParseStackElem!(Location, NonterminalType!6/*Annotation**/) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([50]);
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
            NonterminalType!(50) r;
            Location rl;
            gotoParent = parse120(r, rl, parseStart6, stack6, stack5, stack4, stack3, stack2, stack1, next);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation* "=" Expression ";"
    // type: unknown
    //  SymbolDeclaration ->  DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";". {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse120(ref NonterminalType!(50) result, ref Location resultLocation, Location parseStart7, ParseStackElem!(Location, NonterminalType!18/*DeclarationType?*/) stack7, ParseStackElem!(Location, Token) stack6, ParseStackElem!(Location, NonterminalType!36/*MacroParametersPart?*/) stack5, ParseStackElem!(Location, NonterminalType!6/*Annotation**/) stack4, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!20/*Expression*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce111_SymbolDeclaration/*SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"*/(parseStart7, stack7, stack6, stack5, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 6;
        }
    }
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation+
    // type: unknown
    //  Annotation* ->  Annotation+. {";", "="}
    //  Annotation+ ->  Annotation+.Annotation {";", "=", "@"}
    //  Annotation  ->             ."@" Identifier AnnotationParams? {";", "=", "@"}
    private int parse121(ref CreatorInstance.NonterminalUnion!([6, 7]) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!7/*Annotation+*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([5, 6, 7]);
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
            NonterminalType!(5) r;
            Location rl;
            gotoParent = parse38(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(5/*Annotation*/, r);
            currentResultLocation = rl;
        }
        else
        {
            auto tmp = reduce10/*Annotation* @array = Annotation+ [virtual]*/(parseStart1, stack1);
            result = ThisParseResult.create(6/*Annotation**/, tmp.val);
            resultLocation = tmp.start;
            return 0;
        }

        while (gotoParent == 0)
        {
            if (currentResult.nonterminalID == 5/*Annotation*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!5/*Annotation*/)(currentResultLocation, currentResult.get!(5/*Annotation*/)());
                NonterminalType!(7) r;
                Location rl;
                gotoParent = parse122(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = ThisParseResult.create(7/*Annotation+*/, r);
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
    // path: EBNF Declaration+ DeclarationType Identifier MacroParametersPart Annotation+ Annotation
    // type: unknown
    //  Annotation+ ->  Annotation+ Annotation. {";", "=", "@"}
    private int parse122(ref NonterminalType!(7) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, NonterminalType!7/*Annotation+*/) stack2, ParseStackElem!(Location, NonterminalType!5/*Annotation*/) stack1)
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
    // path: EBNF Declaration+ "fragment"
    // type: unknown
    //  DeclarationType ->  "fragment". {Identifier}
    private int parse123(ref NonterminalType!(17) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce54_DeclarationType/*DeclarationType = "fragment"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF Declaration+ "import"
    // type: unknown
    //  Import ->  "import".StringLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse124(ref NonterminalType!(30) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([30]);
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
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse125(r, rl, parseStart1, stack1, next);
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
    // path: EBNF Declaration+ "import" StringLiteral
    // type: unknown
    //  Import ->  "import" StringLiteral.";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse125(ref NonterminalType!(30) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([30]);
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
            NonterminalType!(30) r;
            Location rl;
            gotoParent = parse126(r, rl, parseStart2, stack2, stack1, next);
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
    // path: EBNF Declaration+ "import" StringLiteral ";"
    // type: unknown
    //  Import ->  "import" StringLiteral ";". {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse126(ref NonterminalType!(30) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce77_Import/*Import = "import" StringLiteral ";"*/(parseStart3, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 2;
        }
    }
    // path: EBNF Declaration+ "match"
    // type: unknown
    //  MatchDeclaration ->  "match".Symbol Symbol ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  MacroInstance    ->         .Identifier "(" ExpressionList? ")" {CharacterSetLiteral, Identifier, StringLiteral}
    //  Name             ->         .Identifier {CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol           ->         .MacroInstance {CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol           ->         .Name {CharacterSetLiteral, Identifier, StringLiteral}
    //  Symbol           ->         .Token {CharacterSetLiteral, Identifier, StringLiteral}
    //  Token            ->         .CharacterSetLiteral {CharacterSetLiteral, Identifier, StringLiteral}
    //  Token            ->         .StringLiteral {CharacterSetLiteral, Identifier, StringLiteral}
    private int parse127(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 37, 38, 49, 51]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([31, 38]) r;
            Location rl;
            gotoParent = parse31(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse90(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
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
            if (currentResult.nonterminalID == 31/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(31/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*Name*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(38/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 49/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!49/*Symbol*/)(currentResultLocation, currentResult.get!(49/*Symbol*/)());
                NonterminalType!(37) r;
                Location rl;
                gotoParent = parse128(r, rl, parseStart1, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*Token*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(51/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(37/*MatchDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ "match" Symbol
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol.Symbol ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    //  MacroInstance    ->                .Identifier "(" ExpressionList? ")" {";"}
    //  Name             ->                .Identifier {";"}
    //  Symbol           ->                .MacroInstance {";"}
    //  Symbol           ->                .Name {";"}
    //  Symbol           ->                .Token {";"}
    //  Token            ->                .CharacterSetLiteral {";"}
    //  Token            ->                .StringLiteral {";"}
    private int parse128(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart2, ParseStackElem!(Location, Token) stack2, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([31, 37, 38, 49, 51]);
        ParseResultIn currentResult;
        Location currentResultLocation;
        int gotoParent = -1;
        Location currentStart = lexer.front.currentLocation;
        if (lexer.empty)
        {
            lastError = new SingleParseException!Location("EOF", lexer.front.currentLocation, lexer.front.currentTokenEnd);
            return -1;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"CharacterSetLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse30(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"Identifier")
        {
            auto next = popToken();
            CreatorInstance.NonterminalUnion!([31, 38]) r;
            Location rl;
            gotoParent = parse31(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = r;
            currentResultLocation = rl;
        }
        else if (lexer.front.symbol == Lexer.tokenID!"StringLiteral")
        {
            auto next = popToken();
            NonterminalType!(51) r;
            Location rl;
            gotoParent = parse90(r, rl, currentStart, next);
            if (gotoParent < 0)
                return gotoParent;
            currentResult = ParseResultIn.create(51/*Token*/, r);
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
            if (currentResult.nonterminalID == 31/*MacroInstance*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(31/*MacroInstance*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 38/*Name*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(38/*Name*/));
                currentResultLocation = currentResultLocation;
            }
            else if (currentResult.nonterminalID == 49/*Symbol*/)
            {
                auto next = ParseStackElem!(Location, NonterminalType!49/*Symbol*/)(currentResultLocation, currentResult.get!(49/*Symbol*/)());
                NonterminalType!(37) r;
                Location rl;
                gotoParent = parse129(r, rl, parseStart2, stack2, stack1, next);
                if (gotoParent < 0)
                    return gotoParent;
                assert(gotoParent > 0);
                result = r;
                resultLocation = rl;
                return gotoParent - 1;
            }
            else if (currentResult.nonterminalID == 51/*Token*/)
            {
                currentResult = ParseResultIn.create(49/*Symbol*/, currentResult.get!(51/*Token*/));
                currentResultLocation = currentResultLocation;
            }
            else
                assert(0, text("no jump ", currentResult.nonterminalID, " ", allNonterminals[currentResult.nonterminalID].name));
        }

        result = currentResult.get!(37/*MatchDeclaration*/);
        resultLocation = currentResultLocation;
        return gotoParent - 1;
    }
    // path: EBNF Declaration+ "match" Symbol Symbol
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol Symbol.";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse129(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart3, ParseStackElem!(Location, Token) stack3, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack2, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([37]);
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
            NonterminalType!(37) r;
            Location rl;
            gotoParent = parse130(r, rl, parseStart3, stack3, stack2, stack1, next);
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
    // path: EBNF Declaration+ "match" Symbol Symbol ";"
    // type: unknown
    //  MatchDeclaration ->  "match" Symbol Symbol ";". {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse130(ref NonterminalType!(37) result, ref Location resultLocation, Location parseStart4, ParseStackElem!(Location, Token) stack4, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack3, ParseStackElem!(Location, NonterminalType!49/*Symbol*/) stack2, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce88_MatchDeclaration/*MatchDeclaration = "match" Symbol Symbol ";"*/(parseStart4, stack4, stack3, stack2, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 3;
        }
    }
    // path: EBNF Declaration+ "option"
    // type: unknown
    //  OptionDeclaration ->  "option".Identifier "=" IntegerLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse131(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart1/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([40]);
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
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse132(r, rl, parseStart1/*, stack1*/, next);
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
    // path: EBNF Declaration+ "option" Identifier
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier."=" IntegerLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse132(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart2/+, ParseStackElem!(Location, Token) stack2+/, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([40]);
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
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse133(r, rl, parseStart2/*, stack2*/, stack1/*, next*/);
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
    // path: EBNF Declaration+ "option" Identifier "="
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=".IntegerLiteral ";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse133(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart3/+, ParseStackElem!(Location, Token) stack3+/, ParseStackElem!(Location, Token) stack2/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([40]);
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
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse134(r, rl, parseStart3/*, stack3*/, stack2/*, stack1*/, next);
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
    // path: EBNF Declaration+ "option" Identifier "=" IntegerLiteral
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=" IntegerLiteral.";" {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse134(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart4/+, ParseStackElem!(Location, Token) stack4+/, ParseStackElem!(Location, Token) stack3/+, ParseStackElem!(Location, Token) stack2+/, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        alias ParseResultIn = CreatorInstance.NonterminalUnion!([40]);
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
            NonterminalType!(40) r;
            Location rl;
            gotoParent = parse135(r, rl, parseStart4/*, stack4*/, stack3/*, stack2*/, stack1/*, next*/);
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
    // path: EBNF Declaration+ "option" Identifier "=" IntegerLiteral ";"
    // type: unknown
    //  OptionDeclaration ->  "option" Identifier "=" IntegerLiteral ";". {$end, "fragment", "import", "match", "option", "token", Identifier}
    private int parse135(ref NonterminalType!(40) result, ref Location resultLocation, Location parseStart5/+, ParseStackElem!(Location, Token) stack5+/, ParseStackElem!(Location, Token) stack4/+, ParseStackElem!(Location, Token) stack3+/, ParseStackElem!(Location, Token) stack2/+, ParseStackElem!(Location, Token) stack1+/)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce92_OptionDeclaration/*OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"*/(parseStart5, /*dropped, */stack4, /*dropped, */stack2, /*dropped*/);
            result = tmp.val;
            resultLocation = tmp.start;
            return 4;
        }
    }
    // path: EBNF Declaration+ "token"
    // type: unknown
    //  DeclarationType ->  "token". {Identifier}
    private int parse136(ref NonterminalType!(17) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, Token) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            auto tmp = reduce55_DeclarationType/*DeclarationType = "token"*/(parseStart1, stack1);
            result = tmp.val;
            resultLocation = tmp.start;
            return 0;
        }
    }
    // path: EBNF EBNF
    // type: unknown
    //  EBNF ->  EBNF. {$end} startElement
    private int parse141(ref NonterminalType!(19) result, ref Location resultLocation, Location parseStart1, ParseStackElem!(Location, NonterminalType!19/*EBNF*/) stack1)
    {
        alias ThisParseResult = typeof(result);
        Location currentStart = lexer.front.currentLocation;
        {
            result = stack1.val;
            resultLocation = stack1.start;
            return 1;
        }
    }
}

immutable allTokens = [
    /* 0: */ immutable(Token)("$end", []),
    /* 1: */ immutable(Token)(q{"!"}, []),
    /* 2: */ immutable(Token)(q{"("}, []),
    /* 3: */ immutable(Token)(q{")"}, []),
    /* 4: */ immutable(Token)(q{"*"}, []),
    /* 5: */ immutable(Token)(q{"+"}, []),
    /* 6: */ immutable(Token)(q{","}, []),
    /* 7: */ immutable(Token)(q{"-"}, []),
    /* 8: */ immutable(Token)(q{"..."}, []),
    /* 9: */ immutable(Token)(q{":"}, []),
    /* 10: */ immutable(Token)(q{";"}, []),
    /* 11: */ immutable(Token)(q{"<"}, []),
    /* 12: */ immutable(Token)(q{"<<"}, []),
    /* 13: */ immutable(Token)(q{"="}, []),
    /* 14: */ immutable(Token)(q{">"}, []),
    /* 15: */ immutable(Token)(q{">>"}, []),
    /* 16: */ immutable(Token)(q{"?"}, []),
    /* 17: */ immutable(Token)(q{"@"}, []),
    /* 18: */ immutable(Token)(q{"^"}, []),
    /* 19: */ immutable(Token)(q{"anytoken"}, []),
    /* 20: */ immutable(Token)(q{"fragment"}, []),
    /* 21: */ immutable(Token)(q{"import"}, []),
    /* 22: */ immutable(Token)(q{"match"}, []),
    /* 23: */ immutable(Token)(q{"option"}, []),
    /* 24: */ immutable(Token)(q{"t("}, []),
    /* 25: */ immutable(Token)(q{"token"}, []),
    /* 26: */ immutable(Token)(q{"{"}, []),
    /* 27: */ immutable(Token)(q{"|"}, []),
    /* 28: */ immutable(Token)(q{"}"}, []),
    /* 29: */ immutable(Token)("CharacterSetLiteral", []),
    /* 30: */ immutable(Token)("Identifier", ["lowPrio"]),
    /* 31: */ immutable(Token)("IntegerLiteral", []),
    /* 32: */ immutable(Token)("StringLiteral", []),
];

immutable allNonterminals = [
    /* 0: */ immutable(Nonterminal)("@regArray_ExpressionAnnotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [5, 39], 0, 2),
    /* 1: */ immutable(Nonterminal)("@regArray_ProductionAnnotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [5, 39], 2, 2),
    /* 2: */ immutable(Nonterminal)("@regArray_ProductionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap", "regArray"], [5, 39], 4, 1),
    /* 3: */ immutable(Nonterminal)("Alternation", NonterminalFlags.nonterminal, [], [3, 4, 14, 52], 5, 2),
    /* 4: */ immutable(Nonterminal)("AnnotatedExpression", NonterminalFlags.nonterminal, [], [4], 7, 1),
    /* 5: */ immutable(Nonterminal)("Annotation", NonterminalFlags.nonterminal, [], [5], 8, 1),
    /* 6: */ immutable(Nonterminal)("Annotation*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [5], 9, 2),
    /* 7: */ immutable(Nonterminal)("Annotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [5], 11, 2),
    /* 8: */ immutable(Nonterminal)("AnnotationParams", NonterminalFlags.nonterminal, [], [8], 13, 1),
    /* 9: */ immutable(Nonterminal)("AnnotationParams?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [8], 14, 2),
    /* 10: */ immutable(Nonterminal)("AnnotationParamsPart", NonterminalFlags.nonterminal, [], [10], 16, 19),
    /* 11: */ immutable(Nonterminal)("AnnotationParamsPart*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10], 35, 2),
    /* 12: */ immutable(Nonterminal)("AnnotationParamsPart+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [10], 37, 2),
    /* 13: */ immutable(Nonterminal)("AtomExpression", NonterminalFlags.nonterminal, [], [31, 38, 42, 48, 51, 54, 55], 39, 5),
    /* 14: */ immutable(Nonterminal)("Concatenation", NonterminalFlags.nonterminal, [], [4, 14, 52], 44, 4),
    /* 15: */ immutable(Nonterminal)("Declaration", NonterminalFlags.nonterminal, [], [30, 37, 40, 50], 48, 4),
    /* 16: */ immutable(Nonterminal)("Declaration+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [30, 37, 40, 50], 52, 2),
    /* 17: */ immutable(Nonterminal)("DeclarationType", NonterminalFlags.nonterminal, [], [17], 54, 2),
    /* 18: */ immutable(Nonterminal)("DeclarationType?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [17], 56, 2),
    /* 19: */ immutable(Nonterminal)("EBNF", NonterminalFlags.nonterminal, [], [19], 58, 1),
    /* 20: */ immutable(Nonterminal)("Expression", NonterminalFlags.nonterminal, [], [3, 4, 14, 52], 59, 1),
    /* 21: */ immutable(Nonterminal)("ExpressionAnnotation", NonterminalFlags.nonterminal, ["directUnwrap"], [5, 39], 60, 2),
    /* 22: */ immutable(Nonterminal)("ExpressionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [5, 39], 62, 2),
    /* 23: */ immutable(Nonterminal)("ExpressionList", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, ["array"], [3, 4, 14, 52], 64, 2),
    /* 24: */ immutable(Nonterminal)("ExpressionList?", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, [], [3, 4, 14, 52], 66, 2),
    /* 25: */ immutable(Nonterminal)("ExpressionName", NonterminalFlags.nonterminal, [], [25], 68, 1),
    /* 26: */ immutable(Nonterminal)("ExpressionName?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [25], 69, 2),
    /* 27: */ immutable(Nonterminal)("ExpressionPrefix", NonterminalFlags.nonterminal, [], [27], 71, 2),
    /* 28: */ immutable(Nonterminal)("ExpressionPrefix*", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [27], 73, 2),
    /* 29: */ immutable(Nonterminal)("ExpressionPrefix+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [27], 75, 2),
    /* 30: */ immutable(Nonterminal)("Import", NonterminalFlags.nonterminal, [], [30], 77, 1),
    /* 31: */ immutable(Nonterminal)("MacroInstance", NonterminalFlags.nonterminal, [], [31], 78, 1),
    /* 32: */ immutable(Nonterminal)("MacroParameter", NonterminalFlags.nonterminal, [], [32], 79, 2),
    /* 33: */ immutable(Nonterminal)("MacroParameters", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, ["array"], [32], 81, 2),
    /* 34: */ immutable(Nonterminal)("MacroParameters?", NonterminalFlags.empty | NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal | NonterminalFlags.arrayOfString, [], [32], 83, 2),
    /* 35: */ immutable(Nonterminal)("MacroParametersPart", NonterminalFlags.nonterminal, [], [35], 85, 1),
    /* 36: */ immutable(Nonterminal)("MacroParametersPart?", NonterminalFlags.empty | NonterminalFlags.nonterminal, [], [35], 86, 2),
    /* 37: */ immutable(Nonterminal)("MatchDeclaration", NonterminalFlags.nonterminal, [], [37], 88, 1),
    /* 38: */ immutable(Nonterminal)("Name", NonterminalFlags.nonterminal, [], [38], 89, 1),
    /* 39: */ immutable(Nonterminal)("NegativeLookahead", NonterminalFlags.nonterminal, [], [39], 90, 2),
    /* 40: */ immutable(Nonterminal)("OptionDeclaration", NonterminalFlags.nonterminal, [], [40], 92, 1),
    /* 41: */ immutable(Nonterminal)("Optional", NonterminalFlags.nonterminal, [], [41], 93, 1),
    /* 42: */ immutable(Nonterminal)("ParenExpression", NonterminalFlags.nonterminal, [], [42], 94, 1),
    /* 43: */ immutable(Nonterminal)("PostfixExpression", NonterminalFlags.nonterminal, [], [31, 38, 41, 42, 46, 47, 48, 51, 54, 55], 95, 4),
    /* 44: */ immutable(Nonterminal)("ProductionAnnotation", NonterminalFlags.nonterminal, ["directUnwrap"], [5, 39], 99, 2),
    /* 45: */ immutable(Nonterminal)("ProductionAnnotation+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [5, 39], 101, 2),
    /* 46: */ immutable(Nonterminal)("Repetition", NonterminalFlags.nonterminal, [], [46], 103, 1),
    /* 47: */ immutable(Nonterminal)("RepetitionPlus", NonterminalFlags.nonterminal, [], [47], 104, 1),
    /* 48: */ immutable(Nonterminal)("SubToken", NonterminalFlags.nonterminal, [], [48], 105, 2),
    /* 49: */ immutable(Nonterminal)("Symbol", NonterminalFlags.nonterminal, [], [31, 38, 51], 107, 3),
    /* 50: */ immutable(Nonterminal)("SymbolDeclaration", NonterminalFlags.nonterminal, [], [50], 110, 2),
    /* 51: */ immutable(Nonterminal)("Token", NonterminalFlags.nonterminal, [], [51], 112, 2),
    /* 52: */ immutable(Nonterminal)("TokenMinus", NonterminalFlags.nonterminal, [], [4, 52], 114, 2),
    /* 53: */ immutable(Nonterminal)("TokenMinus+", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array"], [4, 52], 116, 2),
    /* 54: */ immutable(Nonterminal)("Tuple", NonterminalFlags.nonterminal, [], [54], 118, 1),
    /* 55: */ immutable(Nonterminal)("UnpackVariadicList", NonterminalFlags.nonterminal, [], [55], 119, 1),
    /* 56: */ immutable(Nonterminal)("$regarray_0", NonterminalFlags.none, ["array", "directUnwrap"], [], 0, 0),
    /* 57: */ immutable(Nonterminal)("$regarray_1", NonterminalFlags.array | NonterminalFlags.arrayOfNonterminal, ["array", "directUnwrap"], [5, 39], 120, 2),
    /* 58: */ immutable(Nonterminal)("$regarrayedge_0_1", NonterminalFlags.nonterminal, ["directUnwrap"], [5, 39], 122, 2),
    /* 59: */ immutable(Nonterminal)("$regarrayedge_1_1", NonterminalFlags.nonterminal, ["directUnwrap"], [5, 39], 124, 2),
];

immutable allProductions = [
    // 0: @regArray_ExpressionAnnotation* @array @directUnwrap @regArray =
    immutable(Production)(immutable(NonterminalID)(0), [], [], [], false, false),
    // 1: @regArray_ExpressionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(0), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 2: @regArray_ProductionAnnotation* @array @directUnwrap @regArray =
    immutable(Production)(immutable(NonterminalID)(1), [], [], [], false, false),
    // 3: @regArray_ProductionAnnotation* @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(1), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 4: @regArray_ProductionAnnotation+ @array @directUnwrap @regArray = @inheritAnyTag <$regarray_1
    immutable(Production)(immutable(NonterminalID)(2), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", true, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 5: Alternation = <Concatenation
    immutable(Production)(immutable(NonterminalID)(3), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", true, false, [], [])
            ], [], [], false, false),
    // 6: Alternation = Alternation "|" Concatenation
    immutable(Production)(immutable(NonterminalID)(3), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 3), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 27), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 14), "", "", false, false, [], [])
            ], [], [], false, false),
    // 7: AnnotatedExpression = @regArray @regArray_ExpressionAnnotation* ExpressionName? ExpressionPrefix* PostfixExpression
    immutable(Production)(immutable(NonterminalID)(4), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 0), "", "", false, false, ["regArray"], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 26), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 28), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 43), "", "", false, false, [], [])
            ], [], [], false, false),
    // 8: Annotation = "@" Identifier AnnotationParams?
    immutable(Production)(immutable(NonterminalID)(5), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 17), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 9), "", "", false, false, [], [])
            ], [], [], false, false),
    // 9: Annotation* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(6), [], [], [], false, true),
    // 10: Annotation* @array = Annotation+ [virtual]
    immutable(Production)(immutable(NonterminalID)(6), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 7), "", "", false, false, [], [])
            ], [], [], false, true),
    // 11: Annotation+ @array = Annotation [virtual]
    immutable(Production)(immutable(NonterminalID)(7), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", false, false, [], [])
            ], [], [], false, true),
    // 12: Annotation+ @array = Annotation+ Annotation [virtual]
    immutable(Production)(immutable(NonterminalID)(7), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 7), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", false, false, [], [])
            ], [], [], false, true),
    // 13: AnnotationParams = "(" AnnotationParamsPart* ")"
    immutable(Production)(immutable(NonterminalID)(8), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 11), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 14: AnnotationParams? = <AnnotationParams [virtual]
    immutable(Production)(immutable(NonterminalID)(9), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 8), "", "", true, false, [], [])
            ], [], [], false, true),
    // 15: AnnotationParams? = [virtual]
    immutable(Production)(immutable(NonterminalID)(9), [], [], [], false, true),
    // 16: AnnotationParamsPart = StringLiteral
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 32), "", "", false, false, [], [])
            ], [], [], false, false),
    // 17: AnnotationParamsPart = Identifier
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], [])
            ], [], [], false, false),
    // 18: AnnotationParamsPart = CharacterSetLiteral
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 29), "", "", false, false, [], [])
            ], [], [], false, false),
    // 19: AnnotationParamsPart = IntegerLiteral
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 31), "", "", false, false, [], [])
            ], [], [], false, false),
    // 20: AnnotationParamsPart = "(" AnnotationParamsPart* ")"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 11), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 21: AnnotationParamsPart = "="
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 13), "", "", false, false, [], [])
            ], [], [], false, false),
    // 22: AnnotationParamsPart = ":"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], [])
            ], [], [], false, false),
    // 23: AnnotationParamsPart = ";"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 24: AnnotationParamsPart = ","
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, false, [], [])
            ], [], [], false, false),
    // 25: AnnotationParamsPart = "{"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 26), "", "", false, false, [], [])
            ], [], [], false, false),
    // 26: AnnotationParamsPart = "}"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 28), "", "", false, false, [], [])
            ], [], [], false, false),
    // 27: AnnotationParamsPart = "?"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 16), "", "", false, false, [], [])
            ], [], [], false, false),
    // 28: AnnotationParamsPart = "!"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], [])
            ], [], [], false, false),
    // 29: AnnotationParamsPart = "<"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 11), "", "", false, false, [], [])
            ], [], [], false, false),
    // 30: AnnotationParamsPart = ">"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 14), "", "", false, false, [], [])
            ], [], [], false, false),
    // 31: AnnotationParamsPart = "*"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 4), "", "", false, false, [], [])
            ], [], [], false, false),
    // 32: AnnotationParamsPart = ">>"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 15), "", "", false, false, [], [])
            ], [], [], false, false),
    // 33: AnnotationParamsPart = "<<"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 12), "", "", false, false, [], [])
            ], [], [], false, false),
    // 34: AnnotationParamsPart = "-"
    immutable(Production)(immutable(NonterminalID)(10), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 7), "", "", false, false, [], [])
            ], [], [], false, false),
    // 35: AnnotationParamsPart* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(11), [], [], [], false, true),
    // 36: AnnotationParamsPart* @array = AnnotationParamsPart+ [virtual]
    immutable(Production)(immutable(NonterminalID)(11), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 12), "", "", false, false, [], [])
            ], [], [], false, true),
    // 37: AnnotationParamsPart+ @array = AnnotationParamsPart [virtual]
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", false, false, [], [])
            ], [], [], false, true),
    // 38: AnnotationParamsPart+ @array = AnnotationParamsPart+ AnnotationParamsPart [virtual]
    immutable(Production)(immutable(NonterminalID)(12), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 12), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 10), "", "", false, false, [], [])
            ], [], [], false, true),
    // 39: AtomExpression = <Symbol
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", true, false, [], [])
            ], [], [], false, false),
    // 40: AtomExpression = <ParenExpression
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 42), "", "", true, false, [], [])
            ], [], [], false, false),
    // 41: AtomExpression = <SubToken
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 48), "", "", true, false, [], [])
            ], [], [], false, false),
    // 42: AtomExpression = <UnpackVariadicList
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 55), "", "", true, false, [], [])
            ], [], [], false, false),
    // 43: AtomExpression = <Tuple
    immutable(Production)(immutable(NonterminalID)(13), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 54), "", "", true, false, [], [])
            ], [], [], false, false),
    // 44: Concatenation = <TokenMinus
    immutable(Production)(immutable(NonterminalID)(14), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", true, false, [], [])
            ], [], [], false, false),
    // 45: Concatenation = TokenMinus TokenMinus+ @regArray @regArray_ProductionAnnotation*
    immutable(Production)(immutable(NonterminalID)(14), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 53), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 1), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    // 46: Concatenation = TokenMinus @regArray @regArray_ProductionAnnotation+
    immutable(Production)(immutable(NonterminalID)(14), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 2), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    // 47: Concatenation = @regArray @regArray_ProductionAnnotation+
    immutable(Production)(immutable(NonterminalID)(14), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 2), "", "", false, false, ["regArray"], [])
            ], [], [], false, false),
    // 48: Declaration = <SymbolDeclaration
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 50), "", "", true, false, [], [])
            ], [], [], false, false),
    // 49: Declaration = <MatchDeclaration
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 37), "", "", true, false, [], [])
            ], [], [], false, false),
    // 50: Declaration = <Import
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 30), "", "", true, false, [], [])
            ], [], [], false, false),
    // 51: Declaration = <OptionDeclaration
    immutable(Production)(immutable(NonterminalID)(15), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 40), "", "", true, false, [], [])
            ], [], [], false, false),
    // 52: Declaration+ @array = Declaration [virtual]
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 15), "", "", false, false, [], [])
            ], [], [], false, true),
    // 53: Declaration+ @array = Declaration+ Declaration [virtual]
    immutable(Production)(immutable(NonterminalID)(16), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 16), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 15), "", "", false, false, [], [])
            ], [], [], false, true),
    // 54: DeclarationType = "fragment"
    immutable(Production)(immutable(NonterminalID)(17), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 20), "", "", false, false, [], [])
            ], [], [], false, false),
    // 55: DeclarationType = "token"
    immutable(Production)(immutable(NonterminalID)(17), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 25), "", "", false, false, [], [])
            ], [], [], false, false),
    // 56: DeclarationType? = <DeclarationType [virtual]
    immutable(Production)(immutable(NonterminalID)(18), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 17), "", "", true, false, [], [])
            ], [], [], false, true),
    // 57: DeclarationType? = [virtual]
    immutable(Production)(immutable(NonterminalID)(18), [], [], [], false, true),
    // 58: EBNF = Declaration+
    immutable(Production)(immutable(NonterminalID)(19), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 16), "", "", false, false, [], [])
            ], [], [], false, false),
    // 59: Expression = <Alternation
    immutable(Production)(immutable(NonterminalID)(20), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 3), "", "", true, false, [], [])
            ], [], [], false, false),
    // 60: ExpressionAnnotation @directUnwrap = <Annotation
    immutable(Production)(immutable(NonterminalID)(21), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", true, false, [], [])
            ], [], [], false, false),
    // 61: ExpressionAnnotation @directUnwrap = <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(21), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", true, false, [], [])
            ], [], [], false, false),
    // 62: ExpressionAnnotation+ @array = ExpressionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(22), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 21), "", "", false, false, [], [])
            ], [], [], false, true),
    // 63: ExpressionAnnotation+ @array = ExpressionAnnotation+ ExpressionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(22), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 22), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 21), "", "", false, false, [], [])
            ], [], [], false, true),
    // 64: ExpressionList @array = Expression
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], [])
            ], [], [], false, false),
    // 65: ExpressionList @array = ExpressionList "," Expression
    immutable(Production)(immutable(NonterminalID)(23), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], [])
            ], [], [], false, false),
    // 66: ExpressionList? = <ExpressionList [virtual]
    immutable(Production)(immutable(NonterminalID)(24), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 23), "", "", true, false, [], [])
            ], [], [], false, true),
    // 67: ExpressionList? = [virtual]
    immutable(Production)(immutable(NonterminalID)(24), [], [], [], false, true),
    // 68: ExpressionName = Identifier ":"
    immutable(Production)(immutable(NonterminalID)(25), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 9), "", "", false, false, [], [])
            ], [], [], false, false),
    // 69: ExpressionName? = <ExpressionName [virtual]
    immutable(Production)(immutable(NonterminalID)(26), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 25), "", "", true, false, [], [])
            ], [], [], false, true),
    // 70: ExpressionName? = [virtual]
    immutable(Production)(immutable(NonterminalID)(26), [], [], [], false, true),
    // 71: ExpressionPrefix = "<"
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 11), "", "", false, false, [], [])
            ], [], [], false, false),
    // 72: ExpressionPrefix = "^"
    immutable(Production)(immutable(NonterminalID)(27), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 18), "", "", false, false, [], [])
            ], [], [], false, false),
    // 73: ExpressionPrefix* @array = [virtual]
    immutable(Production)(immutable(NonterminalID)(28), [], [], [], false, true),
    // 74: ExpressionPrefix* @array = ExpressionPrefix+ [virtual]
    immutable(Production)(immutable(NonterminalID)(28), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 29), "", "", false, false, [], [])
            ], [], [], false, true),
    // 75: ExpressionPrefix+ @array = ExpressionPrefix [virtual]
    immutable(Production)(immutable(NonterminalID)(29), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 27), "", "", false, false, [], [])
            ], [], [], false, true),
    // 76: ExpressionPrefix+ @array = ExpressionPrefix+ ExpressionPrefix [virtual]
    immutable(Production)(immutable(NonterminalID)(29), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 29), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 27), "", "", false, false, [], [])
            ], [], [], false, true),
    // 77: Import = "import" StringLiteral ";"
    immutable(Production)(immutable(NonterminalID)(30), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 21), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 32), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 78: MacroInstance = Identifier "(" ExpressionList? ")"
    immutable(Production)(immutable(NonterminalID)(31), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 24), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 79: MacroParameter = Identifier
    immutable(Production)(immutable(NonterminalID)(32), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], [])
            ], [], [], false, false),
    // 80: MacroParameter = Identifier "..."
    immutable(Production)(immutable(NonterminalID)(32), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 8), "", "", false, false, [], [])
            ], [], [], false, false),
    // 81: MacroParameters @array = MacroParameter
    immutable(Production)(immutable(NonterminalID)(33), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 32), "", "", false, false, [], [])
            ], [], [], false, false),
    // 82: MacroParameters @array = MacroParameters "," MacroParameter
    immutable(Production)(immutable(NonterminalID)(33), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 33), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 6), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 32), "", "", false, false, [], [])
            ], [], [], false, false),
    // 83: MacroParameters? = <MacroParameters [virtual]
    immutable(Production)(immutable(NonterminalID)(34), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 33), "", "", true, false, [], [])
            ], [], [], false, true),
    // 84: MacroParameters? = [virtual]
    immutable(Production)(immutable(NonterminalID)(34), [], [], [], false, true),
    // 85: MacroParametersPart = "(" MacroParameters? ")"
    immutable(Production)(immutable(NonterminalID)(35), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 2), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 34), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 86: MacroParametersPart? = <MacroParametersPart [virtual]
    immutable(Production)(immutable(NonterminalID)(36), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 35), "", "", true, false, [], [])
            ], [], [], false, true),
    // 87: MacroParametersPart? = [virtual]
    immutable(Production)(immutable(NonterminalID)(36), [], [], [], false, true),
    // 88: MatchDeclaration = "match" Symbol Symbol ";"
    immutable(Production)(immutable(NonterminalID)(37), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 22), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 89: Name = Identifier
    immutable(Production)(immutable(NonterminalID)(38), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], [])
            ], [], [], false, false),
    // 90: NegativeLookahead = "!" Symbol
    immutable(Production)(immutable(NonterminalID)(39), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], [])
            ], [], [], false, false),
    // 91: NegativeLookahead = "!" "anytoken"
    immutable(Production)(immutable(NonterminalID)(39), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 1), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 19), "", "", false, false, [], [])
            ], [], [], false, false),
    // 92: OptionDeclaration = ^"option" Identifier ^"=" IntegerLiteral ^";"
    immutable(Production)(immutable(NonterminalID)(40), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 23), "", "", false, true, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 13), "", "", false, true, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 31), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, true, [], [])
            ], [], [], false, false),
    // 93: Optional = PostfixExpression "?"
    immutable(Production)(immutable(NonterminalID)(41), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 43), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 16), "", "", false, false, [], [])
            ], [], [], false, false),
    // 94: ParenExpression = "{" Expression "}"
    immutable(Production)(immutable(NonterminalID)(42), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 26), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 28), "", "", false, false, [], [])
            ], [], [], false, false),
    // 95: PostfixExpression = <Optional
    immutable(Production)(immutable(NonterminalID)(43), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 41), "", "", true, false, [], [])
            ], [], [], false, false),
    // 96: PostfixExpression = <Repetition
    immutable(Production)(immutable(NonterminalID)(43), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 46), "", "", true, false, [], [])
            ], [], [], false, false),
    // 97: PostfixExpression = <RepetitionPlus
    immutable(Production)(immutable(NonterminalID)(43), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 47), "", "", true, false, [], [])
            ], [], [], false, false),
    // 98: PostfixExpression = <AtomExpression
    immutable(Production)(immutable(NonterminalID)(43), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 13), "", "", true, false, [], [])
            ], [], [], false, false),
    // 99: ProductionAnnotation @directUnwrap = <Annotation
    immutable(Production)(immutable(NonterminalID)(44), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", true, false, [], [])
            ], [], [], false, false),
    // 100: ProductionAnnotation @directUnwrap = <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(44), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", true, false, [], [])
            ], [], [], false, false),
    // 101: ProductionAnnotation+ @array = ProductionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(45), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 44), "", "", false, false, [], [])
            ], [], [], false, true),
    // 102: ProductionAnnotation+ @array = ProductionAnnotation+ ProductionAnnotation [virtual]
    immutable(Production)(immutable(NonterminalID)(45), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 45), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 44), "", "", false, false, [], [])
            ], [], [], false, true),
    // 103: Repetition = PostfixExpression "*"
    immutable(Production)(immutable(NonterminalID)(46), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 43), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 4), "", "", false, false, [], [])
            ], [], [], false, false),
    // 104: RepetitionPlus = PostfixExpression "+"
    immutable(Production)(immutable(NonterminalID)(47), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 43), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 5), "", "", false, false, [], [])
            ], [], [], false, false),
    // 105: SubToken = Symbol ">>" Symbol
    immutable(Production)(immutable(NonterminalID)(48), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 15), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], [])
            ], [], [], false, false),
    // 106: SubToken = Symbol ">>" ParenExpression
    immutable(Production)(immutable(NonterminalID)(48), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 49), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 15), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 42), "", "", false, false, [], [])
            ], [], [], false, false),
    // 107: Symbol = <Name
    immutable(Production)(immutable(NonterminalID)(49), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 38), "", "", true, false, [], [])
            ], [], [], false, false),
    // 108: Symbol = <Token
    immutable(Production)(immutable(NonterminalID)(49), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 51), "", "", true, false, [], [])
            ], [], [], false, false),
    // 109: Symbol = <MacroInstance
    immutable(Production)(immutable(NonterminalID)(49), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 31), "", "", true, false, [], [])
            ], [], [], false, false),
    // 110: SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* ";"
    immutable(Production)(immutable(NonterminalID)(50), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 36), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 6), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 111: SymbolDeclaration = DeclarationType? Identifier MacroParametersPart? Annotation* "=" Expression ";"
    immutable(Production)(immutable(NonterminalID)(50), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 18), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 36), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 6), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 13), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 20), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 10), "", "", false, false, [], [])
            ], [], [], false, false),
    // 112: Token = StringLiteral
    immutable(Production)(immutable(NonterminalID)(51), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 32), "", "", false, false, [], [])
            ], [], [], false, false),
    // 113: Token = CharacterSetLiteral
    immutable(Production)(immutable(NonterminalID)(51), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 29), "", "", false, false, [], [])
            ], [], [], false, false),
    // 114: TokenMinus = <AnnotatedExpression
    immutable(Production)(immutable(NonterminalID)(52), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 4), "", "", true, false, [], [])
            ], [], [], false, false),
    // 115: TokenMinus = TokenMinus "-" AnnotatedExpression
    immutable(Production)(immutable(NonterminalID)(52), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 7), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 4), "", "", false, false, [], [])
            ], [], [], false, false),
    // 116: TokenMinus+ @array = TokenMinus [virtual]
    immutable(Production)(immutable(NonterminalID)(53), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], [])
            ], [], [], false, true),
    // 117: TokenMinus+ @array = TokenMinus+ TokenMinus [virtual]
    immutable(Production)(immutable(NonterminalID)(53), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 53), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 52), "", "", false, false, [], [])
            ], [], [], false, true),
    // 118: Tuple = "t(" ExpressionList? ")"
    immutable(Production)(immutable(NonterminalID)(54), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 24), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 24), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 3), "", "", false, false, [], [])
            ], [], [], false, false),
    // 119: UnpackVariadicList = Identifier "..."
    immutable(Production)(immutable(NonterminalID)(55), [
                immutable(SymbolInstance)(immutable(Symbol)(true, 30), "", "", false, false, [], []),
                immutable(SymbolInstance)(immutable(Symbol)(true, 8), "", "", false, false, [], [])
            ], [], [], false, false),
    // 120: $regarray_1 @array @directUnwrap = @inheritAnyTag $regarray_1 $regarrayedge_1_1
    immutable(Production)(immutable(NonterminalID)(57), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 57), "", "", false, false, ["inheritAnyTag"], []),
                immutable(SymbolInstance)(immutable(Symbol)(false, 59), "", "", false, false, [], [])
            ], [], [], false, false),
    // 121: $regarray_1 @array @directUnwrap = @inheritAnyTag $regarrayedge_0_1
    immutable(Production)(immutable(NonterminalID)(57), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 58), "", "", false, false, ["inheritAnyTag"], [])
            ], [], [], false, false),
    // 122: $regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <Annotation
    immutable(Production)(immutable(NonterminalID)(58), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 123: $regarrayedge_0_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(58), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 124: $regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <Annotation
    immutable(Production)(immutable(NonterminalID)(59), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 5), "", "", true, false, ["excludeDirectUnwrap"], [])
            ], [], [], false, false),
    // 125: $regarrayedge_1_1 @directUnwrap = @excludeDirectUnwrap <NegativeLookahead
    immutable(Production)(immutable(NonterminalID)(59), [
                immutable(SymbolInstance)(immutable(Symbol)(false, 39), "", "", true, false, ["excludeDirectUnwrap"], [])
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
