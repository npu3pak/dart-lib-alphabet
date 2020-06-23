import 'dart:convert';
import 'dart:typed_data';

class KeyCodeParser {
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

  static var _keyCodes = {
    [10] : ENTER,
    [27, 79, 80] : F1,
    [27, 79, 81] : F2,
    [27, 79, 82] : F3,
    [27, 79, 83] : F4,
    [27, 91, 49, 53, 126] : F5,
    [27, 91, 49, 55, 126] : F6,
    [27, 91, 49, 56, 126] : F7,
    [27, 91, 49, 57, 126] : F8,
    [27, 91, 50, 48, 126] : F9,
    [27, 91, 50, 49, 126] : F10,
    [27, 91, 50, 51, 126] : F11,
    [27, 91, 50, 52, 126] : F12,
    [127] : BACKSPACE,
    [9] : TAB,
    [32] : SPACE,
    [27, 91, 65] : UP,
    [27, 91, 66] : DOWN,
    [27, 91, 68] : LEFT,
    [27, 91, 67] : RIGHT,
  }.map((key, value) => MapEntry("$key", value));

  static String parse(Uint8List code) {
    return _keyCodes["$code"] ?? utf8.decode(code);
  }
}