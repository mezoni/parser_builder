part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (!state.ok) {
  state.ok = true;
  {{res}} = true;
} else {
  state.pos = {{pos}};
  state.ok = false;
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
    return context.allocateLocals(['pos']);
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
