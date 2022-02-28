part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [value] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends StringParserBuilder<String> {
  static const _template = '''
state.ok = true;
switch (state.ch) {
  {{cases}}
}
if ({{res}} == null) {
  state.ok = false;
  state.error =  ErrCombined(state.pos, [{{errors}}]);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTest = '''
if (source.startsWith({{tag}}, state.pos)) {
  state.readChar(state.pos + {{len}});
  {{res}} = {{tag}};
  break;
}''';

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
      final tests = <String>[];
      for (final tag in tags) {
        final values = {
          'len': tag.length.toString(),
          'tag': helper.escapeString(tag),
        };

        final test = render(_templateTest, values);
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
