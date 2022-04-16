part of '../../combinator.dart';

class Value<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, dynamic>? parser;

  final O value;

  const Value(this.value, [this.parser]);

  @override
  void build(Context context, CodeGen code) {
    if (parser != null) {
      _buildWithParser(context, code);
    } else {
      _build(context, code);
    }
  }

  void _build(Context context, CodeGen code) {
    code.setSuccess();
    code.setResult(helper.getAsCode(value));
  }

  void _buildWithParser(Context context, CodeGen code) {
    helper.build(context, code, parser!, fast: true);
    code.ifSuccess((code) {
      code.setResult(helper.getAsCode(value));
    });
  }
}
