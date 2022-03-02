part of '../../sequence.dart';

class SeparatedPair<I, O1, O2> extends ParserBuilder<I, _t.Tuple2<O1, O2>> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{p3}}
    if (state.ok) {
      {{res}} = Tuple2({{p1_val}}, {{p3_val}});
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedPair(this.parser1, this.separator, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': separator,
      'p3': parser2,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['pos']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser1, parser2]);
  }
}
