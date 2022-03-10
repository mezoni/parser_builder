part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{log}} = state.log;
var {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
for (;;) {
  state.log = {{list}}.isEmpty;
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{list}}.add({{p1_val}});
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
if ({{list}}.isNotEmpty) {
  state.ok = true;
  {{res}} = {{list}};
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList1(this.parser, this.separator);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
      'p2': separator,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['list', 'log', 'pos']);
    return {
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
