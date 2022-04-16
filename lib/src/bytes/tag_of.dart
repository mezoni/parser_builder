part of '../../bytes.dart';

class TagOf extends StringParserBuilder<String> {
  final ParserBuilder<String, String> tag;

  const TagOf(this.tag);

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final result =
        helper.build(context, code, tag, fast: false, result: code.result);
    code.ifSuccess((code) {
      final tag = code.val('tag', result.value);
      code.setState('source.startsWith($tag, state.pos)');
      code.ifSuccess((code) {
        code.addToPos('$tag.length');
      }, else_: (code) {
        code.clearResult();
        code.setError('ErrExpected.tag(state.pos, Tag($tag))');
      });
    });
  }
}
