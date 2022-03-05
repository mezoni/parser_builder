part of '../../multi.dart';

class ManyMN<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{opt}} = state.opt;
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
var {{cnt}} = 0;
while ({{cnt}} < {{n}}) {
  state.opt = {{cnt}} > {{m}};
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{p1_val}});
  {{cnt}}++;
}
state.ok = {{cnt}} >= {{m}};
if (state.ok) {
  {{res}} = {{list}};
} else {
  state.pos = {{pos}};
}
state.opt = {{opt}};''';

  final int m;

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyMN(this.m, this.n, this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
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

    final locals = context.allocateLocals(['cnt', 'list', 'opt', 'pos']);
    return {
      'm': m.toString(),
      'n': n.toString(),
      'O': O.toString(),
      ...locals,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
