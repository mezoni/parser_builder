import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class GetResult<I, O> extends ParserBuilder<I, O> {
  final Object key;

  const GetResult(this.key);

  @override
  void build(Context context, CodeGen code) {
    if (!context.context.containsKey(key)) {
      throw StateError('Result key not found: $key');
    }

    final result = context.context[key] as ParserResult;
    code.setSuccess();
    code.setResult(result.name, false);
  }
}
