part of '../../bytes.dart';

@experimental
class TakeWhile1Fold<O> extends StringParserBuilder<O> {
  static const _template16 = '''
final {{pos}} = state.pos;
var {{acc}} = {{init}};
{{transform1}}
{{transform2}}
{{transform3}}
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (ok) {
    {{fold}};
    state.pos++;
    continue;
  }
  break;
}
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res}} = {{acc}};
} else if (state.log) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos))) : state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
var {{c}} = 0;
var {{acc}} = {{init}};
{{transform1}}
{{transform2}}
while (state.pos < source.length) {
  final pos = state.pos;
  {{c}} = source.readRune(state.pos);
  final ok = {{cond}};
  if (ok) {
    {{fold}};
    continue;
  }
  statae.pos = pos;
  break;
}
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res}} = {{acc}};
} else if (state.log) {
   state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : state.error = ErrUnexpected.eof(state.pos);
}''';

  final Transformer<O> combine;

  final Transformer<O> initialize;

  final Transformer<bool> predicate;

  const TakeWhile1Fold(this.predicate, this.initialize, this.combine);

  @override
  Map<String, String> getTags(Context context) {
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    final locals = context.allocateLocals(
        ['acc', if (has32BitChars) 'c', 'cond', 'fold', 'init', 'pos']);
    final acc = locals['acc']!;
    final c = has32BitChars ? locals['c']! : 'c';
    final cond = locals['cond']!;
    final fold = locals['fold']!;
    final init = locals['init']!;
    final t1 = Transformation(context: context, name: cond, arguments: [c]);
    final t2 = Transformation(context: context, name: init, arguments: []);
    final t3 =
        Transformation(context: context, name: fold, arguments: [acc, c]);
    return {
      ...locals,
      'transform1': predicate.declare(t1),
      'cond': predicate.invoke(t1),
      'transform2': initialize.declare(t2),
      'init': initialize.invoke(t2),
      'transform3': combine.declare(t3),
      'fold': combine.invoke(t3),
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
