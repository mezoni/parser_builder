part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [arguments] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends _Tags<String> {
  @override
  final List<String> tags;

  const Tags(this.tags);

  @override
  void _onDone(CodeGen code, ParserResult result, bool silent, String pos) {
    final errors = tags
        .map((e) =>
            'ErrExpected.tag($pos, const Tag(${helper.escapeString(e)}))')
        .join(', ');
    code.ifFailure((code) {
      code += silent ? '' : 'state.error = ErrCombined($pos, [$errors]);';
      code.labelFailure(result);
    });
  }

  @override
  void _onInit(CodeGen code) {
    code.setFailure();
  }

  @override
  void _onTag(
      CodeGen code, ParserResult result, bool silent, String pos, String tag) {
    final length = tag.length;
    final value = helper.escapeString(tag);
    if (length == 1) {
      code + 'state.pos++;';
      code.setSuccess();
      code.setResult(result, value);
    } else {
      code.if_('source.startsWith($value, $pos)', (code) {
        code + 'state.pos += $length;';
        code.setSuccess();
        code.setResult(result, value);
        code.break$();
      });
    }
  }
}
