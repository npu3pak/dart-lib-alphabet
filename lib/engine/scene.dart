import 'dart:async';
import 'dart:io' as io;

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
  KeyListener keyListener;

  Scene(this.logic, this.renderer, this.keyListener);

  startScene() async {
    logic.startScene();
    renderer.startScene();

    logic.stateStreamController.stream.listen((state) {
      renderer.onSceneStateUpdated(state);
    });

    keyListener.onKeyPressed = (key) {
      logic.onKeyPressed(key);
    };
  }

  stopScene() {
    renderer.stopScene();
    logic.stopScene();
  }
}

class SceneCoordinator {
  Scene currentScene;

  start(SceneLogic logic, SceneRenderer renderer) async {
    currentScene?.stopScene();
    currentScene = Scene(logic, renderer, KeyListener.getInstance());
    await currentScene.startScene();
  }

  exit() {
    currentScene?.stopScene();
    io.exit(0);
  }
}
