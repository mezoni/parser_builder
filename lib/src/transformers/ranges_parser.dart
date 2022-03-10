part of '../../transformers.dart';

class RangesParser {
  List<int> parse(String chars) {
    final ranges = _char_class_parser.parseString(chars);
    String rangeToString(int start, int end) {
      return '[#x${start.toRadixString(16)}-#x${end.toRadixString(16)}]';
    }

    for (final range in ranges) {
      final start = range.item1;
      final end = range.item2;
      if (start > end) {
        throw StateError('Invalid range ${rangeToString(start, end)}: $chars');
      }
    }

    ranges.sort((x, y) => x.item1.compareTo(y.item2));
    final first = ranges[0];
    final list = [first.item1, first.item2];
    var prevStart = list[0];
    var prevEnd = list[1];
    for (var i = 1; i < ranges.length; i++) {
      final range = ranges[i];
      final start = range.item1;
      final end = range.item2;
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
