part of '../../parser_builder.dart';

class Ref<I, O> extends ParserBuilder<I, O> {
  final String name;

  const Ref(this.name);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    code.callParse(name, result);
    return key;
  }
}
