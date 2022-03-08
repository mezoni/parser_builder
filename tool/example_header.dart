const header = r'''
// ignore_for_file: unused_local_variable

import 'package:source_span/source_span.dart';

dynamic parse(String source) {
  final state = State(source);
  final result = _json(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result;
}''';
