part of '../../multi.dart';

class Many1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
var {{list}} = <{{O}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{val1}});
}
state.ok = {{list}}.isNotEmpty;
if (state.ok) {
  {{res0}} = {{list}};
}''';

  static const _templateFast = '''
var {{ok}} = false;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.ok = {{ok}};''';

  final ParserBuilder<I, O> parser;

  const Many1(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['list', 'ok']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'O': '$O',
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
