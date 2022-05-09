part of '../../combinator.dart';

@experimental
class Lookahead<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
  {{p2}}
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
  {{p2}}
}''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, O> predict;

  const Lookahead(this.predict, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': predict.build(context, null),
      'p2': parser.build(context, result),
    });
    return render2(
        fast, _templateFast, _template, values, [result, null, result]);
  }
}
