## 2.0.26

- Breaking change. The enum `FailPos` has been renamed to `StatePos` and moved from `error.dart` to `parser_builder.dart`. It is now public, but certain `state.*` fields will only have their respective values set by specially generated code to set them only on demand using special parser builders to reduce runtime overhead. Example: `WithLastErrorPos(Alt2(parser, FailMessage(StatePos.lastErrorPos, 'some message')))`
- Implemented, tested (as a basis of other builders), but not documented parser builder `SwicthTag`
- Refactored parser builders `Tags`, `TagValues` using the new `SwicthTag` parser builder

## 2.0.25

- Breaking change. Does not affect user parser definitions. The signature of the `State.fail` method has been changed. Due to improvements in the error generation system, the `length` parameter has been removed and parameter `value` is made optional. The new signature is now `void fail(int pos, int kind, [Object? value, int start = -1])`
- Another round to improve the error reporting system. Parser builders have been added to implement the ability to generate complex error messages at any level of the parser rule. Now it is possible to generate errors using special parsers. These parser builders include facilities for generating errors directly, for capturing information about the initial parse position, tracking on demand the last error position, and turning off error generation for the current parse position. By combining the above parser builders and placing them in different places in the parsing rules, it is possible to generate complex error messages that were previously only available when implementing (hand-writing) individual parser builder classes
- Implemnented, a little tested and not documented parser builders `FailExpected`, `FailMessage`,  `SilentAtThisPos`,  `WithLastErrorPos`, `WithStart`, `WithStartAndLastErrorPos`
- Reimplemented error generation parser builders `Indicate`, `Expected` and `Nested` using only a combination of other error generation parser builders. That is, correctly, safely and without the need to write new code templates
- An example of an elegant and correct way to generate an `Unterminated string` error in the JSON parser code was given. The method of generating this error demonstrates a new possibility for generating errors by combining special parser builders designed for these purposes

## 2.0.24

- Implemented, tested, but not documented parser builder `TagPair`. It is intended to parse markup languages elements

## 2.0.23

- Fixed bug in parser builder `Named`

## 2.0.22

- Minor improvements in the experimental implementation of the `_errorMessage` function. Current operating principle. When displaying text, it is `formatted` (all `whitespace` characters are displayed as spaces) into one line (with a length of no more than 80 characters) and the position of the error is displayed as close to the center of the output line as possible. Thus (regardless of line breaks) the text before and after the error position is displayed (if it fits in a line of 80 characters). This looks more informative and clearer, and at the same time solves the problem with the case when all the parsed text is one very long line and the error message looks just awful

## 2.0.21

- Breaking change. Semantic actions for `Tokenize`, `TokenizeTags` parser builders have been simplified
- Implemented, tested, but not documented parser builder `TokenizeSimilarTags`. It allows very fast parsing of tokens that can be created in a single semantic action

## 2.0.20

- Despite the fact that the `source_span` package is no longer used, the error generation system, the error reporting system and the `ParseError` class have been unified in accordance with the way it is implemented in the `source_span` package, in particular in the `Span` classes. In the `ParseError` class, the `end` field no longer includes the value at that position. That is, the range (10, 10) means start position 10 with no value (empty value), (10, 11) start position 10, with value 1 element long, and so on. The values of these ranges are used to indicate the sequence of data elements using an indicator of the form `^^^^^`. Why exactly this way and not otherwise? Firstly, the ability to correctly encode empty ranges, and secondly, at runtime, during parsing, after successful parsing, the current position indicates the next element of the sequence and only such a state is available to next parsers. For example, for parsers-verifiers, this fits very well with the principle of their work. Parsers-verifiers do not analyze positions and the length of the parsed sequence at runtime, they react to the result returned by a predicate that checks the result of a successful parse and generate errors `as is` from the current parsing state data
- Breaking change. Class `_Memo` is now public and is now called `MemoizedResult`
- Implemented, tested, but not documented parser builders `Tokenize`, `TokenizeTags`. They are designed to implement high-performance lexers

## 2.0.19

