part of '../../combinator.dart';

class Map1<I, O1, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser;

  const Map1(this.parser, this.map);

  @override
  void build(Context context, CodeGen code) {
    final result = helper.build(context, code, parser);
    code.ifSuccess((code) {
      final v = code.val('v', result.value, false);
      code.setResult(map.build(context, 'map', [v]));
    });
  }
}
