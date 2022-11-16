import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/util/functions.dart';
import 'package:game_tcc/util/player_sprite_sheet.dart';
import 'package:flutter/material.dart';

class Personagem_widget extends SimplePlayer with Lighting, ObjectCollision {
  static Personagem_widget? _personagem_widget;
  async.Timer? _timerStamina;
  // bool containKey = false;
  bool showObserveEnemy = false;
  PersonagemModel personagemModel;
  // Vector2 posit

  Personagem_widget(this.personagemModel)
      : super(
          animation: PlayerSpriteSheet.playerAnimations(),
          size: Vector2.all(32),
          position: personagemModel.position,
          // position: this.position,

          life: 200,
          speed: tileSize * 32,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(valueByTileSize(6), valueByTileSize(6)),
            align: Vector2(
              valueByTileSize(4),
              valueByTileSize(8),
            ),
          ),
        ],
      ),
    );

    setupLighting(
      LightingConfig(
        radius: width * 1.5,
        blurBorder: width,
        color: Colors.deepOrangeAccent.withOpacity(0.2),
      ),
    );
  }

  static getInstance(PersonagemModel p) {
    if (_personagem_widget == null) {
      _personagem_widget = Personagem_widget(p);
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    this.speed = personagemModel.initSpeed * event.intensity;
    super.joystickChangeDirectional(event);
  }

  // @override
  // void joystickAction(JoystickActionEvent event) {
  //   if (event.id == 0 && event.event == ActionEvent.DOWN) {
  //     actionAttack();
  //   }

  //   if (event.id == LogicalKeyboardKey.space.keyId &&
  //       event.event == ActionEvent.DOWN) {
  //     actionAttack();
  //   }

  //   if (event.id == 1 && event.event == ActionEvent.DOWN) {
  //     actionAttackRange();
  //   }
  //   super.joystickAction(event);
  // }

  @override
  void die() {
    removeFromParent();
    gameRef.add(
      GameDecoration.withSprite(
        sprite: Sprite.load('player/crypt.png'),
        position: Vector2(
          this.position.x,
          this.position.y,
        ),
        size: Vector2.all(30),
      ),
    );
    super.die();
  }

  // void actionAttack() {
  //   if (stamina < 15) {
  //     return;
  //   }

  //   Sounds.attackPlayerMelee();
  //   decrementStamina(15);
  //   this.simpleAttackMelee(
  //     damage: attack,
  //     animationDown: PlayerSpriteSheet.attackEffectBottom(),
  //     animationLeft: PlayerSpriteSheet.attackEffectLeft(),
  //     animationRight: PlayerSpriteSheet.attackEffectRight(),
  //     animationUp: PlayerSpriteSheet.attackEffectTop(),
  //     size: Vector2.all(tileSize),
  //   );
  // }

  // void actionAttackRange() {
  //   if (stamina < 10) {
  //     return;
  //   }

  //   Sounds.attackRange();

  //   decrementStamina(10);
  //   this.simpleAttackRange(
  //     animationRight: GameSpriteSheet.fireBallAttackRight(),
  //     animationLeft: GameSpriteSheet.fireBallAttackLeft(),
  //     animationUp: GameSpriteSheet.fireBallAttackTop(),
  //     animationDown: GameSpriteSheet.fireBallAttackBottom(),
  //     animationDestroy: GameSpriteSheet.fireBallExplosion(),
  //     size: Vector2(tileSize * 0.65, tileSize * 0.65),
  //     damage: 10,
  //     speed: initSpeed * (tileSize / 32),
  //     enableDiagonal: false,
  //     onDestroy: () {
  //       Sounds.explosion();
  //     },
  //     collision: CollisionConfig(
  //       collisions: [
  //         CollisionArea.rectangle(size: Vector2(tileSize / 2, tileSize / 2)),
  //       ],
  //     ),
  //     lightingConfig: LightingConfig(
  //       radius: tileSize * 0.9,
  //       blurBorder: tileSize / 2,
  //       color: Colors.deepOrangeAccent.withOpacity(0.4),
  //     ),
  //   );
  // }

  @override
  void update(double dt) {
    if (isDead) return;
    _verifyStamina();
    this.seeEnemy(
      radiusVision: tileSize * 6,
      notObserved: () {
        showObserveEnemy = false;
      },
      observed: (enemies) {
        if (showObserveEnemy) return;
        showObserveEnemy = true;
        _showEmote();
      },
    );
    super.update(dt);
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }

  void _verifyStamina() {
    if (_timerStamina == null) {
      _timerStamina = async.Timer(Duration(milliseconds: 150), () {
        _timerStamina = null;
      });
    } else {
      return;
    }

    personagemModel.stamina += 2;
    if (personagemModel.stamina > 100) {
      personagemModel.stamina = 100;
    }
  }

  void decrementStamina(int i) {
    personagemModel.stamina -= i;
    if (personagemModel.stamina < 0) {
      personagemModel.stamina = 0;
    }
  }

  @override
  void receiveDamage(double damage, dynamic id) {
    if (isDead) return;
    this.showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.orange,
        fontFamily: 'Normal',
      ),
    );
    super.receiveDamage(damage, id);
  }

  void _showEmote({String emote = 'emote/emote_exclamacao.png'}) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: SpriteAnimation.load(
          emote,
          SpriteAnimationData.sequenced(
            amount: 8,
            stepTime: 0.1,
            textureSize: Vector2(32, 32),
          ),
        ),
        target: this,
        size: Vector2(32, 32),
        positionFromTarget: Vector2(18, -6),
      ),
    );
  }
}
