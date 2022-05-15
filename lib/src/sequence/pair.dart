part of '../../sequence.dart';

class Pair<I, O1, O2> extends ParserBuilder<I, tuple.Tuple2<O1, O2>> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  {{var2}}
  {{p2}}
  if (state.ok) {
    {{res0}} = Tuple2({{val1}}, {{val2}});
  } else {
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

  final ParserBuilder<I, O1> first;

  final ParserBuilder<I, O2> second;

  const Pair(this.first, this.second);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(first, !fast);
    final r2 = context.getResult(second, !fast);
    values.addAll({
      'p1': first.build(context, r1),
      'p2': second.build(context, r2),
    });
    return render2(fast, _templateFast, _template, values, [result, r1, r2]);
  }
}
