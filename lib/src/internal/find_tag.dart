import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class FindTag extends ParserBuilder<String, int> {
  final String tag;

  const FindTag(this.tag);

  @override
  void build(Context context, CodeGen code) {
    if (this.tag.isEmpty) {
      throw ArgumentError.value(this.tag, 'tag', 'The tag must not be empty');
    }

    context.refersToStateSource = true;
    final tag = helper.escapeString(this.tag);
    final index = code.val('index', 'source.indexOf($tag, state.pos)');
    code.setState('$index >= 0');
    code.ifSuccess((code) {
      code.setResult(index);
    }, else_: (code) {
      code.setError('ErrExpected.tag(state.pos, const Tag($tag))');
    });
  }
}
