part of '../../error.dart';

class Malformed<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{res}} = {{p1_res}};
} else if (!state.opt) {
  state.error = ErrMalformed(state.pos, const Tag({{tag}}), [state.error]);
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Malformed(this.tag, this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
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
