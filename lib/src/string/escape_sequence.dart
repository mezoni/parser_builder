part of '../../string.dart';

class EscapeSequence extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.{{read}}(state.pos);
  int? v;
  switch (c) {
    {{cases}}
  }
  if (v != null) {
    state.ok = true;
    state.pos += {{size}};
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
    final sameValues =
        table.entries.where((e) => e.key == e.value).map((e) => e.key);
    if (sameValues.isNotEmpty) {
      final sb = StringBuffer();
      for (final value in sameValues) {
        sb.write('case ');
        sb.write(value);
        sb.writeln(':');
      }

      sb.writeln('v = c;');
      sb.write('break;');
      cases.add(sb.toString());
    }

    final sameValuesSet = sameValues.toSet();
    for (final key in table.keys) {
      if (sameValuesSet.contains(key)) {
        continue;
      }

      final value = table[key]!;
      final values = {
        'key': key.toString(),
        'val': value.toString(),
      };
      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    final isUnicode = table.keys.any((e) => e > 0xffff);
    return {
      'cases': cases.join('\n'),
      'read': isUnicode ? 'runeAt' : 'codeUnitAt',
      'size': isUnicode ? 'c > 0xffff ? 2 : 1' : '1',
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
