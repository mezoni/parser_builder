part of '../../parser_builder.dart';

abstract class ParserBuilder<I, O> {
  const ParserBuilder();

  void build(Context context, CodeGen code, ParserResult result, bool silent);

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
    return (isNullable ? name : '$name!');
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
