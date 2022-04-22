part of '../../sequence.dart';

abstract class _Sequence<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{parsers}}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  static const _templateParser = '''
{{var1}}
{{p1}}
if (state.ok) {
  {{body}}
}''';

  static const _templateParserFast = '''
{{p1}}
if (state.ok) {
  {{body}}
}''';

  const _Sequence();

  @override
  String build(Context context, ParserResult? result) {
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final fast = result == null;
    final ignoreVoid = !_useResultsOfFastParsers();
    final values = context.allocateLocals(['pos']);
    final results = <ParserResult>[];
    var templateParsers = '{{body}}';
    for (var i = 0; i < parsers.length; i++) {
      final parser = parsers[i];
      final type = parser.getResultType();
      final isVoid = ignoreVoid ? type == 'void' : fast;
      final r1 = context.getResult(parser, !isVoid);
      if (r1 != null) {
        results.add(r1);
      }

      final index = results.length;
      final values = {
        'p1': parser.build(context, r1),
        'var1': '{{var$index}}',
      };
      final templateParser =
          render2(isVoid, _templateParserFast, _templateParser, values);
      values.clear();
      values.addAll({
        'body': templateParser,
      });
      templateParsers = render(templateParsers, values);
    }

    if (!fast) {
      values.addAll({
        'body': _setResult(context, results),
      });
    } else {
      values.addAll({
        'body': ' //',
      });
    }

    templateParsers = render(templateParsers, values);
    values.addAll({
      'parsers': templateParsers,
    });
    return render(_template, values, [result, ...results]);
  }

  List<ParserBuilder<I, dynamic>> _getParsers();

  String _setResult(Context context, List<ParserResult> results);

  bool _useResultsOfFastParsers() {
    return true;
  }
}
