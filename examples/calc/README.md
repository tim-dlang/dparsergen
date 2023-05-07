# Example grammar for arithmetic expressions

This example contains a grammer for arithmetic expressions in
grammarcalc.ebnf. The application testgrammarcalc.d reads expressions
from the standard input and tries to parse them. The expressions
are directly evaluated and the result is printed. Expressions
can span multiple lines.

The application can be built with the following command:
```sh
dub build
```

The following command starts the application:
```sh
./example_calc
```

The application can be quit by closing the input (e.g. Ctrl+D) or using
the command quit.
