import 'package:parser_builder/branch.dart';
import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/character.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/multi.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';
import 'package:parser_builder/string.dart';
import 'package:parser_builder/transformers.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  context.optimizeForSize = true;
  final builders = [
    _alpha0,
    _alpha1,
    _alphanumeric0,
    _alphanumeric1,
    _altC16OrC32,
    _anyChar,
    _char16,
    _char32,
    _consumedSeparatedAbcC32,
    _delimited,
    _digit0,
    _digit1,
    _eof,
    _escapeSequence16,
    _escapeSequence32,
    _hexDigit0,
    _hexDigit1,
    _many0C32,
    _many0CountC32,
    _many1C32,
    _many1CountC32,
    _manyMNC32_2_3,
    _manyTillAOrBTillAbc,
    _mapC32ToStr,
    _noneOfC16,
    _noneOfC16OrC32Ex,
    _noneOfC32,
    _noneOfTagsAbcAbdDefDegXXY,
    _notC32OrC16,
    _oneOfC16,
    _oneOfC32,
    _optAbc,
    _pairC16C32,
    _peekC32,
    _precededC16C32,
    _recognize3C32AbcC16,
    _satisfyC16,
    _satisfyC32,
    _separatedList0C32Abc,
    _separatedList1C32Abc,
    _separatedPairC16AbcC32,
    _sequenceC16C32,
    _skipWhile1C16,
    _skipWhile1C32,
    _skipWhileC16,
    _skipWhileC32,
    _tagAbc,
    _tagC16,
    _tagC16C32,
    _tagC32,
    _tagC32C16,
    _tagExFoo,
    _tagNoCaseAbc,
    _tagsAbcAbdDefDegXXY,
    _takeUntilAbc,
    _takeUntil1Abc,
    _takeWhile1C16,
    _takeWhile1C32,
    _takeWhileC16,
    _takeWhileC16UntilAbc,
    _takeWhileC32UntilAbc,
    _takeWhileC32,
    _takeWhileMN_2_4C16,
    _takeWhileMN_2_4C32,
    _terminatedC16C32,
    _testRef_,
    _tuple2C32Abc,
    _tuple3C32AbcC16,
    _valueAbcToTrueValue,
    _valueTrue,
  ];

  final filename = 'test/_test_parser.dart';
  await fastBuild(context, builders, filename,
      addErrorMessageProcessor: false,
      header: header,
      lightweightRuntime: false);
}

const abc = 'abc';

const c16 = 0x50;

const c32 = 0x1d200;

const header = r'''
// ignore_for_file: unused_local_variable

import 'package:tuple/tuple.dart';

''';

const s16 = 'P';

const s32 = '𝈀';

const _alpha0 = Named('alpha0', Alpha0());

const _alpha1 = Named('alpha1', Alpha1());

const _alphanumeric0 = Named('alphanumeric0', Alphanumeric0());

const _alphanumeric1 = Named('alphanumeric1', Alphanumeric1());

const _altC16OrC32 = Named('altC16OrC32', Alt([_char16, _char32]));

const _anyChar = Named('anyChar', AnyChar());

const _char16 = Named('char16', Char(c16));

const _char32 = Named('char32', Char(c32));

const _consumedSeparatedAbcC32 = Named(
    'consumedSeparatedAbcC32', Consumed(SeparatedList1(_tagAbc, _char32)));

const _delimited = Named('delimited', Delimited(_char16, _char32, _char16));

const _digit0 = Named('digit0', Digit0());

const _digit1 = Named('digit1', Digit1());

const _eof = Named('eof', Eof<String>());

const _escapeSequence16 =
    Named('escapeSequence16', EscapeSequence({0x6e: 0xa, 0x72: 0xd, c16: c16}));

const _escapeSequence32 = Named('escapeSequence32',
    EscapeSequence({0x6e: 0xa, 0x72: 0xd, c16: c16, c32: c32}));

const _hexDigit0 = Named('hexDigit0', HexDigit0());

const _hexDigit1 = Named('hexDigit1', HexDigit1());

const _isC16 = CharClass('#x50');

const _isC32 = CharClass('#x1d200');

const _many0C32 = Named('many0C32', Many0(_char32));

const _many0CountC32 = Named('many0CountC32', Many0Count(_char32));

const _many1C32 = Named('many1C32', Many1(_char32));

const _many1CountC32 = Named('many1CountC32', Many1Count(_char32));

const _manyMNC32_2_3 = Named('manyMNC32_2_3', ManyMN(2, 3, _char32));

const _manyTillAOrBTillAbc =
    Named('manyTillAOrBTillAbc', ManyTill(Alt([Tag('a'), Tag('b')]), Tag(abc)));

const _mapC32ToStr = Named(
    'mapC32ToStr',
    Map$(Char(c32),
        Transformer<int, String>('c', '=> String.fromCharCode(c);')));

