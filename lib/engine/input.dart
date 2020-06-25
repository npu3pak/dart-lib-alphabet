import 'dart:convert';
import 'dart:typed_data';

class KeyCode {
  static const ESC = "ESC";
  static const ENTER = "ENTER";
  static const F1 = "F1";
  static const F2 = "F2";
  static const F3 = "F3";
  static const F4 = "F4";
  static const F5 = "F5";
  static const F6 = "F6";
  static const F7 = "F7";
  static const F8 = "F8";
  static const F9 = "F9";
  static const F10 = "F10";
  static const F11 = "F11";
  static const F12 = "F12";
  static const BACKSPACE = "BACKSPACE";
  static const TAB = "TAB";
  static const SPACE = "SPACE";
  static const UP = "UP";
  static const DOWN = "DOWN";
  static const LEFT = "LEFT";
  static const RIGHT = "RIGHT";
}

class KeyCodeParser {

  static var _keyCodes = {
    [27] : KeyCode.ESC,
    [10] : KeyCode.ENTER,
    [27, 79, 80] : KeyCode.F1,
    [27, 79, 81] : KeyCode.F2,
    [27, 79, 82] : KeyCode.F3,
    [27, 79, 83] : KeyCode.F4,
    [27, 91, 49, 53, 126] : KeyCode.F5,
    [27, 91, 49, 55, 126] : KeyCode.F6,
    [27, 91, 49, 56, 126] : KeyCode.F7,
    [27, 91, 49, 57, 126] : KeyCode.F8,
    [27, 91, 50, 48, 126] : KeyCode.F9,
    [27, 91, 50, 49, 126] : KeyCode.F10,
    [27, 91, 50, 51, 126] : KeyCode.F11,
    [27, 91, 50, 52, 126] : KeyCode.F12,
    [127] : KeyCode.BACKSPACE,
    [9] : KeyCode.TAB,
    [32] : KeyCode.SPACE,
    [27, 91, 65] : KeyCode.UP,
    [27, 91, 66] : KeyCode.DOWN,
    [27, 91, 68] : KeyCode.LEFT,
    [27, 91, 67] : KeyCode.RIGHT,
  }.map((key, value) => MapEntry("$key", value));

  static String parse(Uint8List code) {
    return _keyCodes["$code"] ?? utf8.decode(code);
  }
}