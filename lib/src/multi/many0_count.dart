part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
var {{count}} = 0;
final {{log}} = state.log;
state.log = false;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.log = {{log}};
state.ok = true;
if (state.ok) {
  {{res0}} = {{count}};
}''';

  static const _templateFast = '''
final {{log}} = state.log;
state.log = false;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
}
state.log = {{log}};
state.ok = true;''';

  final ParserBuilder<I, dynamic> parser;

  const Many0Count(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['count', 'log']);
    values.addAll({
      'p1': parser.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
