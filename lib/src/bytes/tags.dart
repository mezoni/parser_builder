part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [arguments] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends StringParserBuilder<String> {
  static const _template = '''
state.ok = false;
final {{pos}} = state.pos;
if (state.pos < source.length) {
  final c = source.codeUnitAt({{pos}});
  switch (c) {
    {{cases}}
  }
}
if (!state.ok && state.log) {
  state.error = ErrCombined({{pos}}, [{{errors}}]);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, {{pos}})) {
  state.pos += {{len}};
  state.ok = true;
  {{res}} = {{tag}};
  break;
}''';

  static const _templateTestShort = '''
state.pos++;
state.ok = true;
{{res}} = {{tag}};''';

  final List<String> tags;

  const Tags(this.tags);

  @override
  String getTemplate(Context context) {
    if (tags.isEmpty) {
      throw ArgumentError.value(
          tags, 'tags', 'The list of tags must not be empty: $this');
    }

    final locals = context.allocateLocals(['c', 'pos']);
    final map = <int, List<String>>{};
    final errors = <String>[];
    for (final tag in tags) {
      if (tag.isEmpty) {
        throw ArgumentError.value(tags, 'tags',
            'The list of tags must not contain empty tags: $this');
      }

      final c = tag.codeUnitAt(0);
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
          ...locals,
          'len': tag.length.toString(),
          'tag': helper.escapeString(tag),
        };

        final templateTest =
            tag.length > 1 ? _templateTestLong : _templateTestShort;
        final test = render(templateTest, values);
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
      ...locals,
      'cases': cases.join('\n'),
      'errors': errors.join(','),
    };

    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName([tags]);
  }
}
