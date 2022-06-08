part of '../../parser_builder.dart';

class ParseRuntime {
  /// Simplified (to reduce code size), experimental implementation.
  /// As a result, there is a possibility that the error position indicator may
  /// be displayed in a different position.
  static const _functionErrorMessage = r'''
String _errorMessage(String source, List<ParseError> errors) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (sb.isNotEmpty) {
      sb.writeln();
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
    final lineLimit = min(80, sourceLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final extraLen = lineLimit - errorLen;
    final rightLen = min(sourceLen - end2, extraLen - (extraLen >> 1));
    final leftLen = min(start, max(0, lineLimit - errorLen - rightLen));
    final list = <int>[];
    final iterator = RuneIterator.at(source, start2);
    for (var i = 0; i < leftLen; i++) {
      if (!iterator.movePrevious()) {
        break;
      }

      list.add(iterator.current);
    }

    final column = start - lineStart + 1;
    final left = String.fromCharCodes(list.reversed);
    final end3 = min(sourceLen, start2 + (lineLimit - leftLen));
    final indicatorLen = max(1, errorLen);
    final right = source.substring(start2, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    sb.writeln('line $row, column $column: $error');
    sb.writeln(text);
    sb.write(' ' * leftLen + '^' * indicatorLen);
  }

  return sb.toString();
}''';

  static void addCapability(
      Context context, ParseRuntimeCapability capability, bool condition) {
    if (condition) {
      final registry = _getRegistry(context);
      registry.add(capability);
    }
  }

  static void addCapabilityByName(
      Context context, String name, bool condition) {
    final value =
        ParseRuntimeCapability.values.firstWhere((e) => e.name == name);
    addCapability(context, value, condition);
  }

  static void addClasses(Context context) {
    final classes = [
      _MemoizedResultClassBuilder(),
      _ObjectExtensionBuilder(),
      _ParseErrorClassBuilder(),
      _Result2ClassBuilder(),
      _Result3ClassBuilder(),
      _Result4ClassBuilder(),
      _Result5ClassBuilder(),
      _Result6ClassBuilder(),
      _Result7ClassBuilder(),
      _StateClassBuilder(),
      _StringExtensionBuilder(),
    ];

    final map = <String, _RuntimeClassBuilder>{};
    for (final element in classes) {
      map[element.name] = element;
    }

    final keys = map.keys.toList();
    keys.sort();
    final registry = _getRegistry(context);
    for (final key in keys) {
      final builder = map[key]!;
      final result = builder.build(registry);
      if (result != null) {
        context.globalDeclarations.add(result);
      }
    }
  }

  static String getErrorMessageProcessor() {
    const result = _functionErrorMessage;
    return result;
  }

  static Set<ParseRuntimeCapability> _getRegistry(Context context) {
    final registry = context.globalRegistry;
    return context.readRegistryValue(
        registry, ParseRuntime, 'capability', () => <ParseRuntimeCapability>{});
  }
}

enum ParseRuntimeCapability {
  contains1,
  contains2,
  contains3,
  contains4,
  contains5,
  memoization,
  result2,
  result3,
  result4,
  result5,
  result6,
  result7,
  tag,
  tag1,
  tag2,
}

class _MemoizedResultClassBuilder extends _RuntimeClassBuilder {
  static const _template = '''
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

  @override
  String get name => 'MemoizedResult';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.memoization)) {
      return null;
    }

    return _template;
  }
}

class _ObjectExtensionBuilder extends _RuntimeClassBuilder {
  static const _template = '''
extension on Object {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  R as<R>() => this as R;
}''';

  @override
  String get name => '_ObjectExt';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    return _template;
  }
}

class _ParseErrorClassBuilder extends _RuntimeClassBuilder {
  static const _template = '''
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

  @override
  String get name => 'ParseError';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    return _template;
  }
}

class _Result2ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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

  @override
  String get name => 'Result2';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result2)) {
      return null;
    }

    return _template;
  }
}

class _Result3ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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

  @override
  String get name => 'Result3';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result3)) {
      return null;
    }

    return _template;
  }
}

