import 'package:source_span/source_span.dart';

void main() {
  final source = '1 + 2 * 3 * (1 + 2.0)';
  final result = parse(source);
  print(result);
}

num _calculate(num left, String operator, num right) {
  switch (operator) {
    case '+':
      return left + right;
    case '-':
      return left - right;
    case '*':
      return left * right;
    case '/':
      return left / right;
    case '~/':
      return left ~/ right;
    default:
      throw StateError('Unknown operator: $operator');
  }
}

num parse(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final errors = ParseError.errorReport(state.errors);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

num? _parse(State<String> state) {
  num? $0;
  final source = state.source;
  final $pos = state.pos;
  $0 = _expression(state);
  if (state.ok) {
    state.ok = state.pos >= source.length;
    if (!state.ok) {
      state.error = ParseError.expected(state.pos, 'EOF');
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

void _digit1(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (!state.ok) {
    if ($pos < source.length) {
      final c = source.runeAt($pos);
      state.error = ParseError.unexpected($pos, 0, c);
    } else {
      state.error = ParseError.unexpected($pos, 0, 'EOF');
    }
  }
}

num? _number(State<String> state) {
  num? $0;
  final source = state.source;
  final $log = state.log;
  state.log = false;
  num? $1;
  String? $2;
  final $pos = state.pos;
  final $pos1 = state.pos;
  _digit1(state);
  if (state.ok) {
    final $log1 = state.log;
    state.log = false;
    final $pos2 = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 46;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.error = ParseError.expected(state.pos, '.');
    }
    if (state.ok) {
      _digit1(state);
    }
    if (!state.ok) {
      state.pos = $pos2;
    }
    state.log = $log1;
    if (!state.ok) {
      state.ok = true;
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
  }
  if (state.ok) {
    $2 = source.slice($pos, state.pos);
  }
  if (state.ok) {
    final v = $2!;
    $1 = num.parse(v);
  }
  state.log = $log;
  if (state.ok) {
    $0 = $1;
  } else {
    state.error = ParseError.expected(state.pos, 'number');
  }
  return $0;
}

void _ws(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 32 && (c >= 9 && c <= 10 || c == 13 || c == 32);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
}

void _openParen(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 40;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '(');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
  }
}

void _closeParen(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 41;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, ')');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
  }
}

num? _primary(State<String> state) {
  num? $0;
  final $errorPos = state.errorPos;
  state.errorPos = state.pos + 1;
  num? $1;
  $1 = _number(state);
  if (!state.ok) {
    final $pos = state.pos;
    _openParen(state);
    if (state.ok) {
      $1 = _expression(state);
      if (state.ok) {
        _closeParen(state);
      }
    }
    if (!state.ok) {
      $1 = null;
      state.pos = $pos;
    }
  }
  state.restoreErrorPos($errorPos);
  if (state.ok) {
    $0 = $1;
  } else {
    state.error = ParseError.expected(state.pos, 'expression');
  }
  return $0;
}

