part of '../../char_class.dart';

class CharClasses extends _CharClass implements CharClass {
  final List<CharClass> classes;

  const CharClasses(this.classes) : super(negate: false);

  @override
  String get chars => getChars();

  @override
  String getChars() {
    return classes.map((e) => e.chars).join(' | ');
  }
}
