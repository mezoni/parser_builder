part of '../../string.dart';

class EscapeSequence extends ParserBuilder<String, int> {
  static const _template = '''
state.ok = false;
if (state.ch != State.eof) {
  int? v;
  switch (state.ch) {
    {{cases}}
  }
  if (v != null) {
    state.ok = true;
    state.nextChar();
    {{res}} = v;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(state.ch));
  }
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _templateCase = '''
case {{key}}:
  v = {{val}};
  break;''';

  final Map<int, int> table;

  const EscapeSequence(this.table);

  @override
  Map<String, String> getTags(Context context) {
    final cases = <String>[];
    for (final key in table.keys) {
      final value = table[key]!;
      final values = {
        'key': key.toString(),
        'val': value.toString(),
      };
      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    return {
      'cases': cases.join('\n'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([table]);
  }
}
