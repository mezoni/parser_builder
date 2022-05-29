import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/char_class.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/capture.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/string.dart';

import 'build_json_number_parser.dart' as json_number;

Future<void> main(List<String> args) async {
  final context = Context();
  await fastBuild(context, [_json, _value_], 'example/example.dart',
      footer: __footer, publish: {'parse': _json});
}

const __footer = r'''
@pragma('vm:prefer-inline')
int _toHexValue(String s) {
  final l = s.codeUnits;
  var r = 0;
  for (var i = l.length - 1, j = 0; i >= 0; i--, j += 4) {
    final c = l[i];
    var v = 0;
    if (c >= 0x30 && c <= 0x39) {
      v = c - 0x30;
    } else if (c >= 0x41 && c <= 0x46) {
      v = c - 0x41 + 10;
    } else if (c >= 0x61 && c <= 0x66) {
      v = c - 0x61 + 10;
    } else {
      throw StateError('Internal error');
    }

    r += v * (1 << j);
  }

  return r;
}''';

const _array = Named('_array', Delimited(_openBracket, _values, _closeBracket));

const _closeBrace =
    Named('_closeBrace', Fast(Terminated(Tag('}'), _ws)), [_inline]);

const _closeBracket =
    Named('_closeBracket', Fast(Terminated(Tag(']'), _ws)), [_inline]);

const _colon = Fast(Terminated(Tag(':'), _ws));

const _comma = Terminated(Tag(','), _ws);

const _eof = Eof<Utf16Reader>();

const _escaped = Named('_escaped', Alt2(_escapeSeq, _escapeHex));

const _escapeHex = Named<Utf16Reader, int>(
    '_escapeHex',
    Map2(
        Fast(CaptureStart('start', Satisfy(CharClass('[u]')))),
        HandleLastErrorPos<Utf16Reader, String>(
          Alt2(
            TakeWhileMN(4, 4, CharClass('[0-9a-fA-F]')),
            FailMessage(
                LastErrorPositionAction(),
                "An escape sequence starting with '\\u' must be followed by 4 hexadecimal digits",
                CapturedValueAction('start'),
                LastErrorPositionAction()),
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

const _inline = '@pragma(\'vm:prefer-inline\')';

const _isNormalChar = CharClass('[#x20-#x21] | [#x23-#x5b] | [#x5d-#x10ffff]');

const _isWhitespace = CharClass('#x9 | #xA | #xD | #x20');

const _json =
    Named<Utf16Reader, dynamic>('_json', Delimited(_ws, _value, _eof));

const _keyValue = Named(
    '_keyValue',
    Map3(
        _string,
        _colon,
        _value,
        ExpressionAction<MapEntry<String, dynamic>>(
            ['k', 'v'], 'MapEntry({{k}}, {{v}})')));

const _keyValues = Named('_keyValues', SeparatedList0(_keyValue, _comma));

const _number = Named('_number', Expected('number', json_number.parser));

const _object = Named(
    '_object',
    Map3(_openBrace, _keyValues, _closeBrace,
        ExpressionAction(['kv'], 'Map.fromEntries({{kv}})')));

const _openBrace =
    Named('_openBrace', Fast(Terminated(Tag('{'), _ws)), [_inline]);

const _openBracket =
    Named('_openBracket', Fast(Terminated(Tag('['), _ws)), [_inline]);

const _quote = Named('_quote', Fast(Terminated(Tag('"'), _ws)), [_inline]);

const _string = Named<Utf16Reader, String>(
    '_string',
    Nested(
        'string',
        HandleLastErrorPos(Delimited(
            Fast(CaptureStart('start', Tag('"'))),
            _stringValue,
            Alt2(
                _quote,
                FailMessage(
                  LastErrorPositionAction(),
                  'Unterminated string',
                  CapturedValueAction('start'),
                ))))));

const _stringValue = StringValue(_isNormalChar, 0x5c, _escaped);

const _value = Ref<Utf16Reader, dynamic>('_value');

const _value_ = Named<Utf16Reader, dynamic>(
    '_value',
    Terminated(
        SwitchTag(
          {
            '"': _string,
            '[': _array,
            '{': _object,
            'false': Value(false, Advance(5)),
            'true': Value(true, Advance(4)),
            'null': Value(null as dynamic, Advance(4)),
            null: _number,
          },
          [
            FailExpected(PositionAction(), 'string'),
            FailExpected(PositionAction(), '['),
            FailExpected(PositionAction(), '}'),
            FailExpected(PositionAction(), 'false'),
            FailExpected(PositionAction(), 'true'),
            FailExpected(PositionAction(), 'null'),
            FailExpected(PositionAction(), 'number'),
          ],
        ),
        _ws));

const _values = Named('_values', SeparatedList0(_value, _comma));

const _ws = Named('_ws', SkipWhile(_isWhitespace));
