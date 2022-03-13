part of '../../multi.dart';

class ManyTill<I, O> extends ParserBuilder<I, _t.Tuple2<List<O>, O>> {
  static const _template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
for (;;) {
  {{p1}}
  if (state.ok) {
    {{res}} = Tuple2({{list}}, {{p1_val}});
    break;
  }
  final {{error}} = state.error;
  {{p2}}
  if (!state.ok) {
    if (state.log) {
      state.error = ErrCombined(state.pos, [{{error}}, state.error]);
    }
    state.pos = {{pos}};
    break;
  }
  {{list}}.add({{p2_val}});
}''';

  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  const ManyTill(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser2,
      'p2': parser1,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['error', 'list', 'pos']);
    return {
      'O': O.toString(),
      ...locals,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
