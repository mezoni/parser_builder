part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// NoneOf([0x22, 0x27])
/// ```
class NoneOf extends StringParserBuilder<int> {
  final List<int> characters;

  const NoneOf(this.characters);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final predicate = NotCharClass.fromList(characters);
    final parser = Satisfy(predicate);
    parser.build(context, code, result, silent);
  }
}
