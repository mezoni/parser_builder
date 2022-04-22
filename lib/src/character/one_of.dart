part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends ParserBuilder<String, int> {
  final List<int> characters;

  const OneOf(this.characters);

  @override
  String build(Context context, ParserResult? result) {
    final predicate = CharClass.fromList(characters);
    final parser = Satisfy(predicate);
    return parser.build(context, result);
  }
}
