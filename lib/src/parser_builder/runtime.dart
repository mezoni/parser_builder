part of '../../parser_builder.dart';

class ParseRuntime {
  static const _classChar = r'''
/// Represents the `char` used in parsing errors.
class Char {
  final int charCode;

  const Char(this.charCode);

  @override
  int get hashCode => charCode.hashCode;

  @override
  operator ==(other) {
    return other is Char && other.charCode == charCode;
  }

  @override
  String toString() {
    final s = String.fromCharCode(charCode);
    return '\'$s\'';
  }
}''';

  static const _classErr = r'''
abstract class Err {
  @override
  int get hashCode => length.hashCode ^ offset.hashCode;

  int get length;

  int get offset;

  @override
  bool operator ==(other) {
    return other is Err && other.length == length && other.offset == offset;
  }

  static List<Err> errorReport(Err error) {
    var result = Err.flatten(error);
    result = Err.groupExpected(result);
    return result;
  }

  static List<Err> flatten(Err error) {
    void flatten(Err error, List<Err> result) {
      if (error is ErrCombined) {
        for (final error in error.errors) {
          flatten(error, result);
        }
      } else if (error is ErrWithTagAndErrors) {
        final inner = <Err>[];
        for (final nestedError in error.errors) {
          flatten(nestedError, inner);
        }

        int max(int x, int y) => x > y
            ? x
            : y < x
                ? x
                : y;
        final maxOffset = inner.map((e) => e.offset).reduce(max);
        final farthest = inner.where((e) => e.offset == maxOffset);
        final offset = error.offset;
        final tag = error.tag;
        result.add(ErrExpected.tag(offset, tag));
        if (maxOffset > offset) {
          if (error is ErrMalformed) {
            result
                .add(ErrMessage(offset, maxOffset - offset, 'Malformed $tag'));
            result.addAll(farthest);
          } else if (error is ErrNested) {
            result.addAll(farthest);
          } else {
            throw StateError('Internal error');
          }
        }
      } else {
        result.add(error);
      }
    }

    final result = <Err>[];
    flatten(error, result);
    return result.toSet().toList();
  }

  static List<Err> groupExpected(List<Err> errors) {
    final result = <Err>[];
    final expected = errors.whereType<ErrExpected>();
    Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
      final map = <T, List<S>>{};
      for (final element in values) {
        (map[key(element)] ??= []).add(element);
      }
      return map;
    }

    final groupped = groupBy(expected, (Err e) => e.offset);
    final offsets = <int>{};
    final processed = <Err>{};
    for (final error in errors) {
      if (!processed.add(error)) {
        continue;
      }

      if (error is! ErrExpected) {
        result.add(error);
        continue;
      }

      final offset = error.offset;
      if (!offsets.add(offset)) {
        continue;
      }

      final elements = <String>[];
      for (final error in groupped[offset]!) {
        elements.add(error.value.toString());
        processed.add(error);
      }

      final message = elements.join(', ');
      final newError = ErrMessage(offset, 1, 'Expected: $message');
      result.add(newError);
    }

    return result;
  }
}''';

  static const _classErrCombined = '''
class ErrCombined extends ErrWithErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  ErrCombined(this.offset, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrCombined;
  }
}''';

  static const _classErrCombinedLite = '''
class ErrCombined extends ErrWithErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  ErrCombined(this.offset, this.errors);

  @override
  int get length => 1;
}''';

  static const _classErrExpected = r'''
class ErrExpected extends Err {
  @override
  final int offset;

  final Object? value;

  ErrExpected(this.offset, this.value);

  ErrExpected.char(this.offset, Char value) : value = value;

  ErrExpected.eof(this.offset) : value = const Tag('EOF');

  ErrExpected.label(this.offset, String value) : value = value;

  ErrExpected.tag(this.offset, Tag value) : value = value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;

  @override
  int get length => 1;

  @override
  bool operator ==(other) {
    return super == other && other is ErrExpected && other.value == value;
  }

  @override
  String toString() {
    final result = 'Expected: $value';
    return result;
  }
}''';

