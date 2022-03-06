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
      if (c > 0xd7ff) {
        c = source.runeAt(state.pos);
      }
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
    var size = 1;
    c = source.codeUnitAt(state.pos);
    if (c > 0xd7ff) {
      c = source.runeAt(state.pos);
      size = c > 0xffff ? 2 : 1;
    }
    final ok = {{cond}};
    if (!ok) {
      break;
    }
    state.pos += size;
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

  final Transformer<int, bool> predicate;

  final String tag;

  const TakeWhileUntil(this.predicate, this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['index']);
    return {
      'tag': helper.escapeString(tag),
      ...locals,
      ...helper.tfToTemplateValues(predicate, key: 'cond', value: 'c'),
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
