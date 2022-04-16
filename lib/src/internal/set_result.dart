import '../../builder_helper.dart' as helper;
import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class SetResult<I, O> extends ParserBuilder<I, O> {
  final Object key;

  final ParserBuilder<I, O> parser;

  const SetResult(this.key, this.parser);

  @override
  void build(Context context, CodeGen code) {
    if (context.context.containsKey(key)) {
      throw StateError('Result key already exists: $key');
    }

    final result =
        helper.build(context, code, parser, fast: false, result: code.result);
    context.context[key] = result;
  }
}
