part of '../../capture.dart';

class CapturedValueAction extends SemanticAction<int> {
  final Object key;

  const CapturedValueAction(this.key);

  @override
  String build(Context context, String name, List<String> arguments) {
    final value = context.getSemanticValue(key);
    return replaceParameters(value.value, const [], arguments);
  }
}
