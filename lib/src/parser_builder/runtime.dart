part of '../../parser_builder.dart';

class ParseRuntime {
  static const _classMemo = '''
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
}''';

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
}''';

  static const _classState = r'''
class State<T> {
  dynamic context;

  int errorPos = -1;

  int newErrorPos = -1;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<ParseError?> _errors = List.filled(500, null);

  int _length = 0;

  final List<_Memo> _memos = [];

  State(this.source);

  set error(ParseError error) {
    final offset = error.offset;
    if (offset >= errorPos) {
      if (offset > errorPos) {
        errorPos = offset;
        _length = 0;
      }
      newErrorPos = offset;
      _errors[_length++] = error;
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
  void restoreErrorPos() {
    errorPos = _length == 0 ? -1 : _errors[0]!.offset;
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
      _extensionString,
      _classMemo,
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
