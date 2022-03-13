part of '../../bytes.dart';

/// Skips the specified number of characters ([count]) if there are enough
/// characters in the input, and returns the specified [value] (if specified) or
/// `null`.
///
/// Example:
/// ```dart
/// Skip(5, ExprTransformer.value(true))
/// ```
class Skip<O> extends StringParserBuilder<O> {
  static const _template = '''
state.ok = state.pos + {{n}} <= source.length;
if (state.ok) {
  {{transform}}
  state.pos += {{n}};
  {{res}} = {{value}};
} else if (state.log) {
  state.error = ErrUnexpected.eof(source.length);
}''';

  final int count;

  final Transformer<O>? value;

  const Skip(this.count, [this.value]);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['n', 'value']);
    final expr = locals['value']!;
    final t = Transformation(context: context, name: expr, arguments: const []);
    final value = this.value ?? ExprTransformer.value('null');
    return {
      ...locals,
      'n': count.toString(),
      'transform': value.declare(t),
      'value': value.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([count, value]);
  }
}
