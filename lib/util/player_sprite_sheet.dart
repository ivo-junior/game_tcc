import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static Future<SpriteAnimation> idleRight() => SpriteAnimation.load(
        'player/knight_idle.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(22.5, 42),
        ),
      );

  static SimpleDirectionAnimation playerAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: idleRight(),
        idleRight: idleRight(),
        runLeft: SpriteAnimation.load(
          'player/knight_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(22.5, 42),
          ),
        ),
        runRight: SpriteAnimation.load(
          'player/knight_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(22.5, 42),
          ),
        ),
        runUp: SpriteAnimation.load(
          'player/knight_run_up.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(22.5, 42),
          ),
        ),
        runDown: SpriteAnimation.load(
          'player/knight_run_dow.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(22.5, 42),
          ),
        ),
      );
}
