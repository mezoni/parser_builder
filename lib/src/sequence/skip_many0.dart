part of '../../sequence.dart';

class SkipMany0<I> extends ParserBuilder<I, bool> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
for (;;) {
  final {{pos}} = state.pos;
  {{body}}
  state.pos = {{pos}};
  state.ok = true;
  {{res}} = true;
  break;
}
state.opt = {{opt}};''';

  final List<ParserBuilder<I, dynamic>> parsers;

  const SkipMany0(this.parsers);

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
    final locals = context.allocateLocals(['opt', 'pos']);
    final count = getBuilders().length;
    String plunge(int i) {
      const templateBody = '''
{{p}}
 if (state.ok) {
   {{body}}
 }
 ''';

      const templateLast = '''
continue;''';

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
    }..addAll(locals);
    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName(parsers);
  }
}
