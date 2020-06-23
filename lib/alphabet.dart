library alphabet;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:alphabet/engine/concurrency.dart';
import 'package:alphabet/engine/input.dart';
import 'package:alphabet/engine/rendering.dart';
import 'package:alphabet/engine/utils.dart';

main() async {
  var input = await IsolateEnvironment.spawn(runInput);
  var logic = await IsolateEnvironment.spawn(runLogic);
  var rendering = await IsolateEnvironment.spawn(runRendering);

  input.receivePort.listen((key) {
    logic.sendPort.send(key);
  });

  logic.receivePort.listen((gameLogic) {
    rendering.sendPort.send(gameLogic);
  });
}

// Input

runInput(SendPort sendPort, ReceivePort receivePort) {
  stdin.lineMode = false;
  stdin.echoMode = false;
  stdin.listen((code) {
    sendPort.send(KeyCodeParser.parse(code));
  });
}

// Game Logic

class GameState {
  dynamic lastKeyCode;
}

runLogic(SendPort sendPort, ReceivePort receivePort) {
  var state = GameState();

  receivePort.listen((keyCode) {
    state.lastKeyCode = keyCode;
  });

  Timer.periodic(Duration(milliseconds: 1000 ~/ 25), (_) {
    sendPort.send(state);
  });
}

// Rendering

runRendering(SendPort sendPort, ReceivePort receivePort) {
  const screenHeight = 11;
  const screenWidth = 40;
  var enemy = ScreenBuffer.fromFile("res/enemy.txt", width: 5, height: 6);
  var screen = ScreenBuffer(width: screenWidth, height: screenHeight);
  var frameCounter = FrameCounter();

  receivePort.listen((msg) {
    var state = msg as GameState;
    var lastKeyCode = state.lastKeyCode;
    screen
      ..clear()
      ..addBuffer(enemy, 0, 4)
      ..addBuffer(enemy, 7, 2)
      ..addBuffer(enemy, 14, 1)
      ..addText("key: $lastKeyCode", 0, 1)
      ..addText("fps: ${frameCounter.measureFps()}", 0, 0)
      ..printValue();
  });
}
