part of '../../sequence.dart';

class Preceded<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (!state.ok) {
    state.pos = {{pos}};
  }
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (!state.ok) {
    state.pos = {{pos}};
  }
}''';

  final ParserBuilder<I, dynamic> precede;

  final ParserBuilder<I, O> parser;

  const Preceded(this.precede, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': precede.build(context, null),
      'p2': parser.build(context, result),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
