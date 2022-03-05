part of '../../transformers.dart';

class CharClasses extends _CharClass {
  final List<CharClass> classes;

  const CharClasses(this.classes,
      {RangeProcessing processing = RangeProcessing.test})
      : super(negate: false, processing: processing);

  @override
  String getChars() {
    return classes.map((e) => e.chars).join(' | ');
  }
}
