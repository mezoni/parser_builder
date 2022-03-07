part of '../../combinator.dart';

class Map$<I, O1, O2> extends ParserBuilder<I, O2> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{transform}}
  final v = {{p1_val}};
  {{res}} = {{map}};
}''';

  final Transformer<O1, O2> map;

  final ParserBuilder<I, O1> parser;

  const Map$(this.parser, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'map': map.invoke(context, 'map', 'v'),
      'transform': map.declare(context, 'map'),
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