- Minor improvements related to reducing the size of the generated code of the `built-in runtime library` for the parser. The following classes are generated only on demand: `Result2`-`Result7`, `_Memo`. Also, the size of the `State` class code is slightly reduced in the case when memoization is not used. All this does not particularly reduce the size of the code, but at the same time, it does not increase its size unnecessarily
- Removed dependency on `source_span` package. Now the generated parsers have no dependencies

## 2.0.18

- Breaking change. On the way to generating parsers without dependencies, the use of the `tuple` package has been stopped. Now the `Result2`-`Result7` classes are generated on demand. These changes require minor changes to the parser definitions. The next step is to remove the dependency on the `source_span` package

## 2.0.17

- The following parser builders now generate more optimized code: `Delimited`, `Pair`, `Preceded`, `Terminated`
- The following parser builders now generate more optimized code in fast mode: `Map2-MapN`, `Tuple-TupleN`
- The following parser builders now generate more optimized code: `Fast2-FastN`

## 2.0.16

- Implemented the ability to register errors with a position less than the current error position. The error is registered at the current position, but with the actual location of the error (as an optional parameter). In particular, it allows errors such as `unterminated` to be elegantly registered when it is no longer possible to register the start position because the current position is at the end of the file (at a position farther away)
- Breaking change. Errors can no longer be registered with a negative `length` value

## 2.0.15

- Minor improvements in `BinarySearchBuilder`. Also `untestable` sections of the code were tested. That is, those cases are practically not achievable, but theoretically this has not been proven

## 2.0.14

- Fixed bug in binary search code builder

## 2.0.12

- The binary search code builder has been redesigned. Now it is a separate class. New implementation tested. The generated code is very efficient. It generates a single expression consisting of many comparison tests. For 3 ranges (6 values), the generated algorithm finds the result by testing 3 constant values. For 20 ranges (40 values) finds the result by testing 5-6 constant values. The only downside is that the Dart SDK formatter formats such code using 4 character indentation instead of 2 character indentation

## 2.0.11

- Fixed bug in parser builders `SeparatedList0`, `SeparatedList1`. Invalid `{{var1}}` keys have been removed from fast templates
- Fixed bug in parser builder `StringValue`. Invalid `{{val1}}` keys have been removed from fast template

## 2.0.10

- The parser builder `Peek` has been optimized for size and speed
- Fixed bug in parser builder `Named`. For functions with a return type of `void`, the fast parsing mode is forced to turn on
- Implemented (inlined) binary search expression builder

## 2.0.9

- Fixed bug in parser builder `Memoize`. In fast parsing mode, memoization did not work due to passing an invalid value as an argument, indicating the parsing mode. This was due to a `copy-paste` oversight made while editing the templates

## 2.0.8

- Implemented, tested and documented parser builder `TagValues`
- The `Tags` parser builder has been changed from generating source code using a `switch` statement to using `if-else` statements

## 2.0.7

- Fixed bug in parser builder `Memoize`. Added missing result type information to `state.memoized<R>()` and `state.memoize<R>()` calls
- Fixed bug in method `state.memoize<R>()`. Added missing result type information when instantiating `_Memo<R>`

## 2.0.6

- Fixed bug in parser builder `Nested`. The value of `state.minErrorPos` was incorrectly restored to `state.errorPos`. Now this value is saved and restored from the saved value
- Fixed bug in parser builder `PrefixExpression`. Incorrect parsing algorithm. Parser templates have been changed
- Fixed bug in function `_errorMessage()`

## 2.0.5

- Improved performance of lightweight memoization. Saving the parsed state is now just creating an instance of `_Memo` and single write operation to the list. Restoring the parsed state is one read operation from the list, one conditional ternary operation and a few assignment expressions to restore the parse state. This memoization method is very fast and efficient
- Breaking change. Does not affect end users (parser definitions). The error registration operation has been changed. Now registering an error does not require any data instances to be created. This works quite quickly and efficiently and does not consume memory

## 2.0.4

- Improved the stability of tracking the position of the last `local` error. This feature is used in the parser builder `Indicate`
- Breaking change. Does not affect end users (parser definitions). Increased performance by reworking the `ParseError` class. Now instances of this class are mostly used as constant values. This greatly improves performance. Now the generated parsers work almost as fast as in the previous version. And, of course, now they register and report errors more accurately. There is even too much information about errors and they have to be reduced (when declaring parsers), combining them into a kind of `tokens`. Maybe it makes sense to implement a `silent` version of the `Opt` parser for special cases?

