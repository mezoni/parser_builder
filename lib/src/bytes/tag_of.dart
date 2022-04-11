part of '../../bytes.dart';

class TagOf extends StringParserBuilder<String> {
  final ParserBuilder<String, String> tag;

  const TagOf(this.tag);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final r1 = helper.build(context, code, tag, silent, false);
    code.ifChildSuccess(r1, (code) {
      code + 'final tag = ${r1.value};';
      code.setState('source.startsWith(tag, state.pos)');
      code.ifSuccess((code) {
        code + 'state.pos += tag.length;';
        code.setResult(result, 'tag');
        code.labelSuccess(result);
      }, else_: (code) {
        code +=
            silent ? '' : 'state.error = ErrExpected.tag(state.pos, Tag(tag));';
      });
    });
  }
}
