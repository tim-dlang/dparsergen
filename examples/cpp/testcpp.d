import dparsergen.core.dynamictree;
import dparsergen.core.grammarinfo;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
static import grammarcpp;
static import grammarcpp_lexer;
static import grammarcpreproc;
static import grammarcpreproc_lexer;
import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.file;
import std.stdio;

/**
Custom type, which stores the filename in addition to the position in the file.
*/
struct Location
{
    LocationAll loc;
    string filename;
    alias LocationDiff = LocationAll.LocationDiff;

    this(LocationAll loc, string filename = "")
    {
        this.loc = loc;
        this.filename = filename;
    }

    auto bytePos() const
    {
        return loc.bytePos;
    }

    auto line() const
    {
        return loc.line;
    }

    auto offset() const
    {
        return loc.offset;
    }

    enum invalid = Location(LocationAll.invalid);

    bool isValid() const
    {
        return loc.isValid;
    }

    LocationDiff opBinary(string op)(const Location rhs) const if (op == "-")
    {
        if (rhs.filename == filename)
            return loc - rhs.loc;
        else
            return LocationDiff.invalid;
    }

    Location opBinary(string op)(const LocationDiff rhs) const if (op == "+")
    {
        if (this == invalid || rhs == LocationDiff.invalid)
            return invalid;
        else
            return Location(loc + rhs, filename);
    }

    void opOpAssign(string op)(const LocationDiff rhs) if (op == "+")
    {
        loc += rhs;
    }

    int opCmp(const Location rhs) const
    {
        if (filename < rhs.filename)
            return -1;
        if (filename > rhs.filename)
            return 1;
        return loc.opCmp(rhs.loc);
    }

    string toPrettyString() const
    {
        return text(filename, ":", line + 1, ":", offset + 1);
    }
}

alias Tree = DynamicParseTree!(Location, LocationRangeStartLength);
alias CreatorCpp = DynamicParseTreeCreator!(grammarcpp, Location, LocationRangeStartLength);
alias CreatorPreproc = DynamicParseTreeCreator!(grammarcpreproc, Location,
        LocationRangeStartLength);

/**
State of parser and current location during parse.
*/
struct ParseState
{
    grammarcpp.PushParser!(CreatorCpp, string) pushParser;
    string currentFilename;
    int lineOffset;
}

/**
Push tokens from preprocessed file into parser.
*/
void pushTokens(ref ParseState state, Tree preprocTree)
{
    if (preprocTree.nodeType == NodeType.array)
    {
        foreach (child; preprocTree.childs)
        {
            pushTokens(state, child);
        }
    }
    else if (preprocTree.nodeType == NodeType.nonterminal && preprocTree.name == "EmptyLine")
    {
    }
    else if (preprocTree.nodeType == NodeType.nonterminal && preprocTree.name == "PreprocessingFile")
    {
        pushTokens(state, preprocTree.childs[0]);
    }
    else if (preprocTree.nodeType == NodeType.nonterminal && preprocTree.name == "TextLine")
    {
        pushTokens(state, preprocTree.childs[1]);
    }
    else if (preprocTree.nodeType == NodeType.nonterminal && preprocTree.name == "LineAnnotation")
    {
        if (preprocTree.hasChildWithName("filename"))
        {
            Tree childFilename = preprocTree.childByName("filename");
            enforce(childFilename.content.startsWith("\""));
            enforce(childFilename.content.endsWith("\""));
            state.currentFilename = childFilename.content[1 .. $ - 1];
        }
        Tree childLine = preprocTree.childByName("line");
        state.lineOffset = childLine.content.to!int - int(preprocTree.end.line + 1);
    }
    else if (preprocTree.nodeType == NodeType.nonterminal && preprocTree.name == "Token")
    {
        alias Lexer = grammarcpp_lexer.Lexer!(Location);

        assert(preprocTree.childs[0].nodeType == NodeType.token);
        auto lexer = Lexer(preprocTree.childs[0].content);
        Location location = preprocTree.childs[0].start;
        location.filename = state.currentFilename;
        location.loc.line += state.lineOffset;
        lexer.front.currentLocation = location;

        enforce(!lexer.empty);

        SymbolID symbolID = grammarcpp.translateTokenIdFromLexer!Lexer(lexer.front.symbol);
        state.pushParser.pushToken(symbolID, lexer.front.content,
                lexer.front.currentLocation, lexer.front.currentTokenEnd);

        lexer.popFront();
        enforce(lexer.empty);
    }
    else
    {
        throw new Exception("Only preprocessed code supported");
    }
}

int main(string[] args)
{
    string filename;
    bool verbose;
    bool preprocOnly;
    foreach (arg; args[1 .. $])
    {
        if (arg.startsWith("-"))
        {
            if (arg == "-v")
                verbose = true;
            else if (arg == "-p")
                preprocOnly = true;
            else if (arg == "-h")
            {
                filename = "";
                break;
            }
            else
            {
                stderr.writeln("Unknown option ", arg);
            }
        }
        else
        {
            if (filename.length)
            {
                stderr.writeln("Too many arguments");
                return 1;
            }
            filename = arg;
        }
    }
    if (filename.length == 0)
    {
        stderr.writeln("Usage: testcpp [OPTIONS] filename.cpp");
        stderr.writeln("    -v Verbose output");
        stderr.writeln("    -p Show tree of preprocessor grammar");
        stderr.writeln("    -h Show this help");
        return 0;
    }

    string inText = cast(string) read(filename);

    Tree preprocTree;
    try
    {
        auto creator = new CreatorPreproc;
        preprocTree = grammarcpreproc.parse!(CreatorPreproc,
                grammarcpreproc_lexer.Lexer!Location)(inText, creator,
                Location(LocationAll.init, filename));
        assert(preprocTree.inputLength.bytePos <= inText.length);
    }
    catch (Exception e)
    {
        stderr.writeln(e);
        return 1;
    }

    if (preprocOnly)
    {
        printTree(stdout, preprocTree, verbose);
        return 0;
    }

    Tree tree;
    try
    {
        auto creator = new CreatorCpp;

        ParseState state = ParseState(grammarcpp.PushParser!(CreatorCpp,
                string)(creator), filename);
        state.pushParser.startParseTranslationUnit();

        pushTokens(state, preprocTree);

        state.pushParser.pushEnd();

        tree = state.pushParser.getParseTree!"TranslationUnit";
    }
    catch (Exception e)
    {
        stderr.writeln(e);
        return 1;
    }

    printTree(stdout, tree, verbose);

    return 0;
}
