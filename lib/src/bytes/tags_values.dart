part of '../../bytes.dart';

/// Parses the keys from hash table [table] as tags and returns the
/// corresponding value from hash table [table].
@experimental
class TagValues<O> extends ParserBuilder<String, O> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  {{type}} v;
  state.ok =false;
  {{tests}}
  if (state.ok) {
    {{res0}} = v;
  }
}
if (!state.ok) {
  {{errors}}
}''';

  static const _templateFast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  {{type}} v;
  state.ok =false;
  {{tests}}
}
if (!state.ok) {
  {{errors}}
}''';

  static const _templateTestLong = '''
  state.ok = true;
  state.pos += {{length}};
  v = {{value}};''';

  static const _templateTestShort = '''
state.ok = true;
state.pos++;
v = {{value}};''';

  final Map<String, O> table;

  const TagValues(this.table);

  @override
  String build(Context context, ParserResult? result) {
    if (table.isEmpty) {
      throw ArgumentError.value(
          table, 'tags', 'The list of tags must not be empty: $this');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final map = <int, List<String>>{};
    final errors = <String>[];
    for (final tag in table.keys) {
      if (tag.isEmpty) {
        throw ArgumentError.value(table, 'tags',
            'The list of tags must not contain empty tags: $table');
      }

      final c = tag.codeUnitAt(0);
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
      final escaped = helper.escapeString(tag);
      errors.add('state.fail(state.pos, ParseError.expected, 0, $escaped);');
    }

    final branches = <String, String>{};
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String, String>{};
      for (final tag in tags) {
        final length = tag.length;
        final value = table[tag];
        final escaped = helper.escapeString(tag);
        final values = {
          'length': '$length',
          'tag': escaped,
          'value': helper.getAsCode(value),
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
      'errors': errors.join('\n'),
      'tests': helper.buildConditional(branches),
      'type': getResultType(),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