## 2.0.3

- Implemented, tested and documented experimental parser builder `Memoize`. This is an attempt to implement lightweight (on demand) memoization with saving only one state of parsing (just for a specific case)

## 2.0.2

- Optimization of parser builders for generating errors (`Expected`, `Malformed`, `Nested`). Creating a way for a simple and optimal way to implement them, optimizing the implementation of the class `State`

## 2.0.1

- Tested and documented parser builder `Expected`
- Documented parser builder `Nested`
- Implemented, tested and documented parser builder `Malformed`
- Implemented (but not tested) and documented experimental parser builder `Indicate`

## 2.0.0

- Breaking change.
Does not affect end users (parser definitions). The changes concern the development of parser builders.  
As practice has shown, the current error registration system turned out to be a system of the registration of the local errors in relation to the current alternative choice parser. In other words, if one of the alternatives was successfully parsed, all other registered errors were discarded (despite the fact that these errors could have the farthest positions).  
This led to the fact that information about real (the farthest in position) parsing errors was lost forever. In some cases it did not matter because each choice from the alternative did not have the same grammar symbols at the beginning and, accordingly, there are no problems with determining the exact position of the error. But, in the case when the first grammar symbols in different choices is the same, then the absence of this information would lead to a less accurate interpretation of the exact location of the parse error. This is especially true for parsing expressions of grammars of high-level programming languages (or even complex expression calculators).  
The new error system registers and saves errors until new errors are found in the next (far) positions.  
Thus, the new system is devoid of this shortcoming.  
These changes cause the generated parsers to be slightly slower (about 10%), smaller in size, and much more accurate in determining the real location of a parsing error.  
Now the principle of operation is closest to `PEG` parsers, where each parser can be considered as a parsing expression
- Breaking change. Removed classes `Char`, `Tag`. They were used solely for registering errors
- Breaking change. Removed class `Err` and its descendants
- Added new class `ParseError`. All errors are registered through this class. There are 3 kind of errors in total. These are `expected`, `message` and `unexpected`

## 1.0.10

- The size of the generated source code of the parser `BinaryExpression` has been slightly reduced

## 1.0.9

- Implemented and tested parser builder `PostfixExpression`
- Implemented and tested parser builder `PrefixExpression`
- Fixed bug in parser builder `BinaryExpression`. In case of failure, the position was restored incorrectly, not to the very beginning of the binary expression. The position is now restored to the very first left-hand operand

## 1.0.8

- Improved parser builder `BinaryExpression`. The generated parser is now smaller, faster and uses less memory (does not use list and tuples)
- Improved parser builder `IdentifierExpression`. The generated parser is now faster (using binary search)

## 1.0.7

- Implemented and tested parser builder `IdentifierExpression`

## 1.0.6

- Added the ability to optimize fast parsers at the global level. This is achieved by building in two passes. During the first pass, information is collected about the use of the parsing results returned by the functions. If the return result is never used, then the parser function is built as a fast (non-resulting, `void`) function (on the next pass)
- Breaking change: Removed `Context.contex`. Instead, added the concept of the registry. Added new metod `T getRegistry<T>(owner, String name, T defaultValue)` to class `Context`. Currently, this has an internal use when generating parsers

## 1.0.5

- Implemented and tested parser builder `SeparatedListN`

## 1.0.4

- Implemented and tested parser builder `ManyN`

## 1.0.3

- Implemented and tested parser builder `BinaryExpression`
- Added simple calculator parser example

## 1.0.2

- Fixed bug in parser builder `Verify`. There was an oversight in rewriting the builder implementation (from codegen based to template-based generation) for the new version. A small piece of code was omitted to generate an error with a message if verification fails with the semantic action

## 1.0.1