  static const _classErrExpectedLite = r'''
class ErrExpected extends Err {
  @override
  final int offset;

  final Object? value;

  ErrExpected(this.offset, this.value);

  ErrExpected.char(this.offset, Char value) : value = value;

  ErrExpected.eof(this.offset) : value = const Tag('EOF');

  ErrExpected.label(this.offset, String value) : value = value;

  ErrExpected.tag(this.offset, Tag value) : value = value;

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Expected: $value';
    return result;
  }
}''';

  static const _classErrMalformed = r'''
class ErrMalformed extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrMalformed(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrMalformed;
  }

  @override
  String toString() {
    final result = 'Malformed $tag';
    return result;
  }
}''';

  static const _classErrMalformedLite = r'''
class ErrMalformed extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrMalformed(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Malformed $tag';
    return result;
  }
}''';

  static const _classErrMessage = '''
class ErrMessage extends Err {
  @override
  final int length;

  final String message;

  @override
  final int offset;

  ErrMessage(this.offset, this.length, this.message);

  @override
  int get hashCode => super.hashCode ^ message.hashCode;

  @override
  bool operator ==(other) {
    return super == other && other is ErrMessage && other.message == message;
  }

  @override
  String toString() {
    return message;
  }
}''';

  static const _classErrMessageLite = '''
class ErrMessage extends Err {
  @override
  final int length;

  final String message;

  @override
  final int offset;

  ErrMessage(this.offset, this.length, this.message);

  @override
  String toString() {
    return message;
  }
}''';

  static const _classErrNested = r'''
class ErrNested extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrNested(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrNested;
  }

  @override
  String toString() {
    final result = 'Nested $tag';
    return result;
  }
}''';

  static const _classErrNestedLite = r'''
class ErrNested extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrNested(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Nested $tag';
    return result;
  }
}''';

  static const _classErrUnexpected = r'''
class ErrUnexpected extends Err {
  @override
  final int length;

  @override
  final int offset;

  final Object? value;

  ErrUnexpected(this.offset, this.length, this.value);

  ErrUnexpected.char(this.offset, Char value)
      : length = 1,
        value = value;

  ErrUnexpected.eof(this.offset)
      : length = 1,
        value = const Tag('EOF');

  ErrUnexpected.label(this.offset, String value)
      : length = value.length,
        value = value;

  ErrUnexpected.tag(this.offset, Tag value)
      : length = value.name.length,
        value = value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;

  @override
  bool operator ==(other) {
    return super == other && other is ErrUnexpected && other.value == value;
  }

  @override
  String toString() {
    final result = 'Unexpected: $value';
    return result;
  }
}''';

  static const _classErrUnexpectedLite = r'''
class ErrUnexpected extends Err {
  @override
  final int length;

  @override
  final int offset;

  final Object? value;

  ErrUnexpected(this.offset, this.length, this.value);

  ErrUnexpected.char(this.offset, Char value)
      : length = 1,
        value = value;

  ErrUnexpected.eof(this.offset)
      : length = 1,
        value = const Tag('EOF');

  ErrUnexpected.label(this.offset, String value)
      : length = value.length,
        value = value;

  ErrUnexpected.tag(this.offset, Tag value)
      : length = value.name.length,
        value = value;

  @override
  String toString() {
    final result = 'Unexpected: $value';
    return result;
  }
}''';

  static const _classErrUnknown = '''
class ErrUnknown extends Err {
  @override
  final int offset;

  ErrUnknown(this.offset);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrUnknown;
  }

  @override
  String toString() {
    final result = 'Unknown error';
    return result;
  }
}''';

  static const _classErrUnknownLite = '''
class ErrUnknown extends Err {
  @override
  final int offset;

  ErrUnknown(this.offset);

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Unknown error';
    return result;
  }
}''';

