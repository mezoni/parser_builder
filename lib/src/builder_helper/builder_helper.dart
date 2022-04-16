part of '../../builder_helper.dart';

String addNullCheck<T>(String name) {
  final isNullable = isNullableType<T>();
  return isNullable ? name : '$name!';
}

ParserResult build(
  Context context,
  CodeGen code,
  ParserBuilder parser, {
  bool? fast,
  String? pos,
  ParserResult? result,
  bool? silent,
}) {
  final fast_ = code.fast;
  final pos_ = code.pos;
  final result_ = code.result;
  final silent_ = code.silent;
  fast ??= code.fast;
  silent ??= code.silent;
  if (result == null) {
    result = getResult(context, code, parser, fast);
  } else {
    if (fast) {
      if (!result.isVoid) {
        result = getVoidResult(context, code, parser, result);
      }
    } else {
      if (result.isVoid) {
        result = getNotVoidResult(context, code, parser, result);
      }
    }
  }

  if (context.diagnose) {
    if (parser is Named) {
      final mode = <String>[];
      if (silent) {
        mode.add('silent');
      }

      final fast = result.isVoid;
      final type = parser.getResultType();
      if (fast && type != 'void') {
        mode.add('fast');
      }

      if (mode.isNotEmpty) {
        final buffer = StringBuffer();
        buffer.write('Named parser ');
        buffer.write(parser.name);
        buffer.write(': called as ');
        buffer.write(mode.join(', '));
        print(buffer);
      }
    }
  }

  code.fast = fast;
  code.pos = pos;
  code.result = result;
  code.silent = silent;
  parser.build(context, code);
  code.fast = fast_;
  code.pos = pos_;
  code.result = result_;
  code.silent = silent_;
  return result;
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

ParserResult getNotVoidResult(
    Context context, CodeGen code, ParserBuilder parser, ParserResult result) {
  if (!result.isVoid) {
    return result;
  }

  result = getResult(context, code, parser, false);
  return result;
}

ParserResult getResult(
    Context context, CodeGen code, ParserBuilder parser, bool fast) {
  final type = fast ? 'void' : parser.getResultType();
  final name = context.allocateLocal();
  final value = parser.getResultValue(name);
  final result = ParserResult(name, type, value);
  if (!fast) {
    final name = result.name;
    final type = result.type;
    code + '$type $name;';
  }

  return result;
}

ParserResult getVoidResult(
    Context context, CodeGen code, ParserBuilder parser, ParserResult result) {
  if (result.isVoid) {
    return result;
  }

  result = getResult(context, code, parser, true);
  return result;
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
  } else if (value is List) {
    return '[${value.join(', ')}]';
  }

  return null;
}
