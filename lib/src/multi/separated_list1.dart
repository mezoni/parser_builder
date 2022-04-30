part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
var {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{list}}.add({{val1}});
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = {{list}}.isNotEmpty;
if (state.ok) {
  {{res0}} = {{list}};
}''';

  static const _templateFast = '''
var {{pos}} = state.pos;
var {{ok}} = false;
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{ok}} = true;
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = {{ok}};''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList1(this.parser, this.separator);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['list', 'ok', 'pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'O': '$O',
      'p1': parser.build(context, r1),
      'p2': separator.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