class _Result4ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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

  @override
  String get name => 'Result4';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result4)) {
      return null;
    }

    return _template;
  }
}

class _Result5ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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

  @override
  String get name => 'Result5';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result5)) {
      return null;
    }

    return _template;
  }
}

class _Result6ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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

  @override
  String get name => 'Result6';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result6)) {
      return null;
    }

    return _template;
  }
}

class _Result7ClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
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
  @override
  String get name => 'Result7';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    if (!capabilities.contains(ParseRuntimeCapability.result7)) {
      return null;
    }

    return _template;
  }
}

abstract class _RuntimeClassBuilder {
  String get name;

  String? build(Set<ParseRuntimeCapability> capabilities);

  String replace(
      String template,
      String key,
      String value,
      Set<ParseRuntimeCapability> actual,
      Set<ParseRuntimeCapability> required) {
    final found = actual.any((e) => required.contains(e));
    value = found ? value : '';
    final result = template.replaceAll('{{$key}}', value);
    return result;
  }
}

class _StateClassBuilder extends _RuntimeClassBuilder {
  static const _template = r'''
class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<int> _ends = List.filled(150, 0);

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  {{memos}}

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, [Object? value, int start = -1, int end = -1]) {
    ok = false;
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

        _kinds[_length] = kind;
        _ends[_length] = end;
        _starts[_length] = start;
        _values[_length] = value;
        _length++;
      }

      if (lastErrorPos < pos) {
        lastErrorPos = pos;
      }
    }
  }

  {{memoize}}

  {{memoized}}

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
    var start = 0;
    var end = 0;
    void calculate(int index) {
      start = _starts[index];
      if (start < 0) {
        start = errorPos;
        end = start;
      } else {
        end = _ends[index];
        if (end < start) {
          end = start;
        }
      }
    }

    final result = <ParseError>[];
    final expected = <int, List<Object?>>{};
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        calculate(i);
        final value = _values[i];
        (expected[start] ??= []).add(value);
      }
    }

    for (final start in expected.keys) {
      final values = expected[start]!.toSet().map(_escape);
      final text = 'Expecting: ${values.join(', ')}';
      final error = ParseError(start, start, text);
      result.add(error);
    }

    for (var i = 0; i < _length; i++) {
      calculate(i);
      final value = _values[i];
      final kind = _kinds[i];
      switch (kind) {
        case ParseError.character:
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              final value = string.runeAt(errorPos);
              final length = value >= 0xffff ? 2 : 1;
              final escaped = _escape(value);
              final error =
                  ParseError(start, start + length, 'Unexpected $escaped');
              result.add(error);
            } else {
              final error = ParseError(start, start, "Unexpected 'EOF'");
              result.add(error);
            }
          } else {
            final error = ParseError(start, start, 'Unexpected character');
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

  static const _templateMemos = '''
final List<MemoizedResult?> _memos = List.filled(150, null);''';

  static const _templateMemoize = '''
  @pragma('vm:prefer-inline')
  void memoize<R>(int id, bool fast, int start, [R? result]) =>
      _memos[id] = MemoizedResult<R>(id, fast, start, pos, ok, result);
''';

  static const _templateMemoized = '''
  @pragma('vm:prefer-inline')
  MemoizedResult<R>? memoized<R>(int id, bool fast, int start) {
    final memo = _memos[id];
    return (memo != null &&
            memo.start == start &&
            (memo.fast == fast || !memo.fast))
        ? memo as MemoizedResult<R>
        : null;
  }
''';

  @override
  String get name => 'State';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    var template = _template;
    final required = {ParseRuntimeCapability.memoization};
    template =
        replace(template, 'memos', _templateMemos, capabilities, required);
    template =
        replace(template, 'memoize', _templateMemoize, capabilities, required);
    template = replace(
        template, 'memoized', _templateMemoized, capabilities, required);
    return template;
  }
}

class _StringExtensionBuilder extends _RuntimeClassBuilder {
  static const _template = '''
extension on String {
  {{contains1}}

  {{contains2}}

  {{contains3}}

  {{contains4}}

  {{contains5}}

  {{tag}}

  {{tag1}}

