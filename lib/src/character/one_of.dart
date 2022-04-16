part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends Redirect<String, int> {
  final List<int> characters;

  const OneOf(this.characters);

  @override
  ParserBuilder<String, int> getRedirectParser() {
    final predicate = CharClass.fromList(characters);
    return Satisfy(predicate);
  }
}
