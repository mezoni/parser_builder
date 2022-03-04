part of '../../multi.dart';

class Many1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{opt}} = state.opt;
final {{list}} = <{{O}}>[];
for (;;) {
  state.opt = {{list}}.isNotEmpty;
  {{p1}}
  if (!state.ok) {
    if ({{list}}.isNotEmpty) {
      state.ok = true;
      {{res}} = {{list}};
    }
    break;
  }
  {{list}}.add({{p1_val}});
}
state.opt = {{opt}};''';

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
    final locals = context.allocateLocals(['list', 'opt']);
    return {
      'O': O.toString(),
    }..addAll(locals);
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
