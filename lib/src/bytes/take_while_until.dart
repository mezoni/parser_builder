part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and until encounters the
/// [tag], sets the position to the position of the found tag and returns a
/// substring of the parsed data excluding the tag.
///
/// Examples:
///
/// ```dart
/// TakeWhileUntil(_CData, ']]>')
/// ```
class TakeWhileUntil extends StringParserBuilder<String> {
  static const _template16 = '''
final {{index}} = source.indexOf({{tag}}, state.pos);
if ({{index}} != -1) {
  final pos = state.pos;
  var c = 0;
  {{transform}}
  while (state.pos < {{index}}) {
    c = source.codeUnitAt(state.pos);
    final ok = {{cond}};
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos == {{index}};
  if (state.ok) {
    {{res}} = pos == state.pos ? '' : source.substring(pos, state.pos);
  } else {
    if (!state.opt) {
      c = source.decodeW2(state.pos, c);
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
    state.pos = pos;
  }
} else {
  state.ok = false;
  if (!state.opt) {
    state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
  }
}''';

  static const _template32 = '''
final {{index}} = source.indexOf({{tag}}, state.pos);
if ({{index}} != -1) {
  final pos = state.pos;
  var c = 0;
  {{transform}}
  while (state.pos < {{index}}) {
    final pos = state.pos;
    c = source.readRune(state);
    final ok = {{cond}};
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = state.pos == {{index}};
  if (state.ok) {
    {{res}} = pos == state.pos ? '' : source.substring(pos, state.pos);
  } else {
    if (!state.opt) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
    state.pos = pos;
  }
} else {
  state.ok = false;
  if (!state.opt) {
    state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
  }
}''';

  final Transformer<bool> predicate;

  final String tag;

  const TakeWhileUntil(this.predicate, this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['index']);
    final t = Transformation(context: context, name: 'cond', arguments: ['c']);
    return {
      ...locals,
      'tag': helper.escapeString(tag),
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }
}
