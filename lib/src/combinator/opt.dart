part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
{{p1}}
if (!state.ok) {
  state.ok = true;
}''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = {
      'p1': parser.build(context, result),
    };
    return render(_template, values);
  }
}
