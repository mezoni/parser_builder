part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
var {{cnt}} = 0;
while (true) {
  {{p1}}
  if (!state.ok) {
    state.ok = true;
    {{res}} = {{cnt}};
    break;
  }
  {{cnt}}++;
}
state.opt = {{opt}};''';

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
    return context.allocateLocals(['opt', 'cnt']);
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
