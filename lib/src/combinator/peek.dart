part of '../../combinator.dart';

class Peek<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
final {{ch}} = state.ch;
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
  state.ch = {{ch}};
  {{res}} = {{p1_res}};
}''';

  final ParserBuilder<I, O> parser;

  const Peek(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['pos', 'ch']);
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
