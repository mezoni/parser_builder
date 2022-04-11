part of '../../combinator.dart';

class Map1<I, O1, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser;

  const Map1(this.parser, this.map);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final map = fast ? '' : this.map.build(context, 'map', ['v']);
    final r1 = helper.build(context, code, parser, silent, fast);
    code.ifChildSuccess(r1, (code) {
      code += fast ? '' : 'final v = ${r1.value};';
      code.setResult(result, map);
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
