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
    state.ok = true;
    final text = source.slice({{pos}}, state.pos);
    final length = text.length;
    final c = text.codeUnitAt(0);
    final words = const <List<String>>{{words}};
    var index = -1;
    var min = 0;
    var max = words.length - 1;
    while (min <= max) {
      final mid = min + (max - min) ~/ 2;
      final x = words[mid][0].codeUnitAt(0);
      if (x == c) {
        index = mid;
        break;
      }
      if (x < c) {
        min = mid + 1;
      } else {
        max = mid - 1;
      }
    }
    if (index != -1) {
      final list = words[index];
      for (var i = list.length - 1; i >= 0; i--) {
        final v = list[i];
        if (length > v.length) {
          break;
        }
        if (length == v.length && text == v) {
          state.ok = false;
          break;
        }
      }
    }
    if (state.ok) {
      {{res0}} = text;
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.fail(state.pos, ParseError.expected, 0, 'identifier');
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
    state.ok = true;
    final text = source.slice({{pos}}, state.pos);
    final length = text.length;
    final c = text.codeUnitAt(0);
    final words = const <List<String>>{{words}};
    var index = -1;
    var min = 0;
    var max = words.length - 1;
    while (min <= max) {
      final mid = min + (max - min) ~/ 2;
      final x = words[mid][0].codeUnitAt(0);
      if (x == c) {
        index = mid;
        break;
      }
      if (x < c) {
        min = mid + 1;
      } else {
        max = mid - 1;
      }
    }
    if (index != -1) {
      final list = words[index];
      for (var i = list.length - 1; i >= 0; i--) {
        final v = list[i];
        if (length > v.length) {
          break;
        }
        if (length == v.length && text == v) {
          state.ok = false;
          break;
        }
      }
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
  state.fail(state.pos, ParseError.expected, 0, 'identifier');
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
    final words = <List<String>>[];
    final firstChars = sortedWords.map((e) => e.codeUnitAt(0)).toSet().toList();
    for (final item in firstChars) {
      final selected =
          sortedWords.where((e) => e.codeUnitAt(0) == item).toList();
      words.add(selected);
    }

    values.addAll({
      'identCont': identCont.build(context, 'identCont', ['c']),
      'identStart': identStart.build(context, 'identStart', ['c']),
      'readCont': isContUnicode ? 'readRune(state)' : 'codeUnitAt(state.pos++)',
      'readStart':
          isStartUnicode ? 'readRune(state)' : 'codeUnitAt(state.pos++)',
      'words': helper.getAsCode(words),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
