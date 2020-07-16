import 'dart:async';
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
  final _enemiesCount = 3;
  final _state = BattleState();
  Timer _timer;

  @override
  startScene() {
    super.startScene();
    _initState();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimer);
    stateStreamController.add(_state);
  }

  _initState() {
    for (var i = 0; i < _enemiesCount; i++) {
      _spawnEnemy(i);
    }
  }

  _spawnEnemy(int position) {
    final enemy = Random().randomItem(GameRoster.allEnemies);
    final cooldown = Random().randomItem(enemy.availableAttacks).cooldown;
    _state.enemies[position] = enemy;
    _state.cooldowns[position] = cooldown;
  }

  _onTimer(Timer timer) {
    for (var i = 0; i < _enemiesCount; i++) {
      if (_state.enemies.containsKey(i)) {
        if (_state.cooldowns[i] == 0) {
          _spawnAttack(i);
        } else {
          _state.cooldowns[i]--;
        }

        if (_state.attacksTime.containsKey(i)) {
          if (_state.attacksTime[i] == 0) {
            _attackPlayer(i);
          } else {
            _state.attacksTime[i]--;
          }
        }
      }
    }
    stateStreamController.add(_state);
  }

  _spawnAttack(int position) {
    final enemy = _state.enemies[position];
    final attackFactory = Random().randomItem(enemy.availableAttacks);
    final symbol = Random().nextChar(Characters.lowerCased);
    _state.attacks[position] = attackFactory.getAttack(symbol);
    _state.attacksTime[position] = attackFactory.attackTime;
    _state.cooldowns[position] = attackFactory.cooldown;
  }

  _attackPlayer(int position) {
    final attack = _state.attacks[position];
    _state.attacks.remove(position);
    _state.attacksTime.remove(position);
    _state.playerHealth -= attack.damage;
  }

  @override
  onKeyPressed(String keyCode) {
    if (_hit(keyCode)) {
      _removeDeadEnemies();

      if (_checkWinCondition()) {
        _state.lastMessage = "You win!";
      }

      stateStreamController.add(_state);
    }
  }

  bool _hit(String symbol) {
    var isSuccess = false;
    _state.enemies.forEach((_, enemy) {
      if (enemy.hit(symbol)) {
        isSuccess = true;
      }
    });
    return isSuccess;
  }

  bool _checkWinCondition() => _state.enemies.length == 0;

  void _removeDeadEnemies() {
    _state.enemies.removeWhere((_, enemy) => enemy.isDead);
  }

  @override
  stopScene() {
    _timer.cancel();
    super.stopScene();
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
    for (var i in state.attacks.keys) {
      var attack = state.attacks[i];
      final time = state.attacksTime[i];
      final radius = _getAttackRadius(attack, time);
      var x = i * spriteWidth + spriteWidth / 2;
      var y = screenHeight / 2;
      screen.addCircle(attack.symbol, x.round(), y.round(), radius,
          filled: true);
    }
    screen.addText(state.lastMessage, 1, 1);
    screen.printValue();
  }

  int _getAttackRadius(EnemyAttack attack, int time) {
    final minRadius = attack.startRadius;
    final maxRadius = attack.endRadius;
    final timeProportion = (attack.attackTime - time) / attack.attackTime;
    final radius = minRadius + (maxRadius - minRadius) * timeProportion;
    return radius.ceil();
  }
}
