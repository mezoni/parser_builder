part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found and returns a
/// substring up to the found [tag].
///
/// Example
/// ```dart
/// TakeUntil('{{')
/// ```
class TakeUntil extends StringParserBuilder<String> {
  final String tag;

  const TakeUntil(this.tag);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    Recognize(MoveTo(FindTag(tag))).build(context, code, result, silent);
  }
}
