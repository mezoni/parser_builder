# parser_builder

Lightweight parser build system. Simple prototyping. Comfortable debugging. Effective developing.

Version: 0.16.1

Early release version (not all built-in common buildres are implemented but can be used without them).  
It is under development, but you can already play around. An example of a working JSON parser is included.  

At the moment, the implementation of useful built-in common parser builders is underway.

The build system is already implemented and ready to use and you can try it out in action. Rewrite your existing parser and feel the difference!  
Attention, the generated combinations of parsers are very small and very efficient.  
Ask questions if something is not clear.  

## Advantage

- `Very simple and clear` build and code generation system
- Parser declaration based on `combinations of parsers`
- Allows to build parsers to `parse any kind of data` (binary data, tokens, etc.)
- Support for generating parsers `into functions or into statements` (inlined parser code)
- The performance of the generated parsers is `quite high`
- The generated parsers `does not wrap the values` of the parse results
- The parser builder generates `fully strongly typed` parsers
- Small size of the embedded `runtime code (about 11 Kb)` to support the work of the parser
- The size of generated parser rules `starts from 350 bytes` (without runtime code)
- The generated source code of the parsers is `human-friendly` as if you wrote it by hand
- Very `handy debugging` and setting breakpoints to any place of parsing
- An `elegant way to implement your own tracing` which can easily be turned off
- Very `flexible error handling` system (with support for nested errors)
- Built-in `error preprocessing` procedures (grouping and flattening errors)
- `Fully customizable` (according to your needs) error reporting procedures
- Error messages `can be easily localized` (translated into another language) before being output
- Includes high-performance, most common `built-in parser builders`
- Support for `32 bit Unicode characters` out of the box (no need to worry about that)

## Included parser builders

built-in:
- [`Named`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/named.dart)
- [`Ref`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/ref.dart)

[`branch`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch):
- [`Alt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)
- [`Alt2..Alt7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)
- [`SwitchTag`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/switch_tag.dart)

[`bytes`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes):
- [`NoneOfTags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/none_of_tags.dart)
- [`Skip`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip.dart)
- [`SkipWhile`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while.dart)
- [`SkipWhile1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while1.dart)
- [`Tag`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag.dart)
- [`TagNoCase`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_no_case.dart)
- [`TagOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_of.dart)
- [`Tags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tags.dart)
- [`TakeUntil`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/take_until.dart)
- [`TakeUntil1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/take_until1.dart)
- [`TakeWhile`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/take_while.dart)
- [`TakeWhile1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/take_while1.dart)
- [`TakeWhileMN`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/take_while_m_n.dart)

[`character`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character):
- [`Alpha0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/alpha0.dart)
- [`Alpha1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/alpha1.dart)
- [`Alphanumeric0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/alphanumeric0.dart)
- [`Alphanumeric1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/alphanumeric1.dart)
- [`AnyChar`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/any_char.dart)
- [`Char`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/char.dart)
- [`Digit0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/digit0.dart)
- [`Digit1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/digit1.dart)
- [`HexDigit0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/hex_digit0.dart)
- [`HexDigit1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/hex_digit1.dart)
- [`NoneOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/none_of.dart)
- [`NoneOfEx`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/none_of_ex.dart)
- [`OneOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/one_of.dart)
- [`Satisfy`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/satisfy.dart)

[`combinator`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator):
- [`Consumed`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/consumed.dart)
- [`Eof`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/eof.dart)
- [`Fast`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/fast.dart)
- [`Map1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/map1.dart)
- [`Not`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/not.dart)
- [`Opt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/opt.dart)
- [`Peek`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/peek.dart)
- [`Recognize`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/recognize.dart)
- [`Value`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/value.dart)
- [`Verify`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/verify.dart)

[`error`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error):
- [`Expected`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/expected.dart) (not tested yet)
- [`Nested`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/nested.dart) (not fully tested)

