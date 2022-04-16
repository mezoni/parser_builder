part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends StringParserBuilder<String> {
  final String tag;

  const Tag(this.tag);

  @override
  void build(Context context, CodeGen code) {
    if (this.tag.isEmpty) {
      throw ArgumentError.value(this.tag, 'tag', 'The tag must not be empty');
    }

    context.refersToStateSource = true;
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

    code.setState(test);
    code.ifSuccess((code) {
      code.addToPos(length);
      code.setResult(tag);
    }, else_: (code) {
      code.setError('ErrExpected.tag(state.pos, const Tag($tag))');
    });
  }
}
