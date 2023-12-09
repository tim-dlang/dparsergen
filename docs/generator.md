# DParserGen Generator documentation

The source code for lexer and parser is generated from the grammar file
using the program dparsergen.

```
dparsergen grammar.ebnf [OPTIONS]
-o --parser             Output filename for parser
   --module             Set module name for parser
   --lexer-module       Set module name for lexer
   --package            Set package for parser and lexer
   --lexer              Generate lexer in this file
   --glr                Generate parser with GLR instead of LALR
   --combinedreduce     Allows to resolve some conflicts
   --mergesimilarstates Reduce number of parser states by combining some states
   --lexer-dfa          Generate graph for lexer
   --graph              Generate graph for parser
   --finalgrammar       Generate grammar file after all grammar rewritings
   --doc-html           Generate documentation in HTML format
   --doc-md             Generate documentation in Markdown format
   --optdescent         Try to make decisions in the parser earlier
   --optempty           Rewrite grammar to remove empty productions
   --regexlookahead     Try to resolve conflicts with arbitrary lookahead
   --glr-global-cache   Use a global cache for the GLR parser (normally not needed)
-h --help               Print this help and exit
```

The generator needs a grammar file as input. The grammar file can also
import other files. Details for the syntax of grammar files are described
in [syntax.md](syntax.md). By default, it generates a LALR parser.
Instead, it can also generate a GLR parser using option `--glr`. A lexer for
the same grammar can be generated with option `--lexer`. It is possible to
generate documentation from the grammar using option `--doc-html` or
`--doc-md`. Other options set details for the generation of parser or
lexer or are useful for debugging.

## Backtracking

Normally the order of productions for a nonterminal is not important.
If two productions match a given text, then this would be a conflict.
Backtracking is an option to avoid the conflict by trying one production
first. A nonterminal can be marked with `@backtrack` to enable backtracking
for this nonterminal. The parser will then try the productions in the
order and use the first match. This is only used for the LALR parser and
is ignored by the GLR parser.

## Removing Empty Productions

Option `--optempty` can be used to rewrite the grammar, so it does not
contain empty productions anymore. This can be used to avoid some
conflicts if multiple empty productions would match otherwise.
The resulting parse tree can be slightly different, because empty parse tree
nodes can now be null instead.

## Direct Unwrap

The annotation `@directUnwrap` for nonterminals can be used to avoid some
conflicts. Consider the following example:

```
S @directUnwrap = <A | <B;
A @directUnwrap = <X | <Y;
B @directUnwrap = <Y | <Z;
```

This would result in a conflict without `@directUnwrap`, because the
parser can not decide if Y should be parsed as A or B. For the resulting
parse tree this decision does not matter, because A and B are replaced with
Y in the parse tree. With the annotation `@directUnwrap` the parser directly
uses Y without trying to put it into A or B first, so the conflict is
avoided.

## Grammar Rewriting for Arrays

The annotation `@regArray` is used to rewrite the grammar, so some conflicts
can be avoided for arrays. The exact productions used for array nonterminals
are not important, so the grammar can be rewritten without changing
the final parse tree. Consider the grammar in
[../tests/grammars/grammarregarray2.ebnf](../tests/grammars/grammarregarray2.ebnf)
as an example. It allows declarations
for variables and classes. Both have an optional list of attributes at
the start, but the allowed attributes are different: A class can have the
attributes const and final, but a variable can only have the attribute
const and not final.

Normally this grammar would have a reduce/reduce conflict, because
it can not decide if a const attribute should be part of VariableAttrs
or ClassAttrs without arbitrary lookahead. Using `@regArray` avoids the
conflict, because the grammar is internally rewritten. This can be done,
because the parse tree does not distinguish the different array types.

The grammar rewriting works by interpreting the nonterminals marked with
`@regArray` as regular expressions, but using other nonterminals and tokens
as elements instead of characters like normal regular expressions.
A deterministic finite automaton is created from the regular expressions
and used to rewrite the grammar.

## Arbitrary Lookahead

Normally the parser has only one or two tokens lookahead to decide, which
action should be taken. In some situations lookahead of arbitrary length
is needed. An example in the D grammar are function declarations,
which have optional template parameters. Both normal parameters and
template parameters are surrounded by parens, so the parser can only see
if template parameters are used by looking after the first paren pair.

The annotation `@lookahead` can be used to tell the parser generator, that
it should try to use arbitrary lookahead. There is also the option `--regexlookahead`
for the parser generator, which tells it to try this automatically for
conflicts. The parser generator builds an automaton for the lookahead.
The grammar can contain `match` declarations, which tell the
parser generator, that some tokens like parens normally come in pairs.
This is used for arbitrary lookahead to find relevant tokens without a full
parser.
