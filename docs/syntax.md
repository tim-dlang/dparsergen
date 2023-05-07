# DParserGen Syntax

The description for the grammar is written as documentation comments
in dparsergen/generator/grammarebnf.ebnf. It is compiled into a
markdown document in docs/syntax.md.

### EBNF
<pre>
EBNF
    = <a href="#ebnf">Declaration</a>+
    ;
Declaration
    = <a href="#symbol-declaration">SymbolDeclaration</a>
    | <a href="#match-declaration">MatchDeclaration</a>
    | <a href="#import">Import</a>
    | <a href="#option-declaration">OptionDeclaration</a>
    ;
</pre>
A grammar file contains a list of declarations.

### Symbol Declaration
<pre>
SymbolDeclaration
    = <a href="#symbol-declaration">DeclarationType</a>? <a href="#identifier">Identifier</a> <a href="#symbol-declaration">MacroParametersPart</a>? <a href="#annotation">Annotation</a>* <b>&quot;;&quot;</b>
    | <a href="#symbol-declaration">DeclarationType</a>? <a href="#identifier">Identifier</a> <a href="#symbol-declaration">MacroParametersPart</a>? <a href="#annotation">Annotation</a>* <b>&quot;=&quot;</b> <a href="#expression">Expression</a> <b>&quot;;&quot;</b>
    ;
DeclarationType
    = <b>&quot;fragment&quot;</b>
    | <b>&quot;token&quot;</b>
    ;
MacroParametersPart
    = <b>&quot;(&quot;</b> <a href="#symbol-declaration">MacroParameters</a>? <b>&quot;)&quot;</b>
    ;
MacroParameters
    = <a href="#symbol-declaration">MacroParameter</a>
    | <a href="#symbol-declaration">MacroParameters</a> <b>&quot;,&quot;</b> <a href="#symbol-declaration">MacroParameter</a>
    ;
MacroParameter
    = <a href="#identifier">Identifier</a>
    | <a href="#identifier">Identifier</a> <b>&quot;...&quot;</b>
    ;
</pre>
Declares a symbol, which describes a part of the language.

Every symbol has a name after the optional type. Optional parameters
can be used to declare patterns like comma separated lists only once.
Annotations starting with @ are used for supplying some options to
the parser and lexer generator, but can also be used by the parse
tree creator. The expression defines the sublanguage for this symbol.

There are three types of symbols: Tokens and fragments are explicitly
declared and nonterminals just use the identifier without type before
it. The type of symbols with parameters and no explicit type is
detected automatically from context.

Tokens are sequences of characters, which are detected by the
lexer. Fragments are only used inside tokens or other fragments.
Nonterminals can use other nonterminals and tokens.

### Option Declaration
<pre>
OptionDeclaration
    = <b>&quot;option&quot;</b> <a href="#identifier">Identifier</a> <b>&quot;=&quot;</b> <a href="#integer-literal">IntegerLiteral</a> <b>&quot;;&quot;</b>
    ;
</pre>
Sets a global option for this grammar. Currently, the following
options are defined and all need an integer as value:

* startTokenID: Sets the first ID for tokens. Defaults to 0.
* startNonterminalID: Sets the first ID for nonterminals. Defaults to 0.
* startProductionID: Sets the first ID for productions. Defaults to 0.

### Import
<pre>
Import
    = <b>&quot;import&quot;</b> <a href="#string-literal">StringLiteral</a> <b>&quot;;&quot;</b>
    ;
</pre>
Imports symbols from a different grammar file.

The string literal contains the path of the other grammar file
relative to the current grammar file. The imported file is parsed
separately, and all symbols will be available.

### Match Declaration
<pre>
MatchDeclaration
    = <b>&quot;match&quot;</b> <a href="#symbol">Symbol</a> <a href="#symbol">Symbol</a> <b>&quot;;&quot;</b>
    ;
</pre>
Hint that two tokens normally come in pairs, like parens. This can be
used by long lookahead to e.g. skip tokens in parens and make a
decision based on tokens after them.

### Annotation
<pre>
Annotation
    = <b>&quot;@&quot;</b> <a href="#identifier">Identifier</a> <a href="#annotation">AnnotationParams</a>?
    ;
AnnotationParams
    = <b>&quot;(&quot;</b> <a href="#annotation">AnnotationParamsPart</a>* <b>&quot;)&quot;</b>
    ;
