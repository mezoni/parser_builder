# parser_builder

Lightweight template-based parser build system. Simple prototyping. Comfortable debugging. Effective developing.

Version: 0.7.2

Early release version (not all built-in common buildres are implemented but can be used without them).  
It is under development, but you can already play around. An example of a working JSON parser is included.  

At the moment, the implementation of useful built-in common parser builders is underway.

The build system is already implemented and ready to use and you can try it out in action. Rewrite your existing parser and feel the difference!  
Attention, the generated combinations of parsers are very small and very efficient.  
Ask questions if something is not clear.  

## First advantage

- `Very simple and clear` build and code generation system
- `Templates-based` (visually intuitive) definition of parser builders
- Parser declaration based on `combinations of parsers`
- Allows to build parsers to `parse any kind of data` (binary data, tokens, etc.)
- Support for generating parsers `into functions or into statements` (inlined parser code)
- The performance of the generated parsers is `quite high`
- The generated parsers `does not wrap the values` of the parse results
- The parser builder generates `fully strongly typed` parsers
- Small size of the embedded `runtime code (about 10 Kb)` to support the work of the parser
- The size of the generated parsers `starts from 600 bytes` (without runtime code)
- The generated source code of the parsers is `human-friendly`
- Very `handy debugging` and setting breakpoints
- An `elegant way to implement your own tracing` which can easily be turned off
- Very `flexible error handling` system (with support for nested errors)
- Built-in `error preprocessing` procedures (grouping and flattening errors)
- `Fully customizable` (according to your needs) error reporting procedures
- Error messages `can be easily localized` (translated into another language) before being output
- Includes high-performance, most common `built-in parser builders`
- Support for `32 bit Unicode characters` out of the box (no need to worry about that)

## Second advantage

Another advantage is that the build system is very simple and straightforward. Any programmer will understand it without much difficulty.  
This means that an ordinary programmer can keep this software up to date.  
You do not need to be a man of seven spans in the forehead for this.  
The author of this software is also not such and is a simple person.  
It's just a simple but handy thing.  
Use it and don't worry about it stopping working.  
This software is already so simple that it couldn't be easier.

Documentation comming soon.  
To get started, you can view and run the following scripts:

Generated simple JSON parser.  
https://github.com/mezoni/parser_builder/blob/master/example/example.dart

Usage of generated JSON parser.  
https://github.com/mezoni/parser_builder/blob/master/example/test_example.dart

A tool to create a simple JSON parser.  
https://github.com/mezoni/parser_builder/blob/master/tool/build_example.dart

## Included parser builders

built-in:
- [`Named`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/named.dart)
- [`Ref`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/ref.dart)

