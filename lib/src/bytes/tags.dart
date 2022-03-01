part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [value] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends StringParserBuilder<String> {
  static const _template = '''
switch (state.ch) {
  {{cases}}
}
state.ok = {{res}} != null;
if (!state.ok) {
  state.error = ErrCombined(state.pos, [{{errors}}]);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, state.pos)) {
  state.readChar(state.pos + {{len}});
  {{res}} = {{tag}};
  break;
}''';

  static const _templateTestShort = '''
state.readChar(state.pos + 1);
{{res}} = {{tag}};''';

  final List<String> tags;

  const Tags(this.tags);

  @override
  String getTemplate(Context context) {
    final map = <int, List<String>>{};
    final errors = <String>[];
    for (final tag in tags) {
      if (tag.isEmpty) {
        throw ArgumentError.value(
            tags, 'tags', 'The list of tags must not contain empty tags');
      }

      final c = tag.runes.first;
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
      final escaped = helper.escapeString(tag);
      errors.add('ErrExpected.tag(state.pos, Tag($escaped))');
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String>[];
      for (final tag in tags) {
        final values = {
          'len': tag.length.toString(),
          'tag': helper.escapeString(tag),
        };

        final runes = tag.runes;
        final template =
            runes.length > 1 ? _templateTestLong : _templateTestShort;
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

    final values = {
      'cases': cases.join('\n'),
      'errors': errors.join(','),
    };

    final result = render(_template, values);
    return result;
  }
}
