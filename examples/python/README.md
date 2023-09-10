# Example grammar for Python

This is an example for parsing [Python](https://www.python.org/).
The grammar is in file grammarpython.ebnf. Application testpython.d uses
it to parse Python files and print a parse tree.

Python uses the indentation to define the structure of the source code.
The generated lexer does not directly implement this. Instead the
grammar contains the tokens `Indent` and `Dedent` without a definition.
A wrapper around the lexer in the application keeps track of the current
indentation and generates these tokens, so the generated parser can use
them.

The application can be built with the following command:
```sh
dub build
```

It is also possible to test the grammar on test cases from
https://github.com/python/cpython/tree/main/Lib/test using the argument `--test-dir`:
```sh
git clone https://github.com/python/cpython.git
git -C cpython checkout 3979150a0d406707f6d253d7c15fb32c1e005a77
./example_python --test-dir cpython/Lib/test/
```
It will only print on errors, so the expected output is empty.

The grammar is based on the official grammar at https://docs.python.org/3/reference/lexical_analysis.html
and https://docs.python.org/3/reference/grammar.html.
The grammar was converted with the program grammarpythongen.d, which
uses grammarpeg.ebnf. Some manual changes were also made.
