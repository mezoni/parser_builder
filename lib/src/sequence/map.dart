part of '../../sequence.dart';

class Map2<I, O1, O2, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  const Map2(this.parser1, this.parser2, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
    };
  }
}

class Map3<I, O1, O2, O3, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  const Map3(this.parser1, this.parser2, this.parser3, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
    };
  }
}

class Map4<I, O1, O2, O3, O4, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  const Map4(this.parser1, this.parser2, this.parser3, this.parser4, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
      'p4': parser4,
    };
  }
}

class Map5<I, O1, O2, O3, O4, O5, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  const Map5(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
      'p4': parser4,
      'p5': parser5,
    };
  }
}

class Map6<I, O1, O2, O3, O4, O5, O6, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  const Map6(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
      'p4': parser4,
      'p5': parser5,
      'p6': parser6,
    };
  }
}

class Map7<I, O1, O2, O3, O4, O5, O6, O7, O> extends _Map<I, O> {
  @override
  final Transformer<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  final ParserBuilder<I, O7> parser7;

  const Map7(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6, this.parser7, this.map);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
      'p4': parser4,
      'p5': parser5,
      'p6': parser6,
      'p7': parser7,
    };
  }
}

abstract class _Map<I, O> extends _Sequence<I, O> {
  static const _template = '''
{{transform}}
{{res}} = {{map}};''';

  const _Map();

  Transformer<O> get map;

  @override
  String getTemplate(Context context) {
    final outer = super.getTemplate(context);
    final locals = context.allocateLocals(['map']);
    final parsers = getBuilders();
    final arguments = List.generate(parsers.length, (i) => '{{p${i + 1}_val}}');
    final func = locals['map']!;
    final t =
        Transformation(context: context, name: func, arguments: arguments);
    final values = {
      ...locals,
      'transform': map.declare(t),
      'map': map.invoke(t),
    };
    final inner = render(_template, values);
    return render(outer, {'body': inner});
  }

  @override
  String toString() {
    return printName(getBuilders().values.toList());
  }
}
