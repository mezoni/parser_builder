part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs at the start position, then an `Expected(tag)`
/// error is generated instead of these errors.
///
/// If a parsing errors occurs at the next positions, then an
/// `Message(message)` error is generated and all other errors are generated as well.
class Malformed<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{minErrorPos}} = state.minErrorPos;
final {{newErrorPos}} = state.newErrorPos;
state.minErrorPos = state.pos + 1;
state.newErrorPos = -1;
{{var1}}
{{p1}}
state.minErrorPos = {{minErrorPos}};
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  if (state.newErrorPos > state.pos) {
    final length = state.pos - state.newErrorPos;
    state.error = ParseError.message(state.newErrorPos, length, {{message}});
  } else {
    state.error = ParseError.expected(state.pos, {{tag}});
  }
}
state.newErrorPos = {{newErrorPos}} > state.newErrorPos ? {{newErrorPos}} : state.newErrorPos;''';

  static const _templateFast = '''
final {{minErrorPos}} = state.minErrorPos;
final {{newErrorPos}} = state.newErrorPos;
state.minErrorPos = state.pos + 1;
state.newErrorPos = -1;
{{p1}}
state.minErrorPos = {{minErrorPos}};
if (!state.ok) {
  if (state.newErrorPos > state.pos) {
    final length = state.pos - state.newErrorPos;
    state.error = ParseError.message(state.newErrorPos, length, {{message}});
  } else {
    state.error = ParseError.expected(state.pos, {{tag}});
  }
}
state.newErrorPos = {{newErrorPos}} > state.newErrorPos ? {{newErrorPos}} : state.newErrorPos;''';

  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Malformed(this.tag, this.message, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['minErrorPos', 'newErrorPos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
