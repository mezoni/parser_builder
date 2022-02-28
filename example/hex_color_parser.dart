import 'package:source_span/source_span.dart';
import 'package:tuple/tuple.dart';

import 'hex_color_parser_helper.dart';

part 'hex_color_parser.g.dart';

void main() {
  final s = '#2F14DF';
  final r = parse(s);
  print(r);
}

Color parse(String s) {
  final state = State(s);
  final r = _parse(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    throw _errorMessage(state.source, errors);
  }
  return r!;
}
