library alphabet;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

main() {
  // TODO: Make proper port binding mechanism without race conditions
  SendPort renderingSendPort;
  SendPort logicSendPort;

  var inputReceivePort = ReceivePort();
  inputReceivePort.listen((key) {
    logicSendPort.send(key);
  });

  var renderingReceivePort = ReceivePort();
  renderingReceivePort.listen((msg) {
    if (msg is SendPort) {
      renderingSendPort = msg;
      Isolate.spawn(runInputIsolate, inputReceivePort.sendPort);
    }
  });

  var logicReceivePort = ReceivePort();
  logicReceivePort.listen((msg) {
    if (msg is SendPort) {
      logicSendPort = msg;
      Isolate.spawn(runRenderingIsolate, renderingReceivePort.sendPort);
    } else if (msg is GameLogic) {
      renderingSendPort.send(msg);
    }
  });

  Isolate.spawn(runGameLogicIsolate, logicReceivePort.sendPort);
}

// Game Logic

class GameLogic {
  var lastKeyCode = -1;
}

runGameLogicIsolate(SendPort sendPort) {
  var logic = GameLogic();

  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((keyCode) {
    logic.lastKeyCode = keyCode;
  });

  Timer.periodic(Duration(milliseconds: 1000~/25), (_) {
    sendPort.send(logic);
  });
}

// Input

runInputIsolate(SendPort sendPort) {
  keysStream().forEach((key) {
    sendPort.send(key);
  });
}

Stream<int> keysStream() async* {
  stdin.lineMode = false;
  stdin.echoMode = false;
  while(true) {
    yield stdin.readByteSync();
  }
}

// Rendering

runRenderingIsolate(SendPort sendPort) {
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  const screenHeight = 11;
  const screenWidth = 40;
  var enemy = ScreenBuffer.fromFile("res/enemy.txt", width: 5, height: 6);
  var screen = ScreenBuffer(width: screenWidth, height: screenHeight);
  var frameCounter = FrameCounter();
  
  receivePort.listen((msg) {
    if (msg is GameLogic) {
      var lastKeyCode = msg.lastKeyCode;
      screen
        ..clear()
        ..addBuffer(enemy, 0, 4)
        ..addBuffer(enemy, 7, 2)
        ..addBuffer(enemy, 14, 1)
        ..addText("keycode: $lastKeyCode", 0, 1)
        ..addText("fps: ${frameCounter.measureFps()}", 0, 0)
        ..printValue();
    }
  });
}

class ScreenBuffer {
  static const whiteTile = 'W';

  var width, height;
  var value = List<List<String>>();

  ScreenBuffer({this.width, this.height}) {
    clear();
  }

  ScreenBuffer.fromFile(String fileName, {this.width, this.height}) {
    clear();
    var file = File(fileName);
    var lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      addTile(line, 0, i);
    }
  }

  clear() {
    value = List.generate(width, (_) => List.generate(height, (_) => ' '));
  }

  addBuffer(ScreenBuffer buffer, x, y) {
    for (var by = 0; by < buffer.height; by++) {
      for (var bx = 0; bx < buffer.width; bx++) {
        var c = buffer.value[bx][by];
        addTile(c, x + bx, y + by);
      }
    }
  }

  addTile(String tile, x, y) {
    for (var i = 0; i < tile.length; i++) {
      if (tile[i] != ' ' && tile[i] != '\n') {
        value[x + i][y] = tile[i] == whiteTile ? ' ' : tile[i];
      }
    }
  }

  addText(String text, x, y) {
    for (var i = 0; i < text.length; i++) {
      value[x + i][y] = text[i];
    }
  }

  printValue() {
    var buf = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buf.write(value[x][y]);
      }
      buf.write('\n');
    }
    print(buf);
  }
}

class FrameCounter {
  var frames = 0;
  var lastFrameTime = DateTime.now().millisecondsSinceEpoch;
  var rate = 0;

  measureFps() {
    if (DateTime.now().millisecondsSinceEpoch - lastFrameTime < 1000) {
      frames++;
    } else {
      rate = frames;
      frames = 0;
      lastFrameTime = DateTime.now().millisecondsSinceEpoch;
    }
    return rate;
  }
}