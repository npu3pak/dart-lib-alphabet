import 'dart:math';

import 'package:alphabet/alphabet.dart';
import 'constants.dart';
import 'resources.dart';

main() async {
  var coordinator = SceneCoordinator();
  await coordinator.start(BattleSceneLogic(), BattleSceneRenderer());
}

class Enemy {
  String bodySprite;

  static Enemy randomEnemy(int symbolsCount) {
    var sprite = Random().randomItem(Sprites.humans);
    return Enemy(sprite, symbolsCount);
  }

  Enemy(String sprite, int symbolsCount) {
    bodySprite = _getRandomizedSprite(sprite, symbolsCount);
  }

  bool hit(String symbol) {
    if (bodySprite.contains(symbol)) {
      bodySprite = bodySprite.replaceAll(symbol, " ");
      return true;
    } else {
      return false;
    }
  }
  
  bool get isDead {
    var regexp = RegExp("[^\\s]+");
    return !regexp.hasMatch(bodySprite);
  }

  start() {

  }

  stop() {

  }

  static String _getRandomizedSprite(String sprite, int symbolsCount) {
    var symbols = Random().randomString(Characters.lowerCased, symbolsCount);
    var buffer = StringBuffer();
    for (var i = 0; i < sprite.length; i++) {
      if (sprite[i] != " " && sprite[i] != "\n") {
        buffer.write(Random().nextChar(symbols));
      } else {
        buffer.write(sprite[i]);
      }
    }
    return buffer.toString();
  }
}

class BattleState extends SceneState {
  var enemies = Map<int, Enemy>();
  var lastMessage = "";

  BattleState(int symbolsCount, int enemiesCount) {
    for (var i = 0; i < enemiesCount; i++) {
      enemies[i] = Enemy.randomEnemy(symbolsCount);
    }
  }
}

class BattleSceneLogic extends SceneLogic<BattleState> {
  BattleState state;

  @override
  startScene() {
    super.startScene();
    state = BattleState(1, 3);
    state.enemies.forEach((_, enemy) { enemy.start(); });

    stateStreamController.add(state);
  }

  @override
  onKeyPressed(String keyCode) {
    if (hit(keyCode)) {
      removeDeadEnemies();

      if (checkWinCondition()) {
        state.lastMessage = "You win!";
      }

      stateStreamController.add(state);
    }
  }

  bool checkWinCondition() => state.enemies.length == 0;

  void removeDeadEnemies() {
    state.enemies.forEach((_, enemy) {
      if (enemy.isDead) {
        enemy.stop();
      }
    });
    state.enemies.removeWhere((_, enemy) => enemy.isDead);
  }

  bool hit(String symbol) {
    var isSuccess = false;
    state.enemies.forEach((_, enemy) {
      if (enemy.hit(symbol)) {
        isSuccess = true;
      }
    });
    return isSuccess;
  }
}

class BattleSceneRenderer extends SceneRenderer<BattleState> {
  ScreenBuffer screen = ScreenBuffer(width: screenWidth, height: screenHeight);

  @override
  onSceneStateUpdated(BattleState state) {
    screen.clear();
    const spriteWidth = 30;
    const spriteY = 3;
    for (var i in state.enemies.keys) {
      var enemy = state.enemies[i];
      var enemyBuffer = ScreenBuffer.fromString(enemy.bodySprite, width: 30, height: 10);
      screen.addBuffer(enemyBuffer, i * spriteWidth, spriteY);
    }
    screen.addText(state.lastMessage, 1, 1);
    screen.printValue();
  }
}
