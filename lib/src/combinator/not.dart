part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, void> {
  static const _template = '''
final {{pos}} = state.pos;
final {{log}} = state.log;
state.log = false;
{{p1}}
state.log = {{log}};
state.ok = !state.ok;
if (!state.ok) {
  state.pos = {{pos}};
  state.fail(state.pos, ParseError.message, {{message}});
}''';

  final String message;

  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser, [this.message = 'Unknown error']);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['log', 'pos']);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, null),
    });
    return render(_template, values, [result]);
  }
}
