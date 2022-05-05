part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = {{test}};
if (state.ok) {
  state.pos += {{length}};
  {{res0}} = {{tag}};
} else {
  state.fail(state.pos, ParseError.expected, 0, {{tag}});
}''';

  static const _templateFast = '''
state.ok = {{test}};
if (state.ok) {
  state.pos += {{length}};
} else {
  state.fail(state.pos, ParseError.expected, 0, {{tag}});
}''';

  final String tag;

  const Tag(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    if (this.tag.isEmpty) {
      throw ArgumentError.value(this.tag, 'tag', 'The tag must not be empty');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final cc = this.tag.codeUnitAt(0).toString();
    final tag = helper.escapeString(this.tag);
    final length = this.tag.length;
    final String test;
    switch (length) {
      case 1:
        test =
            'state.pos < source.length && source.codeUnitAt(state.pos) == $cc';
        break;
      case 2:
        final cc2 = this.tag.codeUnitAt(1).toString();
        test =
            'state.pos + 1 < source.length && source.codeUnitAt(state.pos) == $cc && source.codeUnitAt(state.pos + 1) == $cc2';
        break;
      default:
        test =
            'state.pos < source.length && source.codeUnitAt(state.pos) == $cc && source.startsWith($tag, state.pos)';
    }

    final values = {
      'length': '$length',
      'tag': helper.escapeString(this.tag),
      'test': test,
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
