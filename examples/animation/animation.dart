import 'dart:async';
import 'dart:io';

import 'package:alphabet/alphabet.dart';
import 'package:alphabet/engine/animations.dart';

import 'resources.dart';

main() async {
  final coordinator = SceneCoordinator();
  await coordinator.start(AnimationSceneLogic(), AnimationSceneRenderer());
}

class AnimationSceneState extends SceneState {
  bool isDemo2Visible = false;
}

class AnimationSceneLogic extends SceneLogic<AnimationSceneState> {
  final _state = AnimationSceneState();
  Timer _animationTimer;

  @override
  startScene() {
    super.startScene();
    stateStreamController.add(_state);

    _animationTimer =
        Timer.periodic(Duration(milliseconds: (1000 / 10).round()), (_) {
      stateStreamController.add(_state);
    });
  }

  @override
  stopScene() {
    _animationTimer.cancel();
    return super.stopScene();
  }

  @override
  onKeyPressed(String keyCode) {
    if (keyCode == KeyCode.ESC) {
      exit(0);
    } else {
      _state.isDemo2Visible = !_state.isDemo2Visible;
    }
  }
}

class AnimationSceneRenderer extends SceneRenderer<AnimationSceneState> {
  static const screenWidth = 100;
  static const screenHeight = 13;

  final _screen = ScreenBuffer(width: screenWidth, height: screenHeight);
  final _animationController = AnimationController();

  @override
  onSceneStateUpdated(AnimationSceneState state) {
    _screen.clear();
    _screen.addText("Hello", 1, 1);
    _animationController.add("demo1", Resources.animation, 30, 6, _screen);
    if (state.isDemo2Visible) {
      _animationController.add("demo2", Resources.animation, 30, 8, _screen);
    }
    _animationController.draw();
    _screen.printValue();
  }
}
