part of '../../combinator.dart';

class Map1<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  final v = {{p1_val}};
  {{res}} = {{map}};
}''';

  final Transformer<O> map;

  final ParserBuilder<I, O1> parser;

  const Map1(this.parser, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final t = Transformation(context: context, name: 'map', arguments: ['v']);
    return {
      'transform': map.declare(t),
      'map': map.invoke(t),
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
