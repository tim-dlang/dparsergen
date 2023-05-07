
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.codewriter;
import std.algorithm;
import std.array;
import std.conv;
import std.string;

struct CodeWriter
{
    private char[] buffer;
    size_t dataSize;
    size_t indent;
    string indentStr = "\t";
    string customIndent;
    bool inLine;
    size_t currentLine;
    size_t currentOffset;
    size_t lineStart;

    void ensureAddable(size_t n)
    {
        if (dataSize + n > buffer.length)
        {
            size_t newSize = dataSize;
            if (newSize < 1024)
                newSize = 1024;
            while (dataSize + n > newSize)
                newSize *= 2;
            buffer.length = newSize;
        }
    }

    void put(string data)
    {
        ensureAddable(data.length);
        buffer[dataSize .. dataSize + data.length] = data;
        dataSize += data.length;
    }

    void put(char c)
    {
        ensureAddable(1);
        buffer[dataSize] = c;
        dataSize++;
    }

    const(char)[] data() const
    {
        return buffer[0 .. dataSize];
    }

    void endLine()
    {
        if (!inLine)
        {
            lineStart = data.length;
        }
        put('\n');
        inLine = false;
        currentLine++;
        currentOffset = 0;
    }

    void startLine(bool afterNewline = false)
    {
        if (!inLine)
        {
            if (!afterNewline)
            {
                lineStart = data.length;
            }
            foreach (i; 0 .. indent)
                put(indentStr);
            currentOffset += indent;
            put(customIndent);
            currentOffset += customIndent.length;
            inLine = true;
        }
    }

    ref CodeWriter write(T...)(T args) return
    {
        bool afterNewline;
        foreach (arg; args)
        {
            foreach (char c; text(arg))
            {
                if (c == '\n')
                {
                    endLine();
                    afterNewline = true;
                }
                else
                {
                    startLine(afterNewline);
                    put(c);
                    currentOffset++;
                }
            }
        }
        return this;
    }

    ref CodeWriter writeln(T...)(T args) return
    {
        write(args);
        endLine();
        return this;
    }

    ref CodeWriter incIndent(size_t n = 1) return
    {
        indent += n;
        return this;
    }

    ref CodeWriter decIndent(size_t n = 1, string func = __FUNCTION__,
            string file = __FILE__, size_t line = __LINE__) return
    {
        assert(indent >= n, text("CodeWrite.decIndent indent=", indent, " n=",
                n, "  ", func, " (", file, ":", line, ")"));
        indent -= n;
        return this;
    }
}

void splitInput(alias onNormalText, alias onMacro)(string input)
{
    uint status;
    size_t start;
    size_t varstart;
    foreach (i, char c; input)
    {
        if (status == 0)
        {
            if (c == '$')
            {
                status = 1;
                varstart = i;
            }
        }
        else if (status == 1)
        {
            if (c == '(')
            {
                status = 2;
            }
            else
            {
                status = 0;
            }
        }
        else if (status == 2)
        {
            if (c == ')')
            {
                status = 0;
                onNormalText(input[start .. varstart]);
                onMacro(input[varstart + 2 .. i], "");
                start = i + 1;
            }
            if (c == '(')
            {
                status++;
            }
        }
        else if (status > 2)
        {
            if (c == '(')
                status++;
            if (c == ')')
                status--;
        }
        else
            assert(false);
    }
    onNormalText(input[start .. $]);
}

string escapeDString(string s)
{
    char[] buffer;
    buffer.length = 2 * s.length;
    size_t i;
    foreach (char c; s)
    {
        if (c == '\"')
        {
            buffer[i] = '\\';
            i++;
            buffer[i] = '\"';
            i++;
        }
        else if (c == '\t')
        {
            buffer[i] = '\\';
            i++;
            buffer[i] = 't';
            i++;
        }
        else if (c == '\\')
        {
            buffer[i] = '\\';
            i++;
            buffer[i] = '\\';
            i++;
        }
        else
        {
            buffer[i] = c;
            i++;
        }
    }
    return buffer[0 .. i].idup;
}

size_t startWhitespace(string s, size_t spacesPerTab = 4)
{
    size_t numWS;
    size_t spaces;
    foreach (char c; s)
    {
        if (c == '\t')
        {
            numWS++;
            spaces = 0;
        }
        else if (c == ' ')
        {
            spaces++;
            if (spaces == spacesPerTab)
            {
                numWS++;
                spaces = 0;
            }
        }
        else
            break;
    }
    return numWS;
}

string removeStartWhitespace(string s, size_t startWS, size_t spacesPerTab = 4)
{
    size_t numWS;
    size_t spaces;
    foreach (i, char c; s)
    {
        if (numWS >= startWS)
            break;
        if (c == '\t')
        {
            numWS++;
            s = s[1 .. $];
            spaces = 0;
        }
        else if (c == ' ')
        {
            spaces++;
            if (spaces == spacesPerTab)
            {
                numWS++;
                s = s[spaces .. $];
                spaces = 0;
            }
        }
        else
            break;
    }
    return s;
}

