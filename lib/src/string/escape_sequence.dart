part of '../../string.dart';

class EscapeSequence extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  int? v;
  switch (c) {
    {{cases}}
  }
  if (v != null) {
    state.ok = true;
    state.pos += c > 0xffff ? 2 : 1;
    {{res}} = v;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(c));
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