const _noneOfC16 = Named('noneOfC16', NoneOf([c16]));

const _noneOfC16OrC32Ex = Named('noneOfC16OrC32Ex',
    NoneOfEx(TX('=> state.context.listOfC16AndC32 as List<int>;')));

const _noneOfC32 = Named('noneOfC32', NoneOf([c32]));

const _noneOfTagsAbcAbdDefDegXXY = Named('noneOfTagsAbcAbdDefDegXXY',
    NoneOfTags(['abc', 'abd', 'def', 'deg', 'x', 'xy']));

const _notC32OrC16 = Named('notC32OrC16', Not(Alt([_char16, _char32])));

const _oneOfC16 = Named('oneOfC16', OneOf([c16]));

const _oneOfC32 = Named('oneOfC32', OneOf([c32]));

const _optAbc = Named('optAbc', Opt(Tag(abc)));

const _pairC16C32 = Named('pairC16C32', Pair(_char16, _char32));

const _peekC32 = Named('peekC32', Peek(_char32));

const _precededC16C32 = Named('precededC16C32', Preceded(_char16, _char32));

const _recognize3C32AbcC16 =
    Named('recognize3C32AbcC16', Recognize(Tuple3(_char32, _tagAbc, _char16)));

const _ref = Ref<String, int>('char16');

const _satisfyC16 = Named('satisfyC16', Satisfy(_isC16));

const _satisfyC32 = Named('satisfyC32', Satisfy(_isC32));

const _separatedList0C32Abc =
    Named('separatedList0C32Abc', SeparatedList0(Char(c32), Tag(abc)));

const _separatedList1C32Abc =
    Named('separatedList1C32Abc', SeparatedList1(Char(c32), Tag(abc)));

const _separatedPairC16AbcC32 = Named(
    'separatedPairC16AbcC32', SeparatedPair(Char(c16), Tag(abc), Char(c32)));

const _sequenceC16C32 = Named('sequenceC16C32', Sequence([_char16, _char32]));

const _skipWhile1C16 = Named('skipWhile1C16', SkipWhile1(_isC16));

const _skipWhile1C32 = Named('skipWhile1C32', SkipWhile1(_isC32));

const _skipWhileC16 = Named('skipWhileC16', SkipWhile(_isC16));

const _skipWhileC32 = Named('skipWhileC32', SkipWhile(_isC32));

const _tagAbc = Named('tagAbc', Tag(abc));

const _tagC16 = Named('tagC16', Tag(s16));

const _tagC16C32 = Named('tagC16C32', Tag(s16 + s32));

const _tagC32 = Named('tagC32', Tag(s32));

const _tagC32C16 = Named('tagC32C16', Tag(s32 + s16));

const _tagExFoo =
    Named('tagExFoo', TagEx(TX('=> state.context.foo as String;')));

const _tagNoCaseAbc = Named('tagNoCaseAbc',
    TagNoCase(abc, Transformer<String, String>('s', '=> s.toLowerCase();')));

const _tagsAbcAbdDefDegXXY =
    Named('tagsAbcAbdDefDegXXY', Tags(['abc', 'abd', 'def', 'deg', 'x', 'xy']));

const _takeUntil1Abc = Named('takeUntil1Abc', TakeUntil1(abc));

const _takeUntilAbc = Named('takeUntilAbc', TakeUntil(abc));

const _takeWhile1C16 = Named('takeWhile1C16', TakeWhile1(_isC16));

const _takeWhile1C32 = Named('takeWhile1C32', TakeWhile1(_isC32));

const _takeWhileC16 = Named('takeWhileC16', TakeWhile(_isC16));

const _takeWhileC16UntilAbc =
    Named('takeWhileC16UntilAbc', TakeWhileUntil(_isC16, 'abc'));

const _takeWhileC32 = Named('takeWhileC32', TakeWhile(_isC32));

const _takeWhileC32UntilAbc =
    Named('takeWhileC32UntilAbc', TakeWhileUntil(_isC32, 'abc'));

const _takeWhileMN_2_4C16 =
    Named('takeWhileMN_2_4C16', TakeWhileMN(2, 4, _isC16));

const _takeWhileMN_2_4C32 =
    Named('takeWhileMN_2_4C32', TakeWhileMN(2, 4, _isC32));

const _terminatedC16C32 = Named('terminated', Terminated(_char16, _char32));

const _testRef_ = Named('testRef', _ref);

const _tuple2C32Abc = Named('tuple2C32Abc', Tuple2(_char32, _tagAbc));

const _tuple3C32AbcC16 =
    Named('tuple3C32AbcC16', Tuple3(_char32, _tagAbc, _char16));

const _valueAbcToTrueValue =
    Named('valueAbcToTrueValue', Value(true, Tag(abc)));

const _valueTrue = Named('valueTrue', Value(true));