[`multi`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi):
- `FoldMany0` (not implenented yet)
- `FoldMany1` (not implenented yet)
- [`Many0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many0.dart)
- [`Many0Count`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many0_count.dart)
- [`Many1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many1.dart)
- [`Many1Count`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many1_count.dart)
- [`ManyMN`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many_m_n.dart)
- [`ManyTill`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many_till.dart)
- [`SeparatedList0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/separated_list0.dart)
- [`SeparatedList1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/separated_list1.dart)

[`sequence`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence):
- [`Delimited`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/delimited.dart)
- [`Map2..Map7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/map.dart)
- [`Pair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/pair.dart)
- [`Preceded`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/preceded.dart)
- [`SeparatedPair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/separated_pair.dart)
- [`Skip`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/skip.dart)
- [`SkipMany0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/skip_many0.dart)
- [`Terminated`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/terminated.dart)
- [`Tuple1..Tuple7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/tuple.dart)

[`string`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string):
- [`EscapeSequence`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string/escape_sequence.dart)
- [`StringValue`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string/string_value.dart)

## Semantic action

- [`ClosureAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`ExprAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`FuncExprAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`FuncAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`VarAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)

## Character class

- [`CharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_class.dart)
- [`CharClasses`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_classes.dart)
- [`NotCharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/not_char_class.dart)

## How to start write your parser?

Take look  at this very simple example of hex color parser builder:

```dart
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/transformers.dart';

import 'hex_color_parser_helper.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  final filename = 'example/hex_color_parser.g.dart';
  await fastBuild(context, [_parse], filename, partOf: 'hex_color_parser.dart');
}

const _hexColor = Named(
    '_hexColor',
    Preceded(
        Tag('#'),
        Map3(
            _hexPrimary,
            _hexPrimary,
            _hexPrimary,
            ExprTransformer<Color>(
                ['r', 'g', 'b'], 'Color({{r}}, {{g}}, {{b}})'))));

const _hexPrimary = Named(
    '_hexPrimary',
    Map1(TakeWhileMN(2, 2, CharClass('[0-9A-Fa-f]')),
        ExprTransformer<int>(['x'], 'int.parse({{x}}, radix: 16)')));

const _parse = Named('_parse', _hexColor);

```

Function `fastBuild` performs the following operations:  
- Building of the parser and code generation
- Combining of the parser code from different parts (header + code + footer)
- Write code to file
- Code formatting

The rest of the code includes the following elements:  
- Parser combintors declarations

The generated source code can be found here:  
https://github.com/mezoni/parser_builder/blob/master/example/hex_color_parser.g.dart

To get started, you need to copy 3 files:  
https://github.com/mezoni/parser_builder/blob/master/example/hex_color_parser_builder.dart  
https://github.com/mezoni/parser_builder/blob/master/example/hex_color_parser_helper.dart  
https://github.com/mezoni/parser_builder/blob/master/example/hex_color_parser.dart  

Rename them as you need.  
The file `hex_color_parser_builder.dart` is parser builder script. Place it in the "tool" directory.  
This is where you will declare and build your parser.

The file `hex_color_parser.dart` is parser script. This will be the public part of your parser.  
You can modify it as you wish.

The file `hex_color_parser_helper.dart` is parser dependency script (as an example).  
This file is not particularly required, but for convenience, you can place various functions and data structures in it, which can be referenced from the builder (the data that the parser needs). This data does not have to be in this file.

The file `hex_color_parser.g.dart` is generated by your parser builder.

When static metaprogramming appears in Dart, then some of these operations will not have to be performed and parsers will be generated on the fly, through just one macro annotation.  
Well, of course, you will have to write a small macro for building (with code like in the `main` function).

## Example of parser declaration

