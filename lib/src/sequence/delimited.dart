part of '../../sequence.dart';

class Delimited<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
final {{ch}} = state.ch;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{p3}}
    if (state.ok) {
      {{res}} = {{p2_val}};
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.ch = {{ch}};
}''';

  final ParserBuilder<I, dynamic> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, dynamic> parser3;

  const Delimited(this.parser1, this.parser2, this.parser3);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['pos', 'ch']);
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
