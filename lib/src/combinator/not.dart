part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
final {{pos}} = state.pos;
{{p1}}
state.ok = !state.ok;
if (state.ok) {
  {{res}} = true;
} else {
  state.pos = {{pos}};
  if (!{{opt}}) {
    state.error = ErrUnknown(state.pos);
  }
}
state.opt = {{opt}};''';

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
    return context.allocateLocals(['opt', 'pos']);
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
