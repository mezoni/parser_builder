part of '../../bytes.dart';

/// Parses [tag] case-insensitively with the [convert] function and returns
/// [tag].
///
/// Example:
/// ```dart
/// TagNoCase('if')
/// ```
class TagNoCase extends StringParserBuilder<String> {
  final SemanticAction<String> convert;

  final String tag;

  const TagNoCase(this.tag, this.convert);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final length = this.tag.length;
    final tag = helper.escapeString(this.tag);
    final convert = this.convert.build(context, 'convert', ['v1']);
    code.setFailure();
    code.if_('state.pos + $length <= source.length', (code) {
      code + 'final v1 = source.substring(state.pos, state.pos + $length);';
      code + 'final v2 = $convert;';
      code.if_('v2 == $tag', (code) {
        code + 'state.pos += $length;';
        code.setSuccess();
        code.setResult(result, 'v1');
        code.labelSuccess(result);
      });
    });
    code.ifFailure((code) {
      code += silent
          ? ''
          : 'state.error = ErrExpected.tag(state.pos, const Tag($tag));';
      code.labelFailure(result);
    });
  }
}
