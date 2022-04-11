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
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final isUnicode = table.keys.any((e) => e > 0xffff);
    if (isUnicode) {
      _build32(context, code, result, silent);
    } else {
      _build16(context, code, result, silent);
    }
  }

  void _build16(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final c = context.allocateLocal('c');
    code + 'int? $c;';
    code.setState('state.pos < source.length');
    code.setFailure();
    code.if_('state.pos < source.length', (code) {
      code + '$c = source.codeUnitAt(state.pos);';
      code + 'int? v;';
      code.switch_(c, (code) {
        _buildCases(code, c);
      });
      code.if_('v != null', (code) {
        code + 'state.pos++;';
        code.setSuccess();
        code.setResult(result, 'v');
        code.labelSuccess(result);
      });
    });
    code.ifFailure((code) {
      code += silent
          ? ''
          : 'state.error =  $c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.charAt(state.pos, source);';
      code.labelFailure(result);
    });
  }

  void _build32(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final c = context.allocateLocal('c');
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    code + 'int? $c;';
    code.setState('state.pos < source.length');
    code.setFailure();
    code.if_('state.pos < source.length', (code) {
      code + '$c = source.readRune(state);';
      code + 'int? v;';
      code.switch_(c, (code) {
        _buildCases(code, c);
      });
      code.if_('v != null', (code) {
        code.setSuccess();
        code.setResult(result, 'v');
        code.labelSuccess(result);
      });
    });
    code.ifFailure((code) {
      code + 'state.pos = $pos;';
      code += silent
          ? ''
          : 'state.error = $c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char($c));';
      code.labelFailure(result);
    });
  }

  void _buildCases(SwitchCodeGen code, String c) {
    final entries = table.entries;
    final direct = entries.where((e) => e.key == e.value).map((e) => e.key);
    if (direct.isNotEmpty) {
      code.case_(direct, (code) {
        code + 'v = $c;';
        code.break$();
      });
    }

    final exclude = direct.toSet();
    for (final key in table.keys) {
      if (exclude.contains(key)) {
        continue;
      }

      final value = table[key]!;
      code.case_([key], (code) {
        code + 'v = $value;';
        code.break$();
      });
    }
  }
}
