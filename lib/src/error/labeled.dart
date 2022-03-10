part of '../../error.dart';

class Labeled<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{res}} = {{p1_res}};
} else if (state.log) {
  state.error = ErrExpected.tag(state.pos, const Tag({{label}}));
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Labeled(this.tag, this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {'p1': parser};
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'tag': helper.escapeString(tag),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([tag, parser]);
  }
}
