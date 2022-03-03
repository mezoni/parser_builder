part of '../../bytes.dart';

/// Parses [tags] and returns success if parsing was unsuccessful.
///
/// Example:
/// ```dart
/// NoneOfTags(['true', 'false'])
/// ```
class NoneOfTags extends StringParserBuilder<bool> {
  static const _template16 = '''
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

  static const _template32 = '''
state.ok = true;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
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
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String>[];
      for (final tag in tags) {
        final values = {
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
    };

    final has32BitChars = tags.map((e) => e.runes.first).any((e) => e > 0xffff);
    final template = has32BitChars ? _template32 : _template16;
    final result = render(template, values);
    return result;
  }

  @override
  String toString() {
    return printName([tags]);
  }
}
