part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
{{p1}}
state.log = {{log}};
if (!state.ok) {
  state.ok = true;
}''';

  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['log']);
    values.addAll({
      'p1': parser.build(context, result),
    });
    return render(_template, values);
  }
}
