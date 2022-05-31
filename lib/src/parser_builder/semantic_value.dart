part of '../../parser_builder.dart';

class SemanticValue<T> {
  final String name;

  SemanticValue(this.name);

  bool get isNullable => helper.isNullableType<T>();

  String get value {
    if (helper.isNullableType<T>()) {
      return name;
    }

    return '$name.as()';
  }
}
