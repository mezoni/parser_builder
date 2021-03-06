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
  {{next}}
}''';

  static const _templateParserFast = '''
{{p1}}
if (state.ok) {
  {{next}}
}''';

  static const _templateParserLastFast = '''
{{p1}}''';

  const _Sequence();

  @override
  String build(Context context, ParserResult? result) {
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final results = <ParserResult>[];
    var templateParsers = '{{next}}';
    for (var i = 0; i < parsers.length; i++) {
      final parser = parsers[i];
      var useResult = !fast;
      if (!fast) {
        useResult = _useParserResult(parser, i);
      }

      final r1 = context.getResult(parser, useResult);
      if (r1 != null) {
        results.add(r1);
      }

      final index = results.length;
      final values = {
        'p1': parser.build(context, r1),
        'var1': '{{var$index}}',
      };
      final String template;
      if (i == parsers.length - 1 && !useResult && fast) {
        template = _templateParserLastFast;
      } else if (useResult) {
        template = _templateParser;
      } else {
        template = _templateParserFast;
      }

      final templateParser = render(template, values);
      values.clear();
      values.addAll({
        'next': templateParser,
      });
      templateParsers = render(templateParsers, values);
    }

    if (!fast) {
      values.addAll({
        'next': _setResult(context, results),
      });
    } else {
      values.addAll({
        'next': ' //',
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

  bool _useParserResult(ParserBuilder parser, int index);
}
