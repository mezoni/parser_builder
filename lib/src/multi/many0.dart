part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{list}} = <{{O}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{val1}});
}
state.ok = true;
if (state.ok) {
  {{res0}} = {{list}};
}''';

  static const _templateFast = '''
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
}
state.ok = true;''';

  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['list']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'O': '$O',
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
