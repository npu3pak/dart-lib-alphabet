import 'dart:io';
import 'dart:math';

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

  ScreenBuffer.fromString(String str, {this.width, this.height}) {
    clear();
    var lines = str.split("\n");
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

  addHorizontalLine(String char, int xMin, int xMax, int y) {
    var length = xMax - xMin + 1;
    var tile = char * length;
    addTile(tile, xMin, y);
  }

  addVerticalLine(String char, int x, int yMin, int yMax) {
    for (var yi = yMin; yi <= yMax; yi++) {
      addTile(char, x, yi);
    }
  }

  addCircle(String char, int a, int b, int r,
      {double ratio = 1.4, bool filled = false}) {
    for (var y = b - r; y < b + r + 1; y++) {
      var x1 = a + sqrt(pow(r, 2) - pow(y - b, 2));
      var x2 = a - sqrt(pow(r, 2) - pow(y - b, 2));

      var cx1 = (x2 + (x2 - a) * ratio).round();
      var cx2 = (x1 - (a - x1) * ratio).round();

      if (filled) {
        addHorizontalLine(char, cx1, cx2, y);
      } else {
        addTile(char, cx1, y);
        addTile(char, cx2, y);
      }
    }
  }

  printValue() {
    print(this);
  }

  @override
  String toString() {
    var buf = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buf.write(value[x][y]);
      }
      buf.write('\n');
    }
    return buf.toString();
  }
}
