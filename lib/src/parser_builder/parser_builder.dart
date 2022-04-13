part of '../../parser_builder.dart';

class BuidlResult {
  //
}

abstract class ParserBuilder<I, O> {
  const ParserBuilder();

  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent);

  String getInputType() {
    return '$I';
  }

  String getResultType() {
    final name = '$O';
    final isNullable = isNullableResultType();
    final result = isNullable ? name : '$name?';
    return result;
  }

  String getResultValue(String name) {
    if (name.isEmpty) {
      return '';
    }

    final isNullable = isNullableResultType();
    final type = getResultType();
    return (isNullable ? name : '($name as $type)!');
  }

  String getResultValueUnsafe(String name) {
    if (name.isEmpty) {
      return '';
    }

    final isNullable = isNullableResultType();
    return (isNullable ? name : '$name!');
  }

  bool isAlwaysSuccess() {
    return false;
  }

  bool isNullableResultType() {
    final result = helper.isNullableType<O>();
    return result;
  }

  @override
  String toString() {
    return runtimeType.toString();
  }
}

abstract class StringParserBuilder<O> extends ParserBuilder<String, O> {
  const StringParserBuilder();
}
