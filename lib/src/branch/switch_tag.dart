part of '../../branch.dart';

@experimental

/// Designed for creating parsers using manual look-ahead. String data is used
/// as parameters for look ahead.
///
/// The null value is used to indicate the default parsing (when no match is
/// found).
///
/// It is allowed (and recommended) to specify the generated errors (in the
/// form of a list of errors), in case of unsuccessful parsing.
///
/// If the list of generated errors is not specified, then only one error is
/// generated: `[ErrUnexpected.charOrEof(state.pos, source)]`.
///
/// Example:
/// ```dart
/// SwitchTag({
///  '"': _string,
///  '{': _object,
///  '[': _array,
///  'false': Skip(5, ExprTransformer<bool>.value('false')),
///  'true': Skip(4, ExprTransformer<bool>.value('true')),
///  'null': Skip(4, ExprTransformer.value('null')),
///  null: _number,
///}, ExprTransformer.value('''
///[
///  ErrExpected.tag(state.pos, const Tag('[')),
///  ErrExpected.tag(state.pos, const Tag('{')),
///  ErrExpected.tag(state.pos, const Tag('false')),
///  ErrExpected.tag(state.pos, const Tag('null')),
///  ErrExpected.tag(state.pos, const Tag('number')),
///  ErrExpected.tag(state.pos, const Tag('string')),
///  ErrExpected.tag(state.pos, const Tag('true'))
///]'''));
/// ```
class SwitchTag<O> extends StringParserBuilder<O> {
  static const _template = '''
final {{pos}} = state.pos;
var {{matched}} = false;
state.ok = false;
if ({{pos}} < source.length) {
  final c = source.codeUnitAt({{pos}});
  switch (c) {
    {{cases}}
  }
}
if (!state.ok && state.log) {
  {{transform}}
  List<Err> errors = {{errors}};
  if ({{matched}}) {
    errors.add(state.error);
  }
  state.error = ErrCombined(state.pos, errors);
}''';

  static const _templateCase = '''
case {{cc}}:
  {{body}}
  break;''';

  static const _templateDefault = '''
default:
  {{matched}} = true;
  {{p1}}
  if (state.ok) {
    {{res}} = {{p1_res}};
  }
''';

  static const _templateTestLong = '''
if (source.startsWith({{tag}}, {{pos}})) {
  {{matched}} = true;
  {{p1}}
  if (state.ok) {
    {{res}} = {{p1_res}};
  }
  break;
}''';

  static const _templateTestShort = '''
{{matched}} = true;
{{p1}}
if (state.ok) {
  {{res}} = {{p1_res}};
}''';

  final Transformer? errors;

  final Map<String?, ParserBuilder<String, O>> table;

  const SwitchTag(this.table, [this.errors]);

  @override
  String getTemplate(Context context) {
    final locals = context.allocateLocals(['errors', 'matched', 'pos']);
    final map = <int, List<String>>{};
    final tags = table.keys.where((e) => e != null).cast<String>();
    for (final tag in tags) {
      if (tag.isEmpty) {
        throw ArgumentError.value(
            table, 'table', 'The table must not contain empty tags: $this');
      }

      final c = tag.codeUnitAt(0);
      var list = map[c];
      if (list == null) {
        list = [];
        map[c] = list;
      }

      list.add(tag);
    }

    final cases = <String>[];
    for (final c in map.keys) {
      final tags = map[c]!;
      tags.sort((x, y) => y.length.compareTo(x.length));
      final tests = <String>[];
      for (final tag in tags) {
        final parser = table[tag]!;
        final r = context.allocateLocal();
        final values = {
          ...locals,
          'p1': parser.buildAndAssign(context, r),
          'p1_res': r,
          'res': context.resultVariable,
          'tag': helper.escapeString(tag),
        };
        final template =
            tag.length > 1 ? _templateTestLong : _templateTestShort;
        final test = render(template, values);
        tests.add(test);
      }

      final values = {
        ...locals,
        'body': tests.join('\n'),
        'cc': c.toString(),
      };

      final case_ = render(_templateCase, values);
      cases.add(case_);
    }

    if (table.containsKey(null)) {
      final parser = table[null]!;
      final r = context.allocateLocal();
      final values = {
        ...locals,
        'p1': parser.buildAndAssign(context, r),
        'p1_res': r,
        'res': context.resultVariable,
      };
      final case_ = render(_templateDefault, values);
      cases.add(case_);
    }

    final handler = this.errors ??
        ExprTransformer.value('[ErrUnexpected.charOrEof(state.pos, source)]');
    final errors = locals['errors']!;
    final t = Transformation(context: context, name: errors, arguments: []);
    final values = {
      ...locals,
      'cases': cases.join('\n'),
      'transform': handler.declare(t),
      'errors': handler.invoke(t),
    };

    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName([table, errors]);
  }
}
