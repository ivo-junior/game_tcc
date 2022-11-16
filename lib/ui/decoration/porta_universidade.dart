import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/universidade/universidadde.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:path/path.dart';

class PortaUniversidadde extends GameDecoration with ObjectCollision {
  bool _showIntro = false;
  late BuildContext _context;
  NpcModel desafioAtivo;
  PersonagemModel _personagemModel;
  var root;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  PortaUniversidadde(Vector2 position, Vector2 size, this._context,
      this.desafioAtivo, this._personagemModel)
      : super.withSprite(
          sprite: Sprite.load('itens/door_open.png'),
          // sprite: Sprite.load(''),
          position: position,
          size: size,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            // size: Vector2(width, height / 4),
            size: Vector2(width, height * 20),
            align: Vector2(0, height * 0.75),
          ),
        ],
      ),
    );
    root = () => MaterialPageRoute(
        builder: (context) => new Universidade(_personagemModel));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player != null) {
      this.seeComponent(
        gameRef.player!,
        observed: (player) {
          // Future.delayed(Duration(milliseconds: 200), () {
          //   removeFromParent();
          // });
          // } else {

          if (!_showIntro) {
            _showIntro = true;
            _showIntroduction();

            gameRef.player!.position.y += 30;
          }
          // }
        },
        radiusVision: (60),
      );
      _showIntro = false;
    }
  }

  void _showIntroduction() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_George_1"],
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.reitor(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
            text: [
              TextSpan(
                text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_George_2"],
              ),
            ],
            person: CustomSpriteAnimationWidget(
              animation: NpcSpriteSheet.reitor(),
            ),
            personSayDirection: PersonSayDirection.LEFT,
            bottom: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                if (!desafioAtivo.testResolvido && desafioAtivo.desafioAtivo) {
                  showDialog(
                      context: this.gameRef.context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.green,
                          ),
                          title: Text(
                            'Parabéns!',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          content: Text('Desafio concluido!',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                          actions: [
                            Center(
                              child: TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            )
                          ],
                        );
                      });
                  desafioAtivo.testResolvido = true;
                  _personagemModel.saldo += 100;
                }
                Navigator.of(_context).push(root());
              },
              child: Text('Entrar'),
            )),
      ],
    );
  }
}
