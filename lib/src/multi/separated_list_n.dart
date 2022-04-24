part of '../../multi.dart';

class SeparatedListN<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{pos}} = state.pos;
var {{last}} = {{pos}};
final {{list}} = <{{O}}>[];
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{last}};
    break;
  }
  {{list}}.add({{val1}});
  if ({{list}}.length == {{n}}) {
    break;
  }
  {{last}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = {{list}}.length == {{n}};
if (state.ok) {
  {{res0}} = {{list}};
} else {
  state.pos = {{pos}};
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
var {{last}} = {{pos}};
var {{count}} = 0;
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{last}};
    break;
  }
  {{count}}++;
  if ({{count}} == {{n}}) {
    break;
  }
  {{last}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = {{count}} == {{n}};
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final int n;

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedListN(this.n, this.parser, this.separator);

  @override
  String build(Context context, ParserResult? result) {
    if (n < 1) {
      throw RangeError.value(n, 'n', 'Must be greater than 0');
    }

    final fast = result == null;
    final values = context.allocateLocals(['count', 'last', 'list', 'pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'n': '$n',
      'O': '$O',
      'p1': parser.build(context, r1),
      'p2': separator.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
