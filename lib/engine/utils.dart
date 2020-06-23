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