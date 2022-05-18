part of '../../parser_builder.dart';

class ParseRuntime {
  static const _classMemoizedResult =
      '''
class MemoizedResult<T> {
  final int end;

  final bool fast;

  final int id;

  final bool ok;

  final T? result;

  final int start;

  MemoizedResult(
      this.id, this.fast, this.start, this.end, this.ok, this.result);

  @pragma('vm:prefer-inline')
  T? restore(State state) {
    state.ok = ok;
    state.pos = end;
    return result;
  }
}''';

  static const _classParseError =
      '''
class ParseError {
  static const character = 0;

  static const expected = 1;

  static const message = 2;

  static const unexpected = 3;

  final int end;

  final int start;

  final String text;

  ParseError(this.start, this.end, this.text);

  @override
  int get hashCode => end.hashCode ^ start.hashCode ^ text.hashCode;

  @override
  bool operator ==(other) =>
      other is ParseError &&
      other.end == end &&
      other.start == start &&
      other.text == text;

  @override
  String toString() {
    return text;
  }
}''';

  static const _classResult2 =
      r'''
class Result2<T0, T1> {
  final T0 $0;
  final T1 $1;

  Result2(this.$0, this.$1);

  @override
  int get hashCode => $0.hashCode ^ $1.hashCode;

  @override
  bool operator ==(other) =>
      other is Result2 && other.$0 == $0 && other.$1 == $1;
}''';

  static const _classResult3 =
      r'''
class Result3<T0, T1, T2> {
  final T0 $0;
  final T1 $1;
  final T2 $2;

  Result3(this.$0, this.$1, this.$2);

  @override
  int get hashCode => $0.hashCode ^ $1.hashCode ^ $2.hashCode;

  @override
  bool operator ==(other) =>
      other is Result3 && other.$0 == $0 && other.$1 == $1 && other.$2 == $2;
}''';

  static const _classResult4 =
      r'''
class Result4<T0, T1, T2, T3> {
  final T0 $0;
  final T1 $1;
  final T2 $2;
  final T3 $3;

  Result4(this.$0, this.$1, this.$2, this.$3);

  @override
  int get hashCode => $0.hashCode ^ $1.hashCode ^ $2.hashCode ^ $3.hashCode;

  @override
  bool operator ==(other) =>
      other is Result4 &&
      other.$0 == $0 &&
      other.$1 == $1 &&
      other.$2 == $2 &&
      other.$3 == $3;
}''';

  static const _classResult5 =
      r'''
class Result5<T0, T1, T2, T3, T4> {
  final T0 $0;
  final T1 $1;
  final T2 $2;
  final T3 $3;
  final T4 $4;

  Result5(this.$0, this.$1, this.$2, this.$3, this.$4);

  @override
  int get hashCode =>
      $0.hashCode ^ $1.hashCode ^ $2.hashCode ^ $3.hashCode ^ $4.hashCode;

  @override
  bool operator ==(other) =>
      other is Result5 &&
      other.$0 == $0 &&
      other.$1 == $1 &&
      other.$2 == $2 &&
      other.$3 == $3 &&
      other.$4 == $4;
}''';

  static const _classResult6 =
      r'''
class Result6<T0, T1, T2, T3, T4, T5> {
  final T0 $0;
  final T1 $1;
  final T2 $2;
  final T3 $3;
  final T4 $4;
  final T5 $5;

  Result6(this.$0, this.$1, this.$2, this.$3, this.$4, this.$5);

  @override
  int get hashCode =>
      $0.hashCode ^
      $1.hashCode ^
      $2.hashCode ^
      $3.hashCode ^
      $4.hashCode ^
      $5.hashCode;

  @override
  bool operator ==(other) =>
      other is Result6 &&
      other.$0 == $0 &&
      other.$1 == $1 &&
      other.$2 == $2 &&
      other.$3 == $3 &&
      other.$4 == $4 &&
      other.$5 == $5;
}''';

