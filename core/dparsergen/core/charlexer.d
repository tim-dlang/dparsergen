
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.charlexer;
import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import std.array;
import std.conv;

/**
Simple lexer, which treats every byte as a token. This is only used
for tests.
*/
struct CharLexer
{
    string input;

    /**
    Creates a character based lexer.

    Params:
        input = Whole input text.
        startLocation = Initial location at start of input.
    */
    this(string input, LocationBytes startLocation = LocationBytes.init)
    {
        this.input = input;
        this.front.currentLocation = startLocation;
        popFront;
    }

    /**
    Gets the internal ID for token with name `tok`.
    */
    template tokenID(string tok)
    {
        static if (tok.length == 3 && tok[0] == '\"' && tok[2] == '\"')
            enum tokenID = tok[1];
        else static if (tok == "$end")
            enum tokenID = 256;
        else static if (tok == "$flushreduces")
            enum tokenID = 257;
        else
            static assert(false, "CharLexer does not support token " ~ tok);
    }

    /**
    Gets the name for token with ID `id`.
    */
    string tokenName(SymbolID id)
    {
        if (id == 256)
            return "$end";
        if (id == 257)
            return "$flushreduces";
        return text("\"", cast(char) id, "\"");
    }

    /**
    Stores information about the current token.
    */
    static struct Front
    {
        /**
        Text content of this token.
        */
        string content;

        /**
        ID of this token.
        */
        SymbolID symbol;

        /**
        Start location of this token.
        */
        LocationBytes currentLocation;

        /**
        End location of this token.
        */
        LocationBytes currentTokenEnd()
        {
            return LocationBytes(cast(typeof(currentLocation.bytePos))(
                    currentLocation.bytePos + content.length));
        }
    }

    /// ditto
    Front front;

    /**
    True if all tokens are consumed.
    */
    bool empty;

    /**
    Advances to the next token and updates front and empty.
    */
    void popFront()
    {
        input = input[front.content.length .. $];
        front.currentLocation.bytePos += front.content.length;
        if (input.empty)
        {
            front.content = "";
            front.symbol = SymbolID(0);
            empty = true;
        }
        else
        {
            auto t = input[0 .. 1];
            front.content = t;
            front.symbol = t[0];
            empty = false;
        }
    }
}
