part of '../../bytes.dart';

class TagOf extends StringParserBuilder<String> {
  final ParserBuilder<String, String> tag;

  const TagOf(this.tag);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final key = BuidlResult();
    final result1 = helper.getResult(context, code, tag, false);
    helper.build(context, code, tag, result1, silent, onSuccess: (code) {
      code + 'final tag = ${result1.value};';
      code.setState('source.startsWith(tag, state.pos)');
      code.ifSuccess((code) {
        code + 'state.pos += tag.length;';
        code.setResult(result, 'tag');
        code.labelSuccess(key);
      }, else_: (code) {
        code +=
            silent ? '' : 'state.error = ErrExpected.tag(state.pos, Tag(tag));';
      });
    });
    return key;
  }
}
