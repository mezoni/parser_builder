import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class Check<I, O> extends ParserBuilder<I, O> {
  final SemanticAction error;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> predicate;

  const Check(this.parser, this.predicate, this.error);

  @override
  void build(Context context, CodeGen code) {
    final pos = code.savePos();
    final result = helper.build(context, code, parser,
        fast: false, pos: pos, result: code.result);
    code.ifSuccess((code) {
      final v = code.val('v', result.value);
      code.setState(predicate.build(context, 'predicate', [v]));
      code.ifFailure((code) {
        code.clearResult();
      });
    });
    code.ifFailure((code) {
      code.setPos(pos);
      code.setError(error.build(context, 'error', []));
    });
  }
}
