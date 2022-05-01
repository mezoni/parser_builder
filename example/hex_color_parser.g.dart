part of 'hex_color_parser.dart';

Color parse(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final errors = ParseError.errorReport(state.errors);
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
      state.error = ParseError.unexpected(state.pos, 0, c);
    } else {
      state.error = ParseError.unexpected(state.pos, 0, 'EOF');
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
  final $minErrorPos = state.minErrorPos;
  final $newErrorPos = state.newErrorPos;
  state.minErrorPos = state.pos + 1;
  state.newErrorPos = -1;
  Color? $1;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 35;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '#');
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
  state.minErrorPos = $minErrorPos;
  if (state.ok) {
    $0 = $1;
  } else {
    if (state.newErrorPos > state.pos) {
      final length = state.pos - state.newErrorPos;
      state.error = ParseError.message(
          state.newErrorPos, length, 'Malformed hexadecimal color');
    } else {
      state.error = ParseError.expected(state.pos, 'hexadecimal color');
    }
  }
  state.newErrorPos =
      $newErrorPos > state.newErrorPos ? $newErrorPos : state.newErrorPos;
  return $0;
}

Color? _parse(State<String> state) {
  Color? $0;
  $0 = _hexColor(state);
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

    errors.removeWhere((e) => e.kind == ParseErrorKind.expected);
    for (var offset in grouped.keys) {
      final list = grouped[offset]!;
      final values = list.map((e) => '\'${_escape(e.value)}\'').join(', ');
      errors.add(ParseError.message(offset, 0, 'Expected: $values'));
    }

    for (var i = 0; i < errors.length; i++) {
      final error = errors[i];
      if (error.kind == ParseErrorKind.unexpected) {
        errors[i] = ParseError.unexpected(
            error.offset, error.length, '\'${_escape(error.value)}\'');
      }
    }

    return errors;
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

  int minErrorPos = -1;

  int newErrorPos = -1;

  bool ok = false;

  int pos = 0;

  final T source;

  ParseError? _error;

  final List _errors = List.filled(100, null);

  int _errorPos = -1;

  int _length = 0;

  State(this.source);

  set error(ParseError error) {
    final offset = error.offset;
    if (offset >= minErrorPos) {
      if (_errorPos < offset) {
        _errorPos = offset;
        _length = 1;
        _error = error;
        newErrorPos = offset;
      } else if (_errorPos == offset) {
        newErrorPos = offset;
        if (_length < _errors.length) {
          _errors[_length++] = error;
        }
      }
    }
  }

  List<ParseError> get errors {
    if (_length == 0) {
      return [];
    } else if (_length == 1) {
      return [_error!];
    } else {
      return [
        _error!,
        ...List.generate(_length - 1, (i) => _errors[i + 1] as ParseError)
      ];
    }
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
