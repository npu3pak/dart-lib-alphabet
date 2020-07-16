import 'entities.dart';
import 'resources.dart';

class GameTable {
  static final weakAttack = EnemyAttackFabric(
    attackTime: 2,
    damage: 1,
    startRadius: 1,
    endRadius: 2,
    cooldown: 4,
  );

  static final mediumAttack = EnemyAttackFabric(
    attackTime: 3,
    damage: 2,
    startRadius: 1,
    endRadius: 3,
    cooldown: 6,
  );

  static final strongAttack = EnemyAttackFabric(
    attackTime: 4,
    damage: 4,
    startRadius: 1,
    endRadius: 4,
    cooldown: 8,
  );

  static final weakHuman = Enemy(
    sprite: Sprites.human1,
    symbolsCount: 4,
    availableAttacks: [weakAttack],
  );

  static final mediumHuman = Enemy(
    sprite: Sprites.human1,
    symbolsCount: 8,
    availableAttacks: [weakAttack, mediumAttack],
  );

  static final strongHuman = Enemy(
    sprite: Sprites.human1,
    symbolsCount: 14,
    availableAttacks: [weakAttack, mediumAttack, strongAttack],
  );

  static final allEnemies = [weakHuman, mediumHuman, strongHuman];
}
