import 'package:game_tcc/main.dart';
import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/functions.dart';

import 'package:game_tcc/util/sounds.dart';
import 'package:flutter/material.dart';

class Npc extends GameDecoration with ObjectCollision {
  bool conversationWithHero = false;

  late BuildContext _context;

  Future<SpriteAnimation> img1, img2;

  NpcModel npcModel;

  var root;
  late Map falas;

  // final IntervalTick _timer = IntervalTick(1000);
  // Kid(Vector2 position, this._context)
  Npc(Vector2 position, this.img1, this.img2, this.root, this.npcModel)
      : super.withAnimation(
          // animation: NpcSpriteSheet.kidIdleLeft(),
          animation: img1,
          position: position,
          size: Vector2(valueByTileSize(8), valueByTileSize(11)),
        ) {
    falas = Dialogs.desafio(npcModel.nome_npc, npcModel.nome_problema);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player != null) {
      this.seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!npcModel.testResolvido) {
            _showEmote(emote: 'emote/emote_interregacao.png');
          } else
            _showEmote();
          if (!conversationWithHero && npcModel.desafioAtivo) {
            gameRef.player!.idle();
            conversationWithHero = true;
            _startConversation(img2);
            gameRef.player!.position.x = this.position.x + 30;
            gameRef.player!.position.y = this.position.y + 35;
          }
        },
        radiusVision: (20),
      );
      conversationWithHero = false;
    }
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
        positionFromTarget: Vector2(18, -6),
        size: Vector2(32, 32),
      ),
    );
  }

  void _startConversation(Future<SpriteAnimation> img) {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(text: falas["talk_npcs_1"].toString()),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 10)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: img,
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(text: falas["talk_npcs_2"].toString()),
          ],
          person: CustomSpriteAnimationWidget(
            animation: img,
          ),
          personSayDirection: PersonSayDirection.RIGHT,
          bottom: ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () => Navigator.of(context).push(root()),
            child: Text('Aceitar desafio!!'),
          ),
        ),
      ],
      // onFinish: () {
      //   Sounds.interaction();
      //   gameRef.camera.moveToPlayerAnimated(finish: () {
      //     Dialogs.showCongratulations(gameRef.context);
      //   });
      // }, onChangeTalk: (index) {
      //   Sounds.interaction();
      // }
    );
  }
}