AnnotationParamsPart
    = <a href="#string-literal">StringLiteral</a>
    | <a href="#identifier">Identifier</a>
    | <a href="#character-set-literal">CharacterSetLiteral</a>
    | <a href="#integer-literal">IntegerLiteral</a>
    | <b>&quot;(&quot;</b> <a href="#annotation">AnnotationParamsPart</a>* <b>&quot;)&quot;</b>
    | <b>&quot;=&quot;</b>
    | <b>&quot;:&quot;</b>
    | <b>&quot;;&quot;</b>
    | <b>&quot;,&quot;</b>
    | <b>&quot;{&quot;</b>
    | <b>&quot;}&quot;</b>
    | <b>&quot;?&quot;</b>
    | <b>&quot;!&quot;</b>
    | <b>&quot;&lt;&quot;</b>
    | <b>&quot;&gt;&quot;</b>
    | <b>&quot;\*&quot;</b>
    | <b>&quot;&gt;&gt;&quot;</b>
    | <b>&quot;&lt;&lt;&quot;</b>
    | <b>&quot;-&quot;</b>
    ;
</pre>
Annotations can be added to symbols or expressions. Some annotations
are used by the parser or lexer generator as options. The user can
also use annotations for custom meta data, which can be used by
the tree creator or at runtime.

### Negative Lookahead
<pre>
NegativeLookahead
    = <b>&quot;!&quot;</b> <a href="#symbol">Symbol</a>
    | <b>&quot;!&quot;</b> <b>&quot;anytoken&quot;</b>
    ;
</pre>
Disallows a symbol at this position. Inside tokens, it can disallow
characters. Inside nonterminals, it can disallow a token. At the
end of a production it disallows the symbol after the production.

### Expression
<pre>
Expression
    = <a href="#alternation">Alternation</a>
    ;
</pre>
Defines a sublanguage.

<table>
<tr>
<td><a href="#alternation">Alternation</a></td>
<td>
 <a href="#alternation">Alternation</a> <b>&quot;|&quot;</b> <a href="#concatenation">Concatenation</a></td>
</tr>
<tr>
<td><a href="#concatenation">Concatenation</a></td>
<td>
 <a href="#token-minus">TokenMinus</a> <a href="#token-minus">TokenMinus</a>+ <a href="#concatenation">ProductionAnnotation</a>*</td>
</tr>
<tr>
<td><a href="#concatenation">Concatenation</a></td>
<td>
 <a href="#token-minus">TokenMinus</a> <a href="#concatenation">ProductionAnnotation</a>+</td>
</tr>
<tr>
<td><a href="#concatenation">Concatenation</a></td>
<td>
 <a href="#concatenation">ProductionAnnotation</a>+</td>
</tr>
<tr>
<td><a href="#token-minus">TokenMinus</a></td>
<td>
 <a href="#token-minus">TokenMinus</a> <b>&quot;-&quot;</b> <a href="#annotated-expression">AnnotatedExpression</a></td>
</tr>
<tr>
<td><a href="#annotated-expression">AnnotatedExpression</a></td>
<td>
 <a href="#annotated-expression">ExpressionAnnotation</a>* <a href="#annotated-expression">ExpressionName</a>? <a href="#annotated-expression">ExpressionPrefix</a>* <a href="#postfix-expression">PostfixExpression</a></td>
</tr>
<tr>
<td><a href="#optional">Optional</a></td>
<td>
 <a href="#postfix-expression">PostfixExpression</a> <b>&quot;?&quot;</b></td>
</tr>
<tr>
<td><a href="#repetition">Repetition</a></td>
<td>
 <a href="#postfix-expression">PostfixExpression</a> <b>&quot;\*&quot;</b></td>
</tr>
<tr>
<td><a href="#repetition-plus">RepetitionPlus</a></td>
<td>
 <a href="#postfix-expression">PostfixExpression</a> <b>&quot;+&quot;</b></td>
</tr>
<tr>
<td><a href="#name">Name</a></td>
<td>
 <a href="#identifier">Identifier</a></td>
</tr>
<tr>
<td><a href="#token">Token</a></td>
<td>
 <a href="#string-literal">StringLiteral</a></td>
</tr>
<tr>
<td><a href="#token">Token</a></td>
<td>
 <a href="#character-set-literal">CharacterSetLiteral</a></td>
</tr>
<tr>
<td><a href="#macro-instance">MacroInstance</a></td>
<td>
 <a href="#identifier">Identifier</a> <b>&quot;(&quot;</b> <a href="#expression-list">ExpressionList</a>? <b>&quot;)&quot;</b></td>
