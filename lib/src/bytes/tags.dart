part of '../../bytes.dart';

/// Parses [tags] one by one and returns the first [arguments] found.
///
/// Example:
/// ```dart
/// Tags(['true', 'false'])
/// ```
class Tags extends ParserBuilder<String, String> {
  final List<String> tags;

  const Tags(this.tags);

  @override
  String build(Context context, ParserResult? result) {
    return SwitchTag<String>(
      Map.fromEntries(tags.map((tag) => MapEntry(
            tag,
            Value(tag, AddToPos(tag.length)),
          ))),
      List.generate(tags.length, (i) => FailExpected(StatePos.pos, tags[i])),
    ).build(context, result);
  }
}
