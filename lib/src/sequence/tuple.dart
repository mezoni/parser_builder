part of '../../sequence.dart';

class Tuple2<I, O1, O2> extends _Tuple<I, tuple.Tuple2<O1, O2>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  const Tuple2(this.parser1, this.parser2);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
    ];
  }
}

class Tuple3<I, O1, O2, O3> extends _Tuple<I, tuple.Tuple3<O1, O2, O3>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  const Tuple3(this.parser1, this.parser2, this.parser3);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
    ];
  }
}

class Tuple4<I, O1, O2, O3, O4>
    extends _Tuple<I, tuple.Tuple4<O1, O2, O3, O4>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  const Tuple4(this.parser1, this.parser2, this.parser3, this.parser4);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
      parser4,
    ];
  }
}

class Tuple5<I, O1, O2, O3, O4, O5>
    extends _Tuple<I, tuple.Tuple5<O1, O2, O3, O4, O5>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  const Tuple5(
      this.parser1, this.parser2, this.parser3, this.parser4, this.parser5);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
      parser4,
      parser5,
    ];
  }
}

class Tuple6<I, O1, O2, O3, O4, O5, O6>
    extends _Tuple<I, tuple.Tuple6<O1, O2, O3, O4, O5, O6>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  const Tuple6(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
      parser4,
      parser5,
      parser6,
    ];
  }
}

class Tuple7<I, O1, O2, O3, O4, O5, O6, O7>
    extends _Tuple<I, tuple.Tuple7<O1, O2, O3, O4, O5, O6, O7>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  final ParserBuilder<I, O7> parser7;

  const Tuple7(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6, this.parser7);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
      parser4,
      parser5,
      parser6,
      parser7,
    ];
  }
}

abstract class _Tuple<I, O> extends _Sequence<I, O> {
  static const _template = '''
{{res0}} = Tuple{{size}}({{values}});''';

  const _Tuple();

  @override
  String _setResult(Context context, List<ParserResult> results) {
    final size = results.length;
    final values = {
      'size': '$size',
      'values': results.map((e) => e.value).join(', '),
    };
    return render(_template, values);
  }
}
