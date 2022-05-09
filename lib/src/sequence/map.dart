part of '../../sequence.dart';

class Map2<I, O1, O2, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  const Map2(this.parser1, this.parser2, this.map);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
    ];
  }
}

class Map3<I, O1, O2, O3, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  const Map3(this.parser1, this.parser2, this.parser3, this.map);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser1,
      parser2,
      parser3,
    ];
  }
}

class Map4<I, O1, O2, O3, O4, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  const Map4(this.parser1, this.parser2, this.parser3, this.parser4, this.map);

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

class Map5<I, O1, O2, O3, O4, O5, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  const Map5(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.map);

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

class Map6<I, O1, O2, O3, O4, O5, O6, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

  final ParserBuilder<I, O1> parser1;

  final ParserBuilder<I, O2> parser2;

  final ParserBuilder<I, O3> parser3;

  final ParserBuilder<I, O4> parser4;

  final ParserBuilder<I, O5> parser5;

  final ParserBuilder<I, O6> parser6;

  const Map6(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6, this.map);

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

class Map7<I, O1, O2, O3, O4, O5, O6, O7, O> extends _Map<I, O> {
  @override
  final SemanticAction<O> map;

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

abstract class _Map<I, O> extends _Sequence<I, O> {
  static const _template = '''
{{arguments}}
{{res0}} = {{map}};''';

  static const _templateArgument = '''
final {{name}} = {{value}};''';

  const _Map();

  SemanticAction<O> get map;

  @override
  String _setResult(Context context, List<ParserResult> results) {
    final code = <String>[];
    final arguments = <String>[];
    for (var i = 0, j = 1; i < results.length; i++, j++) {
      final result = results[i];
      if (result.type != 'void') {
        final argument = 'v$j';
        final value = '{{val$j}}';
        arguments.add(argument);
        final values = {
          'name': argument,
          'value': value,
        };
        final template = render(_templateArgument, values);
        code.add(template);
      }
    }

    final values = {
      'arguments': code.join('\n'),
      'map': map.build(context, 'map', arguments),
    };
    return render(_template, values);
  }

  @override
  bool _useParserResult(ParserBuilder parser, int index) {
    final type = parser.getResultType();
    return type != 'void';
  }
}
