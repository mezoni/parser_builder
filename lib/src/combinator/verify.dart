part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
final {{ok}} = state.ok;
if ({{ok}}) {
  {{transform}}
  final v = {{p1_val}};
  state.ok = {{verify}};
}
if (state.ok) {
  {{res}} = {{p1_val}};
} else {
  if ({{ok}}) {
    state.error = ErrMessage({{pos}}, state.pos - {{pos}}, {{message}});
    state.error.failure = state.pos;
    state.pos = {{pos}};
  }
} ''';

  final String message;

  final ParserBuilder<I, O> parser;

  final Transformer<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['ok', 'pos', 'verify']);
    final verify = locals['verify']!;
    final t = Transformation(context: context, name: verify, arguments: ['v']);
    return {
      ...locals,
      'message': helper.escapeString(message),
      'transform': this.verify.declare(t),
      'verify': this.verify.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser, verify]);
  }
}
