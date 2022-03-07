part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends StringParserBuilder<String> {
  static const _templateLong = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  if (c == {{cc}} && source.startsWith({{tag}}, state.pos)) {
    state.pos += {{len}};
    state.ok = true;
    {{res}}= {{tag}};
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateShort = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  if (c == {{cc}}) {
    state.pos++;
    state.ok = true;
    {{res}}= {{tag}};
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final String tag;

  const Tag(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    if (tag.isEmpty) {
      throw ArgumentError.value(tag, 'tag', 'The tag must not be empty');
    }

    return {
      'cc': tag.codeUnitAt(0).toString(),
      if (tag.length > 1) 'len': tag.length.toString(),
      'tag': helper.escapeString(tag),
    };
  }

  @override
  String getTemplate(Context context) {
    return tag.length == 1 ? _templateShort : _templateLong;
  }
}
