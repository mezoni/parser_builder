part of '../../multi.dart';

class Many1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{log}} = state.log;
final {{list}} = <{{O}}>[];
for (;;) {
  state.log = {{list}}.isEmpty;
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{p1_val}});
}
if ({{list}}.isNotEmpty) {
  state.ok = true;
  {{res}} = {{list}};
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser;

  const Many1(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['list', 'log']);
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
