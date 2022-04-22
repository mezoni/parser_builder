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
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.codeUnitAt(state.pos);
  state.ok = {{test}};
  if (state.ok) {
    state.pos++;
    {{res0}} = c;
  } else if (state.log) {
    state.error = ErrUnexpected.charAt(state.pos, source);
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template16Fast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final c = source.codeUnitAt(state.pos);
  state.ok = {{test}};
  if (state.ok) {
    state.pos++;
  } else if (state.log) {
    state.error = ErrUnexpected.charAt(state.pos, source);
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.readRune(state);
  state.ok = {{test}};
  if (state.ok) {
    {{res0}} = c;
  } else {
    state.pos = pos;
    if (state.log) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32Fast = '''
state.ok = state.pos < source.length;
if (state.ok) {
  final pos = state.pos;
  final c = source.readRune(state);
  state.ok = {{test}};
  if (!state.ok) {
    state.pos = pos;
    if (state.log) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final SemanticAction<bool> predicate;

  const Satisfy(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'test': fast ? '' : predicate.build(context, 'test', ['c']),
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
}