  static const _classResult7 =
      r'''
class Result7<T0, T1, T2, T3, T4, T5, T6> {
  final T0 $0;
  final T1 $1;
  final T2 $2;
  final T3 $3;
  final T4 $4;
  final T5 $5;
  final T6 $6;

  Result7(this.$0, this.$1, this.$2, this.$3, this.$4, this.$5, this.$6);

  @override
  int get hashCode =>
      $0.hashCode ^
      $1.hashCode ^
      $2.hashCode ^
      $3.hashCode ^
      $4.hashCode ^
      $5.hashCode ^
      $6.hashCode;

  @override
  bool operator ==(other) =>
      other is Result7 &&
      other.$0 == $0 &&
      other.$1 == $1 &&
      other.$2 == $2 &&
      other.$3 == $3 &&
      other.$4 == $4 &&
      other.$5 == $5 &&
      other.$6 == $6;
}''';

  static const _classState =
      r'''
class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  final List<int> _lengths = List.filled(150, 0);

  final List<MemoizedResult?> _memos = List.filled(150, null);

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, int length, Object? value, [int start = -1]) {
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

        _kinds[_length] = kind;
        _lengths[_length] = length;
        _starts[_length] = start;
        _values[_length] = value;
        _length++;
      }

      if (lastErrorPos < pos) {
        lastErrorPos = pos;
      }
    }
  }

  @pragma('vm:prefer-inline')
  void memoize<R>(int id, bool fast, int start, [R? result]) =>
      _memos[id] = MemoizedResult<R>(id, fast, start, pos, ok, result);

  @pragma('vm:prefer-inline')
  MemoizedResult<R>? memoized<R>(int id, bool fast, int start) {
    final memo = _memos[id];
    return (memo != null &&
            memo.start == start &&
            (memo.fast == fast || !memo.fast))
        ? memo as MemoizedResult<R>
        : null;
  }

  @pragma('vm:prefer-inline')
  void restoreLastErrorPos(int pos) {
    if (lastErrorPos < pos) {
      lastErrorPos = pos;
    }
  }

  @pragma('vm:prefer-inline')
  int setLastErrorPos(int pos) {
    final result = lastErrorPos;
    lastErrorPos = pos;
    return result;
  }

  @override
  String toString() {
    if (source is String) {
      final s = source as String;
      if (pos >= s.length) {
        return '$pos:';
      }

      var length = s.length - pos;
      length = length > 40 ? 40 : length;
      final string = s.substring(pos, pos + length);
      return '$pos:$string';
    } else {
      return super.toString();
    }
  }

  List<ParseError> _buildErrors() {
    final result = <ParseError>[];
    final expected = <String>[];
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        final value = _values[i];
        final escaped = _escape(value);
        expected.add(escaped);
      }
    }

    if (expected.isNotEmpty) {
      final text = 'Expected: ${expected.toSet().join(', ')}';
      final error = ParseError(errorPos, errorPos, text);
      result.add(error);
    }

    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      final length = _lengths[i];
      var value = _values[i];
      var start = _starts[i];
      if (start < 0) {
        start = errorPos;
      }

      final end = start + length;
      switch (kind) {
        case ParseError.character:
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              value = string.runeAt(errorPos);
              final escaped = _escape(value);
              final error =
                  ParseError(errorPos, errorPos, 'Unexpected $escaped');
              result.add(error);
            } else {
              final error = ParseError(errorPos, errorPos, "Unexpected 'EOF'");
              result.add(error);
            }
          } else {
            final error =
                ParseError(errorPos, errorPos, 'Unexpected character');
            result.add(error);
          }

          break;
        case ParseError.expected:
          break;
        case ParseError.message:
          final error = ParseError(start, end, '$value');
          result.add(error);
          break;
        case ParseError.unexpected:
          final escaped = _escape(value);
          final error = ParseError(start, end, 'Unexpected $escaped');
          result.add(error);
          break;
        default:
          final error = ParseError(start, end, '$value');
          result.add(error);
      }
    }

    return result.toSet().toList();
  }

  String _escape(Object? value, [bool quote = true]) {
    if (value is int) {
      if (value >= 0 && value <= 0xd7ff ||
          value >= 0xe000 && value <= 0x10ffff) {
        value = String.fromCharCode(value);
      } else {
        return value.toString();
      }
    } else if (value is! String) {
      return value.toString();
    }

    final map = {
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\r',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    if (quote) {
      result = "'$result'";
    }

    return result;
  }
}''';

