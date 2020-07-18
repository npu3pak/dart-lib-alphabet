import 'dart:math';
import 'package:alphabet/alphabet.dart';
import 'constants.dart';
import 'game_roster.dart';

enum GameState { progress, lose, win }

class BattleState extends SceneState {
  var gameState = GameState.progress;
  var enemies = Map<int, Enemy>();
  var attacks = Map<int, EnemyAttack>();
  var attacksTime = Map<int, double>();
  var cooldowns = Map<int, double>();
  var playerHealth = GameRoster.playerHealth;
}

class Enemy {
  String bodySprite;
  final List<EnemyAttackFabric> availableAttacks;

  Enemy(this.bodySprite, this.availableAttacks);

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
}

class EnemyFabric {
  final String sprite;
  final int symbolsCount;
  final List<EnemyAttackFabric> availableAttacks;

  EnemyFabric({this.sprite, this.symbolsCount, this.availableAttacks});

  Enemy getEnemy() {
    final bodySprite = _getRandomizedSprite(sprite, symbolsCount);
    return Enemy(bodySprite, availableAttacks);
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

class EnemyAttack {
  final String symbol;
  final double cooldownTime;
  final double attackTime;
  final int damage;
  final int startRadius;
  final int endRadius;

  EnemyAttack({
    this.symbol,
    this.attackTime,
    this.damage,
    this.startRadius,
    this.endRadius,
    this.cooldownTime,
  });

  bool hit(String symbol) {
    return this.symbol == symbol;
  }
}

class EnemyAttackFabric {
  final double cooldown;
  final double attackTime;
  final int damage;
  final int startRadius;
  final int endRadius;

  EnemyAttackFabric({
    this.attackTime,
    this.damage,
    this.startRadius,
    this.endRadius,
    this.cooldown,
  });

  EnemyAttack getAttack(symbol) => EnemyAttack(
        symbol: symbol,
        attackTime: attackTime,
        damage: damage,
        startRadius: startRadius,
        endRadius: endRadius,
        cooldownTime: cooldown,
      );
}