String? _multiplicativeOperator(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 42:
        state.pos++;
        v = '*';
        break;
      case 47:
        state.pos++;
        v = '/';
        break;
      case 126:
        if (source.startsWith('~/', pos)) {
          state.pos += 2;
          v = '~/';
          break;
        }
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    }
  }
  if (!state.ok) {
    state.error = ParseError.expected(state.pos, '*');
    state.error = ParseError.expected(state.pos, '/');
    state.error = ParseError.expected(state.pos, '~/');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

num? _multiplicative(State<String> state) {
  num? $0;
  final $pos = state.pos;
  num? $left;
  final $log = state.log;
  num? $1;
  $1 = _primary(state);
  if (state.ok) {
    $left = $1;
    while (true) {
      state.log = false;
      String? $2;
      $2 = _multiplicativeOperator(state);
      state.log = $log;
      if (!state.ok) {
        state.ok = true;
        break;
      }
      num? $3;
      $3 = _primary(state);
      if (!state.ok) {
        state.pos = $pos;
        break;
      }
      final $op = $2!;
      final $right = $3!;
      $left = _calculate($left!, $op, $right);
    }
  }
  if (state.ok) {
    $0 = $left;
  }
  return $0;
}

String? _additiveOperator(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 43:
        state.pos++;
        v = '+';
        break;
      case 45:
        state.pos++;
        v = '-';
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    }
  }
  if (!state.ok) {
    state.error = ParseError.expected(state.pos, '+');
    state.error = ParseError.expected(state.pos, '-');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

num? _additive(State<String> state) {
  num? $0;
  final $pos = state.pos;
  num? $left;
  final $log = state.log;
  num? $1;
  $1 = _multiplicative(state);
  if (state.ok) {
    $left = $1;
    while (true) {
      state.log = false;
      String? $2;
      $2 = _additiveOperator(state);
      state.log = $log;
      if (!state.ok) {
        state.ok = true;
        break;
      }
      num? $3;
      $3 = _multiplicative(state);
      if (!state.ok) {
        state.pos = $pos;
        break;
      }
      final $op = $2!;
      final $right = $3!;
      $left = _calculate($left!, $op, $right);
    }
  }
  if (state.ok) {
    $0 = $left;
  }
  return $0;
}

num? _expression(State<String> state) {
  num? $0;
  final $errorPos = state.errorPos;
  state.errorPos = state.pos + 1;
  num? $1;
  $1 = _additive(state);
  state.restoreErrorPos($errorPos);
  if (state.ok) {
    $0 = $1;
  } else {
    state.error = ParseError.expected(state.pos, 'expression');
  }
  return $0;
}

String _errorMessage(String source, List<ParseError> errors,
    [color, int maxCount = 10, String? url]) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (i > maxCount) {
      break;
    }

    final error = errors[i];
    if (error.offset + error.length > source.length) {
      source += ' ' * (error.offset + error.length - source.length);
    }

    final file = SourceFile.fromString(source, url: url);
    final span = file.span(error.offset, error.offset + error.length);
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

  final int offset;

  final Object? value;

  ParseError.expected(this.offset, this.value)
      : kind = ParseErrorKind.expected,
        length = 0;

  ParseError.message(this.offset, this.length, String message)
      : kind = ParseErrorKind.message,
        value = message;

  ParseError.unexpected(this.offset, this.length, this.value)
      : kind = ParseErrorKind.unexpected;

  ParseError._(this.kind, this.offset, this.length, this.value);

  @override
  int get hashCode =>
      kind.hashCode ^ length.hashCode ^ offset.hashCode ^ value.hashCode;

  @override
  bool operator ==(other) {
    return other is ParseError &&
        other.kind == kind &&
        other.length == length &&
        other.offset == offset &&
        other.value == value;
  }

  ParseError normalize() {
    if (length >= 0) {
      return this;
    }

    return ParseError._(kind, offset + length, -length, value);
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

  static List<ParseError> errorReport(List<ParseError> errors) {
    errors = errors.toSet().map((e) => e.normalize()).toList();
    final grouped = <int, List<ParseError>>{};
    final expected = errors.where((e) => e.kind == ParseErrorKind.expected);
    for (final error in expected) {
      final offset = error.offset;
      var list = grouped[offset];
      if (list == null) {
        list = [];
        grouped[offset] = list;
      }

      list.add(error);
    }

    final result = <ParseError>[];
    for (final key in grouped.keys) {
      final list = grouped[key]!;
      final values = list.map((e) => '\'${_escape(e.value)}\'').join(', ');
      result.add(ParseError.message(key, 0, 'Expected: $values'));
    }

    for (var i = 0; i < errors.length; i++) {
      var error = errors[i];
      if (error.kind != ParseErrorKind.expected) {
        if (error.kind == ParseErrorKind.unexpected) {
          error = ParseError.unexpected(
              error.offset, error.length, '\'${_escape(error.value)}\'');
        }
        result.add(error);
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

class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<ParseError?> _errors = List.filled(500, null);

  int _length = 0;

  final List<_Memo> _memos = [];

  State(this.source);

  set error(ParseError error) {
    if (log) {
      final pos = error.offset;
      if (errorPos <= pos) {
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
  void restoreErrorPos(int pos) => errorPos = errorPos <= pos
      ? pos
      : _length == 0
          ? -1
          : _errors[0]!.offset;

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
