part of '../../char_class.dart';

class NotCharClass extends _CharClass {
  final String chars;

  const NotCharClass(this.chars) : super(negate: true);

  @override
  String getChars() {
    return chars;
  }

  static NotCharClass fromList(List<int> chars) {
    return NotCharClass(_CharClass.listToPattern(chars));
  }
}
