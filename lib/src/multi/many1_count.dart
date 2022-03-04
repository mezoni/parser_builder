part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
final {{opt}} = state.opt;
var {{cnt}} = 0;
while (true) {
  state.opt = {{cnt}} != 0;
  {{p1}}
  if (!state.ok) {
    if ({{cnt}} > 0) {
      state.ok = true;
      {{res}} = {{cnt}};
    }
    break;
  }
  {{cnt}}++;
}
state.opt = {{opt}};''';

  final ParserBuilder<I, dynamic> parser;

  const Many1Count(this.parser);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['cnt', 'opt']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
