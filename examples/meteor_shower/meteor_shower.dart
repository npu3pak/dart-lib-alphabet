import 'package:alphabet/alphabet.dart' as abc;

import 'game_scene.dart';
import 'menu_scene.dart';

class GlobalState {
  var highScore = 0;
}

class SceneCoordinator extends abc.SceneCoordinator {
  var globalState = GlobalState();

  startMenu() async {
    var logic = MenuSceneLogic(globalState);
    logic.onExit = exit;
    logic.onStartGame = startGame;
    var renderer = MenuSceneRenderer();
    await start(logic, renderer);
  }

  startGame() async {
    var logic = GameSceneLogic(globalState);
    logic.onStartMenu = startMenu;
    var renderer = GameSceneRenderer();
    await start(logic, renderer);
  }
}

main() async {
  var coordinator = SceneCoordinator();
  await coordinator.startMenu();
}