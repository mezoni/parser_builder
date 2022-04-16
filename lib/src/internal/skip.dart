import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class Skip<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, int> count;

  const Skip(this.count);

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final result =
        helper.build(context, code, count, fast: false, result: code.result);
    code.ifSuccess((code) {
      final count = code.val('count', result.value);
      code.setState('state.pos + $count <= source.length');
      code.ifSuccess((code) {
        code.addToPos(count);
      });
    });
    code.ifFailure((code) {
      code.errorUnexpectedEof('state.pos');
    });
  }
}