[`branch`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch):
- [`Alt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)

[`bytes`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes):
- [`NoneOfTags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/none_of_tags.dart)
- [`SkipWhile`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while.dart)
- [`SkipWhile1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/skip_while1.dart)
- [`Tag`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag.dart)
- [`TagNoCase`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/tag_no_case.dart)
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
- [`Crlf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/crlf.dart)
- [`Digit0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/digit0.dart)
- [`Digit1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/digit1.dart)
- [`HexDigit0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/hex_digit0.dart)
- [`HexDigit1`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/hex_digit1.dart)
- [`LineEnding`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/line_ending.dart)
- [`NoneOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/none_of.dart)
- [`OneOf`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/one_of.dart)
- [`Satisfy`](https://github.com/mezoni/parser_builder/blob/master/lib/src/character/satisfy.dart)

[`combinator`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator):
- [`Consumed`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/consumed.dart)
- [`Eof`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/eof.dart)
- [`Map$`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/map.dart)
- [`Not`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/not.dart)
- [`Opt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/opt.dart)
- [`Peek`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/peek.dart)
- [`Recognize`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/recognize.dart)
- [`Value`](https://github.com/mezoni/parser_builder/blob/master/lib/src/combinator/value.dart)

[`error`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error):
- [`Labeled`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/labeled.dart) (not tested yet)
- [`Malformed`](https://github.com/mezoni/parser_builder/blob/master/lib/src/error/malformed.dart) (not fully tested)
- `Nested` (not implenented yet)

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
- [`Pair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/pair.dart)
- [`Preceded`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/preceded.dart)
- [`SeparatedPair`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/separated_pair.dart)
- [`Skip`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/skip.dart)
- [`SkipMany0`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/skip_many0.dart)
- [`Terminated`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/terminated.dart)
- [`Tuple`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/tuple.dart)

## Included transformers

- [`CharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_class.dart)
- [`CharClasses`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/char_classes.dart)
- [`NotCharClass`](https://github.com/mezoni/parser_builder/blob/master/lib/src/transformers/not_char_class.dart)

## What is a build system?

The build system itself is very simple and consists of the following files:  
- [`allocator.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/allocator.dart)
- [`context.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/context.dart)
- [`named`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/named.dart)
- [`parser_builder.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/parser_builder.dart)
- [`ref.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/ref.dart)
- [`runtime.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/runtime.dart)
- [`transformer.dart`](https://github.com/mezoni/parser_builder/blob/master/lib/src/parser_builder/transformer.dart)

The file `runtime.dart` contains only the static source code of the runtime, and without it, the entire build system takes about 9 KB (including a simple templating engine).  
Thus, all parsers building-related bugs can be easily found and fixed in this small library.  
It is quite possible to consider this system easy to maintain and reliable enough in the sense that there is no need to hire expensive specialists to understand how it works in order to fix it in case of a malfunction.

The rest of the code in this package is mostly libraries with useful parser builders for different use cases.

## How to start write your parser?

Take look  at this very simple example of hex color parser builder:

```dart
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';
import 'package:tuple/tuple.dart' as _t;

import 'hex_color_parser_helper.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  final filename = 'example/hex_color_parser.g.dart';
  await fastBuild(context, [_parse], filename, partOf: 'hex_color_parser.dart');
}

const _hexColor = Named('_hexColor',
    Preceded(Tag('#'), Tuple3(_hexPrimary, _hexPrimary, _hexPrimary)));

const _hexPrimary = Named(
    '_hexPrimary',
    Map$(TakeWhileMN(2, 2, TX('=> isHexDigit(x);')),
        TX<String, int>('=> fromHex(x);')));

const _parse = Named('_parse',
    Map$(_hexColor, TX<_t.Tuple3<int, int, int>, Color>('=> toColor(x);')));

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

const _eof = Eof();

const _escapeHex = Named(
    '_escapeHex',
    MapRes(Preceded(Char(0x75), TakeWhileMN(4, 4, _isHexDigit)), _toHexValue),
    [_inline]);

const _isHexDigit = CharClass('[0-9a-fA-F]');

const _inline = '@pragma(\'vm:prefer-inline\')';

const _toHexValue = Transformer<List<int>, int>('v', '=> _toHexValue(v);');
```

## Example of generated code

```dart
Tuple3<int, int, int>? _hexColor(State<String> state) {
  Tuple3<int, int, int>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  String? $1;
  state.ok = state.ch == 35;
  if (state.ok) {
    state.nextChar();
    $1 = '#';
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('#'));
  }
  if (state.ok) {
    Tuple3<int, int, int>? $2;
    final $pos1 = state.pos;
    final $ch1 = state.ch;
    int? $3;
    $3 = _hexPrimary(state);
    if (state.ok) {
      int? $4;
      $4 = _hexPrimary(state);
      if (state.ok) {
        int? $5;
        $5 = _hexPrimary(state);
        if (state.ok) {
          $2 = Tuple3($3!, $4!, $5!);
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.ch = $ch1;
    }
    if (state.ok) {
      $0 = $2!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}
```

This code was generated from this declaration:

```dart
const _hexColor = Named('_hexColor',
    Preceded(Tag('#'), Tuple3(_hexPrimary, _hexPrimary, _hexPrimary)));
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
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    dynamic $2;
    $2 = _value(state);
    if (state.ok) {
      bool? $3;
      final $pos1 = state.pos;
      state.ok = state.source.atEnd($pos1);
      if (state.ok) {
        $3 = true;
      } else {
        state.error = ErrExpected.eof($pos1);
      }
      if (state.ok) {
        $0 = $2;
      }
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

Declaring your parser (if required) is very simple. The process is very simple.  
Let's take a look at an existing parser builder and assume it doesn't exist and you need to create one just like it.

```dart
part of '../../combinator.dart';

class Map$<I, O1, O2> extends ParserBuilder<I, O2> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  final v = {{p1_val}};
  {{res}} = map(v);
}''';

  final ParserBuilder<I, O1> parser;

  final Transformer<O1, O2> transformer;

  const Map$(this.parser, this.transformer);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': transformer.transform('map'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser, transformer]);
  }
}

```

As a result, the generated parser `Map$` will run another parser `parser` and, if successful, will transform the result using the transformer `transformer`. Everything is simple.

This is a typical example of a parser builder that has dependencies (combines another parser builder) and also requires some data to generate the parser.  

To start, a few explanations. Parser builders are formed from templates and are described using templates. We can say that they are similar to macros, which are expanded based on the given data (their parameters).  
In the vast majority of cases (with the exception of self-modifying complex implementations with nested templates), this works 100%.  

And so, what is what in this definition.  

This parser builder uses the following parameters:

```dart
final ParserBuilder<I, O1> parser;

final Transformer<O1, O2> transformer;

const MapRes(this.parser, this.transformer);
```

In terms of parsing (when the source code is generated) the `parser` will produce some result (parse data), and the `transformer` will transform this result.  

In terms of building, the builder `parser` should go through the build process (into the parser source code), and the transformer `transformer` should be materialized (it also should generate some code that willl be used in parser code to transform the result).  
Instead of a transformer, other data may be used that does not require building, but requires embedding this data in the source code of the parser.  

Thus, we can conclude that two types of data (parameters) can be used. These are other parser builders and any other data needed to generate the parser code (strings, symbols, functions, and other data types).  
So, how to embed (transform) this data (parameters) into the source code?  

Now let's look at the builder template:

```dart
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  final v = {{p1_val}};
  {{res}} = map(v);
}''';
```

This is normal Dart code, but using tags for data that hasn't been defined yet.

All embedded (not defined yet) data is specified in the template through tags.  
We can see the following tags:  

- `p1`
- `p1_val`
- `res`
- `transform`

What do they mean and how should they be assigned (set)?   
First, let's take a look at how values are set for them.  

For parser builders:

```dart
  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }
