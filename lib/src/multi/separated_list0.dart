part of '../../multi.dart';

class SeparatedList0<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
var {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
for (;;) {
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
state.ok = true;
if (state.ok) {
  {{res}} = {{list}};
}
state.opt = {{opt}};''';

  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList0(this.parser, this.separator);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
      'p2': separator,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['list', 'opt', 'pos']);
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
