part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [value] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends StringParserBuilder<String> {
  static const _template16 = '''
final {{pos}} = state.pos;
if (state.pos < source.length) {
  final c = source.codeUnitAt({{pos}});
  switch (c) {
    {{cases}}
  }
}
state.ok = {{res}} != null;
if (!state.ok && !state.opt) {
  state.error = ErrCombined({{pos}}, [{{errors}}]);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
if (state.pos < source.length) {
  var c = source.codeUnitAt({{pos}});
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt({{pos}});
  switch (c) {
    {{cases}}
  }
}
state.ok = {{res}} != null;
if (!state.ok && !state.opt) {
  state.error = ErrCombined({{pos}}, [{{errors}}]);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, {{pos}})) {
  state.pos += {{len}};
  {{res}} = {{tag}};
  break;
}''';

  static const _templateTestShort = '''
state.pos++;
{{res}} = {{tag}};''';

  final List<String> tags;

  const Tags(this.tags);

  @override
  String getTemplate(Context context) {
    final locals = context.allocateLocals(['c', 'pos']);
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
        }..addAll(locals);

        final runes = tag.runes;
        final templateTest =
            runes.length > 1 ? _templateTestLong : _templateTestShort;
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
      'cases': cases.join('\n'),
      'errors': errors.join(','),
    }..addAll(locals);

    final has32BitChars = tags.map((e) => e.runes.first).any((e) => e > 0xffff);
    final template = has32BitChars ? _template32 : _template16;
    final result = render(template, values);
    return result;
  }
}
