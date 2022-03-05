part of '../../transformers.dart';

class NotCharClass extends _CharClass {
  final String chars;

  const NotCharClass(this.chars,
      {RangeProcessing processing = RangeProcessing.test})
      : super(negate: true, processing: processing);

  @override
  String getChars() {
    return chars;
  }
}
