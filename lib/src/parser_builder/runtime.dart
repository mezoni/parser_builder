part of '../../parser_builder.dart';

class ParseRuntime {
  static const _classParseError = r'''
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
    final result = errors.toSet().toList();
    final expected = <int, List<ParseError>>{};
    for (final error
        in result.where((e) => e.kind == ParseErrorKind.expected)) {
      final offset = error.offset;
      var list = expected[offset];
      if (list == null) {
        list = [];
        expected[offset] = list;
      }

      list.add(error);
    }

    result.removeWhere((e) => e.kind == ParseErrorKind.expected);
    for (var i = 0; i < result.length; i++) {
      final error = result[i];
      if (error.kind == ParseErrorKind.unexpected) {
        result[i] = ParseError.unexpected(
            error.offset, error.length, _escape(error.value));
      }
    }

    for (var offset in expected.keys) {
      final list = expected[offset]!;
      final values = list.map((e) => _escape(e.value)).join(', ');
      result.add(ParseError.message(offset, 0, 'Expected: $values'));
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

    return '\'$result\'';
  }
}''';

  static const _classState = r'''
class State<T> {
  dynamic context;

  bool log = true;

  int nested = -1;

  bool ok = false;

  int pos = 0;

  final T source;

  ParseError? _error;

  int _errorPos = -1;

  int _length = 0;

  final List _list = List.filled(100, null);

  State(this.source);

  set error(ParseError error) {
    final offset = error.offset;
    if (offset > nested && log) {
      if (_errorPos < offset) {
        _errorPos = offset;
        _length = 1;
        _error = error;
      } else if (_errorPos == offset) {
        if (_length == 1) {
          _list[0] = _error;
        }

        if (_length < _list.length) {
          _list[_length++] = error;
        }
      }
    }
  }

  List<ParseError> get errors {
    if (_length == 1) {
      return [_error!];
    } else {
      return List.generate(_length, (i) => _list[i] as ParseError);
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
}''';

  static const _enumParseErrorKind = '''
enum ParseErrorKind { expected, message, unexpected }''';

  static const _extensionString = r'''
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

  static const _functionErrorMessage = r'''
String {{name}}(String source, List<ParseError> errors,
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
''';

  static List<String> getClasses() {
    return const [
      _classParseError,
      _enumParseErrorKind,
      _classState,
      _extensionString
    ];
  }

  /// An unofficial way to display error messages.
  /// Can be used as a starting point when developing parsers.
  ///
  /// An unofficial way because the concept of building a parser implies that
  /// the generated parser should not have dependencies.
  ///
  /// Use of this function requires the import of a third party package:
  ///
  /// import 'package:source_span/source_span.dart';
  static String getErrorMessageProcessor([String name = '_errorMessage']) {
    var result = _functionErrorMessage;
    result = result.replaceAll('{{name}}', name);
    return result;
  }
}
