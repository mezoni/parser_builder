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
    Expected(
        'hexadecimal color',
        Preceded(
            Tag('#'),
            Map3(
                _hexPrimary,
                _hexPrimary,
                _hexPrimary,
                ExpressionAction<Color>(
                    ['r', 'g', 'b'], 'Color({{r}}, {{g}}, {{b}})')))));

const _hexPrimary = Named(
    '_hexPrimary',
    Map1(TakeWhileMN(2, 2, CharClass('[0-9A-Fa-f]')),
        ExpressionAction<int>(['x'], 'int.parse({{x}}, radix: 16)')));

const _parse = Named('_parse', _hexColor);