string intToStr(long l)
{
    char[20] buffer;
    size_t i;
    bool negative;
    if (l < 0)
    {
        negative = true;
        l = -l;
    }
    while (l != 0)
    {
        i++;
        buffer[$ - i] = '0' + l % 10;
        l = l / 10;
    }
    if (negative)
    {
        i++;
        buffer[$ - 1] = '-';
    }
    return buffer[$ - i .. $].idup;
}

string genCode(string code, string str, string callingFunction = __FUNCTION__,
        string callingFilename = __FILE__, size_t callingLine = __LINE__)
{
    CodeWriter app;
    string[] lines = str.splitLines;
    if (lines[0] == "")
    {
        lines = lines[1 .. $];
        callingLine++;
        app.put("\n");
    }
    if (lines[$ - 1].all!((c) => c == '\t' || c == ' '))
        lines = lines[0 .. $ - 1];

    size_t minNumWhitespace = size_t.max;
    foreach (i, l; lines)
    {
        if (l.all!((c) => c == '\t' || c == ' '))
            continue;
        size_t numWhitespace = l.startWhitespace;
        if (numWhitespace < minNumWhitespace)
            minNumWhitespace = numWhitespace;
    }

    static struct IgnoreInfo
    {
        size_t indent;
        size_t lineNr;
    }

    Appender!(IgnoreInfo[]) ignoreInfos;

    size_t currentStartWhitespace = 0;
    bool inCodeWriteStmt = false;
    void startCode()
    {
        assert(!inCodeWriteStmt);
        inCodeWriteStmt = true;
        app.put(code);
    }

    void endCode()
    {
        if (!inCodeWriteStmt)
            return;
        inCodeWriteStmt = false;
        app.put(text(";\n"));
    }

    void adjustStartWhitespace(size_t n, size_t debugLine, bool doEndCode = false,
            bool doStartCode = false)
    {
        assert(n >= ignoreInfos.data.length, text("n=", n, "  ignoreWhitespace=",
                ignoreInfos.data.length, " line ", debugLine, ":\n", lines[debugLine]));
        if (n < ignoreInfos.data.length)
        {
            n = ignoreInfos.data.length;
        }
        n -= ignoreInfos.data.length;
        if (n < currentStartWhitespace)
        {
            if (!inCodeWriteStmt)
                app.put(code);
            app.put(text(".decIndent(", intToStr(currentStartWhitespace - n), ", \"", callingFunction,
                    "\", \"", callingFilename.escapeDString, "\", ", callingLine + debugLine, ")"));
            if (!inCodeWriteStmt)
                app.put(";");
        }
        if (doEndCode)
            endCode();
        if (doStartCode)
            startCode();
        if (n > currentStartWhitespace)
        {
            if (!inCodeWriteStmt)
                app.put(code);
            app.put(text(".incIndent(", intToStr(n - currentStartWhitespace), ")"));
            if (!inCodeWriteStmt)
                app.put(";");
        }
        currentStartWhitespace = n;
    }

    foreach (lineNr, l; lines)
    {
        if (l.startWhitespace < minNumWhitespace)
        {
            foreach (char c; l)
                assert(c == '\t' || c == ' ');
            endCode();
            startCode();
            app.put(text(".writeln()"));
            continue;
        }
        auto line = l.removeStartWhitespace(minNumWhitespace);
        auto st = line.startWhitespace;
        line = line.removeStartWhitespace(st);
        if (line.startsWith("$$"))
        {
            string errorMessage;
            foreach (char c; line)
            {
                if (c == '}')
                {
                    assert(ignoreInfos.data.length, text(callingFunction, " (",
                            callingFilename, ":", callingLine + lineNr, ")"));
                    if (st != ignoreInfos.data[$ - 1].indent)
                    {
                        errorMessage = text("Braces don't match: ", callingFunction,
                                " indent = ", ignoreInfos.data[$ - 1].indent,
                                " (", callingFilename, ":",
                                callingLine + ignoreInfos.data[$ - 1].lineNr, ")", " indent = ",
                                st, " (", callingFilename, ":", callingLine + lineNr, ")");
                        st = ignoreInfos.data[$ - 1].indent;
                    }
                    ignoreInfos.shrinkTo(ignoreInfos.data.length - 1);
                }
            }
            adjustStartWhitespace(st, lineNr);
            endCode();
            if (errorMessage.length)
                app.put(text("pragma(msg, \"", errorMessage.escapeDString, "\");"));
            app.put(line[2 .. $]);
            app.put("\n");
            foreach (char c; line)
            {
                if (c == '{')
                    ignoreInfos.put(IgnoreInfo(st, lineNr));
            }
        }
        else
        {
            adjustStartWhitespace(st, lineNr, true, true);
            bool addNewLine = true;
            if (line.endsWith("  _"))
            {
                addNewLine = false;
                line = line[0 .. $ - 3];
            }

            line.splitInput!(
                (t) { app.put(text(".write(\"", t.escapeDString, "\")")); },
                (m, p) { app.put(text(".write(", m, ")")); });
            if (addNewLine)
                app.put(text(".writeln()"));
        }
    }
    adjustStartWhitespace(0, lines.length - 1, true, false);

    return app.data.idup;
}
