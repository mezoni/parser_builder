part of '../../character.dart';

/// Parses any single character and returns that character.
///
/// Example:
/// ```dart
/// AnyChar()
/// ```
class AnyChar extends ParserBuilder<String, int> {
  static const _template = '''
if (state.pos < source.length) {
  state.ok = true;
  {{res0}} = source.readRune(state);
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateFast = '''
if (state.pos < source.length) {
  state.ok = true;
  source.readRune(state);
} else {
  state.fail(state.pos, ParseError.character);
}''';

  const AnyChar();

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = <String, String>{};
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
