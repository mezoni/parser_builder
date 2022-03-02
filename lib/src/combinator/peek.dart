part of '../../combinator.dart';

class Peek<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  state.pos = {{pos}};
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
    return context.allocateLocals(['pos']);
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
