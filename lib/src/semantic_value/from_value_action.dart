part of '../../semantic_value.dart';

class FromValueAction extends SemanticAction<int> {
  final Object key;

  const FromValueAction(this.key);

  @override
  String build(Context context, String name, List<String> arguments) {
    final value = context.getSemanticValue(key);
    return replaceParameters(value.value, const [], arguments);
  }
}
