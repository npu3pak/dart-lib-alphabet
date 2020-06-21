library alphabet;

import 'dart:io';

const whiteTile = 'W';

class ScreenBuffer {
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

main() {
  const screenHeight = 11;
  const screenWidth = 40;
  const frameRate = 25;

  var enemy = ScreenBuffer.fromFile("res/enemy.txt", width: 5, height: 6);
  var screen = ScreenBuffer(width: screenWidth, height: screenHeight);
  var frameCounter = FrameCounter();

  while (true) {
    sleep(Duration(milliseconds: 1000~/frameRate));
    screen
      ..clear()
      ..addBuffer(enemy, 0, 4)
      ..addBuffer(enemy, 7, 2)
      ..addBuffer(enemy, 14, 1)
      ..addText("${frameCounter.measureFps()}", 0, 0)
      ..printValue();
  }
}
