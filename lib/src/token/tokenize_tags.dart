part of '../../token.dart';

class TokenizeTags<O> extends StringParserBuilder<O> {
  static const _template = '''
state.ok = true;
final {{pos}} = state.pos;
if ({state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
  }
  switch (state.ch) {
    {{cases}}
  }
}
if ({{res}} == null) {
  state.ok = false;
  state.error =  ErrCombined({{pos}}, [{{errors}}]);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateTest = '''
if (source.startsWith({{tag}}, {{pos}})) {
  {{transform}}
  final start = {{pos}};
  final end = state.pos;
  final v = Tuple3(start, end, source.substring(start, end));
  {{res}} = {{map}};
  state.pos += {{len}};
  break;
}''';

  final Map<String, Transformer<Tuple3<int, int, String>, O>> transformers;

  const TokenizeTags(this.transformers);

  @override
  String getTemplate(Context context) {
    final locals = context.allocateLocals(['pos']);
    final map = <int, List<String>>{};
    final errors = <String>[];
    for (final tag in transformers.keys) {
      if (tag.isEmpty) {
        throw ArgumentError.value(transformers, 'tags',
            'The map of transformers must not contain empty tags');
      }

      final c = tag.runes.first;
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
      final escaped = helper.escapeString(tag);
      errors.add('ErrExpected.tag({{pos}}, const Tag($escaped))');
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      final tests = <String>[];
      for (final tag in tags) {
        final transformer = transformers[tag]!;
        final values = {
          'len': tag.length.toString(),
          'tag': helper.escapeString(tag),
          ...locals,
          'cond': transformer.invoke(context, 'map', 'v'),
          'transform': transformer.declare(context, 'map'),
        };

        final test = render(_templateTest, values);
        tests.add(test);
      }

      final values = {
        'body': tests.join('\n'),
        'cc': c.toString(),
        ...locals,
      };

      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    final values = {
      'cases': cases.join('\n'),
      'errors': errors.join(','),
      ...locals,
    };

    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName([transformers]);
  }
}
