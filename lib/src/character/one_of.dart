part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends StringParserBuilder<int> {
  final List<int> characters;

  const OneOf(this.characters);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final predicate = CharClass.fromList(characters);
    final parser = Satisfy(predicate);
    parser.build(context, code, result, silent);
  }
}
