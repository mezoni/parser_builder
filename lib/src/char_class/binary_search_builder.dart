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
      if (ranges.length == 1) {
        final range1 = ranges[0];
        final start1 = range1.start;
        final end1 = range1.end;
        final isSimple1 = start1 == end1;
        if (ranges.length == 1) {
          if (isSimple1) {
            return '$name != $end1';
          } else {
            return '$name < $start1 || $name > $end1';
          }
        }
      }
    }

    final expression = _plunge(ranges, 0, ranges.length - 1);
    final result = _build(name, expression);
    if (negate) {
      return '!($result)';
    }

    return result;
  }

  String _build(String name, _Ranges ranges) {
    switch (ranges.kind) {
      case _RangesKind.double:
        final double = ranges as _Double;
        final result = _buildDouble(name, double);
        return result;
      case _RangesKind.half:
        final half = ranges as _Half;
        final result = _buildHalf(name, half);
        return result;
      case _RangesKind.single:
        final single = ranges as _Single;
        final result = _buildSingle(name, single);
        return result;
      case _RangesKind.triple:
        final triple = ranges as _Triple;
        final result = _buildTriple(name, triple);
        return result;
    }
  }

  String _buildDouble(String name, _Double double) {
    final less = double.less;
    final greater = double.greater;
    if (less is _Single) {
      final range = less.range;
      final start = range.start;
      final end = range.end;
      final isSimple = start == end;
      final op = isSimple ? '==' : '>=';
      final right = _build(name, greater);
      final result = '$name <= $end ? $name $op $start : $right';
      return result;
    }

    if (less is _Double) {
      final element1 = less.less;
      final element2 = less.greater;
      if (element1 is _Single) {
        final result =
            _buildDouble(name, _Double(element1, _Double(element2, greater)));
        return result;
      } else if (element2 is _Single) {
        final result = _buildTriple(name, _Triple(element1, element2, greater));
        return result;
      }
    }

    if (less is _Triple) {
      final element1 = less.less;
      final element2 = less.middle;
      final element3 = less.greater;
      final result = _buildTriple(
          name, _Triple(element1, element2, _Double(element3, greater)));
      return result;
    }

    if (greater is _Single) {
      final range = greater.range;
      final start = range.start;
      final end = range.end;
      final isSimple = start == end;
      final op = isSimple ? '==' : '<=';
      final right = _build(name, less);
      final result = '$name >= $start ? $name $op $end : $right';
      // TODO Not tested
      return result;
    }

    final left = _build(name, less);
    final right = _build(name, greater);
    final result = '($right) || ($left)';
    // TODO Not tested
    return result;
  }

  String _buildHalf(String name, _Half half) {
    final operator = half.operator;
    final value = half.value;
    final result = '$name $operator $value';
    return result;
  }

  String _buildSingle(String name, _Single single) {
    final range = single.range;
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

  String _buildTriple(String name, _Triple triple) {
    var less = triple.less;
    final middle = triple.middle;
    var greater = triple.greater;
    final range = middle.range;
    final start = range.start;
    final end = range.end;
    final operator = start == end ? '==' : '>=';
    final tail = _Half(start, operator);
    if (less is _Single) {
      less = _Double(less, tail);
    } else if (less is _Double) {
      less = _Double(less.less, _Double(less.greater, tail));
    } else if (less is _Triple) {
      less = _Triple(less.less, less.middle, _Double(less.greater, tail));
    } else {
      _error(triple);
    }

    final left = _build(name, less);
    final right = _build(name, greater);
    final result = '$name <= $end ? $left : $right';
    return result;
  }

  Never _error(_Ranges expression) {
    throw StateError('Unable to build expression\nExpression: $expression');
  }

  _Ranges _plunge(List<Range> ranges, int min, int max) {
    final mid = min + (max - min) ~/ 2;
    final range = ranges[mid];
    final hasLess = min != mid;
    final hasGreater = min != max;
    final single = _Single(range);
    if (!hasLess && !hasGreater) {
      return single;
    }

    if (hasLess) {
      final less = _plunge(ranges, min, mid - 1);
      if (hasGreater) {
        final greater = _plunge(ranges, mid + 1, max);
        return _Triple(less, single, greater);
      } else {
        return _Double(less, single);
      }
    } else {
      final greater = _plunge(ranges, mid + 1, max);
      return _Double(single, greater);
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

class _Double implements _Ranges {
  @override
  final _RangesKind kind = _RangesKind.double;

  final _Ranges greater;

  final _Ranges less;

  _Double(this.less, this.greater) {
    if (less.max >= greater.min) {
      throw ArgumentError('Lest mus be less than greater');
    }
  }

  @override
  int get max => greater.max;

  @override
  int get min => less.min;
}

class _Half implements _Ranges {
  @override
  final _RangesKind kind = _RangesKind.half;

  String operator;

  int value;

  _Half(this.value, this.operator);

  @override
  int get max => value;

  @override
  int get min => value;
}

abstract class _Ranges {
  _RangesKind get kind;

  int get max;

  int get min;
}

enum _RangesKind { double, half, single, triple }

class _Single implements _Ranges {
  @override
  final _RangesKind kind = _RangesKind.single;

  final Range range;

  _Single(this.range);

  @override
  int get max => range.end;

  @override
  int get min => range.start;
}

class _Triple implements _Ranges {
  @override
  final _RangesKind kind = _RangesKind.triple;

  final _Ranges greater;

  final _Ranges less;

  final _Single middle;

  _Triple(this.less, this.middle, this.greater) {
    if (less.max >= middle.range.start) {
      throw ArgumentError('Lest mus be less than middle');
    }

    if (middle.range.end >= greater.min) {
      throw ArgumentError('Middle mus be less than greater');
    }
  }

  @override
  int get max => greater.max;

  @override
  int get min => less.min;
}
