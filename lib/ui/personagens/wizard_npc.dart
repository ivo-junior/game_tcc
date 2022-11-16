import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/ui/universidade/universidadde.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/ui/menu.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:game_tcc/util/sounds.dart';
import 'package:flutter/material.dart';

class WizardNPC extends GameDecoration with ObjectCollision {
  bool _showConversation = false;
  bool _showNpc = true;

  int currentDesafio = 0;

  bool showDes1 = true,
      showDes2 = false,
      showAllDes = false,
      showLos = false,
      showDesistir = false,
      _start = true;

  List<NpcModel> _lsNpcModel;
  String _nomeP;
  PersonagemModel personagemModel;

  late BuildContext _context;

  final IntervalTick _timer = IntervalTick(1000);

  WizardNPC(
      Vector2 position, this._nomeP, this._lsNpcModel, this.personagemModel)
      : super.withAnimation(
          animation: NpcSpriteSheet.ceo(),
          position: position,
          size: Vector2(tileSize * 0.8, tileSize),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            // size: Vector2(width, height / 4),
            size: Vector2(width, height),
            align: Vector2(0, height * 0.75),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_start) {
      if (_showNpc) {
        _showNpc = false;
        gameRef.camera.moveToTargetAnimated(
          this,
          duration: Duration(seconds: 4),
          finish: () {
            gameRef.camera.moveToPlayerAnimated();
            _showAcessMiniMapa();
          },
        );
      }
      verificaObjetivo();
      if (gameRef.player != null) {
        desafioAtivo();
        this.seeComponent(
          gameRef.player!,
          observed: (player) {
            _showEmote(emote: 'emote/emote_interregacao.png');

            if (!_showConversation) {
              gameRef.player!.idle();
              _showConversation = true;
              if (showDes1) {
                _showIntroduction(_nomeP);
                // _lsNpcModel[currentDesafio].desafioAtivo = true;
                // personagemModel.currentDesafio = 'Ajudar Maria!';
              }
              if (showDes2) {
                _showDesafio2();
                // _lsNpcModel[currentDesafio].desafioAtivo = true;
                // personagemModel.currentDesafio = 'Ir a Universidade Invest';
              }
              if (showAllDes) {
                _showDesafioAll();
                // personagemModel.currentDesafio =
                //     'Resolver problemas dos residentes';
              }
              if (showLos) _showLoos(_nomeP);
              if (showDesistir) _showCaseDesistir();
              // _lsNpcModel[currentDesafio].desafioAtivo = true;

              gameRef.player!.position.y = this.y + 120;
            }
          },
          radiusVision: (2 * tileSize),
        );
        _showConversation = false;
      }
    }
  }

  void verificaObjetivo() {
    if (!_lsNpcModel.any((element) => !element.testResolvido)) {
      _start = false;
      Navigator.popAndPushNamed(context, '/creditos');
      // pushNamedAndRemoveUntil(context, '/creditos', ModalRoute.withName('/'));
    }
  }

  void desafioAtivo() {
    // currentDesafio = _lsNpcModel.indexOf(_lsNpcModel.firstWhere(
    //     (element) => element.desafioAtivo && !element.testResolvido));
    if (_lsNpcModel[currentDesafio].testResolvido &&
        currentDesafio < _lsNpcModel.length - 1) {
      currentDesafio++;
      if (!_lsNpcModel[currentDesafio].desafioAtivo &&
          !_lsNpcModel[currentDesafio].testResolvido) {
        personagemModel.currentDesafio = 'Falar com Alberto!';
      }
    }
    if (personagemModel.currentDesafio == 'Resolver problemas dos residentes')
      _lsNpcModel.forEach((element) {
        if (!element.testResolvido) element.desafioAtivo = true;
      });

    opcaoDialogs(currentDesafio);
  }

  void opcaoDialogs(int op) {
    if (op == 0) {
      //Maria
      showDes1 = true;
      showDes2 = false;
      showAllDes = false;
      showLos = false;
      showDesistir = false;
      _lsNpcModel[op].desafioAtivo = true;
    } else if (op == 1) {
      //Univeersidade Invest
      showDes1 = false;
      showDes2 = true;
      showAllDes = false;
      showLos = false;
      showDesistir = false;
      _lsNpcModel[op].desafioAtivo = true;
    } else if (op == 2) {
      //tudo
      showDes1 = false;
      showDes2 = false;
      showAllDes = true;
      showLos = false;
      showDesistir = false;
    }
    // else if (op == 3) {
    //   showDes1 = false;
    //   showDes2 = false;
    //   showAllDes = false;
    //   showLos = true;
    //   showDesistir = false;
    // } else if (op == 4) {
    //   showDes1 = false;
    //   showDes2 = false;
    //   showAllDes = false;
    //   showLos = false;
    //   showDesistir = true;
    // }
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

  void _showIntroduction(String nomeP) {
    bool continuarDial = true, exitGame = false;
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text:
                  (Dialogs.diall(nomeP)["talk_npcs"] as Map)["talk_alberto_1"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_2"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_4"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      // if (continuarDial == true)
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_5"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),

      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_7"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),

      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_9"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),

      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_alberto_10"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      personagemModel.currentDesafio = 'Ajudar Maria!';
      if (personagemModel.saldo == 0) {
        personagemModel.saldo += 1000.0;
      }
      Sounds.interaction();
    });
  }

  void _showDesafio2() {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_11"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_12"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_13"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_14"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_15"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      personagemModel.currentDesafio = 'Ir a Universidade Invest';
      Sounds.interaction();
    });
  }

  void _showDesafioAll() {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_16"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_17"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_18"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_19"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_20"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      personagemModel.currentDesafio = 'Resolver problemas dos residentes';
      Sounds.interaction();
    });
  }

  void _showLoos(String nomeP) {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall(nomeP)["talk_npcs"]
                  as Map)["talk_alberto_loos"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall(nomeP)["talk_npcs"]
                  as Map)["talk_alberto_loos_1"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      Sounds.interaction();
    });
  }

  void _showCaseDesistir() {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text:
                  (Dialogs.diall("")["talk_npcs"] as Map)["talk_alberto_des"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_npcs"]
                  as Map)["talk_alberto_des_1"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.ceoP(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      Sounds.interaction();
    });
  }

  void _showAcessMiniMapa() {
    Sounds.interaction();
    _context = gameRef.context;
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
              text: (Dialogs.diall("")["talk_game"] as Map)["talk_game_12"]),
          TextSpan(
              text: "\n(Clique para continuar)",
              style: TextStyle(fontSize: 10)),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.gameADM(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ], onChangeTalk: (index) {
      Sounds.interaction();
    }, onFinish: () {
      Sounds.interaction();
    });
  }
}
