part of '../../character.dart';

/// Parses a single character, and if [chars] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends ParserBuilder<String, int> {
  static const _template16 = '''
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  state.ok = {{test}};
  if (state.ok) {
    state.pos++;
    {{res0}} = c;
  } else {
    state.fail(state.pos, ParseError.character);
  }
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _template16Fast = '''
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  state.ok = {{test}};
  if (state.ok) {
    state.pos++;
  } else {
    state.fail(state.pos, ParseError.character);
  }
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
if ({{pos}} < source.length) {
  final c = source.readRune(state);
  state.ok = {{test}};
  if (state.ok) {
    {{res0}} = c;
  } else {
    state.pos = {{pos}};
    state.fail({{pos}}, ParseError.character);
  }
} else {
  state.fail({{pos}}, ParseError.character);
}''';

  static const _template32Fast = '''
final {{pos}} = state.pos;
if ({{pos}} < source.length) {
  final c = source.readRune(state);
  state.ok = {{test}};
  if (!state.ok) {
    state.pos = {{pos}};
    state.fail({{pos}}, ParseError.character);
  }
} else {
  state.fail({{pos}}, ParseError.character);
}''';

  static const _templateOne16 = '''
if (source.contains1(state.pos, {{c0}})) {
  state.ok = true;
  state.pos++;
  {{res0}} = {{cc}};
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateOne16Fast = '''
if (source.contains1(state.pos, {{c0}})) {
  state.ok = true;
  state.pos++;
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateOne32 = '''
if (source.contains2(state.pos, {{c0}}, {{c1}})) {
  state.ok = true;
  state.pos += 2;
  {{res0}} = {{cc}};
} else {
  state.fail(state.pos, ParseError.character);
}''';

  static const _templateOne32Fast = '''
if (source.contains2(state.pos, {{c0}}, {{c1}})) {
  state.ok = true;
  state.pos += 2;
} else {
  state.fail(state.pos, ParseError.character);
}''';

  final SemanticAction<bool> predicate;

  const Satisfy(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    if (predicate is CharClass) {
      final charClass = predicate as CharClass;
      final charList = charClass.getCharList();
      if (charList.length == 2 && charList[0] == charList[1]) {
        return _buildOne(context, result);
      }
    }

    return _build(context, result);
  }

  String _build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'test': predicate.build(context, 'test', ['c']),
    });
    final isUnicode = predicate.isUnicode;
    final String template;
    if (isUnicode) {
      if (fast) {
        template = _template32Fast;
      } else {
        template = _template32;
      }
    } else {
      if (fast) {
        template = _template16Fast;
      } else {
        template = _template16;
      }
    }

    return render(template, values, [result]);
  }

  String _buildOne(Context context, ParserResult? result) {
    final fast = result == null;
    final charClass = predicate as CharClass;
    final charList = charClass.getCharList();
    if (charList.length != 2 || charList[0] != charList[1]) {
      throw StateError('Internal error');
    }

    final char = charList[0];
    final str = String.fromCharCode(char);
    final isUnicode = str.length > 1;
    final String template;
    if (isUnicode) {
      template = fast ? _templateOne32Fast : _templateOne32;
    } else {
      template = fast ? _templateOne16Fast : _templateOne16;
    }

    final values = {
      'c0': '${str.codeUnitAt(0)}',
      'c1': isUnicode ? '${str.codeUnitAt(1)}' : '',
      'cc': '$char',
    };
    return render(template, values, [result]);
  }
}
