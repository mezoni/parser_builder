part of '../../bytes.dart';

/// Parses [tags] and returns success if parsing was unsuccessful.
///
/// Example:
/// ```dart
/// NoneOfTags(['true', 'false'])
/// ```
class NoneOfTags extends _Tags<void> {
  @override
  final List<String> tags;

  const NoneOfTags(this.tags);

  @override
  void _onDone(CodeGen code, ParserResult result, bool silent, String pos) {
    //
  }

  @override
  void _onInit(CodeGen code) {
    code.setSuccess();
  }

  @override
  void _onTag(
      CodeGen code, ParserResult result, bool silent, String pos, String tag) {
    final length = tag.length;
    final value = helper.escapeString(tag);
    if (length == 1) {
      code.setFailure();
      code += silent
          ? ''
          : 'state.error = ErrUnexpected.tag($pos, const Tag($value));';
    } else {
      code.if_('source.startsWith($value, $pos)', (code) {
        code.setFailure();
        code += silent
            ? ''
            : 'state.error = ErrUnexpected.tag($pos, const Tag($value));';
        code.break$();
      });
    }
  }
}
