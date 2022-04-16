part of '../../bytes.dart';

/// Parses [tag] case-insensitively with the [convert] function and returns
/// [tag].
///
/// Example:
/// ```dart
/// TagNoCase('if')
/// ```
class TagNoCase extends Redirect<String, String> {
  final String tag;

  const TagNoCase(this.tag);

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final tag = helper.escapeString(this.tag);
    final lowerCase = helper.escapeString(this.tag.toLowerCase());
    final error =
        ExprAction<String>([], 'ErrExpected.tag(state.pos, const Tag($tag))');
    final predicate =
        ExprAction<bool>(['v'], '{{v}}.toLowerCase() == $lowerCase');
    return Check(
        Silent(Recognize(Skip(Value(this.tag.length)))), predicate, error);
  }
}
