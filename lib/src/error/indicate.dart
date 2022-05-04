part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs, then an `Message(message)` error is generated
/// and all other errors are generated as well.
@experimental
class Indicate<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{last}} = state.setLastErrorPos(-1);
{{var1}}
{{p1}}
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  final pos = state.lastErrorPos;
  final length = state.pos - pos;
  state.fail(pos, ParseError.message(length, {{message}}));
}
state.restoreLastErrorPos({{last}});''';

  static const _templateFast = '''
final {{last}} = state.setLastErrorPos(-1);
{{p1}}
if (!state.ok) {
  final pos = state.lastErrorPos;
  final length = state.pos - pos;
  state.fail(pos, ParseError.message(length, {{message}}));
}
state.restoreLastErrorPos({{last}});''';

  final String message;

  final ParserBuilder<I, O> parser;

  const Indicate(this.message, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['last']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
