part of '../../branch.dart';

class SwitchTag<I extends Utf16Reader, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  state.ok = false;
  {{tests}}
}
if (!state.ok) {
  {{errors}}
}''';

  final List<ParserBuilder<I, O>> errors;

  final Map<String?, ParserBuilder<I, O>> table;

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
    ParseRuntime.addClassUtf16Reader(context);
    final values = context.allocateLocals(['pos']);
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
        final isLong = tag.length > 1;
        final branch = parser.build(context, result);
        final condition = isLong ? 'source.startsWith($escaped, pos)' : '';
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
