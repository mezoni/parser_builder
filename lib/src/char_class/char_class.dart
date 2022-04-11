part of '../../char_class.dart';

class CharClass extends _CharClass {
  final String chars;

  const CharClass(this.chars) : super(negate: false);

  @override
  String getChars() {
    return chars;
  }

  static CharClass fromList(List<int> chars) {
    return CharClass(_CharClass.listToPattern(chars));
  }
}
