part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
var {{count}} = 0;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} != 0;
if (state.ok) {
  {{res0}} = {{count}};
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

  final ParserBuilder<I, dynamic> parser;

  const Many1Count(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['count']);
    values.addAll({
      'p1': parser.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
