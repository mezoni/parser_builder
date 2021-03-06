# parser_builder

Lightweight template-based parser build system. Simple prototyping. Comfortable debugging. Effective developing.

Version: 2.0.34

It is under development (not all built-in common buildres are implemented but can be used without them), but you can already play around.  

At the moment, the implementation of useful built-in common parser builders is underway.

The build system is already implemented and ready to use and you can try it out in action. Rewrite your existing parser and feel the difference!  
The generated combinations of parsers are very small and very efficient.  
Ask questions if something is not clear.  

## Advantage

- `Very simple and clear` build and code generation system
- `Templates-based` (visually intuitive) definition of parser builders
- Parser declaration based on `combinations of parsers`
- Allows to build parsers to `parse any kind of data` (binary data, tokens, etc.)
- Support for generating parsers `into functions or into statements` (inlined parser code)
- The performance of the generated parsers is `quite high`
- The generated parsers `does not wrap the values` of the parse results
- The parser builder generates `fully strongly typed` parsers
- Small size of the embedded `runtime code (about 6 Kb)` to support the work of the parser
- The size of generated parser rules `starts from 350 bytes` (without runtime code)
- The generated source code of the parsers is `human-friendly` as if you wrote it by hand
- Very `handy debugging` and setting breakpoints to any place of parsing
- An `elegant way to implement your own tracing` which can easily be turned off
- Very `flexible error handling` system
- Built-in `error preprocessing` procedures (grouping and flattening errors)
- `Fully customizable` (according to your needs) error reporting procedures
- Error messages `can be easily localized` (translated into another language) before being output
- Includes high-performance, most common `built-in parser builders`
- Includes built-in parser builders `to simplify parsing expressions`
- Includes built-in parser builder `for lightweight (on demand) memoization`
- Support for `32 bit Unicode characters` out of the box (no need to worry about that)
- Included built-in simple script for `fast building of parsers`

## Projects using parser builder

