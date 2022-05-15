part of '../../sequence.dart';

class Delimited<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{p3}}
  }
  if (!state.ok) {
    {{res0}} = null;
    state.pos = {{pos}};
  }
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{p3}}
  }
  if (!state.ok) {
    state.pos = {{pos}};
  }
}''';

  final ParserBuilder<I, dynamic> after;

  final ParserBuilder<I, dynamic> before;

  final ParserBuilder<I, O> parser;

  const Delimited(this.before, this.parser, this.after);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': before.build(context, null),
      'p2': parser.build(context, result),
      'p3': after.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