</tr>
<tr>
<td><a href="#paren-expression">ParenExpression</a></td>
<td>
 <b>&quot;{&quot;</b> <a href="#expression">Expression</a> <b>&quot;}&quot;</b></td>
</tr>
<tr>
<td><a href="#sub-token">SubToken</a></td>
<td>
 <a href="#symbol">Symbol</a> <b>&quot;&gt;&gt;&quot;</b> <a href="#symbol">Symbol</a></td>
</tr>
<tr>
<td><a href="#sub-token">SubToken</a></td>
<td>
 <a href="#symbol">Symbol</a> <b>&quot;&gt;&gt;&quot;</b> <a href="#paren-expression">ParenExpression</a></td>
</tr>
<tr>
<td><a href="#unpack-variadic-list">UnpackVariadicList</a></td>
<td>
 <a href="#identifier">Identifier</a> <b>&quot;...&quot;</b></td>
</tr>
<tr>
<td><a href="#tuple">Tuple</a></td>
<td>
 <b>&quot;t(&quot;</b> <a href="#expression-list">ExpressionList</a>? <b>&quot;)&quot;</b></td>
</tr>
</table>

### Alternation
<pre>
Alternation
    = <a href="#concatenation">Concatenation</a>
    | <a href="#alternation">Alternation</a> <b>&quot;|&quot;</b> <a href="#concatenation">Concatenation</a>
    ;
</pre>
Defines a sublanguage, which allows all texts of the combined
sublanguages.

### Concatenation
<pre>
Concatenation
    = <a href="#token-minus">TokenMinus</a>
    | <a href="#token-minus">TokenMinus</a> <a href="#token-minus">TokenMinus</a>+ <a href="#concatenation">ProductionAnnotation</a>*
    | <a href="#token-minus">TokenMinus</a> <a href="#concatenation">ProductionAnnotation</a>+
    | <a href="#concatenation">ProductionAnnotation</a>+
    ;
ProductionAnnotation
    = <a href="#annotation">Annotation</a>
    | <a href="#negative-lookahead">NegativeLookahead</a>
    ;
</pre>
Defines a sublanguage, where multiple parts appear in a sequence.
It allows optional annotations at the end.

Empty productions should use the annotation @empty.

### Token Minus
<pre>
TokenMinus
    = <a href="#annotated-expression">AnnotatedExpression</a>
    | <a href="#token-minus">TokenMinus</a> <b>&quot;-&quot;</b> <a href="#annotated-expression">AnnotatedExpression</a>
    ;
</pre>
Defines a sublanguage for tokens, which allows every text in the left
sublanguage, but not in the right sublanguge. Only allowed inside
the definition of tokens.

### Annotated Expression
<pre>
AnnotatedExpression
    = <a href="#annotated-expression">ExpressionAnnotation</a>* <a href="#annotated-expression">ExpressionName</a>? <a href="#annotated-expression">ExpressionPrefix</a>* <a href="#postfix-expression">PostfixExpression</a>
    ;
ExpressionAnnotation
    = <a href="#annotation">Annotation</a>
    | <a href="#negative-lookahead">NegativeLookahead</a>
    ;
ExpressionName
    = <a href="#identifier">Identifier</a> <b>&quot;:&quot;</b>
    ;
ExpressionPrefix
    = <b>&quot;&lt;&quot;</b>
    | <b>&quot;^&quot;</b>
    ;
</pre>
Adds different annotations to an expression.

The optional name can be used by the tree creator.

The prefix "<" can be used to unwrap nonterminals for simple
definitions like "A = <B;", so no tree will be created for "A".

The prefix "^" drops this part in the created tree.

### Postfix Expression
<pre>
PostfixExpression
    = <a href="#optional">Optional</a>
    | <a href="#repetition">Repetition</a>
    | <a href="#repetition-plus">RepetitionPlus</a>
    | <a href="#atom-expression">AtomExpression</a>
    ;
</pre>


### Optional
<pre>
Optional
    = <a href="#postfix-expression">PostfixExpression</a> <b>&quot;?&quot;</b>
    ;
</pre>
Makes an expression optional.

Internally using X? is replaced with a new nonterminal and new
grammar rules are added, similar to the following:
<pre>
XOpt = @empty | &lt;X;
</pre>

### Repetition
<pre>
Repetition
    = <a href="#postfix-expression">PostfixExpression</a> <b>&quot;\*&quot;</b>
    ;
</pre>
Allows to repeat an expression zero or more time.

