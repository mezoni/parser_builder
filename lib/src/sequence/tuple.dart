part of '../../sequence.dart';

class Tuple2<I, O1, O2> extends _Tuple<I, _t.Tuple2<O1, O2>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  const Tuple2(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
    };
  }
}

class Tuple3<I, O1, O2, O3> extends _Tuple<I, _t.Tuple3<O1, O2, O3>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  const Tuple3(this.parser1, this.parser2, this.parser3);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
      'p3': parser3,
    };
  }
}

class Tuple4<I, O1, O2, O3, O4> extends _Tuple<I, _t.Tuple4<O1, O2, O3, O4>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  const Tuple4(this.parser1, this.parser2, this.parser3, this.parser4);

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

class Tuple5<I, O1, O2, O3, O4, O5>
    extends _Tuple<I, _t.Tuple5<O1, O2, O3, O4, O5>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  const Tuple5(
      this.parser1, this.parser2, this.parser3, this.parser4, this.parser5);

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

class Tuple6<I, O1, O2, O3, O4, O5, O6>
    extends _Tuple<I, _t.Tuple6<O1, O2, O3, O4, O5, O6>> {
  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  const Tuple6(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6);

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

class Tuple7<I, O1, O2, O3, O4, O5, O6, O7>
    extends _Tuple<I, _t.Tuple7<O1, O2, O3, O4, O5, O6, O7>> {
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

abstract class _Tuple<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{body}}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  const _Tuple();

  @override
  String getTemplate(Context context) {
    final locals = context.allocateLocals(['pos']);
    final count = getBuilders().length;
    String plunge(int i) {
      const template1 = '''
{{p}}
 if (state.ok) {
   {{body}}
 }''';

      const template2 = '''
{{res}} = Tuple{{size}}({{values}});''';

      var body = '';
      if (i < count) {
        body = plunge(i + 1);
      } else {
        final values = {
          'size': '$i',
          'values': List.generate(i, (i) => '{{p${i + 1}_val}}').join(', '),
        };

        body = render(template2, values);
      }

      final values = {
        'p': '{{p$i}}',
        'p_res': '{{p${i}_res}}',
        'body': body,
      };

      return render(template1, values);
    }

    final body = plunge(1);
    final values = {
      'body': body,
    }..addAll(locals);
    final result = render(_template, values);
    return result;
  }

  @override
  String toString() {
    return printName(getBuilders().values.toList());
  }
}
