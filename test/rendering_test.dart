import 'package:alphabet/alphabet.dart';

main() {
  testAddTile();
}

testAddTile() {
  final buffer = ScreenBuffer(height: 3, width: 3);
  buffer.addTile("111\n111", 0, 0);
  checkBuffer(buffer, "111\n111\n   ");
}

checkBuffer(buffer, String expected) {
  final exp = "$expected\n";
  final str = buffer.toString();
  try {
    var assertMsg = "\n====\nExpected:\n$expected\nGiven:\n$str====";
    assert(str == exp, assertMsg);
  } on Error catch (e) {
    print(e);
  }
}
