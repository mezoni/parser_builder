part of '../../combinator.dart';

class Map1<I, O1, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser;

  const Map1(this.parser, this.map);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final fast = result.isVoid;
    final v = fast ? '' : context.allocateLocal('v');
    final map = fast ? '' : this.map.build(context, 'map', [v]);
    final result1 = helper.getResult(context, code, parser, fast);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      code += fast ? '' : 'final $v = ${result1.value};';
      code.setResult(result, map);
      code.labelSuccess(key);
    }, onFailure: (code) {
      code.labelFailure(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
