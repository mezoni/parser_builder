part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends StringParserBuilder<String> {
  static const _templateLong16 = '''
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

  static const _templateLong32 = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.runeAt(state.pos);
  if (c == {{cc}} && source.startsWith({{tag}}, state.pos)) {
    state.pos += {{len}};
    state.ok = true;
    {{res}}= {{tag}};
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateShort16 = '''
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

  static const _templateShort32 = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.runeAt(state.pos);
  if (c == {{cc}}) {
    state.pos += 2;
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

    final runes = tag.runes;
    final isShort = runes.length == 1;
    return {
      'cc': helper.toHex(runes.first),
      if (!isShort) 'len': tag.length.toString(),
      'tag': helper.escapeString(tag),
    };
  }

  @override
  String getTemplate(Context context) {
    final runes = tag.runes;
    final has32BitChars = runes.first > 0xffff;
    if (runes.length == 1) {
      if (has32BitChars) {
        return _templateShort32;
      } else {
        return _templateShort16;
      }
    } else {
      if (has32BitChars) {
        return _templateLong32;
      } else {
        return _templateLong16;
      }
    }
  }
}
