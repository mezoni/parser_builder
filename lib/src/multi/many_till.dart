part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, Result2<List<O1>, O2>> {
  static const _template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O1}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (state.ok) {
    {{res0}} = Result2({{list}}, {{val1}});
    break;
  }
  {{var2}}
  {{p2}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{list}}.add({{val2}});
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
while (true) {
  {{p1}}
  if (state.ok) {
    break;
  }
  {{p2}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
}''';

  final ParserBuilder<I, O2> end;

  final ParserBuilder<I, O1> parser;

  const ManyTill(this.parser, this.end);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    ParseRuntime.addClassResult(context, 2, !fast);
    final values = context.allocateLocals(['list', 'pos']);
    final r1 = context.getResult(end, !fast);
    final r2 = context.getResult(parser, !fast);
    values.addAll({
      'O1': '$O1',
      'p1': end.build(context, r1),
      'p2': parser.build(context, r2),
    });
    return render2(fast, _templateFast, _template, values, [result, r1, r2]);
  }
}
