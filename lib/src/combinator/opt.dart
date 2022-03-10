part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
{{p1}}
if (state.ok) {
  {{res}} = {{p1_val}};
} else {
  state.ok = true;
  {{res}} = null;
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['log']);
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
