import 'dart:io';

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