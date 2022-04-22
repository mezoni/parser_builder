part of '../../combinator.dart';

class Peek<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
  {{res0}} = {{val1}};
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
}''';

  final ParserBuilder<I, O> parser;

  const Peek(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
