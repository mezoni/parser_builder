part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
var {{cnt}} = 0;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  {{cnt}}++;
}
state.ok = true;
if (state.ok) {
  {{res}} = {{cnt}};
}
state.log = {{log}};''';

  final ParserBuilder<I, dynamic> parser;

  const Many0Count(this.parser);

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
