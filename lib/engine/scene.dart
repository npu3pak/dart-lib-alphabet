import 'dart:async';
import 'dart:io';
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
    inputEnv.isolate.kill();
  }

  static runInput(SendPort sendPort, ReceivePort receivePort) {
    stdin.lineMode = false;
    stdin.echoMode = false;
    stdin.listen((code) {
      sendPort.send(KeyCodeParser.parse(code));
    });
  }
}
