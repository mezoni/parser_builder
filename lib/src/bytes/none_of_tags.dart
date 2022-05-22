part of '../../bytes.dart';

/// Parses [tags] and returns success if parsing was unsuccessful.
///
/// Example:
/// ```dart
/// NoneOfTags(['true', 'false'])
/// ```
class NoneOfTags extends ParserBuilder<String, void> {
  static const _template = '''
state.ok = true;
if (state.pos < source.length) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  switch (c) {
    {{cases}}
  }
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, pos)) {
  state.ok = false;
  state.fail(pos, ParseError.unexpected, {{tag}}, length: {{length}});
  break;
}''';

  static const _templateTestShort = '''
state.ok = false;
state.fail(pos, ParseError.unexpected, {{tag}}, length: {{length}});''';

  final List<String> tags;

  const NoneOfTags(this.tags);

  @override
  String build(Context context, ParserResult? result) {
    if (tags.isEmpty) {
      throw ArgumentError.value(
          tags, 'tags', 'The list of tags must not be empty: $this');
    }

    context.refersToStateSource = true;
    final values = context.allocateLocals(['pos']);
    final map = <int, List<String>>{};
    for (final tag in tags) {
      if (tag.isEmpty) {
        throw ArgumentError.value(tags, 'tags',
            'The list of tags must not contain empty tags: $tags');
      }

      final c = tag.codeUnitAt(0);
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String>[];
      for (final tag in tags) {
        final values = {
          'length': tag.length.toString(),
          'tag': helper.escapeString(tag),
        };

        final template =
            tag.length > 1 ? _templateTestLong : _templateTestShort;
        final test = render(template, values);
        tests.add(test);
      }

      final values = {
        'body': tests.join('\n'),
        'cc': c.toString(),
      };

      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    values.addAll({
      'cases': cases.join('\n'),
    });
    return render(_template, values, [result]);
  }
}
