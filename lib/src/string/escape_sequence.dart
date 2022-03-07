part of '../../string.dart';

/// Parses the escape sequence and translates the found escaped character into
/// another character and returns the escaped value.
///
/// Example:
/// ```dart
/// EscapeSequence({0x22: 0x22,
///   0x2f: 0x2f,
///   0x5c: 0x5c,
///   0x62: 0x08,
///   0x66: 0x0c,
///   0x6e: 0x0a,
///   0x72: 0x0d,
///   0x74: 0x09
/// }));
/// ```
class EscapeSequence extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  int? v;
  switch (c) {
    {{cases}}
  }
  if (v != null) {
    state.pos++;
    state.ok = true;
    {{res}} = v;
  } else if (!state.opt) {
    if (c > 0xd7ff) {
      c = source.runeAt(state.pos);
    }
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  final pos = state.pos;
  var c = source.codeUnitAt(state.pos++);
  if (c > 0xd7ff) {
    c = source.decodeW2(state, c);
  }
  int? v;
  switch (c) {
    {{cases}}
  }
  if (v != null) {
    state.ok = true;
    {{res}} = v;
  } else {
    state.pos = pos;
    if (!state.opt) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _templateCase = '''
case {{key}}:
  v = {{val}};
  break;''';

  final Map<int, int> table;

  const EscapeSequence(this.table);

  @override
  Map<String, String> getTags(Context context) {
    final cases = <String>[];
    final sameValues =
        table.entries.where((e) => e.key == e.value).map((e) => e.key);
    if (sameValues.isNotEmpty) {
      final sb = StringBuffer();
      for (final value in sameValues) {
        sb.write('case ');
        sb.write(value);
        sb.writeln(':');
      }

      sb.writeln('v = c;');
      sb.write('break;');
      cases.add(sb.toString());
    }

    final sameValuesSet = sameValues.toSet();
    for (final key in table.keys) {
      if (sameValuesSet.contains(key)) {
        continue;
      }

      final value = table[key]!;
      final values = {
        'key': key.toString(),
        'val': value.toString(),
      };
      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    return {
      'cases': cases.join('\n'),
    };
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = table.keys.any((e) => e > 0xffff);
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([table]);
  }
}
