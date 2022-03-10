part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
final {{pos}} = state.pos;
{{p1}}
state.ok = !state.ok;
if (state.ok) {
  {{res}} = true;
} else {
  state.pos = {{pos}};
  if ({{log}}) {
    state.error = ErrUnknown(state.pos);
  }
}
state.log = {{log}};''';

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
    return context.allocateLocals(['log', 'pos']);
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
