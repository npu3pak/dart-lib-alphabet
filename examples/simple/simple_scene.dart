import 'dart:async';

import 'package:alphabet/alphabet.dart';

main() async {
  var scene = Scene(SimpleSceneLogic(), SimpleSceneRenderer());
  await scene.startScene();
}

class SimpleSceneState extends SceneState {
  String lastKeyCode;
  DateTime lastTime;
}

class SimpleSceneLogic extends SceneLogic<SimpleSceneState> {
  var state = SimpleSceneState();

  @override
  startScene() {
    super.startScene();

    stateStreamController.add(state);
    Timer.periodic(Duration(milliseconds: 1000 ~/ 1), (_) {
      onTimer();
    });
  }

  @override
  onKeyPressed(String keyCode) {
    state.lastKeyCode = keyCode;
    stateStreamController.add(state);
  }

  onTimer() {
    state.lastTime = DateTime.now();
    stateStreamController.add(state);
  }
}

class SimpleSceneRenderer extends SceneRenderer<SimpleSceneState> {
  static const screenHeight = 11;
  static const screenWidth = 40;

  ScreenBuffer enemy;
  ScreenBuffer screen;
  var frameCounter = FrameCounter();

  @override
  startScene() {
    super.startScene();
    enemy = ScreenBuffer.fromFile("res/enemy.txt", width: 5, height: 6);
    screen = ScreenBuffer(width: screenWidth, height: screenHeight);
  }

  @override
  onSceneStateUpdated(SimpleSceneState state) {
    screen
      ..clear()
      ..addText("fps: ${frameCounter.measureFps()}", 0, 0)
      ..addText("key: ${state.lastKeyCode}", 0, 1)
      ..addText("utc: ${state.lastTime.toUtc()}", 0, 2)
      ..addBuffer(enemy, 0, 4)
      ..addBuffer(enemy, 7, 5)
      ..addBuffer(enemy, 14, 4)
      ..printValue();
  }
}