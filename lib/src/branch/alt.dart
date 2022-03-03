part of '../../branch.dart';

/// Parses [parsers] one by one and returns the first successful results.
class Alt<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
for (;;) {
  {{body}}
  if (!state.opt) {
    state.error = ErrCombined(state.pos, [{{errors}}]);
  }
  break;
}''';

  static const _templateChoice = '''
{{p2}}
if (state.ok) {
  {{res}} = {{p2_res}};
  break;
}
final {{e}} = state.error;''';

  final List<ParserBuilder<I, O>> parsers;

  const Alt(this.parsers);

  @override
  Map<String, String> getTags(Context context) {
    final errors = <String>[];
    final body = StringBuffer();
    for (var i = 0; i < parsers.length; i++) {
      final p = parsers[i];
      final values = <String, String>{};
      final r = context.allocateLocal();
      final e = context.allocateLocal();
      errors.add(e);
      values['e'] = e;
      values['p2'] = p.buildAndAssign(context, r);
      values['p2_res'] = r;
      values['res'] = context.resultVariable;
      final code = render(_templateChoice, values);
      body.write(code);
    }

    return {
      'errors': errors.join(', '),
      'body': body.toString(),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
