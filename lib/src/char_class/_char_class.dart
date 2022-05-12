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
    final builder = BinarySearchBuilder();
    final argument = arguments.first;
    final list = getCharList();
    final result = builder.build(argument, list, negate);
    return result;
  }

  /*
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
  */

  List<int> getCharList() {
    final chars = getChars();
    final parser = RangesParser();
    final result = parser.parse(chars);
    return result;
  }

  String getChars();

  String _binarySearch(List<int> chars, String name) {
    final low = <int>[];
    final high = <int>[];
    for (var i = 0; i < chars.length; i += 2) {
      low.add(chars[i]);
      high.add(chars[i + 1]);
    }

    String plunge(int min, int max, Set<int> tested) {
      if (min > max) {
        throw ArgumentError.value(
            min, 'min', 'Must be less than or equal to $max');
      }

      String compareUseTested(int start, int end) {
        if (tested.contains(end)) {
          if (start == end) {
            final result = '$name == $start';
            return result;
          } else {
            final result = '$name >= $start';
            return result;
          }
        } else {
          if (start + 1 == end) {
            final result = '($name == $end || $name == $start)';
            return result;
          } else {
            final result = '$name <= $end && $name >= $start';
            return result;
          }
        }
      }

      final mid = min + (max - min) ~/ 2;
      final start = low[mid];
      final end = high[mid];
      var left = '';
      final hasOnLeftSide = min != mid;
      final hasOnRightSide = min != max;
      if (hasOnLeftSide && hasOnRightSide) {
        final x = high[mid - 1];
        tested.add(x);
      }

      if (!hasOnLeftSide) {
        if (start == end) {
          left = '$name == $start';
        } else {
          left = compareUseTested(start, end);
        }
      } else {
        left = plunge(min, mid - 1, tested);
      }

      if (!hasOnRightSide) {
        return left;
      } else {
        final isLastRight = mid + 1 == max;
        final right = plunge(mid + 1, max, tested);
        if (start == end) {
          if (!hasOnLeftSide) {
            if (isLastRight) {
              final rightStart = low[max];
              final rightEnd = high[max];
              final result =
                  '$name < $rightStart ? $name == $start : $name <= $rightEnd';
              return result;
            } else {
              final result = '($name == $start || $right)';
              return result;
            }
          } else {
            final x = high[mid - 1];
            final result = '($name == $start || $name <= $x ? $left : $right)';
            return result;
          }
        } else {
          if (!hasOnLeftSide) {
            if (start + 1 == end) {
              final result = '($name == $end || $name == $start || $right)';
              return result;
            } else {
              if (isLastRight) {
                final rightStart = low[max];
                final rightEnd = high[max];
                final right = compareUseTested(rightStart, rightEnd);
                final result = '$name <= $end ? $name >= $start : $right';
                return result;
              } else {
                final result = '($name <= $end && $name >= $start || $right)';
                return result;
              }
            }
          } else {
            final x = high[mid - 1];
            final result =
                '($name <= $x ? $left : $name <= $end ? $name >= $start : $right)';
            return result;
          }
        }
      }
    }

    var result = plunge(0, low.length - 1, {});
    if (result.startsWith('(')) {
      result = result.substring(1, result.length - 1);
    }

    return result;
  }

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
