part of '../../memoization.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This is a lightweight implementation of local (on demand) memoization with
/// a short lifetime (within the function body).
///
/// This parser works as follows:
///
/// After parsing, the parsed state is stored for a single position, in a local
/// variable declared at the beginning of the function body.
///
/// If a parsed state is requested for a saved position, then the parsed state
/// is restored (within the function body).
@experimental
class Memoize<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
if ({{memo}}.isStored(state.pos, false)) {
  {{res0}} = {{memo}}.restore(state);
} else {
  final {{pos}} = state.pos;
  {{p1}}
  {{memo}}.store(state, false, {{pos}}, {{res0}});
}''';

  static const _templateFast = '''
if ({{memo}}.isStored(state.pos, true)) {
  {{memo}}.restore(state);
} else {
  final {{pos}} = state.pos;
  {{p1}}
  {{memo}}.store(state, true, {{pos}});
}''';

  final ParserBuilder<I, O> parser;

  const Memoize(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final memo = _allocate(context);
    values.addAll({
      'memo': memo,
      'p1': parser.build(context, result),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }

  String _allocate(Context context) {
    final result = context.readRegistryValue(context.localRegistry, this, 'var',
        () => context.allocateLocal('memo'));
    final type = getResultType();
    context.localDeclarations[result] = 'var $result = _Memo<$type>();';
    return result;
  }
}
