import 'dart:async';

abstract class SceneState {

}

abstract class SceneLogic<T extends SceneState> {
  var stateStreamController = StreamController<T>();

  startScene() {

  }

  stopScene() {
    stateStreamController.close();
  }

  onTimeUpdated(DateTime time);
  onKeyPressed(String keyCode);
}

abstract class SceneRenderer<T extends SceneState> {

  startScene() {

  }

  stopScene() {

  }

  onSceneStateUpdated(T state);
}