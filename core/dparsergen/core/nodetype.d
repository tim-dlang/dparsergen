
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.core.nodetype;

/**
Type for nodes in the parse tree.
*/
enum NodeType : ubyte
{
    /// Token or nonterminal marked as string.
    token,
    /// Normal nonterminal.
    nonterminal,
    /// Nonterminal marked as array.
    array,
    /// Multiple ambiguous nonterminals merged into a single node.
    merged
}