- Minor changes in `README.md` file
- Fixed bugs in some parser builders that generates the parsers that use (require) semantic actions even in `fast` mode (for verification and so on). Bugs were found with the following parser builders `Satisfy`, `TakeWhile`, `TakeWhile1`, `Verify`. This error did not result in parsing errors, but did result in the generation of uncompilable (not a valid) source code of parsers

## 1.0.0

- First major version

## 0.18.0

- After many experiments, it was decided to return everything back as it was originally. With one small exception. The build system has been greatly simplified and improved

## 0.17.0

- Breaking change: It was decided to simplify the implementation of parser builders (human work) and the build process (main work) by improving the generated code optimizer (optional work). These changes do not affect the definition of parsers and do not break the work. This refers to the implementation details of the parser builders. The implementation of the new code optimizer is under development as it requires the development of a simple data flow analyzer

## 0.16.1

- The improvement of code generation in the new version is almost completed

## 0.16.0

- Breaking change: Everything is implemented almost from scratch. Now code generation is done with the code generator

## 0.15.4

- Improved `Verify` parser builder. Now the failure position in `ErrMessage` is set not to the initial position, but to the last position. Previously, this was not possible (before the improvement of the system for working with parsing errors). This applies only to cases where verification fails. In fact, this is the purpose of the generated `Verify` parser
- Minor improvements to the error reporting system

## 0.15.3

- Another round to improve the error reporting system. Without breaking changes. This system is getting better and better. The results are already very good. All known shortcomings (and found bugs) have been fixed
- Implemented and not tested parser builder `Verify`. It is very, very helpful. Allows, at runtime, to influence the parsing process and to program "smart" parsing rules in the grammar. For example, define a parser that will check the number of arguments of a known function. It is programmed not flexibly, but rigidly (you can also flexibly, this is a matter of taste). The main thing is that it works. And it works on top of another parser. No need to write duplicate code. Great

## 0.15.2

- Fixed minor bug in parser builder `SwitchTag`

## 0.15.1

- Slightly improved the code generated by parser builder `ManyTill`. Generated errors are now more informative
- Another round to improve the error reporting system. Now the parsing error post processing procedures generate a more informative error report when using the builder `Nested`. Changes were made to improve the post-processing of `ErrNested` errors. Generated errors that are nested relative to an `ErrNested` error are now temporarily `wrapped` and do not affect the process of determining the furthest position of an error when filtering errors by their position. This allows more errors to be displayed and, at the same time, it allows to reduce the number of unnecessary error messages where it is required, combining them into one informative error (combination of main error and furthest errors if they are further than main error)
- Breaking change: The signature of the parser builder constructor `Nested` has been changed. The parameter  `Tag tag` is non nullable now and must be specified


## 0.15.0

- Improved error reporting procedures. Fixed shortcomings, defects and errors in post-processing errors when creating a parser error report. Now the error messages look like they should
- Slightly changed the implementation of the experimental parser builder `SwitchTag` to improve error reporting
- Breaking change: The way of generating and reporting errors with nested errors has been unified. The number of error types for such cases has been reduced, instead one type has been left (`ErrNested`). This type has been changed and is now universal and easily customizable
- Implemented parser builder `Nested` (this is a reworked builder `Malformed`)
- Breaking change: Removed parser builder `Malformed` in favor of using parser builder `Nested`. It supports specifying an error message value and optionally specifying a tag value
- Breaking change: The `Labeled` parser builder has been renamed to `Expected`. To more accurately reflect its purpose

## 0.14.4

- Removed `lightweight runtime`. The use of this implementation did not allow a correct comparison (and filtration) of the errors in error reporting procedures. As a result, errors messages were redundant and not correct

## 0.14.3

- Implemented, tested and documented experimental parser builder `CombinedList1`
- Breaking change: Changed the signature of the method `Transformation.checkArguments()`. Added new parameter `String information`. This is done to make it easier to find the location of the exception when calling this method. The common value is the transformer template or other useful information to identify the transformer. This applies only to the implementation of transformers
- Breaking change: Changed definition and behavior of transformer `VarTransformer`. Now it's a combination of a variable and an expression. The definition of the variable, the key of this variable in the expression template, and the expression (using this variable) are specified. Previously, it was possible to use only a variable by name, without the ability to use it as part of an expression. This helps make it easier to the creation of more flexible, faster, configurable (including in real time) parsers
- Fixed bug in transformer `NotCharClass`

