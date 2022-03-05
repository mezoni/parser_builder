part of '../../sequence.dart';

class Sequence<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{pos}} = state.pos;
{{body}}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final List<ParserBuilder<I, dynamic>> parsers;

  const Sequence(this.parsers);

  @override
  Map<String, ParserBuilder> getBuilders() {
    final result = <String, ParserBuilder<I, dynamic>>{};
    for (var i = 0; i < parsers.length; i++) {
      result['p${i + 1}'] = parsers[i];
    }

    return result;
  }

  @override
  String getTemplate(Context context) {
    final locals = context.allocateLocals(['pos']);
    final count = getBuilders().length;
    String plunge(int i) {
      const templateBody = '''
{{p}}
 if (state.ok) {
   {{body}}
 }''';

      const templateLast = '''
{{res}} = true;''';

      var body = '';
      if (i < count) {
        body = plunge(i + 1);
      } else {
        body = render(templateLast, {});
      }

      final values = {
        'p': '{{p$i}}',
        'body': body,
      };
      return render(templateBody, values);
    }

    final body = plunge(1);
    final values = {
      'body': body,
      ...locals,
    };
    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName(parsers);
  }
}
