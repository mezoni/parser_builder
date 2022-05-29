part of '../../bytes.dart';

/// Parses [tag] and returns [tag].
///
/// Example:
/// ```dart
/// Tag('{')
/// ```
class Tag extends ParserBuilder<String, String> {
  static const _templateForSpeed = '''
state.ok = {{test}};
if (state.ok) {
  state.pos += {{length}};
  {{res0}} = {{tag}};
} else {
  state.fail(state.pos, ParseError.expected, {{tag}});
}''';

  static const _templateForSpeedFast = '''
state.ok = {{test}};
if (state.ok) {
  state.pos += {{length}};
} else {
  state.fail(state.pos, ParseError.expected, {{tag}});
}''';

  static const _templateForSize = '''
{{res0}} = source.tag{{size}}(state, {{tag}});''';

  static const _templateForSizeFast = '''
source.tag{{size}}(state, {{tag}});''';

  final String tag;

  const Tag(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    if (tag.isEmpty) {
      throw ArgumentError.value(tag, 'tag', 'The tag must not be empty');
    }

    context.refersToStateSource = true;
    if (context.optimizeForSize) {
      return _buildForSize(context, result);
    } else {
      return _buildForSpeed(context, result);
    }
  }

  String _buildForSize(Context context, ParserResult? result) {
    final fast = result == null;
    final length = tag.length;
    final String size;
    switch (length) {
      case 1:
        size = '1';
        break;
      case 2:
        size = '2';
        break;
      default:
        size = '';
    }

    final values = {
      'size': size,
      'tag': helper.escapeString(tag),
    };
    return render2(
        fast, _templateForSizeFast, _templateForSize, values, [result]);
  }

  String _buildForSpeed(Context context, ParserResult? result) {
    final fast = result == null;
    final cc = tag.codeUnitAt(0).toString();
    final length = tag.length;
    final String test;
    switch (length) {
      case 1:
        test =
            'state.pos < source.length && source.codeUnitAt(state.pos) == $cc';
        break;
      case 2:
        final cc2 = tag.codeUnitAt(1).toString();
        test =
            'state.pos + 1 < source.length && source.codeUnitAt(state.pos) == $cc && source.codeUnitAt(state.pos + 1) == $cc2';
        break;
      default:
        test =
            'state.pos < source.length && source.codeUnitAt(state.pos) == $cc && source.startsWith($tag, state.pos)';
    }

    final values = {
      'length': '$length',
      'tag': helper.escapeString(tag),
      'test': test,
    };
    return render2(
        fast, _templateForSpeedFast, _templateForSpeed, values, [result]);
  }
}
