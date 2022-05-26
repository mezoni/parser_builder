part of '../../semantic_value.dart';

class FromValueAction extends SemanticAction<int> {
  final Object key;

  final bool safe;

  const FromValueAction(this.key, [this.safe = true]);

  @override
  String build(Context context, String name, List<String> arguments) {
    final value = context.getSemanticValue(key);
    return replaceParameters(value.value, const [], arguments);
  }
}
