import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import dparsergen.core.nonterminalunion;
import dparsergen.core.parseexception;
import std.conv;
import std.math;
import std.stdio;
import std.string;
import std.uni;

import P = grammarcalc;

alias L = imported!"grammarcalc_lexer".Lexer!LocationAll;

/**
Custom parse tree creator, which directly calculates the answer
instead of building a complete parse tree.
*/
class Creator
{
    alias Location = LocationAll;
    alias LocationDiff = typeof(Location.init - Location.init);
    alias Type = double;
    enum startNonterminalID = P.startNonterminalID;
    enum endNonterminalID = P.endNonterminalID;

    template NonterminalType(SymbolID nonterminalID)
    {
        static if (P.allNonterminals[nonterminalID - P.startNonterminalID].flags & NonterminalFlags.array)
            alias NonterminalType = double[];
        else static if (P.allNonterminals[nonterminalID - P.startNonterminalID].flags & NonterminalFlags.string)
            alias NonterminalType = string;
        else
            alias NonterminalType = double;
    }

    alias NonterminalUnion = GenericNonterminalUnion!(Creator).Union;
    alias NonterminalUnionAny = GenericNonterminalUnion!(Creator).Union!(SymbolID.max, size_t.max);

    template createParseTree(SymbolID productionID)
    {
        NonterminalType!(P.allProductions[productionID - P.startProductionID].nonterminalID.id) createParseTree(T...)(Location firstParamStart, Location lastParamEnd, T params)
        {
            enum nonterminalID = P.allProductions[productionID - P.startProductionID].nonterminalID.id;
            enum nonterminalName = P.allNonterminals[nonterminalID - P.startNonterminalID].name;
            enum nonterminalFlags = P.allNonterminals[nonterminalID - P.startNonterminalID].flags;
            enum symbols = P.allProductions[productionID - P.startProductionID].symbols;
            assert(firstParamStart <= lastParamEnd);

            static if (nonterminalFlags & NonterminalFlags.array)
            {
                double[] r;
                foreach (p; params)
                    r ~= p.val;
                return r;
            }
            else static if (nonterminalName == "Primary" && symbols.length == 1)
                return to!double(params[0].val);
            else static if (nonterminalName == "Primary" && symbols.length == 3)
                return params[1].val;
            else static if (nonterminalName == "Constant" && symbols.length == 1)
            {
                static foreach (name; ["E", "PI"])
                {
                    if (icmp(params[0].val, name) == 0)
                        mixin("return std.math." ~ name ~ ";");
                }
                throw new ParseException("Unknown constant " ~ params[0].val);
            }
            else static if (nonterminalName == "FunctionCall" && symbols.length == 4)
            {
                size_t expectedArguments;
                double[] arguments = params[2].val;
                static foreach (name; [
                        "abs", "fabs", "sqrt", "cbrt", "sin", "cos", "tan", "asin",
                        "acos", "atan", "sinh", "cosh", "tanh", "asinh", "acosh",
                        "atanh", "ceil", "floor", "round", "lround", "trunc",
                        "rint", "lrint", "nearbyint", "rndtol", "exp", "exp2",
                        "expm1", "log", "log2", "log10", "logb", "ilogb", "log1p"
                    ])
                {
                    if (icmp(params[0].val, name) == 0)
                    {
                        if (arguments.length != 1)
                            expectedArguments = 1;
                        else
                            mixin("return std.math." ~ name ~ "(arguments[0]);");
                    }
                }
                static foreach (name; ["atan2", "quantize", "pow"])
                {
                    if (icmp(params[0].val, name) == 0)
                    {
                        if (arguments.length != 2)
                            expectedArguments = 2;
                        else
                            mixin("return std.math." ~ name ~ "(arguments[0], arguments[1]);");
                    }
                }
                if (expectedArguments)
                    throw new ParseException(text("Function ", params[0].val, " needs ",
                            expectedArguments, " arguments and not ", arguments.length));
                else
                    throw new ParseException("Unknown function " ~ params[0].val);
            }
            // Productions looking like binary operators
            else static if (symbols.length == 3 && symbols[1].isToken)
            {
                enum opToken = P.allTokens[symbols[1].toTokenID.id].name;
                static assert(opToken.length >= 3 && opToken[0] == '"' && opToken[$ - 1] == '"');
                mixin("return params[0].val " ~ opToken[1 .. $ - 1] ~ " params[2].val;");
            }
            // Productions looking like unary operators
            else static if (symbols.length == 2 && symbols[0].isToken)
            {
                enum opToken = P.allTokens[symbols[0].toTokenID.id].name;
                static assert(opToken.length >= 3 && opToken[0] == '"' && opToken[$ - 1] == '"');
                mixin("return " ~ opToken[1 .. $ - 1] ~ " params[1].val;");
            }
            else
            {
                pragma(msg, nonterminalName, " ", params.length);
                pragma(msg, T);
                static assert(false);
            }
        }
    }

    void adjustStart(T)(T result, Location start)
    {
    }
}

void main()
{
    Creator creator = new Creator;

    while (true)
    {
        string inputText;
        bool canContinue;
        do
        {
            stdout.write(inputText.length ? "... " : ">>> ");

            string line = stdin.readln;
            if (line.length == 0)
                return;
            inputText ~= line;

            string strippedText = inputText.strip();
            if (strippedText == "quit" || strippedText == "exit" || strippedText == ":q")
                return;

            canContinue = false;
            try
            {
                auto tree = P.parse!(Creator, L)(inputText, creator, LocationAll.init);
                writeln(tree);
            }
            catch (ParseException e)
            {
                if (e.msg == "EOF")
                    canContinue = e.msg == "EOF";
                else
                {
                    stderr.writeln("Error: ", e.msg);
                }
            }
        }
        while (canContinue);
    }
}
