import 'package:alphabet/alphabet.dart';

class Animation {
  final List<String> frames;
  final int frameTime;

  Animation(this.frames, this.frameTime);
}

class AnimationController {
  final _animationStates = Map<String, _AnimationState>();

  AnimationController();

  add(
    String id,
    Animation animation,
    int x,
    int y,
    ScreenBuffer buffer,
  ) {
    if (_animationStates.containsKey(id)) {
      final state = _animationStates[id];
      state.x = x;
      state.y = y;
      state.buffer = buffer;
      state.isTriggered = true;
    } else {
      final state = _AnimationState(animation, x, y, buffer);
      state.isTriggered = true;
      _animationStates[id] = state;
    }
  }

  draw() {
    _animationStates.removeWhere((_, state) => !state.isTriggered);
    _animationStates.values.forEach((state) => state.isTriggered = false);

    for (var state in _animationStates.values) {
      state.buffer.addTile(state.getCurrentFrame(), state.x, state.y);
    }
  }
}

class _AnimationState {
  final Animation animation;
  int x;
  int y;
  ScreenBuffer buffer;
  bool isTriggered = false;

  DateTime _lastFrameTimestamp;
  int _lastFrameIndex = 0;

  String getCurrentFrame() {
    if (_lastFrameTimestamp == null) {
      _lastFrameTimestamp = DateTime.now();
    }
    var timePassed = DateTime.now().millisecondsSinceEpoch -
        _lastFrameTimestamp.millisecondsSinceEpoch;

    if (timePassed >= animation.frameTime) {
      _lastFrameTimestamp = DateTime.now();
      if (_lastFrameIndex < animation.frames.length - 1) {
        _lastFrameIndex++;
      } else {
        _lastFrameIndex = 0;
      }
    }

    return animation.frames[_lastFrameIndex];
  }

  _AnimationState(this.animation, this.x, this.y, this.buffer);
}
