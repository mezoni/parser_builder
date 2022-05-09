part of '../../parser_builder.dart';

abstract class ParserBuilder<I, O> {
  const ParserBuilder();

  void addResultsToTemplateValues(
      Map<String, String> values, List<ParserResult?> results) {
    for (var i = 0; i < results.length; i++) {
      final result = results[i];
      if (result != null) {
        final name = result.name;
        final type = result.type;
        values['res$i'] = name;
        values['val$i'] = result.value;
        values['var$i'] = '$type $name;';
      }
    }
  }

  String build(Context context, ParserResult? result);

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

  String render(String template, Map<String, String> values,
      [List<ParserResult?>? results]) {
    values = Map.from(values);
    if (results != null) {
      addResultsToTemplateValues(values, results);
    }

    for (final key in values.keys) {
      final value = values[key]!;
      template = template.replaceAll('{{$key}}', value);
    }

    return template;
  }

  String render2(bool condition, String template1, String template2,
      Map<String, String> values,
      [List<ParserResult?>? results]) {
    if (condition) {
      final result = render(template1, values, results);
      return result;
    } else {
      final result = render(template2, values, results);
      return result;
    }
  }

  @override
  String toString() {
    return runtimeType.toString();
  }
}

class ParserResult {
  final String name;

  final String type;

  final String value;

  ParserResult(this.name, this.type, this.value);
}
