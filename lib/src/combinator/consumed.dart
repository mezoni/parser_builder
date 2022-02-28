part of '../../combinator.dart';

class Consumed<I, O> extends ParserBuilder<I, _t.Tuple2<I, O>> {
  static const _template = '''
final {{start}} = state.pos;
{{p1}}
if (state.ok) {
  final v = state.source.slice({{start}}, state.pos);
  {{res}} = Tuple2(v, {{p1_val}});
}''';

  final ParserBuilder<I, O> parser;

  const Consumed(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['start']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
