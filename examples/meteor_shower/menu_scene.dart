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
    var maxX = Constants.screenWidth - 1;
    var maxY = Constants.screenHeight - 1;

    screen.clear();
    screen.addVerticalLine("|", 0, 0, maxY);
    screen.addVerticalLine("|", maxX, 0, maxY);
    screen.addHorizontalLine("=", 0, maxX, 0);
    screen.addHorizontalLine("=", 0, maxX, maxY);
    screen.addText("high score: ${state.highScore}", 3, 1);

    screen.addCircle("0", 2, 10, 0, filled: true);
    screen.addCircle("1", 7, 10, 1, filled: true);
    screen.addCircle("2", 17, 10, 2, filled: true);
    screen.addCircle("3", 33, 10, 3, filled: true);
    screen.addCircle("4", 54, 10, 4, filled: true);
    
    for (var i=0; i<state.items.length; i++) {
      var text = i == state.selectedItemIndex
          ? state.items[i].toUpperCase()
          : state.items[i];
      screen.addText(text, 3, i + 3);
    }
    screen.printValue();
  }
}
