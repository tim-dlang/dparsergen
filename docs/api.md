# DParserGen API Overview

Three main components are used to parse a text:
* The lexer splits the input into tokens. It can be generated from the
  grammar file.
* The tree creator is used to define the types for trees representing
  nonterminals and create them. Instead of a tree it can also directly
  calculate values. The library contains a predefined tree creator,
  but the user can also define a custom one.
* The parser determines how the tokens from the lexer should be combined
  to a tree of nonterminals. It calls a function of the tree creator
  for every nonterminal, so the tree can be created.

All components also use a type for locations in the source text. The
generated lexer and the predefined tree creator allow to select the
location type as a template parameter. The parser uses the same location
type as lexer and tree creator and requires that they use the same.
The default location types can store the position in bytes and a line
number and offset from line start. A custom location type could also
include a filename or other information.

The tree creator can also choose if and how the location for subtree
start and end is stored. The following strategies are supported by the
default tree creator:
* Store two locations for start and end.
* Store a start location and a length, which allows to calculate the end.
* Store the offset from the parent start to the start and a length. The
  real start can be calculated by adding the offsets of all parents and
  this subtree. This strategy would allow to modify the tree and update
  only some offsets instead of many locations.

The package [dparsergen.core](../core/dparsergen/core) contains different
components, which are used by lexer and parser. Details are documented with
Ddoc comments.

## Lexer

The lexer is implemented as a struct, which provides an input range.
Every token is an element of the range. Every token in the range stores
an ID for the token, the content as a string and the location.
The lexer decides, which IDs are used for the tokens. Template tokenID
in the lexer converts a token name into the token ID. Function tokenName
converts in the other direction.

Tokens marked with `@ignoreToken` are automatically skipped by the lexer.
Alternatively they can be provided like normal tokens by setting the
optional template argument includeIgnoredTokens of the lexer to true.
The elements of the range will then also contain the member
isIgnoreToken.

The parser can sometimes create copies of the lexer and assign lexer
instances. This is for example used for backtracking.

### Lexer Wrapper

The lexer is normally used directly by the parser, but it is also
possible to use a custom wrapper of the lexer. The wrapper could do
different things, like for example:

* Interpret special directives like `__EOF__` or `#line`.
* Modify the type of token based the current language version. If the
  language added a feature with a new keyword, then the wrapper could
  treat it as a normal identifier for the old language version, but
  treat it as the keyword for the new language version.
* Distinguish tokens depending on context, like the
  [lexer hack](https://en.wikipedia.org/wiki/Lexer_hack) for C.
* Store or process comments, which are ignored by the parser.
* Add debug output without modifying lexer or parser directly.
* Keep track of the indentation level for languages like Python, see
  example in [examples/python/](../examples/python/).

## Tree Creator

The parser does not create the syntax tree itself, but only calls methods
on a tree creator. The tree creator is a template parameter of the parser
and can choose types for all created tree nodes.

`DynamicParseTreeCreator` in module
[dparsergen.core.dynamictree](../core/dparsergen/core/dynamictree.d)
uses the same class for all tree nodes. Custom tree creators could also
directly make calculations, like in [example calc](../examples/calc/).

## Parser

The function `parse` can be used to directly parse input. It receives
the input as a string or uses a lexer as a reference. A tree creator
also needs to be provided as parameter. The start nonterminal can
optionally be set as a template parameter.

Internally the parser is a struct called `Parser`. For the LALR parser it
has functions for different states. The GLR has a different struct
called `PushParser`, but also implements a wrapper called `Parser` with the
same API as the LALR parser.

Struct `PushParser` for the GLR parser allows to push new tokens into
the parser and the parser will store the state in the struct. The normal
parser gets new tokens from the lexer instead, so it stores most state
on the call stack of the current thread.

## Error Handling

An exception of type `ParseException` is thrown on parser or lexer errors.
Subclass `SingleParseException` also depends on a template parameter for
the location and contains more informations.

Internally the exception is not directly thrown, but first stored inside
the parser. This is more efficient if backtracking is used, because
throwing can be slow.