  static const _classErrWithErrors = r'''
abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  int get hashCode {
    var result = super.hashCode;
    for (final error in errors) {
      result ^= error.hashCode;
    }

    return result;
  }

  @override
  bool operator ==(other) {
    if (super == other) {
      if (other is ErrWithErrors) {
        final otherErrors = other.errors;
        if (otherErrors.length == errors.length) {
          for (var i = 0; i < errors.length; i++) {
            final error = errors[i];
            final otherError = otherErrors[i];
            if (otherError != error) {
              return false;
            }
          }

          return true;
        }
      }
    }

    return false;
  }

  @override
  String toString() {
    final list = errors.join(', ');
    final result = '[$list]';
    return result;
  }
}''';

  static const _classErrWithErrorsLite = r'''
abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  String toString() {
    final list = errors.join(', ');
    final result = '[$list]';
    return result;
  }
}''';

  static const _classErrWithTagAndErrors = '''
abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrWithTagAndErrors && other.tag == tag;
  }
}
''';

  static const _classErrWithTagAndErrorsLite = '''
abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;
}
''';

  static const _classState = r'''
class State<T> {
  static const eof = 0x110000;

  dynamic context;

  int ch = eof;

  Err error = ErrUnknown(0);

  bool ok = false;

  int pos = 0;

  final T source;

  State(this.source) {
    if (this is State<String>) {
      final this_ = this as State<String>;
      ch = this_.readChar(0);
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

  static const _classTag = '''
/// Represents the `tag` (symbol) used in parsing errors.
class Tag {
  final String name;

  const Tag(this.name);

  @override
  int get hashCode => name.hashCode;

  @override
  operator ==(other) {
    return other is Tag && other.name == name;
  }

  @override
  String toString() {
    return name;
  }
}''';

  static const _extensionState = '''
extension on State<String> {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int getChar(int index) {
    if (index < source.length) {
      final c = source.codeUnitAt(index);
      return c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      return State.eof;
    }
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int nextChar() {
    final index = pos + (ch > 0xffff ? 2 : 1);
    if (index < source.length) {
      pos = index;
      final c = source.codeUnitAt(index);
      ch = c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      pos = source.length;
      ch = State.eof;
    }
    return ch;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int readChar(int index) {
    if (index < source.length) {
      pos = index;
      final c = source.codeUnitAt(index);
      ch = c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      pos = source.length;
      ch = State.eof;
    }
    return ch;
  }

  @pragma('vm:prefer-inline')
  int _getChar32(int c, int index) {
    if (index < source.length) {
      final c2 = source.codeUnitAt(index);
      if ((c2 & 0xfc00) == 0xdc00) {
        return 0x10000 + ((c & 0x3ff) << 10) + (c2 & 0x3ff);
      }
    }
    return State.eof;
  }
}''';

  static const _extensionString = '''
extension on String {
  /// Returns `true` if [pos] points to the end of the string (or beyond).
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  bool atEnd(int pos) {
    return pos >= length;
  }

  /// Returns a slice (substring) of the string from [start] to [end].
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String slice(int start, int end) {
    return substring(start, end);
  }
}''';

  static const _functionErrorMessage = r'''
String {{name}}(String source, List<Err> errors,
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

  static List<String> getClasses({bool lightweightRuntime = true}) {
    if (lightweightRuntime) {
      return const [
        _classChar,
        _classErr,
        _classErrCombinedLite,
        _classErrExpectedLite,
        _classErrMalformedLite,
        _classErrMessageLite,
        _classErrNestedLite,
        _classErrUnexpectedLite,
        _classErrUnknownLite,
        _classErrWithErrorsLite,
        _classErrWithTagAndErrorsLite,
        _classState,
        _classTag,
        _extensionState,
        _extensionString
      ];
    } else {
      return const [
        _classChar,
        _classErr,
        _classErrCombined,
        _classErrExpected,
        _classErrMalformed,
        _classErrMessage,
        _classErrNested,
        _classErrUnexpected,
        _classErrUnknown,
        _classErrWithErrors,
        _classErrWithTagAndErrors,
        _classState,
        _classTag,
        _extensionState,
        _extensionString
      ];
    }
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
