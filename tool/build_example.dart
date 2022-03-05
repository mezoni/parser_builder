import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/string.dart';
import 'package:parser_builder/transformers.dart';
import 'package:tuple/tuple.dart' as _t;

import 'build_json_number_parser.dart' as _json_number;
import 'example_footer.dart';
import 'example_header.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  context.optimizeForSize = false;
  _configure(context, comment: false, trace: false);
  await fastBuild(context, [_json, _value_], 'example/example.dart',
      footer: [footer].join('\n'), header: header);
}

const _array = Named('_array', Delimited(_openBracket, _values, _closeBracket));

const _closeBrace = Named('_closeBrace', Terminated(Tag('}'), _ws), [_inline]);

const _closeBracket =
    Named('_closeBracket', Terminated(Tag(']'), _ws), [_inline]);

const _colon = Named('_colon', Terminated(Tag(':'), _ws), [_inline]);

const _comma = Named('_comma', Terminated(Tag(','), _ws), [_inline]);

const _eof = Named('_eof', Eof<String>());

const _escaped = Named('_escaped', Alt([_escapeSeq, _escapeHex]));

const _escapeHex = Named(
    '_escapeHex',
    Map$(Preceded(Char(0x75), TakeWhileMN(4, 4, _isHexDigit)), _toHexValue),
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

const _isHexDigit = CharClass('[0-9a-fA-F]');

const _isNormalChar = ExprTransformer<int, bool>(
    'x', '{{x}} >= 0x20 && {{x}} != 0x22 && {{x}} != 0x5c');

const _isWhitespace = CharClass('#x9 | #xA | #xD | #x20');

const _json = Named<String, dynamic>('_json', Delimited(_ws, _value, _eof));

const _keyValue = Named(
    '_keyValue', Map$(SeparatedPair(_string, _colon, _value), _toMapEntry));

const _keyValues = Named('_keyValues', SeparatedList0(_keyValue, _comma));

const _null = Named('_null', Value(null as dynamic, Tag('null')), [_inline]);

const _number = Named('_number', Malformed('number', _json_number.parser));

const _object = Named(
    '_object', Map$(Delimited(_openBrace, _keyValues, _closeBrace), _toMap));

const _openBrace = Named('_openBrace', Terminated(Tag('{'), _ws), [_inline]);

const _openBracket =
    Named('_openBracket', Terminated(Tag('['), _ws), [_inline]);

const _quote = Named('_quote', Terminated(Tag('"'), _ws), [_inline]);

const _string = Named(
    '_string', Malformed('string', Delimited(Tag('"'), _stringValue, _quote)));

const _stringValue =
    Named('_stringValue', StringValue(_isNormalChar, 0x5c, _escaped));

const _toHexValue = ExprTransformer<String, int>('x', '_toHexValue({{x}})');

const _toMap =
    ExprTransformer<List<MapEntry<String, dynamic>>, Map<String, dynamic>>(
        'x', 'Map.fromEntries({{x}})');

const _toMapEntry =
    ExprTransformer<_t.Tuple2<String, dynamic>, MapEntry<String, dynamic>>(
        'x', 'MapEntry({{x}}.item1, {{x}}.item2)');

const _true = Named('_true', Value(true, Tag('true')), [_inline]);

const _value = Ref<String, dynamic>('_value');

const _value_ = Named<String, dynamic>(
    '_value',
    Terminated(
        Alt([_string, _number, _false, _null, _true, _array, _object]), _ws),
    [_inline]);

const _values = Named('_values', SeparatedList0(_value, _comma));

const _ws = Named('_ws', SkipWhile(_isWhitespace), [_inline]);

void _configure(Context context, {bool comment = false, bool trace = false}) {
  if (comment || trace) {
    context.onEnter = (b) {
      final name = b.runtimeType.toString();
      final sb = StringBuffer();
      if (comment) {
        sb.writeln(' // => $name');
      }

      if (trace) {
        // Simple tracing
        sb.writeln('print(\'=> $name\');');
        sb.writeln('print(state.source);');
      }

      return sb.toString();
    };

    context.onLeave = (b, r) {
      final name = b.runtimeType.toString();
      final sb = StringBuffer();
      if (comment) {
        sb.writeln(' // <= $name');
      }

      if (trace) {
        // Simple tracing
        sb.writeln('print(\'<= $name: $r\');');
        sb.writeln('print(state.source);');
      }

      return sb.toString();
    };
  }
}
