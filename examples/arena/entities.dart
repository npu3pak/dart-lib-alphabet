import 'dart:math';
import 'package:alphabet/alphabet.dart';
import 'constants.dart';

class BattleState extends SceneState {
  var enemies = Map<int, Enemy>();
  var attacks = Map<int, EnemyAttack>();
  var attacksTime = Map<int, int>();
  var cooldowns = Map<int, int>();
  var lastMessage = "";
  var playerHealth = 1000;
}

class Enemy {
  String bodySprite;
  List<EnemyAttackFabric> availableAttacks;

  Enemy({String sprite, int symbolsCount, this.availableAttacks}) {
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
  final int cooldownTime;
  final int attackTime;
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
  final int cooldown;
  final int attackTime;
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
