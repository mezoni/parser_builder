part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
var {{pos}} = state.pos;
var {{ch}} = state.ch;
final {{list}} = <{{O}}>[];
for (;;) {
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    state.ch = {{ch}};
    break;
  }
  {{list}}.add({{p1_val}});
  {{pos}} = state.pos;
  {{ch}} = state.ch;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
if ({{list}}.isNotEmpty) {
  state.ok = true;
  {{res}} = {{list}};
}''';

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
    final locals = context.allocateLocals(['pos', 'ch', 'list']);
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
