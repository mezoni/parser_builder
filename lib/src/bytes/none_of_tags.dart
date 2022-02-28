part of '../../bytes.dart';

/// Parses [tags] and returns success if parsing was unsuccessful.
///
/// Example:
/// ```dart
/// NoneOfTags(['true', 'false'])
/// ```
class NoneOfTags extends StringParserBuilder<bool> {
  static const _template = '''
state.ok = true;
switch (state.ch) {
  {{cases}}
}
if (state.ok) {
  {{res}} = true;
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTest = '''
if (source.startsWith({{tag}}, state.pos)) {
  state.ok = false;
  state.error = ErrUnexpected.tag(state.pos, const Tag({{tag}}));
  break;
}''';

  final List<String> tags;

  const NoneOfTags(this.tags);

  @override
  String getTemplate(Context context) {
    final map = <int, List<String>>{};
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
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      final tests = <String>[];
      for (final tag in tags) {
        final values = {
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
    };

    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName([tags]);
  }
}
