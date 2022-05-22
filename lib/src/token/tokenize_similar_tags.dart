part of '../../token.dart';

@experimental
class TokenizeSimilarTags<O, O1> extends ParserBuilder<String, O> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  String? tag;
  {{O1}} id;
  state.ok = false;
  {{tests}}
  if (id != null) {
    state.ok = true;
    final v1 = pos;
    final v2 = tag!;
    final v3 = id;
    {{res0}} = {{tokenize}};
  }
}
if (!state.ok) {
  state.fail(state.pos, ParseError.character, null);
}''';

  static const _templateFast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  {{O1}} id;
  sttae.ok = false;
  {{tests}}
  sttae.ok = id != null;
}
if (!state.ok) {
  state.fail(state.pos, ParseError.character, null);
}''';

  static const _templateTestLong = '''
state.pos += {{length}};
id = {{id}};
tag = {{tag}};''';

  static const _templateTestShort = '''
state.pos++;
id = {{id}};
tag = {{tag}};''';

  final Map<String, O1> table;

  final SemanticAction<O> tokenize;

  const TokenizeSimilarTags(this.table, this.tokenize);

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
        throw ArgumentError.value(
            table, 'table', 'The map of tags must not contain empty tags');
      }

      final value = table[tag];
      if (value == null) {
        throw ArgumentError.value(
            table, 'table', 'The map of tags must not contain null values');
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
        final id = table[tag];
        final values = {
          'id': helper.getAsCode(id),
          'length': '$length',
          'tag': escaped,
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
      'O1': helper.isNullableType<O1>() ? '$O1' : '$O1?',
      'tests': helper.buildConditional(branches),
      'tokenize':
          fast ? '' : tokenize.build(context, 'tokenize', ['v1', 'v2', 'v3']),
      'type': getResultType(),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