## 0.14.2

- Added many improvements to the parser builder `StringValue`. The overall performance of parsing data with `String` values can be increased by up to 10%
- Documented and tested parser builder `StringValue`
- Implemented, tested and documented experimental parser builder `SwitchTag`. This parser builder is intended mainly for the implementation of fast lexers, but can be used (with a clever approach) for other purposes. The JSON parser (example) now parses slightly faster when using this builder in JSON parser definition
- Implemented constructor `ExprTransformer.value(this.expression)`. To simplify the definition of expression transformers without parameters
- Implemented, tested and documented parser builder `Skip`. This builder is intended to be used in conjunction with the builder `SwitchTag` to avoid reparsing already parsed simple data (such as literals or punctuation)

## 0.14.1

- Fixed minor bug in builder `SkipWhile1`
- Implemented constructor `ErrUnexpected.charOrEof(this.offset, String source, [int? c])`. Simplified (improved) the generated code of some parsers that parse characters and select the generated error depending on the position of parsing
- Implemented constructor `ErrUnexpected.charAt(this.offset, String source`

## 0.14.0

- Breaking change: Changes have been made to the `State` class. The `opt` field has been removed. Instead, a `log` field has been added to indicate the need for error logging. This is an internal change that does not affect parser definitions

## 0.12.2

- Implemented experimental parser builder `TakeWhile1Fold`
- Improved character and string parser builders. The overall performance of the parsing process can be increased up to 3%
- Improved transformers (character predicates) `CharClass`, `NotCharClass` The overall performance of the parsing process can be increased up to 2%

## 0.12.1

- Changed helper function signature `fastBuild()`. Added named parameter `Map<String, Named> publish = const {}`. Example of specifying arguments: `publish: {'parse': _json}`. This will create the function `dynamic parse(String source)`. This makes it possible not to write public parsing functions by hand. The specified public parsing functions will be created automatically with the specified names and will be available for impossibility by users

## 0.12.0

- Breaking change: Transformers can now have multiple parameters. This allows them to be used as converter (mapper) functions with multiple parameters. An example of a typical use is use of them with the `Map2`, `Map3` (etc) parsers
- Implemented and tested parser builders `FoldMany0`
- Implemented and tested parser builders `Map2`, `Map3`, `Map4`, `Map5`, `Map6`, `Map7`
- Breaking change: The parser builder `Map$` has been renamed to `Map1`


## 0.11.0

- Breaking change: Transformers have become more powerful, much easier to use and clearer. And now they are full citizens, they have access to the building context and can allocate local variables and have access to global declarations. The number of methods has been reduced to two methods: `declare` (optional) and  `invoke`. This makes it possible to implement more efficient configurable (on startup) and context-sensitive parsers
- Improved generated source code of some character and string parsers. The overall performance of the parsing process can be increased up to 3%

## 0.10.2

- Improved character and string parser builders. Performance can be increased up to 5-7%
- Slightly improved the code generated by transformers `CharClass`, `NotCharClass` for small character ranges. The overall performance can be increased not less than 2% due to increasing performance of the frequently called critical parser functions that parse string data (character by character) in a loop using these transformers as predicates

## 0.10.1

- Fixed a bug in the transformer `NotCharClass` that could affect the work of parsers that are sensitive to parsing 32-bit characters, to which this transformer will be passed as a predicate. A rare case, but still a bug. The transformer `NotCharClass` now always returns `true` when calling its method `has32BitChars`

## 0.10.0

- Breaking change: Another round of improvements. Now it's time to improve transformers. Transformers now allow you to solve different problems. Transformers now have three main features: `declare`, `inline` and `invoke`. Each transformer must support the `declare` and `invoke` capability. Support for `inline` is optional, but it's the support for this feature that makes them very performant (and parsers too). The most requested transformers are already available, but nothing prevents you from creating your own transformer with the necessary functionality. All parser builders have already been updated to use the new transformers, which increases performance by at least 10% and makes the source  code a little smaller
- Removed all existing transformers
- Added transformers `ClosureTransformer`, `ExprTransformer`, `FuncExprTransformer`, `FuncTransformer`, `VarTransformer`

