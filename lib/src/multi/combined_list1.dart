part of '../../multi.dart';

/// Parses the [parser1] parser and, if successful, parses the [parser2] parser
/// in a loop and returns all results as a list if the list is not.
/// empty.
///
/// Example
/// ```dart
/// CombinedList1(p1, p2)
/// ```
@experimental
class CombinedList1<I, O> extends ParserBuilder<I, List<O>> {
  static const _template = '''
final {{log}} = state.log;
final {{list}} = <{{O}}>[];
{{p1}}
if (state.ok) {
  {{list}}.add({{p1_val}});
  state.log = false;
  for (;;) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{list}}.add({{p2_val}});
  }
}
state.ok = {{list}}.isNotEmpty;
if (state.ok) {
  {{res}} = {{list}};
}
state.log = {{log}};''';

  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  const CombinedList1(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['list', 'log']);
    return {
      'O': O.toString(),
      ...locals,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser1]);
  }
}
