class Token<T> {
  final int end;
  final TokenKind kind;
  final String source;
  final int start;
  final T value;

  Token(this.kind, this.source, this.start, this.end, this.value);

  @override
  int get hashCode =>
      end.hashCode ^
      kind.hashCode ^
      source.hashCode ^
      start.hashCode ^
      value.hashCode;

  @override
  bool operator ==(other) =>
      other is Token<T> &&
      other.end == end &&
      other.kind == kind &&
      other.source == source &&
      other.start == start &&
      other.value == value;
}

enum TokenKind { number, text }
