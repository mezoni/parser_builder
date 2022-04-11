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
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final tag = helper.escapeString(this.tag, false);
    Recognize(MoveTo(Verify('Expected at least one character before \'$tag\'',
            FindTag(this.tag), ExprAction(['index'], '{{index}} > state.pos'))))
        .build(context, code, result, silent);
  }
}
