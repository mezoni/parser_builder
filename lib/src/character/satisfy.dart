part of '../../character.dart';

/// Parses a single character, and if [predicate] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  {{transform}}
  if (test(c)) {
    state.ok = true;
    state.pos += c > 0xffff ? 2 : 1;
    {{res}} = c;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final Transformer<int, bool> predictate;

  const Satisfy(this.predictate);

  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': predictate.transform('test'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([predictate]);
  }
}
