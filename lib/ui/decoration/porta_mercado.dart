import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/desafios/mercado/simulador.dart';
import 'package:game_tcc/ui/universidade/universidadde.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:path/path.dart';

class PortaSimulador extends GameDecoration with ObjectCollision {
  late BuildContext _context;
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

  PortaSimulador(
      Vector2 position, Vector2 size, this._context, this._personagemModel)
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
        builder: (context) => new Simulador(player: _personagemModel));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player != null) {
      this.seeComponent(
        gameRef.player!,
        observed: (player) {
          Navigator.of(_context).push(root());

          gameRef.player!.position.y += 30;
        },
        radiusVision: (60),
      );
    }
  }
}
