part of '../../bytes.dart';

/// Parses [tag] case-insensitively with the [convert] function and returns
/// [tag].
///
/// Example:
/// ```dart
/// TagNoCase('if')
/// ```
class TagNoCase extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = false;
if (state.pos + {{length}} <= source.length) {
  final v1 = source.substring(state.pos, state.pos + {{length}});
  final v2 = v1.toLowerCase();
  if (v2 == {{tag}}) {
    state.ok = true;
    state.pos += {{length}};
    {{res0}} = v1;
  }
}
if (!state.ok && state.log) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  static const _templateFast = '''
state.ok = false;
if (state.pos + {{length}} <= source.length) {
  final v1 = source.substring(state.pos, state.pos + {{length}});
  final v2 = v1.toLowerCase();
  if (v2 == {{tag}}) {
    state.ok = true;
    state.pos += {{length}};
  }
}
if (!state.ok && state.log) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final String tag;

  const TagNoCase(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = {
      'length': '${tag.length}',
      'lowerCase': helper.escapeString(tag.toLowerCase()),
      'tag': helper.escapeString(tag),
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
