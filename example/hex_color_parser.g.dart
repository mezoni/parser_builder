part of 'hex_color_parser.dart';

Color parse(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final offset = state.errorPos;
    final errors = ParseError.errorReport(offset, state.errors);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

int? _hexPrimary(State<String> state) {
  int? $0;
  final source = state.source;
  String? $1;
  final $pos = state.pos;
  var $count = 0;
  while ($count < 2 && state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (!ok) {
      break;
    }
    state.pos++;
    $count++;
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else {
    if (state.pos < source.length) {
      final c = source.runeAt(state.pos);
      state.fail(state.pos, ParseError.unexpected(0, c));
    } else {
      state.fail(state.pos, const ParseError.unexpected(0, 'EOF'));
    }
    state.pos = $pos;
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v, radix: 16);
  }
  return $0;
}

Color? _hexColor(State<String> state) {
  Color? $0;
  final source = state.source;
  final $log = state.log;
  state.log = false;
  Color? $1;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 35;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, const ParseError.expected('#'));
  }
  if (state.ok) {
    final $pos1 = state.pos;
    int? $2;
    $2 = _hexPrimary(state);
    if (state.ok) {
      int? $3;
      $3 = _hexPrimary(state);
      if (state.ok) {
        int? $4;
        $4 = _hexPrimary(state);
        if (state.ok) {
          final v1 = $2!;
          final v2 = $3!;
          final v3 = $4!;
          $1 = Color(v1, v2, v3);
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
    }
  }
  if (!state.ok) {
    $1 = null;
    state.pos = $pos;
  }
  state.log = $log;
  if (state.ok) {
    $0 = $1;
  } else {
    state.fail(state.pos, const ParseError.expected('hexadecimal color'));
  }
  return $0;
}

Color? _parse(State<String> state) {
  Color? $0;
  $0 = _hexColor(state);
  return $0;
}

String _errorMessage(String source, List<ParserException> errors,
    [color, int maxCount = 10, String? url]) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (i > maxCount) {
      break;
    }

    final error = errors[i];
    final start = error.start;
    final end = error.end;
    if (end > source.length) {
      source += ' ' * (end - source.length);
    }

    final file = SourceFile.fromString(source, url: url);
    final span = file.span(start, end);
    if (sb.isNotEmpty) {
      sb.writeln();
    }

    sb.write(span.message(error.toString(), color: color));
  }

  if (errors.length > maxCount) {
    sb.writeln();
    sb.write('(${errors.length - maxCount} more errors...)');
  }

  return sb.toString();
}

class ParseError {
  final ParseErrorKind kind;

  final int length;

  final Object? value;

  const ParseError.expected(this.value)
      : kind = ParseErrorKind.expected,
        length = 0;

  const ParseError.message(this.length, String message)
      : kind = ParseErrorKind.message,
        value = message;

  const ParseError.unexpected(this.length, this.value)
      : kind = ParseErrorKind.unexpected;

  const ParseError._(this.kind, this.length, this.value);

  @override
  int get hashCode => kind.hashCode ^ length.hashCode ^ value.hashCode;

  @override
  bool operator ==(other) {
    return other is ParseError &&
        other.kind == kind &&
        other.length == length &&
        other.value == value;
  }

  @override
  String toString() {
    switch (kind) {
      case ParseErrorKind.expected:
        return 'Expected: $value';
      case ParseErrorKind.message:
        return '$value';
      case ParseErrorKind.unexpected:
        return 'Unexpected: $value';
    }
  }

  static List<ParserException> errorReport(
      int offset, List<ParseError> errors) {
    final expected = errors.where((e) => e.kind == ParseErrorKind.expected);
    final result = <ParserException>[];
    if (expected.isNotEmpty) {
      final values = expected.map((e) => '\'${_escape(e.value)}\'').join(', ');
      result.add(ParserException(offset, 0, 'Expected: $values'));
    }

    for (var i = 0; i < errors.length; i++) {
      final error = errors[i];
      switch (error.kind) {
        case ParseErrorKind.expected:
          break;
        case ParseErrorKind.message:
          var length = error.length;
          var newOffset = offset;
          if (length < 0) {
            newOffset += length;
            length = -length;
          }

          final newError =
              ParserException(newOffset, length, error.value as String);
          result.add(newError);
          break;
        case ParseErrorKind.unexpected:
          final newError = ParserException(
              offset, error.length, '\'${_escape(error.value)}\'');
          result.add(newError);
          break;
      }
    }

    return result;
  }

  static String _escape(value) {
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
      '\r': '\\t',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    return result;
  }
}

enum ParseErrorKind { expected, message, unexpected }

class ParserException {
  final int end;

  final int start;

  final String text;

  ParserException(this.start, this.end, this.text);
}

class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<ParseError?> _errors = List.filled(500, null);

  int _length = 0;

  final List<_Memo> _memos = [];

  State(this.source);

  void fail(int pos, ParseError error) {
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }
        _errors[_length++] = error;
      }

      if (lastErrorPos < pos) {
        lastErrorPos = pos;
      }
    }
  }

  List<ParseError> get errors {
    return List.generate(_length, (i) => _errors[i]!);
  }

  @pragma('vm:prefer-inline')
  void memoize<R>(int id, bool fast, int start, [R? result]) {
    final memo = _Memo(id, fast, start, pos, ok, result);
    for (var i = 0; i < _memos.length; i++) {
      if (_memos[i].id == id) {
        _memos[i] = memo;
        return;
      }
    }

    _memos.add(memo);
  }

  @pragma('vm:prefer-inline')
  _Memo<R>? memoized<R>(int id, bool fast, int start) {
    for (var i = 0; i < _memos.length; i++) {
      final memo = _memos[i];
      if (memo.id == id) {
        if (memo.canRestore(start, fast)) {
          return memo as _Memo<R>;
        }

        break;
      }
    }

    return null;
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
}

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
}

class _Memo<T> {
  final int end;

  final bool fast;

  final int id;

  final bool ok;

  final T? result;

  final int start;

  _Memo(this.id, this.fast, this.start, this.end, this.ok, this.result);

  @pragma('vm:prefer-inline')
  bool canRestore(int start, bool fast) {
    return this.start == start && (this.fast == fast || !this.fast);
  }

  @pragma('vm:prefer-inline')
  T? restore(State state) {
    state.ok = ok;
    state.pos = end;
    return result;
  }
}
