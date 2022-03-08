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
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  switch (c) {
    {{cases}}
  }
}
if (state.ok) {
  {{res}} = true;
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, state.pos)) {
  state.ok = false;
  if (!state.opt) {
    state.error = ErrUnexpected.tag(state.pos, const Tag({{tag}}));
  }
  break;
}''';

  static const _templateTestShort = '''
state.ok = false;
if (!state.opt) {
  state.error = ErrUnexpected.tag(state.pos, const Tag({{tag}}));
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
