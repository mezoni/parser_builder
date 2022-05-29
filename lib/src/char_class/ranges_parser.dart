part of '../../char_class.dart';

class RangesParser {
  List<int> parse(String chars) {
    final ranges = char_class_parser.parseString(chars);
    String rangeToString(int start, int end) {
      return '[#x${start.toRadixString(16)}-#x${end.toRadixString(16)}]';
    }

    for (final range in ranges) {
      final start = range.$0;
      final end = range.$1;
      if (start > end) {
        throw StateError('Invalid range ${rangeToString(start, end)}: $chars');
      }
    }

    ranges.sort((x, y) => x.$0.compareTo(y.$1));
    final first = ranges[0];
    final list = [first.$0, first.$1];
    var prevStart = list[0];
    var prevEnd = list[1];
    for (var i = 1; i < ranges.length; i++) {
      final range = ranges[i];
      final start = range.$0;
      final end = range.$1;
      if (start >= prevStart && start <= prevEnd) {
        if (end > prevEnd) {
          list.last = end;
        }
      } else if (start == prevEnd + 1) {
        if (end > prevEnd) {
          list.last = end;
        }
      } else {
        list.add(start);
        list.add(end);
      }

      prevStart = list[list.length - 2];
      prevEnd = list.last;
    }

    return list;
  }
}
