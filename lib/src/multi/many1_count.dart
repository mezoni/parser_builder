part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
final {{log}} = state.log;
var {{cnt}} = 0;
while (true) {
  state.log = {{cnt}} == 0 ? {{log}} : false;
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{cnt}}++;
}
if ({{cnt}} > 0) {
  state.ok = true;
  {{res}} = {{cnt}};
}
state.log = {{log}};''';

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
    return context.allocateLocals(['cnt', 'log']);
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
