part of '../../transformers.dart';

class NotCharClass extends TX<int, bool> {
  final String chars;

  const NotCharClass(this.chars) : super('c');

  @override
  String getCode() {
    final parser = RangesParser();
    final list = parser.parse(chars);
    String toHex(int value) {
      return '0x${value.toRadixString(16).toUpperCase()}';
    }

    final tests = <String>[];
    for (var i = 0; i < list.length; i += 2) {
      final start = list[i];
      final end = list[i + 1];
      if (start == end) {
        tests.add('$parameter == ${toHex(start)}');
      } else {
        tests.add(
            '$parameter >= ${toHex(start)} && $parameter <= ${toHex(end)}');
      }
    }

    var result = tests.join(' || ');
    return '=> !($result);';
  }
}
