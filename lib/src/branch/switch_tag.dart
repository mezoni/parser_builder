part of '../../branch.dart';

class SwitchTag<O> extends ParserBuilder<String, O> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  final {{pos}} = state.pos;
  final c = source.codeUnitAt({{pos}});
  {{tests}}
}
if (!state.ok) {
  {{errors}}
}''';

  final List<ParserBuilder<String, O>> errors;

  final Map<String?, ParserBuilder<String, O>> table;

  const SwitchTag(this.table, this.errors);

  @override
  String build(Context context, ParserResult? result) {
    if (table.isEmpty) {
      throw ArgumentError.value(
          table, 'table', 'The map of tags must not be empty: $this');
    }

    if (errors.length != table.length) {
      throw ArgumentError.value(table, 'tags',
          'The length of the error list (${errors.length}) does not match the tag table.: ${table.keys.join(', ')}');
    }

    context.refersToStateSource = true;
    final values = context.allocateLocals(['pos']);
    final pos = values['pos']!;
    final map = <int, List<String>>{};
    for (final tag in table.keys) {
      if (tag == null) {
        continue;
      }

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
        final escaped = helper.escapeString(tag);
        final parser = table[tag]!;
        final length = tag.length;
        final isLong = length > 1;
        final branch = parser.build(context, result);
        final String test;
        if (length > 1 && length <= 6) {
          final size = length - 1;
          final codeUnits = tag.codeUnits.skip(1).join(', ');
          final contains = 'contains$size';
          ParseRuntime.addCapabilityByName(context, contains, true);
          test = 'source.$contains($pos + 1, $codeUnits)';
        } else {
          test = 'source.startsWith($escaped, $pos)';
        }

        final condition = isLong ? test : '';
        tests[condition] = branch;
      }

      final branch = helper.buildConditional(tests);
      branches['c == $c'] = branch;
    }

    if (table.containsKey(null)) {
      final parser = table[null]!;
      final branch = parser.build(context, result);
      branches[''] = branch;
    }

    values.addAll({
      'errors':
          List.generate(errors.length, (i) => errors[i].build(context, null))
              .join('\n'),
      'tests': helper.buildConditional(branches),
      'type': getResultType(),
    });
    return render(_template, values, [result]);
  }
}
