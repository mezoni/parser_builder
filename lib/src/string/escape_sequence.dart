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
  final Map<int, int> table;

  const EscapeSequence(this.table);

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final isUnicode = table.keys.any((e) => e > 0xffff);
    if (isUnicode) {
      _build32(context, code);
    } else {
      _build16(context, code);
    }
  }

  void _build16(Context context, CodeGen code) {
    final c = code.local('int?', 'c');
    code.setFailure();
    code.ifNotEof((code) {
      code.assign(c, 'source.codeUnitAt(state.pos)');
      final v = code.local('int?', 'v');
      final sw = code.switch_(c);
      _buildCases(code, sw, c, v);
      code.if_('$v != null', (code) {
        code.addToPos(1);
        code.setSuccess();
        code.setResult(v);
      });
    });
    code.ifFailure((code) {
      code.setError(
          '$c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.charAt(state.pos, source)');
    });
  }

  void _build32(Context context, CodeGen code) {
    final pos = code.savePos();
    final c = code.local('int?', 'c');
    code.setFailure();
    code.ifNotEof((code) {
      code.assign(c, 'source.readRune(state)');
      final v = code.local('int?', 'v');
      final sw = code.switch_(c);
      _buildCases(code, sw, c, v);
      code.if_('$v != null', (code) {
        code.setSuccess();
        code.setResult(v);
      });
    });
    code.ifFailure((code) {
      code.setPos(pos);
      code.setError(
          '$c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char($c))');
    });
  }

  void _buildCases(CodeGen code, SwitchStatement sw, String c, String v) {
    final entries = table.entries;
    final direct = entries.where((e) => e.key == e.value).map((e) => e.key);
    if (direct.isNotEmpty) {
      code.addCase(sw, direct, (code) {
        code.assign(v, c);
        code.break$();
      });
    }

    final exclude = direct.toSet();
    for (final key in table.keys) {
      if (exclude.contains(key)) {
        continue;
      }

      final value = table[key]!;
      code.addCase(sw, [key], (code) {
        code.assign(v, '$value');
        code.break$();
      });
    }
  }
}
