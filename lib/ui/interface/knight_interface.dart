import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/ui/interface/bar_component.dart';
import 'package:game_tcc/ui/interface/mini_mapa_component.dart';
import 'package:game_tcc/ui/personagens/npcs.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:flutter/material.dart';

class KnightInterface extends GameInterface {
  late Sprite key;
  List<Npc> lsNpcs;
  Personagem_widget personagem;

  KnightInterface(this.lsNpcs, this.personagem);

  @override
  Future<void> onLoad() async {
    // key = await Sprite.load('itens/key_silver.png');
    add(BarComponent(personagem.personagemModel));
    add(MiniMapaComponent(lsNpcs, personagem));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      // _drawKey(canvas);
    } catch (e) {}
    super.render(canvas);
  }

  // void _drawKey(Canvas c) {
  //   if (gameRef.player != null &&
  //       (gameRef.player as Personagem_widget).containKey) {
  //     key.renderRect(c, Rect.fromLTWH(150, 20, 35, 30));
  //   }
  // }
}
