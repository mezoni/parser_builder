part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
final {{list}} = <{{O}}>[];
for (;;) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{p1_val}});
}
state.ok = true;
if (state.ok) {
  {{res}} = {{list}};
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

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
