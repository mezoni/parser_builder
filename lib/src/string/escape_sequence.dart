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
class EscapeSequence extends ParserBuilder<String, int> {
  static const _template16 = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.codeUnitAt(state.pos);
  int? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
  if (state.ok) {
    state.pos++;
    {{res0}} = v;
  } else {
    final c = source.runeAt(state.pos);
    state.fail(state.pos, ParseError.unexpected(0, c));
  }
} else {
  state.fail(state.pos, const ParseError.unexpected(0, 'EOF'));
}''';

  static const _template16Fast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.codeUnitAt(state.pos);
  int? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
  if (state.ok) {
    state.pos++;
    state.ok = true;
  } else {
    final c = source.runeAt(state.pos);
    state.fail(state.pos, ParseError.unexpected(0, c));
  }
} else {
  state.fail(state.pos, const ParseError.unexpected(0, 'EOF'));
}''';

  static const _template32 = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.readRune(state);
  int? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
  if (state.ok) {
    {{res0}} = v;
  } else {
    state.pos = pos;
    state.fail(state.pos, ParseError.unexpected(0, c));
  }
} else {
  state.fail(state.pos, const ParseError.unexpected(0, 'EOF'));
}''';

  static const _template32Fast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.readRune(state);
  int? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
  if (!state.ok) {
    state.pos = pos;
    state.fail(state.pos, ParseError.unexpected(0, c));
  }
} else {
  state.fail(state.pos, const ParseError.unexpected(0, 'EOF'));
}''';

  final Map<int, int> table;

  const EscapeSequence(this.table);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final isUnicode = table.keys.any((e) => e > 0xffff);
    final String template;
    if (isUnicode) {
      if (fast) {
        template = _template32Fast;
      } else {
        template = _template32;
      }
    } else {
      if (fast) {
        template = _template16Fast;
      } else {
        template = _template16;
      }
    }

    final values = {
      'cases': _buildCases(),
    };
    return render(template, values, [result]);
  }

  String _buildCases() {
    final cases = <String>[];
    final entries = table.entries;
    final direct = entries.where((e) => e.key == e.value).map((e) => e.key);
    if (direct.isNotEmpty) {
      final sink = StringBuffer();
      for (final key in direct) {
        sink.writeln('case $key:');
      }

      sink.writeln('v = c;');
      sink.write('break;');
      cases.add(sink.toString());
    }

    final exclude = direct.toSet();
    for (final key in table.keys) {
      if (!exclude.contains(key)) {
        final sink = StringBuffer();
        final value = table[key]!;
        sink.writeln('case $key:');
        sink.writeln('v = $value;');
        sink.write('break;');
        cases.add(sink.toString());
      }
    }

    return cases.join('\n');
  }
}
