import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'codegen/code_gen.dart';
import 'codegen/statements.dart';
import 'parser_builder.dart';

Future<void> fastBuild(Context context, List<Named> builders, String filename,
    {bool addErrorMessageProcessor = true,
    String? footer,
    bool format = true,
    String? header,
    String? partOf,
    Map<String, Named> publish = const {}}) async {
  for (final builder in builders) {
    context.localAllocator = context.localAllocator.clone();
    final statements = LinkedList<Statement>();
    final name = '\$0';
    final type = builder.getResultType();
    final value = builder.getResultValue(name);
    final result = ParserResult(name, type, value);
    final code = CodeGen(statements,
        allocator: context.localAllocator, fast: result.isVoid, result: result);
    builder.build(context, code);
  }

  final declarations = context.globalDeclarations;
  for (final entry in publish.entries) {
    final code = _publish(entry.key, entry.value);
    declarations.insert(0, code);
  }

  if (addErrorMessageProcessor) {
    declarations.add(ParseRuntime.getErrorMessageProcessor());
  }

  declarations.addAll(ParseRuntime.getFunctions());
  declarations.addAll(ParseRuntime.getClasses());
  var code = declarations.join('\n\n');
  if (partOf != null) {
    code = 'part of \'$partOf\';\n\n' + code;
  }

  if (header != null) {
    code = header + code;
  }

  if (footer != null) {
    code += footer;
  }

  File(filename).writeAsStringSync(code);
  if (format) {
    final process =
        await Process.start(Platform.executable, ['format', filename]);
    process.stdout.transform(utf8.decoder).forEach(print);
    process.stderr.transform(utf8.decoder).forEach(print);
  }
}

String _publish(String name, Named builder) {
  const template = r'''
{{O}} {{name}}({{I}} source) {
  final state = State(source);
  final result = {{parse}}(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return {{result}};
}''';

  // TODO
  final isNullableResultType = builder.isNullableResultType();
  var resultType = builder.getResultType();
  if (!isNullableResultType && resultType.endsWith('?')) {
    resultType = resultType.substring(0, resultType.length - 1);
  }

  final values = {
    'I': builder.getInputType(),
    'O': resultType,
    'name': name,
    'parse': builder.name,
    'result': isNullableResultType ? 'result' : 'result!',
  };

  var code = template;
  for (final key in values.keys) {
    final value = values[key]!;
    code = code.replaceAll('{{$key}}', value);
  }

  return code;
}
