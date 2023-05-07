
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.ebnf;
import dparsergen.core.dynamictree;
import dparsergen.core.location;
import dparsergen.core.nodetype;
import dparsergen.core.utils;
import std.algorithm;
import std.conv;
import std.exception;
import std.string;

alias Tree = DynamicParseTree!(LocationAll, LocationRangeStartEnd);
alias TreeToken = DynamicParseTreeToken!(LocationAll, LocationRangeStartEnd);
alias TreeNonterminal = DynamicParseTreeNonterminal!(LocationAll, LocationRangeStartEnd);
alias TreeArray = DynamicParseTreeArray!(LocationAll, LocationRangeStartEnd);

string concatTree(Tree)(Tree tree)
{
    string r;
    if (tree is null)
        return "";
    if (tree.nodeType == NodeType.token)
        r = " " ~ tree.content;
    else
        foreach (c; tree.childs)
            r ~= concatTree(c);
    return r;
}

string ebnfTreeToString(const Tree tree, const Tree parent = null)
{
    string r;
    if (tree.name == "Concatenation")
    {
        r = "{";
        bool needsSpace;
        foreach (c; tree.childs[0 .. $ - 1])
        {
            if (c.nodeType == NodeType.array)
            {
                foreach (c2; c.childs)
                {
                    if (needsSpace)
                        r ~= " ";
                    r ~= ebnfTreeToString(c2);
                    needsSpace = true;
                }
            }
            else
            {
                if (needsSpace)
                    r ~= " ";
                r ~= ebnfTreeToString(c);
                needsSpace = true;
            }
        }
        if (tree.childs[$ - 1].memberOrDefault!"childs".length)
        {
            r ~= " " ~ ebnfTreeToString(tree.childs[$ - 1], tree);
            if (r.endsWith(" "))
                r = r[0 .. $ - 1];
        }
        r ~= "}";
    }
    else if (tree.name == "Alternation")
    {
        r = "{";
        void addAlternation(const Tree tree)
        {
            if (tree.name == "Alternation")
            {
                addAlternation(tree.childs[0]);
                r ~= " | ";
                r ~= ebnfTreeToString(tree.childs[2]);
            }
            else
            {
                r ~= ebnfTreeToString(tree);
            }
        }

        addAlternation(tree);
        r ~= "}";
    }
    else if (tree.name == "ParenExpression")
    {
        r = ebnfTreeToString(tree.childs[1]);
    }
    else if (tree.name == "MacroInstance")
    {
        const(Tree)[] childs = tree.childs[2].memberOrDefault!"childs";
        r = text(tree.childs[0].content, "(", childs.filter!(c => !c.isToken)
                .map!(c => ebnfTreeToString(c))
                .join(", "), ")");
    }
    else if (tree.name == "Tuple")
    {
        const(Tree)[] childs = tree.childs[1].memberOrDefault!"childs";
        r = text("t(", childs.filter!(c => !c.isToken)
                .map!(c => ebnfTreeToString(c))
                .join(", "), ")");
    }
    else if (tree.name == "SubToken")
    {
        r = text("{", tree.childs
                .filter!(c => !c.isToken)
                .map!(c => ebnfTreeToString(c))
                .join(" >> "), "}");
    }
    else if (tree.name == "TokenMinus")
    {
        r = text("{", tree.childs
                .filter!(c => !c.isToken)
                .map!(c => ebnfTreeToString(c))
                .join(" - "), "}");
    }
    else if (tree.name == "Annotation")
    {
        r = text("@", tree.childs[1].content);
        if (tree.childs[2]!is null)
        {
            r ~= "(" ~ concatTree(tree.childs[2].childs[1]).strip() ~ ")";
        }
        r ~= " ";
    }
    else if (tree.name == "NegativeLookahead")
    {
        if (tree.childs[1].isToken)
            r = text("!", tree.childs[1].content);
        else
            r = text("!", ebnfTreeToString(tree.childs[1]));
        r ~= " ";
    }
    else
    {
        foreach (c; tree.childs)
        {
            if (c is null)
            {
            }
            else if (c.nodeType == NodeType.token)
            {
                r ~= c.content;
                if (c.content == ",")
                    r ~= " ";
            }
            else
            {
                r ~= ebnfTreeToString(c);
            }
        }
    }
    return r;
}

enum DeclarationType
{
    auto_,
    token,
    fragment
}

struct Declaration
{
    DeclarationType type;
    string name;
    Tree exprTree;
    string[] parameters;
    immutable(string)[] annotations;
    size_t variadicParameterIndex = size_t.max;
    string documentation;
}

struct EBNF
{
    Declaration[] symbols;
    string[2][] matchingTokens;
    string[] imports;
    size_t startTokenID;
    size_t startNonterminalID;
    size_t startProductionID;
    string globalDocumentation;
}

Tree replaceNames(Tree[string] table, Tree tree)
{
    if (tree is null)
        return tree;
    if (tree.nodeType == NodeType.token)
        return tree;

    if (tree.name == "Name" && tree.childs[0].content in table)
    {
        return table[tree.childs[0].content];
    }
    else if (tree.name.among("MacroInstance", "Tuple"))
    {
        Tree[] childs = tree.childs.dup;
        foreach (ref c; childs)
        {
            c = replaceNames(table, c);
        }
        Tree[] parameters = childs[$ - 2].memberOrDefault!"childs";
        Tree[] newParameters;
        foreach (p; parameters)
        {
            Tree realParameter = p;
            Tree annotatedExpression;
            if (p.nodeType == NodeType.nonterminal && p.name == "AnnotatedExpression")
            {
                annotatedExpression = p;
                realParameter = annotatedExpression.childs[$ - 1];
            }

            if (realParameter.nodeType == NodeType.nonterminal
                    && realParameter.name == "UnpackVariadicList"
                    && realParameter.childs[0].content in table)
            {
                Tree replacement = table[realParameter.childs[0].content];
                while (replacement.nodeType == NodeType.nonterminal
                        && replacement.name == "AnnotatedExpression")
                    replacement = replacement.childs[$ - 1];
                enforce(replacement.name == "Tuple",
                        text("Parameter is not tuple, but ", replacement));
                foreach (c; replacement.childs[$ - 2].memberOrDefault!"childs")
                {
                    if (c.isToken)
                        continue;
                    while (c.nodeType == NodeType.nonterminal && c.name == "AnnotatedExpression")
                        c = c.childs[$ - 1];
                    if (c is null)
                        continue;
                    if (annotatedExpression)
                    {
                        newParameters ~= new TreeNonterminal(annotatedExpression.nonterminalID,
                                annotatedExpression.productionID,
                                annotatedExpression.childs.dup, annotatedExpression.grammarInfo);
                        newParameters[$ - 1].childs[$ - 1] = c;
                    }
                    else
                        newParameters ~= c;
                }
            }
            else
                newParameters ~= p;
        }
        childs[$ - 2] = new TreeArray(newParameters, null);
        auto r = new TreeNonterminal(tree.nonterminalID, tree.productionID,
                childs, tree.grammarInfo);
        return r;
    }
    else
    {
        Tree[] childs = tree.childs.dup;
        foreach (ref c; childs)
        {
            c = replaceNames(table, c);
        }
        if (tree.nodeType == NodeType.nonterminal)
            return new TreeNonterminal(tree.nonterminalID, tree.productionID,
                    childs, tree.grammarInfo);
        else if (tree.nodeType == NodeType.array)
            return new TreeArray(childs, tree.grammarInfo);
        else
            assert(false);
    }
}