```dart
const _comma = Named('_comma', Terminated(Tag(','), _ws), [_inline]);

const _eof = Named('_eof', Eof<String>());

const _escaped = Named('_escaped', Alt([_escapeSeq, _escapeHex]));

const _escapeHex = Named(
    '_escapeHex',
    Map2(Tag('u'), TakeWhileMN(4, 4, CharClass('[0-9a-fA-F]')),
        ExprTransformer<int>(['_', 's'], '_toHexValue({{s}})')),
    [_inline]);

const _escapeSeq = EscapeSequence({
  0x22: 0x22,
  0x2f: 0x2f,
  0x5c: 0x5c,
  0x62: 0x08,
  0x66: 0x0c,
  0x6e: 0x0a,
  0x72: 0x0d,
  0x74: 0x09
});

const _false = Named('_false', Value(false, Tag('false')), [_inline]);

const _inline = '@pragma(\'vm:prefer-inline\')';
```

## Example of generated code

```dart
Color? _hexColor(State<String> state) {
  final source = state.source;
  Color? $0;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 35;
  if (state.ok) {
    state.pos += 1;
    Color? $2;
    final $pos1 = state.pos;
    int? $3;
    $3 = _hexPrimary(state);
    if (state.ok) {
      int? $4;
      $4 = _hexPrimary(state);
      if (state.ok) {
        int? $5;
        $5 = _hexPrimary(state);
        if (state.ok) {
          final $v = ($3 as int?)!;
          final $v1 = ($4 as int?)!;
          final $v2 = ($5 as int?)!;
          $2 = Color($v, $v1, $v2) as Color?;
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.pos = $pos;
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('#'));
  }
  return $0;
}

```

This code was generated from this declaration:

```dart
const _hexColor = Named(
    '_hexColor',
    Preceded(
        Tag('#'),
        Map3(
            _hexPrimary,
            _hexPrimary,
            _hexPrimary,
            ExprTransformer<Color>(
                ['r', 'g', 'b'], 'Color({{r}}, {{g}}, {{b}})'))));
```

## Inlining code example

Declaration of `_json` parser.


```dart
const _eof = Eof();

const _json = Named('_json', Delimited(_ws, _value, _eof));
```

The `Eof` parser was inlined because it was not named.  
Inlined means that it was generated without a function declaration for it (only as statements).

```dart
dynamic _json(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  _ws(state);
  dynamic $2;
  $2 = _value(state);
  if (state.ok) {
    state.ok = state.pos >= state.source.length;
    if (!state.ok) {
      state.error = ErrExpected.eof(state.pos);
    } else {
      $0 = $2;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

```

This code was generated from this declaration:

```dart
const _json = Named('_json', Delimited(_ws, _value, _eof));
```

## Example of error reporting

```
Unhandled exception:
FormatException:
line 1, column 1: Expected: [, {, ", string, number, false, null, true
  ╷
1 │ 123.`
  │ ^
  ╵
line 1, column 1: Malformed number
  ╷
1 │ 123.`
  │ ^^^^^
  ╵
line 1, column 5: Unexpected: '`'
  ╷
1 │ 123.`
  │     ^
  ╵
```

Such an error will be generated, for example, by such a parser:

```dart
const _number =
    Named('_number', Malformed('number', Terminated(Number(), _ws)));
```

This parser (`Malformed`) is not required to know anything about the data format, its task is to correctly handle parsing errors.  
If parsing eventually fails, then the appropriate error post-processing procedure translates all nested errors correctly into other errors, and the output will be such an error message.  
During parsing, errors are generated on the fly, but they are not translated on the fly, but stored only in a form convenient for the parser (in fact, as they are).

## How to declare a parser builder

Declaring your own parser builder (if required) is very simple. The process is very simple.  
Let's take a look at an existing parser builder and assume it doesn't exist and you need to create one just like it.  
This is an implementation of the well-known parsing expression called `optional` (aka `?`).

```dart
part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess()) {
      throw StateError('Using a parser that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    code += fast ? '' : 'final $list = <$O>[];';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, fast);
      helper.build(context, code, parser, result1, true, onSuccess: (code) {
        code += fast ? '' : '$list.add(${result1.valueUnsafe});';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(result, list);
    code.labelSuccess(key);
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return true;
  }
}

```

