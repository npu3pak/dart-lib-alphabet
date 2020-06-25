import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:alphabet/engine/concurrency.dart';
import 'package:alphabet/engine/input.dart';

abstract class SceneState {}

abstract class SceneLogic<T extends SceneState> {
  var stateStreamController = StreamController<T>();
  startScene() {}
  stopScene() => stateStreamController.close();
  onKeyPressed(String keyCode);
}

abstract class SceneRenderer<T extends SceneState> {
  startScene() {}
  stopScene() {}
  onSceneStateUpdated(T state);
}

class Scene<TLogic extends SceneLogic, TRenderer extends SceneRenderer> {
  TLogic logic;
  TRenderer renderer;
  IsolateEnvironment inputEnv;

  Scene(this.logic, this.renderer);

  startScene() async {
    inputEnv = await IsolateEnvironment.spawn(runInput);

    logic.startScene();
    renderer.startScene();

    logic.stateStreamController.stream.listen((state) {
      renderer.onSceneStateUpdated(state);
    });

    inputEnv.receivePort.listen((key) {
      logic.onKeyPressed(key);
    });
  }

  stopScene() {
    renderer.stopScene();
    logic.stopScene();
    inputEnv.receivePort.close();
    inputEnv.isolate.kill();
  }

  static runInput(SendPort sendPort, ReceivePort receivePort) {
    io.stdin
      ..lineMode = false
      ..echoMode = false
      ..listen((code) => sendPort.send(KeyCodeParser.parse(code)));
  }
}

abstract class SceneCoordinator {
  Scene currentScene;

  start(SceneLogic logic, SceneRenderer renderer) async {
    currentScene?.stopScene();
    currentScene = Scene(logic, renderer);
    await currentScene.startScene();
  }

  exit() {
    currentScene?.stopScene();
    io.exit(0);
  }
}
