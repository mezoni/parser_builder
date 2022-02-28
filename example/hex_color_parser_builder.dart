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
