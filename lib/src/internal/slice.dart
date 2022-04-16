import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class Slice<I> extends ParserBuilder<I, I> {
  final ParserBuilder<I, dynamic> parser;

  const Slice(this.parser);

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final pos = code.savePos(false);
    helper.build(context, code, parser, fast: true, pos: pos);
    code.ifSuccess((code) {
      code.setResult('source.slice($pos, state.pos)');
    });
  }
}
