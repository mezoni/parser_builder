part of '../../bytes.dart';

abstract class _Tags<O> extends StringParserBuilder<O> {
  const _Tags();

  List<String> get tags;

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final map = _generateMap();
    _onInit(code);
    final pos = code.savePos();
    code.if_('state.pos < source.length', (code) {
      final c = code.val('c', 'source.codeUnitAt($pos)');
      final sw = code.switch_(c);
      for (final c in map.keys) {
        _buildCase(code, sw, c, map);
      }
    });

    _onDone(code);
  }

  void _buildCase(
      CodeGen code, SwitchStatement sw, int c, Map<int, List<String>> map) {
    final tags = map[c]!;
    tags.sort((x, y) => y.length.compareTo(x.length));
    code.addCase(sw, [c], (code) {
      for (final tag in tags) {
        _onTag(code, tag);
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

  void _onDone(CodeGen code) {
    //
  }

  void _onInit(CodeGen code) {
    //
  }

  void _onTag(CodeGen code, String tag);
}