```

For other data (other tags):

```dart
  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': transformer.transform('map'),
    };
  }
```

As you can see, the values for them are set through two methods:

```dart
Map<String, ParserBuilder> getBuilders()

Map<String, String> getTags(Context context)
```

Both of these methods return hash maps, in which the keys define the tags for the template, and the values are what will be substituted into the templates.  

Everything seems to be clear and simple, but how can you use builders as values for templates?  

In this case, the build system takes over the work.  
In order to be able to simply negotiate with this system, it is customary to use some convention.  

There are not many of them (at the moment) and they can be described as follows.  
For the builder to be processed, a unique tag is specified. This tag will be expanded to the following values and other tags that can be used in the template:

Example for tag `p1`:

- `p1` is a placeholder for the generated (by builder) parser source code
- `p1_res` will be created and set to the local variable name with the parsed result (eg `$5`)
- `p1_val` will be created and set to a safe expression to access the successful value of the local result variable (e.g. `$5`, `$6!`)

Also, the `res` tag will always be created. It will be set to a value with the name of a local variable of the current parse result.

Now looks again at the builder template:

```dart
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  final v = {{p1_val}};
  {{res}} = map(v);
}''';
```

How are the `map` tag created?

```dart
  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': transformer.transform('map'),
    };
  }
```

Tag `map` is used as the name of the `transformer` source code.  
Because the code `transformer.transform('map')` returns the `map` function source code.  

An example of the generated source code for the `map` function:

```dart
String map(List<int> x) => String.fromCharCodes(x);
```

That is, everything is simple and without the need to do anything else besides setting tags.  

Nothing prevents you from using your way of building in case of writing a complex builder.  
You can generate an already filled template (without tags) in the `getTemplate` method and not return any tags. This will be the source code of the parser body.  

Or you can choose not to return a list of builders from the `getBuilders` method, but you can build them yourself if you use nested templates. The main thing is to set the appropriate tags for your template.  
Depending on the complexity of implementing some builder with a complex high-performance specific parsing logic, you can do it (build the source code template) the way your algorithm requires it.

Example of complex builders:

- [`Alt`](https://github.com/mezoni/parser_builder/blob/master/lib/src/branch/alt.dart)
- [`NoneOfTags`](https://github.com/mezoni/parser_builder/blob/master/lib/src/bytes/none_of_tags.dart)
- [`Tuple`](https://github.com/mezoni/parser_builder/blob/master/lib/src/sequence/tuple.dart)

To this purpose a new method `BuildBodyEx` has been introduced, which is currently the basis for building the parser body from a template.   
It is used by the `BuildBody` method, which automatically assembles the parser body.  

```dart
  String buildBody(Context context) {
    final builders = getBuilders();
    final tags = getTags(context);
    final template = getTemplate(context);
    final result = buildBodyEx(context, builders, tags, template);
    return result;
  }
```

This method (`BuildBodyEx`) can be used to generate templates with nested parser blocks (templates) by calling it with the required parameters (builders, tags, and template) as many times as needed and embed the generated code into the main template.

```dart
String buildBodyEx(Context context, Map<String, ParserBuilder> builders,
      Map<String, String> tags, String template)
```

## Performance

Current performance of the generated JSON parser.  

The performance is about 1.2-1.5 times lower than that of a hand-written high-quality specialized state machine based parser from the Dart SDK.

```
Parse 10 times: E:\prj\test_json\bin\data\canada.json
Dart SDK JSON    : k: 1.03, 45.87 MB/s, 468.00 ms (100.00%),
Simple JSON NEW 1: k: 1.00, 47.45 MB/s, 452.40 ms (96.67%),

Parse 10 times: E:\prj\test_json\bin\data\citm_catalog.json
Dart SDK JSON    : k: 1.00, 87.98 MB/s, 187.20 ms (70.59%),
Simple JSON NEW 1: k: 1.42, 62.10 MB/s, 265.20 ms (100.00%),

Parse 10 times: E:\prj\test_json\bin\data\twitter.json
Dart SDK JSON    : k: 1.00, 57.87 MB/s, 93.60 ms (85.71%),
Simple JSON NEW 1: k: 1.17, 49.60 MB/s, 109.20 ms (100.00%),

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
