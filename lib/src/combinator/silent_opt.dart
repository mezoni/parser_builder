part of '../../combinator.dart';

class SilentOpt<I, O> extends ParserBuilder<I, O?> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
{{p1}}
if (!state.ok) {
  state.ok = true;
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser;

  const SilentOpt(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['log']);
    values.addAll({
      'p1': parser.build(context, result),
    });
    return render(_template, values);
  }
}
