part of '../../combinator.dart';

class Value<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, dynamic>? parser;

  final O value;

  const Value(this.value, [this.parser]);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser != null) {
      _buildWithParser(context, code, result, silent);
    } else {
      _build(context, code, result, silent);
    }
  }

  void _build(Context context, CodeGen code, ParserResult result, bool silent) {
    final v = helper.getAsCode(value);
    code.setSuccess();
    code.setResult(result, v);
    code.labelSuccess(result);
  }

  void _buildWithParser(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final v = helper.getAsCode(value);
    final r1 = helper.build(context, code, parser!, silent, true);
    code.ifChildSuccess(r1, (code) {
      code.setResult(result, v);
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
