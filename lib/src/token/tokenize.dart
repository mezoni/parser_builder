part of '../../token.dart';

class Tokenize<O> extends StringParserBuilder<O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{transform}}
  final v1 = state.source.slice({{pos}}, state.pos);
  final v2 = Tuple4({{pos}}, state.pos, v1, {{p1_val}});
  {{res}} = {{map}};
}''';

  final ParserBuilder<String, dynamic> parser;

  final Transformer<Tuple3<int, int, String>, O> transformer;

  const Tokenize(this.parser, this.transformer);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos']);
    return {
      ...locals,
      ...helper.tfToTemplateValues(transformer, key: 'map', value: 'v2'),
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
