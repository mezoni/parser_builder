import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  final filename = 'lib/src/char_class/char_class_parser.dart';
  await fastBuild(context, [_parse], filename,
      footer: __footer, header: __header, publish: {'parseString': _parse});
}

const __footer = '''
List<T> _flatten<T>(List<List<T>> data, List<T> result) {
  for (final item1 in data) {
    for (final item2 in item1) {
      result.add(item2);
    }
  }

  return result;
}

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

const __header = r'''
import 'package:source_span/source_span.dart';

''';

const _char = Named('_char', Delimited(Tag('"'), _charCode, Tag('"')));

const _charCode = Named('_charCode', Satisfy(_isAscii));

const _flatten = ExpressionAction<List<Result2<int, int>>>(
    ['x'], '_flatten({{x}}, <Result2<int, int>>[])');

const _hex = Named('_hex', Preceded(Tag('#x'), _hexVal));

const _hexOrRangeChar = Named('_hexOrRangeChar', Alt([_hex, _rangeChar]));

const _hexVal = Named('_hexVal', Map1(TakeWhile1(_isHexDigit), _toHexValue));

const _intToTuple2 =
    ExpressionAction<Result2<int, int>>(['x'], 'Result2({{x}}, {{x}})');

const _isAscii = ExpressionAction<bool>(['x'], '{{x}} >= 0x20 && {{x}} < 0x7f');

const _isHexDigit = ExpressionAction<bool>([
  'x'
], '{{x}} >= 0x30 && {{x}} <= 0x39 || {{x}} >= 0x41 && {{x}} <= 0x46 || {{x}} >= 0x61 && {{x}}<= 0x66');

const _isWhiteSpace = ExpressionAction<bool>(
    ['x'], '{{x}} == 0x09 || {{x}} == 0xA || {{x}} == 0xD || {{x}} == 0x20');

const _parse = Named('parse', Delimited(_ws, _ranges, Eof<String>()));

const _range = Named(
    '_range',
    Alt<String, List<Result2<int, int>>>([
      Delimited(Tag('['), Many1(_rangeBody), Tag(']')),
      Map1(Alt([_char, _hex]),
          ExpressionAction(['x'], ('[Result2({{x}}, {{x}})]'))),
    ]));

const _rangeBody = Named(
    '_rangeBody',
    Alt([
      SeparatedPair(_hexOrRangeChar, Tag('-'), _hexOrRangeChar),
      Map1(_hex, _intToTuple2),
      Map1(_rangeChar, _intToTuple2),
    ]));

const _rangeChar =
    Named('_rangeChar', Preceded(Not(Tags(['[', ']'])), Satisfy(_isAscii)));

const _ranges = Named('_ranges',
    Map1(SeparatedList1(Terminated(_range, _ws), _verbar), _flatten));

const _toHexValue = ExpressionAction<int>(['x'], '_toHexValue({{x}})');

const _verbar = Named('_verbar', Terminated(Tag('|'), _ws));

const _ws = Named('_ws', SkipWhile(_isWhiteSpace));
