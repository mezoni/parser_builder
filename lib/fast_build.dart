import 'dart:convert';
import 'dart:io';

import 'parser_builder.dart';

Future<void> fastBuild(
    Context context, List<ParserBuilder> builders, String filename,
    {bool addErrorMessageProcessor = true,
    String? footer,
    bool format = true,
    String? header,
    bool lightweightRuntime = true,
    String? partOf}) async {
  for (final builder in builders) {
    builder.build(context);
  }

  final declarations = context.declarations;
  if (addErrorMessageProcessor) {
    declarations.add(ParseRuntime.getErrorMessageProcessor());
  }

  declarations
      .addAll(ParseRuntime.getClasses(lightweightRuntime: lightweightRuntime));
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
