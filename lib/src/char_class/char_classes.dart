part of '../../char_class.dart';

class CharClasses extends _CharClass {
  final List<CharClass> classes;

  const CharClasses(this.classes) : super(negate: false);

  @override
  String getChars() {
    return classes.map((e) => e.chars).join(' | ');
  }
}
