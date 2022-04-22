part of '../../combinator.dart';

class Map1<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  {{res0}} = {{map}};
}''';

  static const _templateFast = '''
{{p1}}''';

  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser;

  const Map1(this.parser, this.map);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final r1 = context.getResult(parser, !fast);
    final values = {
      'map': fast ? '' : map.build(context, 'map', ['v']),
      'p1': parser.build(context, r1),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
