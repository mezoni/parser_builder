part of '../../combinator.dart';

class Value<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, dynamic>? parser;

  final O value;

  const Value(this.value, [this.parser]);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser != null) {
      return _buildWithParser(context, code, result, silent);
    } else {
      return _build(context, code, result, silent);
    }
  }

  @override
  bool isAlwaysSuccess() {
    return parser == null ? true : parser!.isAlwaysSuccess();
  }

  BuidlResult _build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final v = helper.getAsCode(value);
    code.setSuccess();
    code.setResult(result, v);
    code.labelSuccess(key);
    return key;
  }

  BuidlResult _buildWithParser(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final v = helper.getAsCode(value);
    final result1 = helper.getResult(context, code, parser!, true);
    helper.build(context, code, parser!, result1, silent, onSuccess: (code) {
      code.setResult(result, v);
      code.labelSuccess(key);
    }, onFailure: (code) {
      code.labelFailure(key);
    });
    return key;
  }
}
