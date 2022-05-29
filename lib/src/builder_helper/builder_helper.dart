part of '../../builder_helper.dart';

String asNullable<T>() {
  if (isNullableType<T>()) {
    return '$T';
  }

  return '$T?';
}

String buildConditional(Map<String, String> branches) {
  if (branches.isEmpty) {
    throw ArgumentError.value(branches, 'branches', 'Must not be empty');
  }

  final conditions = branches.keys.toList();
  if (conditions.length == 1 && conditions.last.trim().isEmpty) {
    return branches[conditions.first]!;
  }

  final list = <String>[];
  String? elseBranch;
  for (var i = 0; i < conditions.length; i++) {
    final condition = conditions[i];
    final body = branches[condition]!;
    if (condition.trim().isEmpty) {
      if (i != conditions.length - 1) {
        throw ArgumentError(
            'A branch without a condition must be the last branch');
      }

      if (conditions.length < 2) {
        throw ArgumentError(
            'A conditional with an empty condition must contain at least 2 branches');
      }

      elseBranch = body;
      continue;
    }

    final sb = StringBuffer();
    sb.writeln('($condition) {');
    sb.writeln(body);
    sb.write('}');
    list.add(sb.toString());
  }

  final sb = StringBuffer();
  sb.write('if ');
  sb.write(list.join(' else if '));
  if (elseBranch != null) {
    sb.writeln(' else {');
    sb.writeln(elseBranch);
    sb.write('}');
  }

  return sb.toString();
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

String getAsCode(Object? value) {
  final result = tryGetAsCode(value);
  if (result != null) {
    return result;
  }

  throw StateError('Unsupported type: ${value.runtimeType}');
}

bool isNullableType<T>() {
  try {
    // ignore: unused_local_variable
    final T val = null as T;
  } catch (e) {
    return false;
  }

  return true;
}

String toHex(int value) {
  if (value < 0) {
    throw ArgumentError.value(
        value, 'value', 'Must be equal to or greater than 0');
  }

  return '0x${value.toRadixString(16).toUpperCase()}';
}

String? tryGetAsCode(Object? value) {
  if (value is String) {
    final escaped = escapeString(value);
    return escaped;
  } else if (value is bool) {
    return '$value';
  } else if (value is num) {
    return '$value';
  } else if (value == null) {
    return '$value';
  } else if (value is Enum) {
    return '${value.runtimeType}.${value.name}';
  } else if (value is List) {
    final values = [];
    for (var item in value) {
      final code = tryGetAsCode(item);
      values.add(code);
    }

    return '[${values.join(', ')}]';
  }

  return null;
}
