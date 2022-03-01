part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{pos}} = state.pos;
final {{ch}} = state.ch;
{{p1}}
state.ok = !state.ok;
if (state.ok) {
  {{res}} = true;
} else {
  state.pos = {{pos}};
  state.ch = {{ch}};
  state.error = ErrUnknown(state.pos);
}''';

  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
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
    return printName([parser]);
  }
}