  static const _classStateNoMemo =
      r'''
class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  final List<int> _lengths = List.filled(150, 0);

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, int length, Object? value, [int start = -1]) {
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

        _kinds[_length] = kind;
        _lengths[_length] = length;
        _starts[_length] = start;
        _values[_length] = value;
        _length++;
      }

      if (lastErrorPos < pos) {
        lastErrorPos = pos;
      }
    }
  }

  @pragma('vm:prefer-inline')
  void restoreLastErrorPos(int pos) {
    if (lastErrorPos < pos) {
      lastErrorPos = pos;
    }
  }

  @pragma('vm:prefer-inline')
  int setLastErrorPos(int pos) {
    final result = lastErrorPos;
    lastErrorPos = pos;
    return result;
  }

  @override
  String toString() {
    if (source is String) {
      final s = source as String;
      if (pos >= s.length) {
        return '$pos:';
      }

      var length = s.length - pos;
      length = length > 40 ? 40 : length;
      final string = s.substring(pos, pos + length);
      return '$pos:$string';
    } else {
      return super.toString();
    }
  }

  List<ParseError> _buildErrors() {
    final result = <ParseError>[];
    final expected = <String>[];
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        final value = _values[i];
        final escaped = _escape(value);
        expected.add(escaped);
      }
    }

    if (expected.isNotEmpty) {
      final text = 'Expected: ${expected.toSet().join(', ')}';
      final error = ParseError(errorPos, errorPos, text);
      result.add(error);
    }

    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      final length = _lengths[i];
      var value = _values[i];
      var start = _starts[i];
      if (start < 0) {
        start = errorPos;
      }

      final end = start + length;
      switch (kind) {
        case ParseError.character:
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              value = string.runeAt(errorPos);
              final escaped = _escape(value);
              final error =
                  ParseError(errorPos, errorPos, 'Unexpected $escaped');
              result.add(error);
            } else {
              final error = ParseError(errorPos, errorPos, "Unexpected 'EOF'");
              result.add(error);
            }
          } else {
            final error =
                ParseError(errorPos, errorPos, 'Unexpected character');
            result.add(error);
          }

          break;
        case ParseError.expected:
          break;
        case ParseError.message:
          final error = ParseError(start, end, '$value');
          result.add(error);
          break;
        case ParseError.unexpected:
          final escaped = _escape(value);
          final error = ParseError(start, end, 'Unexpected $escaped');
          result.add(error);
          break;
        default:
          final error = ParseError(start, end, '$value');
          result.add(error);
      }
    }

    return result.toSet().toList();
  }

  String _escape(Object? value, [bool quote = true]) {
    if (value is int) {
      if (value >= 0 && value <= 0xd7ff ||
          value >= 0xe000 && value <= 0x10ffff) {
        value = String.fromCharCode(value);
      } else {
        return value.toString();
      }
    } else if (value is! String) {
      return value.toString();
    }

    final map = {
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\r',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    if (quote) {
      result = "'$result'";
    }

    return result;
  }
}''';

