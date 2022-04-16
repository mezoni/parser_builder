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
  void build(Context context, CodeGen code) {
    final size = controlChar > 0xffff ? 2 : 1;
    code.setSuccess();
    final pos = code.savePos();
    final list = code.val('list', '[]');
    final str = code.local('var', 'str', '\'\'');
    code.while$('state.pos < source.length', (code) {
      final start = code.val('start', 'state.pos');
      final c = code.local('var', 'c', '0');
      code.while$('state.pos < source.length', (code) {
        final pos = code.val('pos', 'state.pos');
        code.assign(c, 'source.readRune(state)');
        final ok = code.val('ok', normalChar.build(context, 'normalChar', [c]));
        code.if_(ok, (code) {
          code.continue$();
        });
        code.setPos(pos);
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
      code.addToPos(size);
      final result = helper.build(context, code, escape, fast: false);
      code.ifSuccess((code) {
        code.if_("$list.isEmpty && $str != ''", (code) {
          code + '$list.add($str);';
        });
        code + '$list.add(${result.value});';
      }, else_: (code) {
        code.setPos(pos);
        code.break$();
      });
    });
    code.ifSuccess((code) {
      code.if_('$list.isEmpty', (code) {
        code.setResult(str);
      }, else_: (code) {
        code.if_('$list.length == 1', (code) {
          final c = code.val('c', '$list[0] as int');
          code.setResult('String.fromCharCode($c)');
        }, else_: (code) {
          final buffer = code.val('buffer', 'StringBuffer()');
          code.iteration('for (var i = 0; i < $list.length; i++)', (code) {
            final obj = code.val('obj', '$list[i]');
            code.if_('$obj is int', (code) {
              code + '$buffer.writeCharCode($obj);';
            }, else_: (code) {
              code + '$buffer.write($obj);';
            });
          });
          code.setResult('$buffer.toString()');
        });
      });
    });
  }
}
