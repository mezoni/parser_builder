part of '../../parser_builder.dart';

class BuidlResult {
  //
}

abstract class ParserBuilder<I, O> {
  const ParserBuilder();

  void build(Context context, CodeGen code);

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
    return (isNullable ? name : '_unwrap($name)');
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

abstract class UnaryParserBuilder<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const UnaryParserBuilder(this.parser);
}
