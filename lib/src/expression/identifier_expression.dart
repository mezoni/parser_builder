part of '../../expression.dart';

class IdentifierExpression extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.{{readStart}};
  state.ok = {{identStart}};
  if (state.ok) {
    while (state.pos < source.length) {
      final pos = state.pos;
      final c = source.{{readCont}};
      state.ok = {{identCont}};
      if (!state.ok) {
        state.pos = pos;
        break;
      }
    }
    final word = source.slice({{pos}}, state.pos);
    const words = <String>{{words}};
    state.ok = words.isEmpty || !words.contains(word);
    if (state.ok) {
      {{res0}} = word;
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.fail(state.pos, ParseError.expected, 'identifier');
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.{{readStart}};
  state.ok = {{identStart}};
  if (state.ok) {
    while (state.pos < source.length) {
      final pos = state.pos;
      final c = source.{{readCont}};
      state.ok = {{identCont}};
      if (!state.ok) {
        state.pos = pos;
        break;
      }
    }
    final word = source.slice({{pos}}, state.pos);
    const words = <String>{{words}};
    state.ok = words.isEmpty || !words.contains(word);
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.fail(state.pos, ParseError.expected, 'identifier');
}''';

  final SemanticAction<bool> identCont;

  final SemanticAction<bool> identStart;

  final List<String> reservedWords;

  const IdentifierExpression(
      this.reservedWords, this.identStart, this.identCont);

  @override
  String build(Context context, ParserResult? result) {
    for (final item in reservedWords) {
      if (item.isEmpty) {
        throw ArgumentError(
            'The list of reserved words must not contain empty elements');
      }
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final isContUnicode = identCont.isUnicode;
    final isStartUnicode = identStart.isUnicode;
    final sortedWords = reservedWords.toSet().toList();
    sortedWords.sort();
    values.addAll({
      'identCont': identCont.build(context, 'identCont', ['c']),
      'identStart': identStart.build(context, 'identStart', ['c']),
      'readCont': isContUnicode ? 'readRune(state)' : 'codeUnitAt(state.pos++)',
      'readStart':
          isStartUnicode ? 'readRune(state)' : 'codeUnitAt(state.pos++)',
      'words': helper.getAsCode(reservedWords.toSet()),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
