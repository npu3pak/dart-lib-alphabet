import 'package:alphabet/engine/rendering.dart';
import 'package:alphabet/engine/scene.dart';
import 'package:alphabet/engine/utils.dart';

class ExampleSceneState extends SceneState {
  String lastKeyCode;
  DateTime lastTime;
}

class ExampleSceneLogic extends SceneLogic<ExampleSceneState> {
  var state = ExampleSceneState();

  @override
  startScene() {
    super.startScene();
  }

  @override
  stopScene() {
    super.stopScene();
  }

  @override
  onKeyPressed(String keyCode) {
    state.lastKeyCode = keyCode;
    stateStreamController.add(state);
  }

  @override
  onTimeUpdated(DateTime time) {
    state.lastTime = time;
    stateStreamController.add(state);
  }
}

class ExampleSceneRenderer extends SceneRenderer<ExampleSceneState> {
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
  stopScene() {
    super.stopScene();
  }

  @override
  onSceneStateUpdated(ExampleSceneState state) {
    screen
      ..clear()
      ..addText("fps: ${frameCounter.measureFps()}", 0, 0)
      ..addText("key: ${state.lastKeyCode}", 0, 1)
      ..addText("utc: ${state.lastTime.toUtc()}", 0, 2)
      ..addBuffer(enemy, 0, 4)
      ..addBuffer(enemy, 7, 3)
      ..addBuffer(enemy, 14, 1)
      ..printValue();
  }
}