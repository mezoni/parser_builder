part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends ParserBuilder<String, String> {
  static const _templateLong = '''
state.ok = state.ch == {{cc}} && state.source.startsWith({{tag}}, state.pos);
if (state.ok) {
  state.readChar(state.pos + {{len}});
  {{res}}= {{tag}};
} else {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateShort = '''
state.ok = state.ch == {{cc}};
if (state.ok) {
  state.nextChar();
  {{res}}= {{tag}};
} else {
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
