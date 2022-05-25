part of '../../semantic_value.dart';

class FromValueAction extends SemanticAction<int> {
  final String name;

  const FromValueAction(this.name);

  @override
  String build(Context context, String name, List<String> arguments) {
    final value = context.getSemanticValue(this.name);
    return replaceParameters(value.safeValue, const [], arguments);
  }
}
