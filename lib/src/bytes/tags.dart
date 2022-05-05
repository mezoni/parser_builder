part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [arguments] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.codeUnitAt(pos);
  String? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
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
  String? v;
  switch (c) {
    {{cases}}
  }
  state.ok = v != null;
}
if (!state.ok) {
  {{errors}}
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, pos)) {
  state.pos += {{lenght}};
  v = {{tag}};
  break;
}''';

  static const _templateTestShort = '''
state.pos++;
v = {{tag}};''';

  final List<String> tags;

  const Tags(this.tags);

  @override
  String build(Context context, ParserResult? result) {
    if (tags.isEmpty) {
      throw ArgumentError.value(
          tags, 'tags', 'The list of tags must not be empty: $this');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final map = <int, List<String>>{};
    final errors = <String>[];
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
      final escaped = helper.escapeString(tag);
      errors.add('state.fail(state.pos, ParseError.expected, 0, $escaped);');
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String>[];
      for (final tag in tags) {
        final length = tag.length;
        final values = {
          'lenght': '$length',
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
      'errors': errors.join('\n'),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
