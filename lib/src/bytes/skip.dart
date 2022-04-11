part of '../../bytes.dart';

/// Skips the specified number of characters ([count]) if there are enough
/// characters in the input, and returns the specified [value] (if specified) or
/// `null`.
///
/// Example:
/// ```dart
/// Skip(5, ExprAction.value(true))
/// ```
class Skip<O> extends StringParserBuilder<O> {
  final int count;

  final SemanticAction<O> value;

  const Skip(this.count, this.value);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    if (count < 1) {
      throw StateError('Count must be not less than 1: $count');
    }

    context.refersToStateSource = true;
    final value = this.value.build(context, 'value', []);
    code.setState('state.pos + $count <= source.length');
    code.ifSuccess((code) {
      code + 'state.pos += $count;';
      code.setResult(result, value);
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent ? '' : 'state.error = ErrUnexpected.eof(source.length);';
      code.labelFailure(result);
    });
  }
}
