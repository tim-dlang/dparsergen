# Example grammar for D

This example shows how to parse source code in the D programming language
using DParserGen. The grammar for D is in file grammard.ebnf, which
uses rules for the lexer from file grammardlex.ebnf.
File grammarddoc.ebnf also contains a grammar for DDOC, which is used
to extract the grammar from the source of dlang.org using grammardgen.d.

Example testgrammard.d uses a parser and a lexer generated from
grammard.ebnf and grammardlex.ebnf to parse D files.

The application can be built with the following command:
```sh
dub build
```

The following command runs the application with the source file as input:
```sh
./example_d testgrammard.d
```

Different options also allow to test the grammar on the test suite of
DMD and other folders with source code.
