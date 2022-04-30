part of '../../multi.dart';

class ManyMN<I, O> extends ParserBuilder<I, List<O>> {
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
state.ok = {{list}}.length >= {{m}};
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
state.ok = {{count}} >= {{m}};
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final int m;

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyMN(this.m, this.n, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    if (m < 0) {
      throw RangeError.value(m, 'm', 'Must be equal to or greater than 0');
    }

    if (n < m) {
      throw RangeError.value(
          n, 'n', 'Must be equal to or greater than \'m\' ($m)');
    }

    if (n == 0) {
      throw RangeError.value(n, 'n', 'Must be greater than 0');
    }

    final fast = result == null;
    final values = context.allocateLocals(['count', 'list', 'pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'm': '$m',
      'n': '$n',
      'O': '$O',
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