Internally using X* is replaced with a new nonterminal and new
grammar rules are added, similar to the following:
<pre>
XStar @array = @empty | XPlus;
XPlus @array = X | XPlus X;
</pre>

### Repetition Plus
<pre>
RepetitionPlus
    = <a href="#postfix-expression">PostfixExpression</a> <b>&quot;+&quot;</b>
    ;
</pre>
Allows to repeat an expression one or more time.

Internally using X+ is replaced with a new nonterminal and new
grammar rules are added, similar to the following:
<pre>
XPlus @array = X | XPlus X;
</pre>

### Atom Expression
<pre>
AtomExpression
    = <a href="#symbol">Symbol</a>
    | <a href="#paren-expression">ParenExpression</a>
    | <a href="#sub-token">SubToken</a>
    | <a href="#unpack-variadic-list">UnpackVariadicList</a>
    | <a href="#tuple">Tuple</a>
    ;
</pre>


### Symbol
<pre>
Symbol
    = <a href="#name">Name</a>
    | <a href="#token">Token</a>
    | <a href="#macro-instance">MacroInstance</a>
    ;
</pre>


### Name
<pre>
Name
    = <a href="#identifier">Identifier</a>
    ;
</pre>
References a symbol by name, which could be a token or nonterminal.

### Token
<pre>
Token
    = <a href="#string-literal">StringLiteral</a>
    | <a href="#character-set-literal">CharacterSetLiteral</a>
    ;
</pre>
Literal for token.

### Unpack Variadic List
<pre>
UnpackVariadicList
    = <a href="#identifier">Identifier</a> <b>&quot;...&quot;</b>
    ;
</pre>
Unpacks a list of variadic parameters, so a macro is instantiated
with them directly.

### Sub Token
<pre>
SubToken
    = <a href="#symbol">Symbol</a> <b>&quot;&gt;&gt;&quot;</b> <a href="#symbol">Symbol</a>
    | <a href="#symbol">Symbol</a> <b>&quot;&gt;&gt;&quot;</b> <a href="#paren-expression">ParenExpression</a>
    ;
</pre>
Uses the token on the left side with the condition, that it matches
the right side.

### Macro Instance
<pre>
MacroInstance
    = <a href="#identifier">Identifier</a> <b>&quot;(&quot;</b> <a href="#expression-list">ExpressionList</a>? <b>&quot;)&quot;</b>
    ;
</pre>
Uses a macro.

### Paren Expression
<pre>
ParenExpression
    = <b>&quot;{&quot;</b> <a href="#expression">Expression</a> <b>&quot;}&quot;</b>
    ;
</pre>
Uses the inner expression without change.

### Expression List
<pre>
ExpressionList
    = <a href="#expression">Expression</a>
    | <a href="#expression-list">ExpressionList</a> <b>&quot;,&quot;</b> <a href="#expression">Expression</a>
    ;
</pre>
Comma seperated list of expressions.

### Tuple
<pre>
Tuple
    = <b>&quot;t(&quot;</b> <a href="#expression-list">ExpressionList</a>? <b>&quot;)&quot;</b>
    ;
</pre>
Allows to create a tuple of expressions, which works like variadic
arguments.

### Identifier
<pre>
token Identifier
    = <b>[a-zA-Z\_]</b> <b>[a-zA-Z0-9\_]</b>*
    ;
</pre>


### String Literal
<pre>
token StringLiteral
    = <b>&quot;\\&quot;&quot;</b> <a href="#string-literal">StringPart</a>* <b>&quot;\\&quot;&quot;</b>
    ;
fragment StringPart
    = <b>[^\\&quot;\\\\]</b>
    | <a href="#escape-sequence">EscapeSequence</a>
    ;
</pre>
<a href="#string-literal">StringLiteral</a> specifies a sequence of characters, which can be
 directly used as a token or for defining other tokens.

### Character Set Literal
<pre>
token CharacterSetLiteral
    = <b>&quot;[&quot;</b> <b>&quot;^&quot;</b>? <a href="#character-set-literal">CharacterSetPart</a>* <b>&quot;]&quot;</b>
    ;
fragment CharacterSetPart
    = <a href="#character-set-literal">CharacterSetPart2</a>
    | <a href="#character-set-literal">CharacterSetPart2</a> <b>&quot;-&quot;</b> <a href="#character-set-literal">CharacterSetPart2</a>
    ;
fragment CharacterSetPart2
    = <b>[^\\[\\]\\\\\\-]</b>
    | <a href="#escape-sequence">EscapeSequence</a>
    ;
