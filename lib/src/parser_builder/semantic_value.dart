part of '../../parser_builder.dart';

class SemanticValue<T> {
  final String name;

  SemanticValue(this.name);

  bool get isNullable => helper.isNullableType<T>();

  String get safeValue {
    return '$name as $T';
  }

  String get value {
    if (helper.isNullableType<T>()) {
      return name;
    }

    return '$name!';
  }

  static String nextKey() {
    final previous = DateTime.now().microsecondsSinceEpoch;
    while (true) {
      final current = DateTime.now().microsecondsSinceEpoch;
      if (current != previous) {
        return '$current';
      }
    }
  }
}
