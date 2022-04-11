part of '../../bytes.dart';

class FindTag extends StringParserBuilder<int> {
  final String tag;

  const FindTag(this.tag);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    if (this.tag.isEmpty) {
      throw ArgumentError.value(this.tag, 'tag', 'The tag must not be empty');
    }

    context.refersToStateSource = true;
    final index = context.allocateLocal('index');
    final tag = helper.escapeString(this.tag);
    code + 'final $index = source.indexOf($tag, state.pos);';
    code.setState('$index >= 0');
    code.ifSuccess((code) {
      code.setResult(result, index);
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent
          ? ''
          : 'state.error = ErrExpected.tag(state.pos, const Tag($tag));';
      code.labelFailure(result);
    });
  }
}