</pre>
<a href="#character-set-literal">CharacterSetLiteral</a> specifies a set of characters, which can be directly
used as a token or for defining other tokens. The syntax is inspired
by bracket expressions inside regular expressions.

The set is defined by a list of characters and ranges. A range
consists of two characters separated by a '-'. The range contains
all characters from the start character to the end characters
including both.

Using '^' directly after the opening bracket inverts the set.
The sequence [^] means any valid character.

<a href="#escape-sequence">EscapeSequence</a>s can be used for characters, which would have a special
meaning inside the character set. The characters '\', ']', and '-'
always have a special meaning and need to be escaped. The character
'^' is only special at the beginning. '[' is also reserved.

The characters are always case-sensitive and do not depend on the
locale for ordering.

### Escape Sequence
<pre>
fragment EscapeSequence
    = <b>&quot;\\\\\\\\&quot;</b>
    | <b>&quot;\\\\\\&quot;&quot;</b>
    | <b>&quot;\\\\\\'&quot;</b>
    | <b>&quot;\\\\0&quot;</b>
    | <b>&quot;\\\\a&quot;</b>
    | <b>&quot;\\\\b&quot;</b>
    | <b>&quot;\\\\f&quot;</b>
    | <b>&quot;\\\\n&quot;</b>
    | <b>&quot;\\\\r&quot;</b>
    | <b>&quot;\\\\t&quot;</b>
    | <b>&quot;\\\\v&quot;</b>
    | <b>&quot;\\\\[&quot;</b>
    | <b>&quot;\\\\]&quot;</b>
    | <b>&quot;\\\\-&quot;</b>
    | <b>&quot;\\\\x&quot;</b> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a>
    | <b>&quot;\\\\u&quot;</b> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a>
    | <b>&quot;\\\\U&quot;</b> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a> <a href="#escape-sequence">Hex</a>
    ;
fragment Hex
    = <b>[0-9A-Fa-f]</b>
    ;
</pre>
Used in <a href="#string-literal">StringLiteral</a> and <a href="#character-set-literal">CharacterSetLiteral</a>.

The escape sequences \0, \a, \b, \f, \n, \r, \t and \v represent
special characters like in D.

The escape sequences \x, \u and \U are followed by a hexadecimal
number, which is turned into a Unicode character. The number needs
to be a valid Unicode character of the used size. For \x only ACSII
characters are valid, because other characters need more UTF-8 bytes.
For \u and \U Unicode surrogates are not allowed.

All other escape sequences represent the character following the slash.

### Integer Literal
<pre>
token IntegerLiteral
    = <b>[1-9]</b> <b>[0-9]</b>*
    | <b>&quot;0&quot;</b>
    ;
</pre>


### Space
<pre>
token Space
    = <b>[ \\n\\r\\t]</b>+
    ;
</pre>
Whitespace is ignored. Sometimes it is necessary to separate tokens.

### Line Comment
<pre>
token LineComment
    = <b>&quot;//&quot;</b> <b>[^\\n\\r]</b>*
    ;
</pre>
A line comment starts with "//" and includes all characters of the
current line. Line comments starting with "///" can be used as
documentation comments for symbols.

### Block Comment
<pre>
token BlockComment
    = <b>&quot;/\*&quot;</b> <a href="#block-comment">BlockCommentPart</a>* <b>&quot;\*&quot;</b>* <b>&quot;\*/&quot;</b>
    ;
fragment BlockCommentPart
    = <b>[^\*]</b>
    | <b>&quot;\*&quot;</b>+ <b>[^\*/]</b>
    ;
</pre>
A block comment starts with "/\*" and ends with next occurrence of "\*/".
It can not be nested. Block comments starting with "/\*\*" can be used
as documentation comments for symbols.

### Nesting Block Comment
<pre>
token NestingBlockComment
    = <b>&quot;/+&quot;</b> <a href="#nesting-block-comment">NestingBlockCommentPart</a>* <b>&quot;+&quot;</b>* <b>&quot;+/&quot;</b>
    ;
fragment NestingBlockCommentPart
    = <b>[^+/]</b>
    | <b>&quot;+&quot;</b>+ <b>[^+/]</b>
    | <b>&quot;/&quot;</b>+ <b>[^+/]</b>
    | <b>&quot;/&quot;</b>* <a href="#nesting-block-comment">NestingBlockComment</a>
    ;
</pre>
A nested block comment starts with "/+" and can be nested. It ends with
the next not nested occurrence of "+/". Nested block comments starting
with "/++" can be used as documentation comments for symbols.

