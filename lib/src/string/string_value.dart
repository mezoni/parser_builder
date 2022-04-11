part of '../../string.dart';

/// Parses the value of a string data type using the [normalChar] predicate to
/// parse regular (unescaped) characters, using the [controlChar] character to
/// match an escape character, and the [escape] parser to parse the
/// interpretation of the escape sequence.
///
/// Example:
/// ```dart
/// StringValue(_isNormalChar, 0x5c, _escaped);
/// ```
class StringValue extends StringParserBuilder<String> {
  final int controlChar;

  final ParserBuilder<String, int> escape;

  final SemanticAction<bool> normalChar;

  const StringValue(this.normalChar, this.controlChar, this.escape);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final c = context.allocateLocal('c');
    final list = context.allocateLocal('list');
    final pos = context.allocateLocal('pos');
    final size = controlChar > 0xffff ? 2 : 1;
    final start = context.allocateLocal('start');
    final str = context.allocateLocal('str');
    final normalChar = this.normalChar.build(context, 'normalChar', [c]);
    code.setSuccess();
    code + 'final $pos = state.pos;';
    code + 'final $list = [];';
    code + "var $str = '';";
    code.while$('state.pos < source.length', (code) {
      code + 'final $start = state.pos;';
      code + 'var $c = 0;';
      code.while$('state.pos < source.length', (code) {
        code + 'final pos = state.pos;';
        code + '$c = source.readRune(state);';
        code + 'final ok = $normalChar;';
        code.if_('ok', (code) {
          code.continue$();
        });
        code + 'state.pos = pos;';
        code.break$();
      });
      code +
          "$str = state.pos == $start ? '' : source.substring($start, state.pos);";
      code.if_("$str != '' && $list.isNotEmpty", (code) {
        code + '$list.add($str);';
      });
      code.if_('$c != $controlChar', (code) {
        code.break$();
      });
      code + 'state.pos += $size;';
      final r1 = helper.build(context, code, escape, silent, false);
      code.ifChildFailure(r1, (code) {
        code + 'state.pos = $pos;';
        code.break$();
      });
      code.if_("$list.isEmpty && $str != ''", (code) {
        code + '$list.add($str);';
      });
      code + '$list.add(${r1.value});';
    });
    code.ifSuccess((code) {
      code.if_(
        '$list.isEmpty',
        (code) {
          code.setResult(result, str);
        },
        else_: (code) {
          code.if_('$list.length == 1', (code) {
            code + 'final c = $list[0] as int;';
            code.setResult(result, 'String.fromCharCode(c)');
          }, else_: (code) {
            code + 'final buffer = StringBuffer();';
            code.iteration('for (var i = 0; i < $list.length; i++)', (code) {
              code + 'final obj = $list[i];';
              code.if_('obj is int', (code) {
                code + 'buffer.writeCharCode(obj);';
              }, else_: (code) {
                code + 'buffer.write(obj);';
              });
            });
            code.setResult(result, 'buffer.toString()');
          });
        },
      );
      code.labelSuccess(result);
    });
  }
}
