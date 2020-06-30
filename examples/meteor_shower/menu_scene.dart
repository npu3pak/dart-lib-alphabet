import 'package:alphabet/alphabet.dart';

import 'constants.dart';
import 'meteor_shower.dart';

class MenuSceneState extends SceneState {
  MenuSceneState(GlobalState global) {
    highScore = global.highScore;
  }

  int highScore;
  var items = ["new game", "exit"];
  var selectedItemIndex = 0;
}

class MenuSceneLogic extends SceneLogic<MenuSceneState> {
  Function onStartGame;
  Function onExit;
  MenuSceneState state;

  MenuSceneLogic(GlobalState global) {
    state = MenuSceneState(global);
  }

  @override
  startScene() {
    stateStreamController.add(state);
  }

  @override
  onKeyPressed(String keyCode) {
    switch (keyCode) {
      case KeyCode.UP:
        selectPreviousItem();
        break;
      case KeyCode.DOWN:
        selectNextItem();
        break;
      case KeyCode.ENTER:
        activateSelectedItem();
        break;
    }
  }

  selectPreviousItem() {
    if (state.selectedItemIndex == 0) {
      state.selectedItemIndex = state.items.length - 1;
    } else {
      state.selectedItemIndex--;
    }
    notifyStateChanged();
  }

  selectNextItem() {
    if (state.selectedItemIndex == state.items.length - 1) {
      state.selectedItemIndex = 0;
    } else {
      state.selectedItemIndex++;
    }
    notifyStateChanged();
  }

  activateSelectedItem() {
    switch (state.selectedItemIndex) {
      case 0:
        startGame();
        break;
      case 1:
        exit();
        break;
    }
  }

  startGame() {
    onStartGame();
  }

  exit() {
    onExit();
  }

  notifyStateChanged() {
    stateStreamController.add(state);
  }
}

class MenuSceneRenderer extends SceneRenderer<MenuSceneState> {
  ScreenBuffer screen = ScreenBuffer(
      width: Constants.screenWidth,
      height: Constants.screenHeight
  );

  @override
  onSceneStateUpdated(MenuSceneState state) {
    screen.clear();
    screen.addTile("#", 0, 0);
    screen.addTile("#", Constants.screenWidth - 1, 0);
    screen.addTile("#", 0, Constants.screenHeight - 1);
    screen.addTile("#", Constants.screenWidth - 1, Constants.screenHeight - 1);
    screen.addText("high score: ${state.highScore}", 0, 1);
    
    for (var i=0; i<state.items.length; i++) {
      var text = i == state.selectedItemIndex
          ? state.items[i].toUpperCase()
          : state.items[i];
      screen.addText(text, 3, i + 3);
    }
    screen.printValue();
  }
}