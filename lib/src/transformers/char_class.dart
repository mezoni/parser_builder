part of '../../transformers.dart';

class CharClass extends _CharClass {
  final String chars;

  const CharClass(this.chars,
      {RangeProcessing processing = RangeProcessing.test})
      : super(negate: false, processing: processing);

  @override
  String getChars() {
    return chars;
  }
}
