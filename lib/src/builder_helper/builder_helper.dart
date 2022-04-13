part of '../../builder_helper.dart';

String addNullCheck<T>(String name) {
  final isNullable = isNullableType<T>();
  return isNullable ? name : '$name!';
}

BuidlResult build(Context context, CodeGen code, ParserBuilder parser,
    ParserResult result, bool silent,
    {void Function(CodeGen code)? onFailure,
    void Function(CodeGen code)? onSuccess}) {
  final statement = Statements(LinkedList<Statement>());
  code + statement;
  BuidlResult? key;
  code.scope(statement.statements, (code) {
    key = parser.build(context, code, result, silent);
  });

  var success = code.getLabelSuccess(key!);
  var failure = code.getLabelFailure(key!);
  final statements = statement.statements;
  final isAlwaysSuccess = parser.isAlwaysSuccess();
  if (isAlwaysSuccess) {
    success = statements;
    failure = null;
  }

  ConditionalStatement? handler;
  ConditionalStatement getHandler() {
    if (handler == null) {
      handler = ConditionalStatement(
          'state.ok', LinkedList<Statement>(), LinkedList<Statement>());
      statements.add(handler!);
    }

    return handler!;
  }

  if (onSuccess != null) {
    if (success == null) {
      final handler = getHandler();
      success = handler.ifBranch;
      failure ??= handler.elseBranch;
    }
  }

  if (onFailure != null) {
    if (failure == null) {
      final handler = getHandler();
      failure = handler.elseBranch;
      success ??= handler.ifBranch;
    }
  }

  if (onSuccess != null) {
    code.scope(success!, onSuccess);
  }

  if (onFailure != null) {
    code.scope(failure!, onFailure);
  }

  return key!;
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
  final valueUnsafe = parser.getResultValueUnsafe(name);
  final result = ParserResult(name, type, value, valueUnsafe);
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
