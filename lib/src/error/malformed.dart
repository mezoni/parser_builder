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
final {{last}} = state.setLastErrorPos(-1);
state.errorPos = state.pos + 1;
{{var1}}
{{p1}}
state.restoreErrorPos();
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  final pos = state.lastErrorPos;
  if (pos > state.pos) {
    final length = state.pos - pos;
    state.error = ParseError.message(pos, length, {{message}});
  } else {
    state.error = ParseError.expected(state.pos, {{tag}});
  }
}
state.restoreLastErrorPos({{last}});''';

  static const _templateFast = '''
final {{last}} = state.setLastErrorPos(-1);
state.errorPos = state.pos + 1;
{{p1}}
state.restoreErrorPos();
if (!state.ok) {
  final pos = state.lastErrorPos;
  if (pos > state.pos) {
    final length = state.pos - pos;
    state.error = ParseError.message(pos, length, {{message}});
  } else {
    state.error = ParseError.expected(state.pos, {{tag}});
  }
}
}
state.restoreLastErrorPos({{last}});''';

  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Malformed(this.tag, this.message, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['last']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
