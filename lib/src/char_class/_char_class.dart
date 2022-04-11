part of '../../char_class.dart';

abstract class _CharClass extends SemanticAction<bool> {
  final bool negate;

  const _CharClass({required this.negate});

  @override
  bool get isUnicode {
    if (negate) {
      return true;
    }

    final list = getCharList();
    return list.any((e) => e > 0xffff);
  }

  @override
  String build(Context context, String name, List<String> arguments) {
    checkArguments(['c'], arguments, getChars());
    final argument = arguments.first;
    final list = getCharList();
    final tests = <String>[];
    var simple = true;
    for (var i = 0; i < list.length; i += 2) {
      if (list[i] != list[i + 1]) {
        simple = false;
        break;
      }
    }

    if (negate && simple) {
      var count = 0;
      for (var i = 0; i < list.length; i += 2) {
        final start = list[i];
        tests.add('$argument != $start');
        count++;
      }

      var result = tests.join(' && ');
      if (count > 3) {
        final last = list.last;
        result = '$argument > $last || $result';
      }

      return result;
    } else if (negate && list.length == 2) {
      final start = list[0];
      final end = list[1];
      final result = '$argument < $start && $argument > $end';
      return result;
    } else if (negate) {
      var count = 0;
      for (var i = 0; i < list.length; i += 2) {
        final start = list[i];
        final end = list[i + 1];
        if (start == end) {
          tests.add('$argument == $start');
          count++;
        } else {
          tests.add('$argument >= $start && $argument <= $end');
          count += 2;
        }
      }

      var result = tests.join(' || ');
      if (count > 3) {
        final last = list.last;
        result = '$argument > $last || !($result)';
      } else {
        result = '!($result)';
      }

      return result;
    } else {
      var count = 0;
      for (var i = 0; i < list.length; i += 2) {
        final start = list[i];
        final end = list[i + 1];
        if (start == end) {
          tests.add('$argument == $start');
          count++;
        } else {
          tests.add('$argument >= $start && $argument <= $end');
          count += 2;
        }
      }

      var result = tests.join(' || ');
      if (count > 3) {
        final last = list.last;
        result = '$argument <= $last && ($result)';
      }

      return result;
    }
  }

  List<int> getCharList() {
    final chars = getChars();
    final parser = RangesParser();
    final result = parser.parse(chars);
    return result;
  }

  String getChars();

  static String listToPattern(List<int> chars) {
    if (chars.isEmpty) {
      throw ArgumentError('List of chars mus not be empty');
    }

    final list = <String>[];
    for (var i = 0; i < chars.length; i++) {
      final c = chars[i];
      if (!(c >= 0 && c <= 0xd7ff || c >= 0xe000 && c <= 0x10ffff)) {
        throw RangeError.value(c, 'c', 'Must be a valid Unicode code point');
      }

      final hex = c.toRadixString(16);
      final value = '#x$hex';
      list.add(value);
    }

    return list.join(' | ');
  }
}