- [fast_csv](https://pub.dev/packages/fast_csv)
- [fast_json](https://pub.dev/packages/fast_json)

## Included parser builders

built-in:
- [`Named`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/named.dart)
- [`Ref`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/ref.dart)

[`branch`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch):
- [`Alt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)
- [`Alt2..Alt7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)

[`bytes`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes):
- [`NoneOfTags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/none_of_tags.dart)
- [`SkipWhile`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while.dart)
- [`SkipWhile1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while1.dart)
- [`Tag`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag.dart)
- [`TagNoCase`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_no_case.dart)
- [`TagOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_of.dart)
- [`Tags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tags.dart)
- [`TagValues`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_values.dart)
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
- [`NoneOfOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/none_of_of.dart)
- [`OneOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/one_of.dart)
- [`Satisfy`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/satisfy.dart)

[`combinator`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator):
- [`And`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/and.dart) (not tested yet)
- [`Calculate`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/calculate.dart) (not tested yet)
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
- [`Expected`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/expected.dart)
- [`Nested`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/nested.dart)

[`expression`](https://github.com/mezoni/parser_builder/blob/master/lib/src/expression):
- [`BinaryExpression`](https://github.com/mezoni/parser_builder/blob/master/lib/src/expression/binary_expression.dart)
- [`IdentifierExpression`](https://github.com/mezoni/parser_builder/blob/master/lib/src/expression/identifier_expression.dart)
- [`PostfixExpression`](https://github.com/mezoni/parser_builder/blob/master/lib/src/expression/postfix_expression.dart)
- [`PrefixExpression`](https://github.com/mezoni/parser_builder/blob/master/lib/src/expression/prefix_expression.dart)

[`memoization`](https://github.com/mezoni/parser_builder/blob/master/lib/src/memoization):
- [`Memoize`](https://github.com/mezoni/parser_builder/blob/master/lib/src/memoization/memoize.dart)

[`multi`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi):
- [`FoldMany0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/fold_many0.dart)
- `FoldMany1` (not implenented yet)
- [`Many0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many0.dart)
- [`Many0Count`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many0_count.dart)
- [`Many1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many1.dart)
- [`Many1Count`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many1_count.dart)
- [`ManyMN`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many_m_n.dart)
- [`ManyN`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many_n.dart)
- [`ManyTill`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/many_till.dart)
- [`SeparatedList0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/separated_list0.dart)
- [`SeparatedList1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/separated_list1.dart)
- [`SeparatedListN`](https://github.com/mezoni/parser_builder/blob/master/lib/src/multi/separated_list_n.dart)

[`sequence`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence):
- [`Delimited`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/delimited.dart)
- [`Map2..Map7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/map.dart)
- [`Pair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/pair.dart)
- [`Preceded`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/preceded.dart)
- [`SeparatedPair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/separated_pair.dart)
- [`SkipMany0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/skip_many0.dart)
- [`Terminated`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/terminated.dart)
- [`Tuple1..Tuple7`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/tuple.dart)

[`string`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string):
- [`EscapeSequence`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string/escape_sequence.dart)
- [`StringValue`](https://github.com/mezoni/parser_builder/blob/master/lib/src/string/string_value.dart)

## Built-in semantic actions

- [`ExpressionAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`FunctionAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)
- [`VariableAction`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/semantic_action.dart)

## Character class (additional semantic actions for character ranges)

- [`CharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_class.dart)
- [`CharClasses`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_classes.dart)
- [`NotCharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/not_char_class.dart)

## How to start write your parser?

Take look  at this very simple example of hex color parser builder:

```dart
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/char_class.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';

import 'hex_color_parser_helper.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  final filename = 'example/hex_color_parser.g.dart';
  await fastBuild(context, [_parse], filename,
      partOf: 'hex_color_parser.dart', publish: {'parse': _parse});
}

const _hexColor = Named(
    '_hexColor',
    Nested(
        'hexadecimal color',
        Preceded(
            Tag('#'),
            Indicate(
                'A hexadecimal color starting with "#" must be followed by 6 hexadecimal digits',
                Map3(
                    _hexPrimary,
                    _hexPrimary,
                    _hexPrimary,
                    ExpressionAction<Color>(
                        ['r', 'g', 'b'], 'Color({{r}}, {{g}}, {{b}})'))))));

const _hexPrimary = Named(
    '_hexPrimary',
    Map1(TakeWhileMN(2, 2, CharClass('[0-9A-Fa-f]')),
        ExpressionAction<int>(['x'], 'int.parse({{x}}, radix: 16)')));

const _parse = Named('_parse', _hexColor);

```

Function `fastBuild` performs the following operations:  
- Building specified parsers
- Combining of the parser code from different parts (header + code + footer)
- Write code to file
- Code formatting

The rest of the code includes the following elements:  
- Parser combintors declarations

The generated source code can be found here:  
https://github.com/mezoni/parser_builder/blob/master/example/hex_color_parser.g.dart

To get started, you may to copy 3 files:  
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
const _comma = Terminated(Tag(','), _ws);

const _eof = Eof<String>();

const _escaped = Named('_escaped', Alt2(_escapeSeq, _escapeHex));

const _escapeHex = Named<String, int>(
    '_escapeHex',
    Map3(
        PosToVal('start'),
        Fast(Satisfy(CharClass('[u]'))),
        HandleLastErrorPos<String, String>(
          Alt2(
            TakeWhileMN(4, 4, CharClass('[0-9a-fA-F]')),
            FailMessage(
                StatePos.lastErrorPos,
                "An escape sequence starting with '\\u' must be followed by 4 hexadecimal digits",
                '{{start|value}}',
                StatePos.lastErrorPos),
          ),
        ),
        ExpressionAction<int>(['s'], '_toHexValue({{s}})')),
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

const _false = Named('_false', Value(false, Tag('false')));

const _inline = '@pragma(\'vm:prefer-inline\')';

```

## Example of generated code

```dart
Color? _hexColor(State<String> state) {
  Color? $0;
  final source = state.source;
  final $pos = state.minErrorPos;
  state.minErrorPos = state.pos + 1;
  final $pos1 = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 35;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '#');
  }
  if (state.ok) {
    final $pos2 = state.start;
    state.start = state.pos;
    final $pos3 = state.setLastErrorPos(-1);
    final $pos4 = state.pos;
    int? $1;
    $1 = _hexPrimary(state);
    if (state.ok) {
      int? $2;
      $2 = _hexPrimary(state);
      if (state.ok) {
        int? $3;
        $3 = _hexPrimary(state);
        if (state.ok) {
          final v1 = $1!;
          final v2 = $2!;
          final v3 = $3!;
          $0 = Color(v1, v2, v3);
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos4;
    }
    if (!state.ok) {
      state.ok = false;
      state.fail(
          state.lastErrorPos,
          ParseError.message,
          'A hexadecimal color starting with "#" must be followed by 6 hexadecimal digits',
          state.start);
    }
    state.restoreLastErrorPos($pos3);
    state.start = $pos2;
    if (!state.ok) {
      state.pos = $pos1;
    }
  }
  state.minErrorPos = $pos;
  if (!state.ok) {
    state.ok = false;
    state.fail(state.pos, ParseError.expected, 'hexadecimal color');
  }
  return $0;
}

```

This code was generated from this declaration:

```dart
const _hexColor = Named(
    '_hexColor',
    Nested(
        'hexadecimal color',
        Preceded(
            Tag('#'),
            Indicate(
                'A hexadecimal color starting with "#" must be followed by 6 hexadecimal digits',
                Map3(
                    _hexPrimary,
                    _hexPrimary,
                    _hexPrimary,
                    ExpressionAction<Color>(
                        ['r', 'g', 'b'], 'Color({{r}}, {{g}}, {{b}})'))))));

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
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    $0 = _value(state);
    if (state.ok) {
      state.ok = state.pos >= source.length;
      if (!state.ok) {
        state.fail(state.pos, ParseError.expected, 'EOF');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

```

This code was generated from this declaration:

```dart
const _json = Named<String, dynamic>('_json', Delimited(_ws, _value, _eof));
```

## How to declare a parser builder

Declaring your own parser builder (if required) is very simple. The process is very simple.  
Let's take a look at an existing parser builder and assume it doesn't exist and you need to create one just like it.  
This is an implementation of the well-known parsing expression called `optional` (aka `?`).

```dart
part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
{{p1}}
if (!state.ok) {
  state.ok = true;
}''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = {
      'p1': parser.build(context, result),
    };
    return render(_template, values);
  }
}

```

An updated version of this section will be added later...

## Performance

Current performance of the generated JSON parser.  

The performance is about 1.10-1.17 times lower than that of a hand-written high-quality specialized state machine based JSON parser from the Dart SDK.

Better results in many cases are obtained in AOT mode. If the Dart SDK compiler had made more efficient use placement of (short lifetime) local variables in registers, the results could have been slightly better. At the moment, the generated parser code is not optimized for using machine registers, because performance tests, unfortunately, do not show a gain from this kind of optimization.

AOT mode:

```
Parse 50 times: E:\prj\test_json\bin\data\canada.json (2251.05 Kb)
Dart SDK JSON : k: 2.14, 41.12 MB/s, 2610.1430 ms (100.00%),
Simple JSON NEW 1: k: 1.00, 87.92 MB/s, 1220.8190 ms (46.77%),

Parse 50 times: E:\prj\test_json\bin\data\citm_catalog.json (1727.03 Kb)
Dart SDK JSON : k: 1.00, 88.31 MB/s, 932.4810 ms (85.68%),
Simple JSON NEW 1: k: 1.17, 75.67 MB/s, 1088.3250 ms (100.00%),

Parse 50 times: E:\prj\test_json\bin\data\twitter.json (567.93 Kb)
Dart SDK JSON : k: 1.00, 58.00 MB/s, 466.9370 ms (86.75%),
Simple JSON NEW 1: k: 1.15, 50.31 MB/s, 538.2810 ms (100.00%),

OS: Microsoft Windows 7 Ultimate 6.1.7601
Kernel: Windows_NT 6.1.7601
Processor (4 core) Intel(R) Core(TM) i5-3450 CPU @ 3.10GHz
```

JIT mode:

```
Parse 50 times: E:\prj\test_json\bin\data\canada.json (2251.05 Kb)
Dart SDK JSON : k: 3.23, 49.09 MB/s, 2186.4390 ms (100.00%),
Simple JSON NEW 1: k: 1.00, 158.81 MB/s, 675.8890 ms (30.91%),

Parse 50 times: E:\prj\test_json\bin\data\citm_catalog.json (1727.03 Kb)
Dart SDK JSON : k: 1.00, 107.11 MB/s, 768.8210 ms (86.74%),
Simple JSON NEW 1: k: 1.15, 92.91 MB/s, 886.3120 ms (100.00%),

Parse 50 times: E:\prj\test_json\bin\data\twitter.json (567.93 Kb)
Dart SDK JSON : k: 1.00, 65.10 MB/s, 416.0140 ms (91.71%),
Simple JSON NEW 1: k: 1.09, 59.70 MB/s, 453.6420 ms (100.00%),

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
