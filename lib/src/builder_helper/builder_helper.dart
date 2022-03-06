part of '../../builder_helper.dart';

String addNullCheck<T>(String name) {
  final isNullable = isNullableType<T>();
  return isNullable ? name : '$name!';
}

String escapeString(String text, [bool quote = true]) {
  text = text.replaceAll('\\', r'\\');
  text = text.replaceAll('\b', r'\b');
  text = text.replaceAll('\f', r'\f');
  text = text.replaceAll('\n', r'\n');
  text = text.replaceAll('\r', r'\r');
  text = text.replaceAll('\t', r'\t');
  text = text.replaceAll('\v', r'\v');
  text = text.replaceAll('\'', '\\\'');
  text = text.replaceAll('\$', r'\$');
  if (!quote) {
    return text;
  }

  return '\'$text\'';
}

String getAsCode(value) {
  final result = tryGetAsCode(value);
  if (result != null) {
    return result;
  }

  throw StateError('Unsupported type: ${value.runtimeType}');
}

bool isNullableType<T>() {
  try {
    // ignore: unused_local_variable
    T val = null as T;
  } catch (e) {
    return false;
  }

  return true;
}

String tfToExpression(Transformer transformer, String name, String argument) {
  if (transformer.canInline) {
    return transformer.inline(argument);
  } else {
    return transformer.invoke(name, argument);
  }
}

Map<String, String> tfToTemplateValues(Transformer transformer,
    {required String key,
    String? name,
    String transform = 'transform',
    required String value}) {
  name ??= key;
  return {
    transform: transformer.canInline ? '' : transformer.declare(name),
    key: tfToExpression(transformer, name, value),
  };
}

String toHex(int value) {
  if (value < 0) {
    throw ArgumentError.value(
        value, 'value', 'Must be equal to or greater than 0');
  }

  return '0x${value.toRadixString(16).toUpperCase()}';
}

String? tryGetAsCode(value) {
  if (value is String) {
    final escaped = escapeString(value);
    return escaped;
  } else if (value is bool) {
    return '$value';
  } else if (value is num) {
    return '$value';
  } else if (value == null) {
    return '$value';
  }

  return null;
}
