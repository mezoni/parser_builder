part of '../../bytes.dart';

/// Parses the keys from hash table [table] as tags and returns the
/// corresponding value from hash table [table].
@experimental
class TagValues<O> extends ParserBuilder<String, O> {
  final Map<String, O> table;

  const TagValues(this.table);

  @override
  String build(Context context, ParserResult? result) {
    final keys = table.keys;
    // TODO: Dart compiler cannot infer type `toList()`
    return SwitchTag<O>(
      Map.fromEntries(keys.map((k) => MapEntry(
            k,
            Value(table[k] as O, AddToPos(k.length)),
          ))),
      keys.map((k) => FailExpected<String, O>(PositionAction(), k)).toList(),
    ).build(context, result);
  }
}