## 0.9.2

- Breaking change: The parser builder `Skip` has been renamed to `Sequence`
- Breaking change: The parser builder `SkipMany0` has been removed so as not to make modifications with minor differences. Instead, it is recommended to use the following combination of parsers `Many0Count(Sequence(p1, p2, etc))`

## 0.9.1

- Minor changes in the parser builders

## 0.9.0

- Introduced a new feature called `optional` mode. Does not make breaking changes. Operates automatically. Principle of operation (briefly): tells parsers not to generate errors in `optional` mode because errors are not used (ignored) in this mode. Benefits: significant reduction in memory usage, 5-10% increase in performance

## 0.8.2

- Documented and tested parser builder `EscapeSequence`
- Minor improvements in the `Number` parser. Now the generated parser parses even a little faster. The parser is currently only used internally, when generating a `JSON` parser example

## 0.8.1

- Improved most string parser builders. The generated code is fast again
- Minor improvements in parser builders `Alpha0`, `Alpha1`, `Alphanumeric0`, `Alphanumeric1`, `Digit0`, `Digit1`, `HexDigit0`, `HexDigit1`
- Removed parser builders `Crlf`, `LineEnding` in favor of using parser builder `Tags` which generates code more efficiently than the original code for these removed builders

## 0.8.0

- Breaking change: String parser builders have been revert back. The reason is that Dart is completely unpredictable in terms of predicting performance when writing code. Performance can be reduced by 20% with just a few changes to the source code. Dart is not C/C++, what should be fast in C/C++ will not necessarily be fast in Dart

## 0.7.2

- Minor changes in the parser builders
- Slightly improved generated code (for short tags) by parser builders `NoneOfTags`, `Tags`. Now tags can be specified in any order, the parsing will be done correctly in every case

## 0.7.1

- Fixed bugs in parser builders that generate parsers use other parsers and, at the same time, restore the parsing state. Generated parsers did not restore the value of the newly introduced field of the current character `state.ch`. These builders include `Not`, `Peek`
- Slightly improved generated code by parser builders `NoneOf`, `OneOf`. The generated parser code has become a little faster and a little smaller in size

## 0.7.0

- Breaking change: String parser builders have been reimplemented to use methods `state.getChar()`, `state.nextChar()`, `state.readChar()` and field `state.ch`. The methods are implemented as static extension methods for the `State<String>` class. This change generates a more readable parser source code and reduces its size by 10% and may slightly reduce parser performance by 5-10%.

## 0.6.0

- Breaking change: Unified declaration and usage of the `Transformer`. The transformer code must be a function body or a `callable` object. If the code is the body of a function, then the function will be declared, otherwise the variable will be declared. In both cases, the generated code must be used as a function call.
- Breaking change:  Removed `bool search` parameter from class `CharClass`, added `RangeProcessing processing` parameter

## 0.5.2

- Implemented and tested parser builders `NoneOfEx`, `TagEx`

## 0.5.1-3.dev

- Minor code changes

## 0.5.1-2.dev

- Implemented and tested parser builders `TakeUntil`, `TakeUntil1`
- Breaking change: Removed parser builders `TakeWhileUntil`, `TakeWhileExcept`

## 0.5.1-1.dev

- Lightweight versions of some classes have been added to decrease (by 2 kilobytes) the size of the runtime code
- Changed method signature `ParseRuntime.getClasses()`. Added named parameter `bool lightweightRuntime = true`
- Changed function signature `fastBuild()`. Added named parameter `bool lightweightRuntime = true`
- The parser builder `Many0` has been optimized for size
- The parser builder `Many1` has been optimized for size
- The parser builder `SeparatedList0` has been optimized for size
- The parser builder `SeparatedList1` has been optimized for size

## 0.5.0

- Breaking change: The `Err` type has been redesigned to reduce the size of the memory consumption. Now error generation consumes 20-25% less memory

## 0.4.5-2.dev

- Added documentation for parser builders from the library `character`
- Implemented and tested parser builders `ManyTill`
- Added some documentation for runtime classes

