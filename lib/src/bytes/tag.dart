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
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (c == {{cc}} && source.startsWith({{tag}}, state.pos)) {
    state.ok = true;
    state.pos += {{len}};
    {{res}}= {{tag}};
  }
}
if (!state.ok) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateShort = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (c == {{cc}}) {
    state.ok = true;
    state.pos++;
    {{res}}= {{tag}};
  }
}
if (!state.ok) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final String tag;

  const Tag(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    if (tag.isEmpty) {
      throw ArgumentError.value(tag, 'tag', 'The tag must not be empty');
    }

    final runes = tag.runes;
    final short = runes.length == 1;
    return {
      'cc': helper.toHex(runes.first),
      if (!short) 'len': tag.length.toString(),
      'tag': helper.escapeString(tag),
    };
  }

  @override
  String getTemplate(Context context) {
    if (tag.runes.length == 1) {
      return _templateShort;
    }

    return _templateLong;
  }
}
