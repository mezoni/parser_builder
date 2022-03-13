import 'dart:typed_data';

import 'package:parser_builder/transformers.dart';

void main(List<String> args) {
  final array1 = _createBitArray([31 - 1, 63 + 1]);
  final ranges2 = CharClass(
          '[#x100-#x150] | [#x200-#x250] | [#x300-#x350] | [#x400-#x450] | [#x500-#x550] | [#x600-#x650] | [#x700-#x750] | [#x800-#x850] | [#x900-#x950]')
      .getCharList();
  final array2 = _createBitArray(ranges2);
}

Uint32List _createBitArray(List<int> ranges) {
  final first = ranges.first;
  final last = ranges.last;
  final start = first >> 5;
  final end = last >> 5;
  var length = end - start + 1;
  final result = Uint32List(length);
  for (var i = 0; i < ranges.length; i += 2) {
    final start = ranges[i];
    final end = ranges[i + 1];
    for (var j = start; j < end; j++) {
      //
    }
  }

  return result;
}
