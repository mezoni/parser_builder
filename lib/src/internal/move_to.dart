import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class MoveTo<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, int> position;

  const MoveTo(this.position);

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final pos = code.savePos();
    final result = helper.build(context, code, position,
        fast: false, result: code.result, pos: pos);
    code.ifSuccess((code) {
      final v = code.val('v', result.value);
      code.setState('$v <= source.length');
      code.ifSuccess((code) {
        code.setPos(v);
      }, else_: (code) {
        code.setPos(pos);
        code.errorUnexpectedEof(pos);
      });
    });
  }
}