  static const _extensionString =
      r'''
extension on String {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int readRune(State<String> state) {
    final w1 = codeUnitAt(state.pos++);
    if (w1 > 0xd7ff && w1 < 0xe000) {
      if (state.pos < length) {
        final w2 = codeUnitAt(state.pos++);
        if ((w2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((w1 & 0x3ff) << 10) + (w2 & 0x3ff);
        }

        state.pos--;
      }

      throw FormatException('Invalid UTF-16 character', this, state.pos - 1);
    }

    return w1;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int runeAt(int index) {
    final w1 = codeUnitAt(index++);
    if (w1 > 0xd7ff && w1 < 0xe000) {
      if (index < length) {
        final w2 = codeUnitAt(index);
        if ((w2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((w1 & 0x3ff) << 10) + (w2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return w1;
  }

  /// Returns a slice (substring) of the string from [start] to [end].
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String slice(int start, int end) {
    return substring(start, end);
  }
}''';

  static const _functionErrorMessage =
      r'''
String _errorMessage(String source, List<ParseError> errors) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (sb.isNotEmpty) {
      sb.writeln();
    }

    final error = errors[i];
    final start = error.start;
    final end = error.end;
    RangeError.checkValidRange(start, end, source.length);
    var row = 1;
    var lineStart = 0, next = 0, pos = 0;
    while (pos < source.length) {
      final c = source.codeUnitAt(pos++);
      if (c == 0xa || c == 0xd) {
        next = c == 0xa ? 0xd : 0xa;
        if (pos < source.length && source.codeUnitAt(pos) == next) {
          pos++;
        }

        if (pos - 1 >= start) {
          break;
        }

        row++;
        lineStart = pos;
      }
    }

    int max(int x, int y) => x > y ? x : y;
    int min(int x, int y) => x < y ? x : y;
    final sourceLen = source.length;
    final totalLen = sourceLen - lineStart;
    final lineLimit = min(80, totalLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final textLen = end2 - start2;
    final spaceLen = lineLimit - textLen;
    final prefixLen = min(lineLimit - textLen, start2 - lineStart);
    final list = <int>[];
    final iterator = RuneIterator.at(source, start2);
    for (var i = 0; i < prefixLen; i++) {
      if (!iterator.movePrevious()) {
        break;
      }

      list.add(iterator.current);
    }

    final column = start - lineStart + 1;
    final left = String.fromCharCodes(list.reversed);
    final end3 = max(end2, end2 + (spaceLen - prefixLen));
    final textStart = end3 - lineLimit;
    final indicatorOffset = start2 - textStart;
    final indicatorLen = max(1, end2 - start2);
    final right = source.substring(start2, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    sb.writeln('line $row, column $column: $error');
    sb.writeln(text);
    sb.write(' ' * indicatorOffset + '^' * indicatorLen);
  }

  return sb.toString();
}''';

  static addClassMemoizedResult(Context context) {
    _addClass(context, 'MemoizedResult', _classMemoizedResult);
  }

  static addClassResult(Context context, int size) {
    final String code;
    switch (size) {
      case 2:
        code = _classResult2;
        break;
      case 3:
        code = _classResult3;
        break;
      case 4:
        code = _classResult4;
        break;
      case 5:
        code = _classResult5;
        break;
      case 6:
        code = _classResult6;
        break;
      case 7:
        code = _classResult7;
        break;
      default:
        throw ArgumentError.value(size, 'size', 'Must be in range 2..7');
    }

    final name = 'Result$size';
    _addClass(context, name, code);
  }

  static void addClasses(Context context) {
    if (_hasClass(context, 'MemoizedResult')) {
      _addClass(context, 'State', _classState);
    } else {
      _addClass(context, 'State', _classStateNoMemo);
    }

    _addClass(context, 'State', _classState);
    _addClass(context, 'ParseError', _classParseError);
    context.globalDeclarations.add(_extensionString);
  }

  static String getErrorMessageProcessor() {
    var result = _functionErrorMessage;
    return result;
  }

  static _addClass(Context context, String name, String code) {
    if (!context.classDeclarations.containsKey(name)) {
      context.classDeclarations[name] = code;
    }
  }

  static bool _hasClass(Context context, String name) {
    return context.classDeclarations.containsKey(name);
  }
}
