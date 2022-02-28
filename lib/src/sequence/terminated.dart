part of '../../sequence.dart';

class Terminated<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
final {{ch}} = state.ch;
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    {{res}} = {{p1_val}};
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.ch = {{ch}};
}''';

  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, dynamic> parser2;

  const Terminated(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
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
