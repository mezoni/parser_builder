part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found, and returns a
/// substring up to the found [tag] if the substring is not empty.
///
/// Example
/// ```dart
/// TakeUntil1('{{')
/// ```
class TakeUntil1 extends StringParserBuilder<String> {
  final String tag;

  const TakeUntil1(this.tag);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final tag = helper.escapeString(this.tag);
    final message = 'Expected at least one character before $tag';
    final verify = ExprAction<bool>(['index'], '{{index}} > state.pos');
    return Recognize(MoveTo(Verify(message, FindTag(this.tag), verify)))
        .build(context, code, result, silent);
  }
}
