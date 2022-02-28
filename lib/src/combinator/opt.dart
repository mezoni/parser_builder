part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{res}} = {{p1_val}};
} else {
  state.ok = true;
  {{res}} = null;
}''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