## 0.4.5-1.dev

- Optimized an operation algorithm of the transformer `CharClass`
- Fixed bug in transformer `CharClass`
- Implemented and tested parser builders `SkipMany0`, `TakeWhileExcept`

## 0.4.4

- The syntax used in `CharClass` has been extended. It is now possible to combine ranges `[A-Za-z0-9_] | "$"`.

## 0.4.3-2-dev

- Fixed bug in method `tagNoCase` in `extension on String`

## 0.4.3-1-dev

- Implemented and tested the optional feature to use binary search for the transformer `CharClass`. It can be turned on or off when measuring the effectiveness of using a particular search method
- The `Allocator` now supports variable names
- Implemented and tested parser builders `Crlf`, `LineEnding`, `TakeWhileUntil`
- Added parameter `bool format = true` to the function `fastBuild()`
- The numbering algorithm for local variables has been slightly improved

## 0.4.2

- Implemented and tested transformer `CharClass`

## 0.4.1-1.dev

- Fixed bug in `ParserBuilder.buildBodyEx()`

## 0.4.0

- Breaking change: The generated parser body is no longer wrapped in a `for` statement. This makes the code smaller and more readable

## 0.3.1-1.dev

- Removed class `Result` from runtime library
- Implemented and tested parser builders `Skip`
- Added documentation for parser builders from the library `bytes`
- Breaking change: Renamed parser builder `MapRes` to `Map$`. The `MapRes` will be implemented later

## 0.3.0

- Breaking change: The generated parser no longer requires result value wrapping. This increases parsing performance by 10-20%

## 0.2.1-4.dev

- Added a script `fast_build.dart` with a function `fastBuild` to simplify build process
- Implemented and tested parser builders `Alphanumeric0`, `Alphanumeric1`, `AnyChar`, `HexDigit0`, `HexDigit1`

## 0.2.1-3.dev

- Implemented and tested parser builders `SkipWhile1`
- Added support for an unofficial way to display error messages (for development purposes) via the `getErrorMessageProcessor` function
- Breaking change: Removed all building methods from context class `Context`
- - Added class `ParseRuntime` with source codes of static  declarations necessary for the runtime of the generated parsers

## 0.2.1-2.dev

- Implemented and tested parser builders `Alpha0`, `Alpha1`, `Digit0`, `Digit1`, `NoneOfTags`, `TakeWhile1`
- A new method `BuildBodyEx` has been introduced, which is currently the basis for building the parser body from a template
- Renamed parser builder `SkipWhile0` to `SkipWhile`
- Breaking change: The parser builders `TakeWhile`, `TakeWhileMN` now return a parsed string instead of a character list. It was a mistake to implement them to return a list

## 0.2.1-1.dev

- Implemented and tested parser builders `Consumed`, `Not`, `Peek`, `Recognize`, `Tags`, `Tuple2`, `Tuple3`, `Tuple4`, `Tuple5`, `Tuple6`, `Tuple7`
- Changed parser builder `Eof` from `Eof extends ParserBuilder<String, dynamic>` to `Eof<I> extends ParserBuilder<I, dynamic>`. Now it can be used not only with `String` data

## 0.2.0

- Removed support of `lookahead` as it didn't provide a significant performance boost
- Breaking change: significantly redesigned (unified) and improved the way to define the parser builder. Now it is not required to call any processing methods

## 0.1.6

- Added support for `lookahead`
- Implemented and tested parser builders `Many0`, `Many0Count`, `Many1`, `Many1Count`, `ManyMN`, `SeparatedList1`, `TagNoCase`
- Added tests for parser builder `SeparatedList0`

## 0.1.5

- Added field `Object? context` to the `State` class (the state of the parsing) to possibility the implementation of context-sensitive parsers (by eg. YAML parsers)

## 0.1.4

- Parser builders have been moved to separate classes

## 0.1.3

- Added tests for parser builder `SeparatedPair`

## 0.1.2

- Added tests for parser builders `Eof`, `MapRes`, `Opt`, `Value`

## 0.1.1

- Added tests for parser builders `Satisfy`, `SkipWhile0`

## 0.1.0

- Initial release