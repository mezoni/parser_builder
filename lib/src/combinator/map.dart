part of '../../combinator.dart';

class Map$<I, O1, O2> extends ParserBuilder<I, O2> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  {{res}} = map({{p1_val}});
}''';

  final ParserBuilder<I, O1> parser;

  final Transformer<O1, O2> transformer;

  const Map$(this.parser, this.transformer);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': transformer.transform('map'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser, transformer]);
  }
}
