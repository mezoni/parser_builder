part of '../../sequence.dart';

class Terminated<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
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
  if (!state.ok) {
    state.pos = {{pos}};
  }
}''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> terminate;

  const Terminated(this.parser, this.terminate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, result),
      'p2': terminate.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
