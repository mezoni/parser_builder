part of '../../memoization.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This is a lightweight implementation of (on demand) memoization with saving
/// only one state of parsing (just for a specific case)
///
/// This parser works as follows:
///
/// After parsing, the parsed state is stored for a current position.
///
/// If a parsed state is requested for a saved position, then the parsed state
/// is restored.
@experimental
class Memoize<I, O> extends ParserBuilder<I, O> {
  static const _template =
      '''
final {{memo}} = state.memoized<{{type}}>({{id}}, false, state.pos);
if ({{memo}} != null) {
  {{res0}} = {{memo}}.restore(state);
} else {
  final {{pos}} = state.pos;
  {{p1}}
  state.memoize<{{type}}>({{id}}, false, {{pos}}, {{res0}});
}''';

  static const _templateFast =
      '''
final {{memo}} = state.memoized<{{type}}>({{id}}, true, state.pos);
if ({{memo}} != null) {
  {{memo}}.restore(state);
} else {
  final {{pos}} = state.pos;
  {{p1}}
  state.memoize<{{type}}>({{id}}, true, {{pos}});
}''';

  final ParserBuilder<I, O> parser;

  const Memoize(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    ParseRuntime.addClassMemoizedResult(context);
    final fast = result == null;
    final values = context.allocateLocals(['memo', 'pos']);
    final id = _allocateId(context);
    values.addAll({
      'id': '$id',
      'p1': parser.build(context, result),
      'type': parser.getResultType(),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }

  int _allocateId(Context context) {
    int getId() {
      var id = context.readRegistryValue(
          context.globalRegistry, Memoize, 'id', () => 0);
      context.writeRegistryValue(context.globalRegistry, Memoize, 'id', id + 1);
      return id;
    }

    final result =
        context.readRegistryValue(context.globalRegistry, this, 'id', getId);
    return result;
  }
}
