part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found and returns a
/// substring up to the found [tag].
///
/// Example
/// ```dart
/// TakeUntil('{{')
/// ```
class TakeUntil extends Redirect<String, String> {
  final String tag;

  const TakeUntil(this.tag);

  @override
  ParserBuilder<String, String> getRedirectParser() {
    return Recognize(Fast(MoveTo(FindTag(tag))));
  }
}
