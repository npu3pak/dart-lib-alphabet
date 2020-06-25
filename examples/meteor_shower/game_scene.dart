import 'dart:async';
import 'dart:math';

import 'package:alphabet/alphabet.dart';

import 'constants.dart';
import 'meteor_shower.dart';

class Meteor {
  Meteor(this.letter, this.x, this.y);

  String letter;
  int x, y;
}

class GameSceneState extends SceneState {
  GameSceneState(this.global) {
    highScore = global.highScore;
  }

  GlobalState global;

  int highScore;
  int score = 0;
  List<Meteor> meteors = [];
}

class GameSceneLogic extends SceneLogic<GameSceneState> {
  Function onStartMenu;
  GameSceneState state;
  Timer spawnTimer;
  Timer moveTimer;

  GameSceneLogic(GlobalState global) {
    state = GameSceneState(global);
  }

  @override
  startScene() {
    super.startScene();
    stateStreamController.add(state);
    spawnTimer = Timer.periodic(Duration(milliseconds: 700), onSpawnTimer);
    moveTimer = Timer.periodic(Duration(milliseconds: 600), onMoveTimer);
  }

  @override
  stopScene() {
    super.stopScene();
    spawnTimer.cancel();
    moveTimer.cancel();
  }

  @override
  onKeyPressed(String keyCode) {
    switch (keyCode) {
      case KeyCode.ESC:
        startMenu();
        break;
      default:
        attack(keyCode);
        break;
    }
  }

  onSpawnTimer(_) {
    var x = Random().nextInt(Constants.maxX);
    var meteor = Meteor(getRandomChar(), x, Constants.minY);
    state.meteors.add(meteor);
    notifyStateChanged();
  }

  String getRandomChar() {
    var index = Random().nextInt(Constants.chars.length);
    return Constants.chars[index];
  }

  onMoveTimer(_) {
    for(var meteor in state.meteors) {
      meteor.y++;
      if(meteor.y >= Constants.maxY) {
        startMenu();
      }
    }
    notifyStateChanged();
  }

  attack(String key) {
    for(var meteor in state.meteors) {
      if(meteor.letter == key) {
        increaseScore();
        notifyStateChanged();
      }
    }
    state.meteors.removeWhere((meteor) => meteor.letter == key);
  }

  increaseScore() {
    state.score += 100;
    if (state.score > state.global.highScore) {
      state.global.highScore = state.score;
    }
  }

  notifyStateChanged() {
    if (!stateStreamController.isClosed) {
      stateStreamController.add(state);
    }
  }

  startMenu() {
    onStartMenu();
  }
}

class GameSceneRenderer extends SceneRenderer<GameSceneState> {
  ScreenBuffer screen = ScreenBuffer(
      width: Constants.screenWidth, height: Constants.screenHeight);

  @override
  onSceneStateUpdated(GameSceneState state) {
    screen.clear();
    screen.addText("score: ${state.score}", 0, 0);
    screen.addText("high score: ${state.highScore}", 0, 1);
    for(var meteor in state.meteors) {
      screen.addText(meteor.letter, meteor.x, meteor.y);
    }
    const ground = "========================================";
    screen.addTile(ground, 0, Constants.maxY);
    screen.printValue();
  }
}
