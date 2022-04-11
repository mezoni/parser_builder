part of '../../parser_builder.dart';

class Ref<I, O> extends ParserBuilder<I, O> {
  final String name;

  const Ref(this.name);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    code.callParse(name, result);
  }
}
