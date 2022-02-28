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