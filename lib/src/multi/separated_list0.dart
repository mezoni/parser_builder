part of '../../multi.dart';

class SeparatedList0<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
var {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
final {{log}} = state.log;
state.log = false;
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
state.log = {{log}};
state.ok = true;
if (state.ok) {
  {{res0}} = {{list}};
}''';

  static const _templateFast = '''
var {{pos}} = state.pos;
final {{log}} = state.log;
state.log = false;
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.log = {{log}};
state.ok = true;''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList0(this.parser, this.separator);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['list', 'log', 'pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'O': '$O',
      'p1': parser.build(context, r1),
      'p2': separator.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
