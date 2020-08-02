import 'package:alphabet/engine/animations.dart';

class Resources {
  static final animation = Animation(_animationFrames, 300);

  static final _animationFrames = [
    """
1111111
1111111
1111111
    """,
    """
2222222
2222222
2222222
    """,
    """
3333333
3333333
3333333
    """,
  ].map((e) => e.trim()).toList();
}
