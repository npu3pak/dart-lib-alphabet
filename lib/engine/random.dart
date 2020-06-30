import 'dart:math';

extension Alphabet on Random {
  String nextChar(String chars) {
    var index = Random().nextInt(chars.length);
    return chars[index];
  }
}