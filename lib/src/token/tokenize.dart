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

  final Transformer<O> map;

  final ParserBuilder<String, dynamic> parser;

  const Tokenize(this.parser, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos']);
    final t = Transformation(context: context, name: 'map', arguments: ['v2']);
    return {
      ...locals,
      'transform': map.declare(t),
      'cond': map.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser, map]);
  }
}
