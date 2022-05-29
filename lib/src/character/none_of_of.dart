part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// list of characters obtained as the result returned by the parser [chars].
///
/// Example:
/// ```dart
/// NoneOfOf(GetChars()))
/// ```
class NoneOfOf extends ParserBuilder<Utf16Reader, int> {
  static const _template = '''
if (state.pos < source.length) {
  {{var1}}
  {{p1}}
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    final list = {{val1}};
    for (var i = 0; i < list.length; i++) {
      final ch = list[i];
      if (c == ch) {
        state.pos = pos;
        state.ok = false;
        state.fail(state.pos, ParseError.character);
        break;
      }
    }
    if (state.ok) {
      {{res0}} = c;
    }
  }
} else {
  state.fail(state.pos, ParseError.character);
  state.ok = false;
}''';

  static const _templateFast = '''
if (state.pos < source.length) {
  {{var1}}
  {{p1}}
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    final list = {{val1}};
    for (var i = 0; i < list.length; i++) {
      final ch = list[i];
      if (c == ch) {
        state.pos = pos;
        state.ok = false;
        state.fail(state.pos, ParseError.character);
        break;
      }
    }
  }
} else {
  state.fail(state.pos, ParseError.character);
  state.ok = false;
}''';

  final ParserBuilder<Utf16Reader, List<int>> chars;

  const NoneOfOf(this.chars);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    ParseRuntime.addClassUtf16Reader(context);
    final fast = result == null;
    final r1 = context.getResult(chars, true);
    final values = {
      'p1': chars.build(context, r1),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
