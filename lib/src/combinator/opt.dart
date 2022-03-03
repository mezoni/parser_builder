part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
{{p1}}
if (state.ok) {
  {{res}} = {{p1_val}};
} else {
  state.ok = true;
  {{res}} = null;
}
state.opt = {{opt}};''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['opt']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
