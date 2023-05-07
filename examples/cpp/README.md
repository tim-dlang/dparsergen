# Example grammar for C++

This example shows how to parse C++ files with DParserGen. It contains
two grammars and an additional file with shared rules:
* grammarcpreproc.ebnf splits the input in tokens and represents
    preprocessor constructs.
* grammarcpp.ebnf defines the structure of a C++ file, which is already
    preprocessed.
* grammarcppcommon.ebnf contains rules, which are used by both
    grammarcpreproc.ebnf and grammarcpp.ebnf.

The grammar is for C++11, but also contains some newer constructs and
extensions supported by GCC or MSVC. It is possible to extract the
grammar from the LaTeX source of different versions of the stardard
draft in https://github.com/cplusplus/draft using the D program
grammarcppgen.d, but the extracted grammar also needs some manual
modifications.

File testcpp.d contains an example for using the C++ grammars. First
it will parse the structure for the preprocessor using
grammarcpreproc.ebnf. Using option -p it will print this tree and
directly exit. Otherwise it will pass the tokens to a parser for
grammarcpp.ebnf and print the resulting tree. The C++ file needs
to be already preprocessed, because most preprocessor directives are
not handled by the example. The grammar for C++ contains some
ambiguities, so the parser uses GLR. Subtrees for ambiguities will
have names starting with "Merged:". The printed trees will by default
not show null subtrees and flatten arrays. The full tree can be printed
with option -v.

The application can be built with the following command:
```sh
dub build
```

The following command starts the application with file test.cpp as input:
```sh
./example_cpp test.cpp
```
