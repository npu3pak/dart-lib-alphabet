import 'package:alphabet/alphabet.dart';

import 'constants.dart';
import 'meteor_shower.dart';

class GameSceneState extends SceneState {
  GameSceneState(this.global) {
    maxScore = global.maxScore;
  }

  GlobalState global;
  int maxScore;
}

class GameSceneLogic extends SceneLogic<GameSceneState> {
  Function onStartMenu;
  GlobalState globalState;
  GameSceneState state;

  GameSceneLogic(GlobalState global) {
    state = GameSceneState(global);
  }

  @override
  startScene() {
    stateStreamController.add(state);
  }

  @override
  onKeyPressed(String keyCode) {
    switch (keyCode) {
      case KeyCode.ENTER:
        startMenu();
        break;
    }
  }
  
  startMenu() {
    onStartMenu();
  }
}

class GameSceneRenderer extends SceneRenderer<GameSceneState> {
  ScreenBuffer screen = ScreenBuffer(
    width: Constants.screenWidth,
    height: Constants.screenHeight
  );

  @override
  onSceneStateUpdated(GameSceneState state) {
    screen.clear();
    screen.addText("Not ready yet. Press ENTER.", 0, 0);
    screen.printValue();
  }
}