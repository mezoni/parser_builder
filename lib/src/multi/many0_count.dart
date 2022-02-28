part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
var {{c}} = 0;
while (true) {
  {{p1}}
  if (!state.ok) {
    state.ok = true;
    {{res}} = {{c}};
    break;
  }
  {{c}}++;
}''';

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
    return context.allocateLocals(['c']);
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
