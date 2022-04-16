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
  void _onDone(CodeGen code) {
    final pos = code.pos;
    final errors = tags
        .map((e) =>
            'ErrExpected.tag($pos, const Tag(${helper.escapeString(e)}))')
        .join(', ');
    code.ifFailure((code) {
      code.setError('ErrCombined($pos, [$errors])');
    });
  }

  @override
  void _onInit(CodeGen code) {
    code.setFailure();
  }

  @override
  void _onTag(CodeGen code, String tag) {
    final length = tag.length;
    final value = helper.escapeString(tag);
    if (length == 1) {
      code.addToPos(1);
      code.setSuccess();
      code.setResult(value);
    } else {
      code.if_('source.startsWith($value, ${code.pos})', (code) {
        code.addToPos(length);
        code.setSuccess();
        code.setResult(value);
        code.break$();
      });
    }
  }
}
