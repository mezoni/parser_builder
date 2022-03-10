part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends StringParserBuilder<String> {
  static const _templateLong = '''
state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == {{cc}} && source.startsWith({{tag}}, state.pos);
if (state.ok) {
  state.pos += {{len}};
  {{res}} = {{tag}};
} else if (state.log) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateOne = '''
state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos++;
  {{res}} = {{tag}};
} else if (state.log) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateTwo = '''
state.ok = state.pos + 1 < source.length && source.codeUnitAt(state.pos) == {{cc}} && source.codeUnitAt(state.pos + 1) == {{cc2}};
if (state.ok) {
  state.pos += 2;
  {{res}} = {{tag}};
} else if (state.log) {
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
      if (tag.length == 2) 'cc2': tag.codeUnitAt(1).toString(),
      if (tag.length > 1) 'len': tag.length.toString(),
      'tag': helper.escapeString(tag),
    };
  }

  @override
  String getTemplate(Context context) {
    switch (tag.length) {
      case 1:
        return _templateOne;
      case 2:
        return _templateTwo;
      default:
        return _templateLong;
    }
  }
}