  {{tag2}}

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

  static const _templateContains1 = '''
  @pragma('vm:prefer-inline')
  bool contains1(int index, int c) => index < length && codeUnitAt(index) == c;
''';

  static const _templateContains2 = '''
  @pragma('vm:prefer-inline')
  bool contains2(int index, int c1, int c2) =>
      index + 1 < length &&
      codeUnitAt(index) == c1 &&
      codeUnitAt(index + 1) == c2;
''';

  static const _templateContains3 = '''
   @pragma('vm:prefer-inline')
  bool contains3(int index, int c0, int c1, int c2) =>
      index + 2 < length &&
      codeUnitAt(index) == c0 &&
      codeUnitAt(index + 1) == c1 &&
      codeUnitAt(index + 2) == c2;
''';

  static const _templateContains4 = '''
  @pragma('vm:prefer-inline')
  bool contains4(int index, int c0, int c1, int c2, int c3) =>
      index + 3 < length &&
      codeUnitAt(index) == c0 &&
      codeUnitAt(index + 1) == c1 &&
      codeUnitAt(index + 2) == c2 &&
      codeUnitAt(index + 3) == c3;
''';

  static const _templateContains5 = '''
  @pragma('vm:prefer-inline')
  bool contains5(int index, int c0, int c1, int c2, int c3, int c4) =>
      index + 4 < length &&
      codeUnitAt(index) == c0 &&
      codeUnitAt(index + 1) == c1 &&
      codeUnitAt(index + 2) == c2 &&
      codeUnitAt(index + 3) == c3 &&
      codeUnitAt(index + 4) == c4;
''';

  static const _templateTag = '''
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String? tag(State<String> state, String tag) {
    // ignore: prefer_is_empty
    if (tag.length == 0) {
      throw ArgumentError('Tag must not be empty');
    }

    final pos = state.pos;
    state.ok = pos < length && codeUnitAt(pos) == tag.codeUnitAt(0) && startsWith(tag, pos);
    if (state.ok) {
      state.pos += tag.length;
      return tag;
    }

    return null;
  }''';

  static const _templateTag1 = '''
  @pragma('vm:prefer-inline')
  String? tag1(State<String> state, String tag) {
    if (tag.length != 1) {
      throw ArgumentError.value(tag, 'tag', 'Length must be equal to 1');
    }

    final pos = state.pos;
    state.ok = pos < length && codeUnitAt(pos) == tag.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
      return tag;
    }

    return null;
  }''';

  static const _templateTag2 = '''
  @pragma('vm:prefer-inline')
  String? tag2(State<String> state, String tag) {
    if (tag.length != 2) {
      throw ArgumentError.value(tag, 'tag', 'Length must be equal to 2');
    }

    final pos = state.pos;
    state.ok = pos + 1 < length &&
        codeUnitAt(pos) == tag.codeUnitAt(0) &&
        codeUnitAt(pos + 1) == tag.codeUnitAt(1);
    if (state.ok) {
      state.pos += 2;
      return tag;
    }

    return null;
  }''';

  @override
  String get name => '_StringExt';

  @override
  String? build(Set<ParseRuntimeCapability> capabilities) {
    var template = _template;
    template = replace(template, 'contains1', _templateContains1, capabilities,
        {ParseRuntimeCapability.contains1});
    template = replace(template, 'contains2', _templateContains2, capabilities,
        {ParseRuntimeCapability.contains2});
    template = replace(template, 'contains3', _templateContains3, capabilities,
        {ParseRuntimeCapability.contains3});
    template = replace(template, 'contains4', _templateContains4, capabilities,
        {ParseRuntimeCapability.contains4});
    template = replace(template, 'contains5', _templateContains5, capabilities,
        {ParseRuntimeCapability.contains5});
    template = replace(template, 'tag', _templateTag, capabilities,
        {ParseRuntimeCapability.tag});
    template = replace(template, 'tag1', _templateTag1, capabilities,
        {ParseRuntimeCapability.tag1});
    template = replace(template, 'tag2', _templateTag2, capabilities,
        {ParseRuntimeCapability.tag2});
    return template;
  }
}
