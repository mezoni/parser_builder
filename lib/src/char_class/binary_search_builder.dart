class BinarySearchBuilder {
  String build(String name, List<int> data, bool negate) {
    if (data.isEmpty) {
      throw ArgumentError.value(data, 'data', 'Must not be empty');
    }

    final ranges = <Range>[];
    for (var i = 0; i < data.length; i += 2) {
      final start = data[i];
      final end = data[i + 1];
      final range = Range(start, end);
      ranges.add(range);
    }

    if (negate) {
      if (ranges.length < 2) {
        final range1 = ranges[0];
        final start1 = range1.start;
        final end1 = range1.end;
        final isSimple1 = start1 == end1;
        if (data.length == 1) {
          if (isSimple1) {
            return '$name != $end1';
          } else {
            return '$name < $start1 || $name > $end1';
          }
        } else if (data.length == 1) {
          final range2 = ranges[1];
          final start2 = range2.start;
          final end2 = range2.end;
          final single2 = start2 == end2;
          if (isSimple1 && single2) {
            return '$name != $end1 || $name != $end2';
          }
        }
      }
    }

    final expression = _plunge(ranges, 0, ranges.length - 1);
    final result = _buildExpression(name, expression);
    if (negate) {
      return '!($result)';
    }

    return result;
  }

  String _buildDouble(String name, less, greater) {
    if (less is Range) {
      final start = less.start;
      final end = less.end;
      final isSimple = start == end;
      final op = isSimple ? '==' : '>=';
      final right = _buildExpression(name, greater);
      final result = '$name <= $end ? $name $op $start : $right';
      return result;
    }

    if (less is List) {
      if (less.length == 2) {
        final element1 = less[0];
        final element2 = less[1];
        if (element1 is Range) {
          final result = _buildDouble(name, element1, [element2, greater]);
          return result;
        } else if (element2 is Range) {
          final result = _buildTriple(name, element1, element2, greater);
          return result;
        }
      }

      if (less.length == 3) {
        final element1 = less[0];
        final element2 = less[1];
        final element3 = less[2];
        if (element2 is Range) {
          final result =
              _buildTriple(name, element1, element2, [element3, greater]);
          return result;
        }
      }
    }

    if (greater is Range) {
      final start = greater.start;
      final end = greater.end;
      final isSimple = start == end;
      final op = isSimple ? '==' : '<=';
      final right = _buildExpression(name, less);
      final result = '$name >= $end ? $name $op $start : $right';
      return result;
    }

    final left = _buildExpression(name, less);
    final right = _buildExpression(name, greater);
    final result = '$right || $left';
    return result;
  }

  String _buildExpression(String name, expression) {
    if (expression is String) {
      return expression;
    }

    if (expression is Range) {
      final result = _buildSingle(name, expression);
      return result;
    }

    if (expression is List) {
      if (expression.length == 2) {
        final less = expression[0];
        final greater = expression[1];
        final result = _buildDouble(name, less, greater);
        return result;
      }

      if (expression.length == 3) {
        final less = expression[0];
        final middle = expression[1];
        final greater = expression[2];
        if (middle is Range) {
          final result = _buildTriple(name, less, middle, greater);
          return result;
        }
      }
    }

    _error(expression);
  }

  String _buildSingle(String name, Range range) {
    final start = range.start;
    final end = range.end;
    final isEqual = start == end;
    if (isEqual) {
      final result = '$name == $end';
      return result;
    } else {
      final result = '$name <= $end && $name >= $start';
      return result;
    }
  }

  String _buildTriple(String name, less, middle, greater) {
    if (middle is Range) {
      final start = middle.start;
      final end = middle.end;
      final op = start == end ? '==' : '>=';
      final tail = '$name $op $start';
      var temp = const [];
      if (less is List) {
        if (less.length == 2) {
          temp = [
            less[0],
            [less[1], tail]
          ];
        } else if (less.length == 3) {
          temp = [
            less[0],
            less[1],
            [less[2], tail]
          ];
        }
      } else if (less is Range) {
        temp = [less, tail];
      }

      if (temp.isNotEmpty) {
        less = temp;
        final left = _buildExpression(name, less);
        final right = _buildExpression(name, greater);
        final result = '$name <= $end ? $left : $right';
        return result;
      }
    }

    _error([less, middle, greater]);
  }

  Never _error(expression) {
    throw StateError('Unable to build expression\nExpression: $expression');
  }

  dynamic _plunge(List<Range> ranges, int min, int max) {
    final mid = min + (max - min) ~/ 2;
    final range = ranges[mid];
    final hasLess = min != mid;
    final hasGreater = min != max;
    if (!hasLess && !hasGreater) {
      return range;
    }

    final less = hasLess ? _plunge(ranges, min, mid - 1) : const <List<int>>[];
    final geeater =
        hasGreater ? _plunge(ranges, mid + 1, max) : const <List<int>>[];
    if (hasGreater) {
      if (hasLess) {
        return [less, range, geeater];
      } else {
        return [range, geeater];
      }
    } else {
      return [less, range];
    }
  }
}

class Range {
  final int end;

  final int start;

  Range(this.start, this.end) {
    if (start < 0) {
      throw ArgumentError.value(
          start, 'start', 'Must be greater then ot equal to 0');
    }

    if (end < start) {
      throw ArgumentError.value(
          end, 'end', 'Must be greater then ot equal to $start');
    }
  }

  @override
  String toString() {
    return '$start..$end';
  }
}