An updated version of this section will be added later...

## Performance

Current performance of the generated JSON parser.  

The performance is about 1.17-1.33 times lower than that of a hand-written high-quality specialized state machine based JSON parser from the Dart SDK.

Better results in many cases are obtained in AOT mode. If the Dart SDK compiler had made more efficient use placement of (short lifetime) local variables in registers, the results could have been slightly better. At the moment, the generated parser code is not optimized for using machine registers, because performance tests, unfortunately, do not show a gain from this kind of optimization.

AOT mode:

```
Parse 10 times: E:\prj\test_json\bin\data\canada.json
Dart SDK JSON    : k: 2.06, 41.70 MB/s, 514.80 ms (100.00%),
Simple JSON NEW 2: k: 1.00, 86.01 MB/s, 249.60 ms (48.48%),

Parse 10 times: E:\prj\test_json\bin\data\citm_catalog.json
Dart SDK JSON    : k: 1.00, 87.98 MB/s, 187.20 ms (85.71%),
Simple JSON NEW 2: k: 1.17, 75.41 MB/s, 218.40 ms (100.00%),

Parse 10 times: E:\prj\test_json\bin\data\twitter.json
Dart SDK JSON    : k: 1.00, 57.86 MB/s, 93.60 ms (85.72%),
Simple JSON NEW 2: k: 1.17, 49.60 MB/s, 109.20 ms (100.00%),

OS: Microsoft Windows 7 Ultimate 6.1.7601
Kernel: Windows_NT 6.1.7601
Processor (4 core) Intel(R) Core(TM) i5-3450 CPU @ 3.10GHz
```

JIT mode:

```
Parse 10 times: E:\prj\test_json\bin\data\canada.json
Dart SDK JSON    : k: 2.38, 44.39 MB/s, 483.60 ms (100.00%),
Simple JSON NEW 2: k: 1.00, 105.86 MB/s, 202.80 ms (41.94%),

Parse 10 times: E:\prj\test_json\bin\data\citm_catalog.json
Dart SDK JSON    : k: 1.00, 87.98 MB/s, 187.20 ms (75.00%),
Simple JSON NEW 2: k: 1.33, 65.99 MB/s, 249.60 ms (100.00%),

Parse 10 times: E:\prj\test_json\bin\data\twitter.json
Dart SDK JSON    : k: 1.00, 57.87 MB/s, 93.60 ms (75.00%),
Simple JSON NEW 2: k: 1.33, 43.40 MB/s, 124.80 ms (100.00%),

OS: Microsoft Windows 7 Ultimate 6.1.7601
Kernel: Windows_NT 6.1.7601
Processor (4 core) Intel(R) Core(TM) i5-3450 CPU @ 3.10GHz
```

The data for the test is taken from here:
https://github.com/serde-rs/json-benchmark/tree/master/data


There is a reasonable explanation for this: this is a combinators of universal parsers. It will always be slower than a specialized parser written by hand.  
Because the redundancy that exists in parser combinators cannot be eliminated when generating code.  
The same redundancy allows you to use combinators to parse any type of data, not just text. For the same reason, they are slightly less efficient at parsing text.

But there are still advantages. This is a high development speed and quite informative error messages.

The advantages over parsers that are limited only by notation are obvious. You can implement everything that such parsers support, and everything else that you need can simply be added.  
But parsers using the notation can have the advantage that they can greatly optimize the generated code.  

But at the same time, nothing prevents the programmer from writing sub parsers manually for those parsing places where performance is very critical. And again, this has its share of advantages of combined parsers. Add a little bit of your own code and your parser is already much faster.  
Basically, this concerns the parsing of complex structures with specific data formats (strings, numbers, and so on).  
The fastest parser for them is the state machine. It can and should be created manually and/or using third-party tools. And it will be only some part of the whole parser.  

If I had a lot of free time, then I could probably write a code-first generator of small state machines for quickly parsing data of various formats. For example, to write lexers or sub parsers.

## More info...

To be continued...
