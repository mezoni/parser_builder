part of '../../combinator.dart';

class Recognize<I> extends ParserBuilder<I, I> {
  static const _template = '''
final {{start}} = state.pos;
{{p1}}
if (state.ok) {
  {{res}} = state.source.slice({{start}}, state.pos);
}''';

  final ParserBuilder<I, dynamic> parser;

  const Recognize(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['start']);
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
