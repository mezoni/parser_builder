part of '../../token.dart';

@experimental
class TokenizeTags<O> extends ParserBuilder<String, O> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  state.ok = false;
  {{tests}}
}
if (!state.ok) {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateFast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  sttae.ok = false;
  {{tests}}
}
if (!state.ok) {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateTestLong = '''
state.pos += {{length}};
state.ok = true;
final v1 = pos;
const v2 = {{tag}};
{{res0}} = {{tokenize}};''';

  static const _templateTestShort = '''
state.pos++;
state.ok = true;
final v1 = pos;
const v2 = {{tag}};
{{res0}} = {{tokenize}};''';

  final Map<String, SemanticAction<O>> table;

  const TokenizeTags(this.table);

  @override
  String build(Context context, ParserResult? result) {
    if (table.isEmpty) {
      throw ArgumentError.value(
          table, 'table', 'The map of tags must not be empty: $this');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final values = <String, String>{};
    final map = <int, List<String>>{};
    for (final tag in table.keys) {
      if (tag.isEmpty) {
        throw ArgumentError.value(table, 'table',
            'The map of tags must not contain empty tags: ${table.keys.join(', ')}');
      }

      final c = tag.codeUnitAt(0);
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
    }

    final branches = <String, String>{};
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String, String>{};
      for (final tag in tags) {
        final length = tag.length;
        final escaped = helper.escapeString(tag);
        final tokenize = table[tag]!;
        final values = {
          'length': '$length',
          'tag': escaped,
          'tokenize':
              fast ? '' : tokenize.build(context, 'tokenize', ['v1', 'v2']),
        };

        final isLong = tag.length > 1;
        final template = isLong ? _templateTestLong : _templateTestShort;
        final branch = render(template, values);
        final condition = isLong ? 'source.startsWith($escaped, pos)' : '';
        tests[condition] = branch;
      }

      final branch = helper.buildConditional(tests);
      branches['c == $c'] = branch;
    }

    values.addAll({
      'tests': helper.buildConditional(branches),
      'type': getResultType(),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
