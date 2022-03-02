part of '../../sequence.dart';

class Preceded<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{res}} = {{p2_val}};
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final ParserBuilder<I, dynamic> parser1;

  final ParserBuilder<I, O> parser2;

  const Preceded(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
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
