part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  static const _template = '''
var {{cnt}} = 0;
while (true) {
  {{p1}}
  if (!state.ok) {
    if ({{cnt}} > 0) {
      state.ok = true;
      {{res}} = {{cnt}};
    }
    break;
  }
  {{cnt}}++;
}''';

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
    return context.allocateLocals(['cnt']);
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
