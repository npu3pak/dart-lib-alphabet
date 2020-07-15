import 'dart:math';

extension Alphabet on Random {
  String nextChar(String chars) {
    var index = Random().nextInt(chars.length);
    return chars[index];
  }

  String randomString(String chars, int length) {
    var charCodes = Iterable.generate(length, (_) {
      return chars.codeUnitAt(nextInt(chars.length));
    });
    return String.fromCharCodes(charCodes);
  }

  T randomItem<T>(List<T> items) {
    var i = nextInt(items.length);
    return items[i];
  }
}
