part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, _t.Tuple2<List<O1>, O2>> {
  static const _template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O1}}>[];
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

  final ParserBuilder<I, O2> end;

  final ParserBuilder<I, O1> parser;

  const ManyTill(this.parser, this.end);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': end,
      'p2': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['error', 'list', 'pos']);
    return {
      'O1': O1.toString(),
      ...locals,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
