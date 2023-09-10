# DParserGen

Parser generator for the D programming language.

## Features

* Lexer and parser can be generated from the same grammar file.
* The user can provide a template for creating the parse trees.
* Grammar files can import other grammars.
* Parametrized symbols (inspired by Pegged).
* Documentation can be generated from grammar files using documentation comments.
* Automatic grammar rewriting for optimizations and avoiding conflicts.
* Lexer
  * Uses the longest token by default, but tokens can also be configured
    to stop at the minimial match.
  * The lexer allows limited recursive grammar rules, which can be used for e.g. nested block comments.
* LALR parser
  * Recursive Ascent Parser.
  * Pulls tokens from the lexer.
  * Backtracking for annotated nonterminals.
* GLR parser
  * Ambiguities can be represented as special nodes in the parse tree.
  * Tokens can be pushed into the parser.

## Limitations

* Lexer and parser are not yet very optimized.
* The generated parser can be big for big grammars, like D and C++,
  requiring much memory when compiling.
* Error messages can still be improved.

## Examples

Different examples are in subfolders of [examples/](examples/). Every example also
has a file README.md with more details.

An example grammar for parsing JSON files is in folder [examples/json/](examples/json/).
The parse tree for a JSON file can be printed by an example application.

Folder [examples/calc/](examples/calc/) contains a grammar for simple arithmetic expressions.
The application reads expressions from stdin and directly calculates
the answer without building a parse tree.

A grammar for the D programming language is in [examples/d/](examples/d/). The parser
uses LALR with different extensions, like backtracking. A parse tree
can be printed by the example application. It can also test the grammar
using the test suite of DMD.

Folder [examples/cpp/](examples/cpp/) contains grammars for C++ and the preprocessor.
The parser for C++ uses GLR, while the grammar for the preprocessor can
use LALR. The example application shows the parse tree for a C++ file,
which needs to be already preprocessed.

An example for parsing Python is is folder [examples/python/](examples/python/).
It uses a wrapper around the generated lexer, which keeps track of the
indentation level.

The folder [tests/grammars/](tests/grammars/) also contains example grammars, but some
of them test corner cases and should not be used as examples for
real grammars.

## Documentation

The parser and lexer generator is documented in
[docs/generator.md](docs/generator.md). Documentation of the syntax for
grammar files is in [docs/syntax.md](docs/syntax.md), which was
generated from the grammar in
[grammarebnf.ebnf](generator/dparsergen/generator/grammarebnf.ebnf).
An overview of the API is in [docs/api.md](docs/api.md).

## License

Boost Software License, Version 1.0. See file [LICENSE_1_0.txt](LICENSE_1_0.txt).
