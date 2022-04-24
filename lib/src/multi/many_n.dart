part of '../../multi.dart';

class ManyN<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while ({{list}}.length < {{n}}) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{val1}});
}
state.ok = {{list}}.length == {{n}};
if (state.ok) {
  {{res0}} = {{list}};
} else {
  state.pos = {{pos}};
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} == {{n}};
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyN(this.n, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    if (n < 1) {
      throw RangeError.value(n, 'n', 'Must be greater than 0');
    }

    final fast = result == null;
    final values = context.allocateLocals(['count', 'list', 'pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'n': '$n',
      'O': '$O',
      'p1': parser.build(context, r1),
    });
    final String template;
    if (fast) {
      template = _templateFast;
    } else {
      template = _template;
    }

    return render(template, values, [result, r1]);
  }
}
