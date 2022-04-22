part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// NoneOf([0x22, 0x27])
/// ```
class NoneOf extends ParserBuilder<String, int> {
  final List<int> characters;

  const NoneOf(this.characters);

  @override
  String build(Context context, ParserResult? result) {
    final predicate = NotCharClass.fromList(characters);
    final parser = Satisfy(predicate);
    return parser.build(context, result);
  }
}
