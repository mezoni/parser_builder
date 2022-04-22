part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  state.ok = {{verify}};
  if (state.ok) {
    {{res0}} = v;
  } else {
    if (state.log) {
      state.error = ErrMessage({{pos}}, state.pos - {{pos}}, {{message}});
    }
    state.pos = {{pos}};
  }
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  state.ok = {{verify}};
  if (!state.ok) {
    if (state.log) {
      state.error = ErrMessage({{pos}}, state.pos - {{pos}}, {{message}});
    }
    state.pos = {{pos}};
  }
}''';

  final String message;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, true);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, r1),
      'verify': verify.build(context, 'verify', ['v']),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
