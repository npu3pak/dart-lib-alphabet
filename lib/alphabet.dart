library alphabet;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

main() async {
  var input = await IsolateEnvironment.spawn(runInput);
  var logic = await IsolateEnvironment.spawn(runGameLogic);
  var rendering = await IsolateEnvironment.spawn(runRendering);

  input.receivePort.listen((key) {
    logic.sendPort.send(key);
  });

  logic.receivePort.listen((gameLogic) {
    rendering.sendPort.send(gameLogic);
  });
}

typedef IsolateEnvironmentEntryPoint(SendPort sendPort, ReceivePort receivePort);

class IsolateEnvironment {

  Isolate isolate;
  ReceivePort receivePort;
  SendPort sendPort;

  IsolateEnvironment._(this.isolate, this.receivePort, this.sendPort);

  static Future<IsolateEnvironment> spawn(IsolateEnvironmentEntryPoint entryPoint) async {
    var completer = Completer<IsolateEnvironment>();
    var isolateReceivePort = ReceivePort();
    var envReceivePort = ReceivePort();

    Isolate isolate;
    
    isolateReceivePort.listen((msg) {
      if (msg is SendPort) {
        completer.complete(IsolateEnvironment._(isolate, envReceivePort, msg));
      } else {
        envReceivePort.sendPort.send(msg);
      }
    });

    var args = [entryPoint, isolateReceivePort.sendPort];
    isolate = await Isolate.spawn(isolateEntryPoint, args);
    return completer.future;
  }

  static void isolateEntryPoint(List args) {
    IsolateEnvironmentEntryPoint entryPoint = args[0];
    SendPort sendPort = args[1];

    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    entryPoint(sendPort, receivePort);
  }
}

// Input

runInput(SendPort sendPort, ReceivePort receivePort) {
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

// Game Logic

class GameLogic {
  var lastKeyCode = -1;
}

runGameLogic(SendPort sendPort, ReceivePort receivePort) {
  var logic = GameLogic();

  receivePort.listen((keyCode) {
    logic.lastKeyCode = keyCode;
  });

  Timer.periodic(Duration(milliseconds: 1000~/25), (_) {
    sendPort.send(logic);
  });
}

// Rendering

runRendering(SendPort sendPort, ReceivePort receivePort) {
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