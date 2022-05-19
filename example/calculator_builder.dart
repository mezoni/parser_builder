import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/char_class.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/expression.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  return fastBuild(context, [_parse, _expression_], 'example/calculator.dart',
      header: __header, publish: {'parse': _parse});
}

const __header = '''
void main() {
  final source = '1 + 2 * 3 * (1 + 2.0)';
  final result = parse(source);
  print(result);
}

num _calculate(num left, String operator, num right) {
  switch (operator) {
    case '+':
      return left + right;
    case '-':
      return left - right;
    case '*':
      return left * right;
    case '/':
      return left / right;
    case '~/':
      return left ~/ right;
    default:
      throw StateError('Unknown operator: \$operator');
  }
}
''';

const _additive = Named(
    '_additive',
    BinaryExpression(
        _multiplicative, _additiveOperator, _multiplicative, _calculate));

const _additiveOperator =
    Named('_additiveOperator', Terminated(Tags(['+', '-']), _ws));

const _calculate = ExpressionAction<num>(
    ['left', 'op', 'right'], '_calculate({{left}}, {{op}}, {{right}})');

const _closeParen = Named('_closeParen', Terminated(Tag(')'), _ws));

const _digit1 = Named('_digit1', Digit1());

const _expression = Ref<String, num>('_expression');

const _expression_ = Named('_expression', _additive);

const _isWhitespace = CharClass('#x9 | #xA | #xD | #x20');

const _multiplicative = Named('_multiplicative',
    BinaryExpression(_primary, _multiplicativeOperator, _primary, _calculate));

const _multiplicativeOperator =
    Named('_multiplicativeOperator', Terminated(Tags(['*', '/', '~/']), _ws));

const _number = Named('_number', Terminated(_numberImpl, _ws));

const _numberImpl = Named(
    '_numberImpl',
    Expected(
        'number',
        Map1(Recognize(Pair(_digit1, Opt(Pair(Tag('.'), _digit1)))),
            ExpressionAction<num>(['x'], 'num.parse({{x}})'))));

const _openParen = Named('_openParen', Terminated(Tag('('), _ws));

const _parse = Named('_parse', Delimited(_ws, _expression, Eof<String>()));

const _primary = Named(
    '_primary',
    Nested(
        'expression',
        Alt2(
          _number,
          Delimited(_openParen, _expression, _closeParen),
        )));

const _ws = Named('_ws', SkipWhile(_isWhitespace));
