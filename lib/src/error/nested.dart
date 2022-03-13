part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  static const _template = r'''
{{p1}}
if (state.ok) {
  {{res}} = {{p1_res}};
} else if (state.log) {
  state.error = ErrNested(state.pos, {{message}}, {{tag}}, [state.error]);
}''';

  final String message;

  final ParserBuilder<I, O> parser;

  final String? tag;

  const Nested(this.message, this.tag, this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    var tag = 'null';
    if (this.tag != null) {
      final value = helper.escapeString(this.tag!, false);
      tag = 'const Tag(\'$value\')';
    }

    return {
      'message': helper.escapeString(message),
      'tag': tag,
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
