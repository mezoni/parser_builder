part of '../../bytes.dart';

abstract class _Tags<O> extends StringParserBuilder<O> {
  const _Tags();

  List<String> get tags;

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final map = _generateMap();
    final pos = context.allocateLocal('pos');
    _onInit(code);
    code + 'final $pos = state.pos;';
    code.if_('state.pos < source.length', (code) {
      code + 'final c = source.codeUnitAt($pos);';
      code.switch_('c', (code) {
        for (final c in map.keys) {
          _buildCase(code, result, silent, c, map, pos);
        }
      });
    });

    _onDone(code, result, silent, pos);
  }

  void _buildCase(SwitchCodeGen code, ParserResult result, bool silent, int c,
      Map<int, List<String>> map, String pos) {
    final tags = map[c]!;
    tags.sort((x, y) => y.length.compareTo(x.length));
    code.case_([c], (code) {
      for (final tag in tags) {
        _onTag(code, result, silent, pos, tag);
      }

      code.break$();
    });
  }

  Map<int, List<String>> _generateMap() {
    final result = <int, List<String>>{};
    for (final tag in tags) {
      if (tag.isEmpty) {
        throw ArgumentError.value(tags, 'tags',
            'The list of tags must not contain empty tags: $this');
      }

      final c = tag.codeUnitAt(0);
      var list = result[c];
      if (list == null) {
        list = [];
        result[c] = list;
      }

      list.add(tag);
    }

    return result;
  }

  void _onDone(CodeGen code, ParserResult result, bool silent, String pos);

  void _onInit(CodeGen code);

  void _onTag(
      CodeGen code, ParserResult result, bool silent, String pos, String tag);
}
