import 'dart:convert';
import 'dart:io';

import 'parser_builder.dart';

Future<void> fastBuild(Context context, List<Named> parsers, String filename,
    {bool addErrorMessageProcessor = true,
    String? footer,
    bool format = true,
    String? header,
    String? partOf,
    Map<String, Named> publish = const {}}) async {
  for (var i = 0; i < 2; i++) {
    context.pass = i;
    context.globalDeclarations.clear();
    context.globalRegistry.clear();
    context.globalAllocator = context.globalAllocator.clone();
    context.classDeclarations.clear();
    for (final parser in parsers) {
      context.localAllocator = context.localAllocator.clone();
      final result = context.getResult(parser, true);
      parser.build(context, result);
    }
  }

  final declarations = context.globalDeclarations;
  for (final entry in publish.entries) {
    final code = _publish(entry.key, entry.value);
    declarations.insert(0, code);
  }

  if (addErrorMessageProcessor) {
    declarations.add(ParseRuntime.getErrorMessageProcessor());
  }

  final classDeclarations = context.classDeclarations;
  final classNames = classDeclarations.keys.toList();
  classNames.sort();
  for (final className in classNames) {
    final code = classDeclarations[className]!;
    declarations.add(code);
  }

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
    final message = _errorMessage(source, state.errors);
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
