part of '../../combinator.dart';

class Value<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{res}} = {{v}};
}''';

  static const _templateNoParser = '''
state.ok = true;
if (state.ok) {
  {{res}} = {{v}};
}''';

  final ParserBuilder<I, dynamic>? parser;

  final O value;

  const Value(this.value, [this.parser]);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      if (parser != null) 'p1': parser!,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'v': helper.getAsCode(value),
    };
  }

  @override
  String getTemplate(Context context) {
    if (parser != null) {
      return _template;
    }

    return _templateNoParser;
  }

  @override
  String toString() {
    return printName([value, if (parser != null) parser]);
  }
}
