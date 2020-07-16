import 'dart:math';

import 'package:alphabet/alphabet.dart';
import 'constants.dart';
import 'entities.dart';
import 'game_table.dart';

main() async {
  var coordinator = SceneCoordinator();
  await coordinator.start(BattleSceneLogic(), BattleSceneRenderer());
}

class BattleSceneLogic extends SceneLogic<BattleState> {
  final state = BattleState();

  @override
  startScene() {
    super.startScene();
    _initState();
    stateStreamController.add(state);
  }

  _initState() {
    for (var i = 0; i < 3; i++) {
      _spawnEnemy(i);
    }
  }

  _spawnEnemy(int position) {
    final enemy = Random().randomItem(GameTable.allEnemies);
    final cooldown = Random().randomItem(enemy.availableAttacks).cooldown;
    state.enemies[position] = enemy;
    state.cooldowns[position] = cooldown;
  }

  @override
  onKeyPressed(String keyCode) {
    if (_hit(keyCode)) {
      _removeDeadEnemies();

      if (_checkWinCondition()) {
        state.lastMessage = "You win!";
      }

      stateStreamController.add(state);
    }
  }

  bool _hit(String symbol) {
    var isSuccess = false;
    state.enemies.forEach((_, enemy) {
      if (enemy.hit(symbol)) {
        isSuccess = true;
      }
    });
    return isSuccess;
  }

  bool _checkWinCondition() => state.enemies.length == 0;

  void _removeDeadEnemies() {
    state.enemies.removeWhere((_, enemy) => enemy.isDead);
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
      var enemyBuffer =
          ScreenBuffer.fromString(enemy.bodySprite, width: 30, height: 10);
      screen.addBuffer(enemyBuffer, i * spriteWidth, spriteY);
    }
    screen.addText(state.lastMessage, 1, 1);
    screen.printValue();
  }
}
