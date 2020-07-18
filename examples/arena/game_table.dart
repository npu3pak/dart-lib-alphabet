import 'entities.dart';
import 'resources.dart';

class GameRoster {
  static final weakAttack = EnemyAttackFabric(
    attackTime: 1000,
    damage: 5,
    startRadius: 1,
    endRadius: 3,
    cooldown: 2000,
  );

  static final mediumAttack = EnemyAttackFabric(
    attackTime: 1000,
    damage: 8,
    startRadius: 1,
    endRadius: 4,
    cooldown: 2000,
  );

  static final strongAttack = EnemyAttackFabric(
    attackTime: 1000,
    damage: 12,
    startRadius: 1,
    endRadius: 6,
    cooldown: 2000,
  );

  static final weakHuman = Enemy(
    sprite: Sprites.human1,
    symbolsCount: 4,
    availableAttacks: [weakAttack],
  );

  static final mediumHuman = Enemy(
    sprite: Sprites.human2,
    symbolsCount: 8,
    availableAttacks: [weakAttack, mediumAttack],
  );

  static final strongHuman = Enemy(
    sprite: Sprites.human3,
    symbolsCount: 14,
    availableAttacks: [weakAttack, mediumAttack, strongAttack],
  );

  static final allEnemies = [weakHuman, mediumHuman, strongHuman];

  static final attackTimerInterval = 100;

  static final maxAdditionalCooldown = 2000;

  static final playerHealth = 100;
}
