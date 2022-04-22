part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, tuple.Tuple2<List<O1>, O2>> {
  static const _template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O1}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (state.ok) {
    {{res0}} = Tuple2({{list}}, {{val1}});
    break;
  }
  final {{error}} = state.error;
  {{var2}}
  {{p2}}
  if (!state.ok) {
    if (state.log) {
      state.error = ErrCombined(state.pos, [{{error}}, state.error]);
    }
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
  final {{error}} = state.error;
  {{p2}}
  if (!state.ok) {
    if (state.log) {
      state.error = ErrCombined(state.pos, [{{error}}, state.error]);
    }
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
    final values = context.allocateLocals(['error', 'list', 'log', 'pos']);
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
