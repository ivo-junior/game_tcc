// import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/ui/decoration/porta_Mercado.dart';
import 'package:game_tcc/ui/decoration/porta_universidade.dart';
import 'package:game_tcc/ui/desafios/memoria/game_page.dart';
import 'package:game_tcc/ui/desafios/mercado/simulador.dart';
import 'package:game_tcc/ui/desafios/mercado/simulador_conhecido.dart';
import 'package:game_tcc/ui/desafios/quiz/home_quiz.dart';
import 'package:game_tcc/ui/interface/knight_interface.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/ui/menu.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/personagens/npcs.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:game_tcc/ui/personagens/wizard_npc.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:game_tcc/util/sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game>
    with WidgetsBindingObserver
    implements GameListener {
  bool showGameOver = false;
  bool _initGame = true;
  bool showDialIn = true;

  late String? _nomeP;
  late Npc joaquim, maria, sofia, antonio, sara, marcos, ester;
  late NpcModel joaquimModel,
      george,
      mariaModel,
      sofiaModel,
      antonioModel,
      saraModel,
      marcosModel,
      esterMoel;
  late PersonagemModel _personagemModel;
  late Personagem_widget _personagem_widget;

  List<Npc> lsNpcs = [];
  List<NpcModel> lsNpcsModel = [];

  late GameController _controller;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _controller = GameController()..addListener(this);
    Sounds.playBackgroundSound();
    _textEditingController = TextEditingController();
    _personagemModel = PersonagemModel(saldo: 0.00, ls_compras: []);
    mariaModel = NpcModel(
      "Maria", "descobrir os próximos movimentos de preço", "1", "50.00",
      // desafioAtivo: true);
    );

    george = NpcModel("Reitor", "Assistir Curso", "1", "100.00");
    joaquimModel = NpcModel(
      "Joaquim",
      "Quiz sobres investimentos",
      "1",
      "50.00",
    );
    sofiaModel = NpcModel(
      "Sofia",
      "Jogo da Memória",
      "1",
      "50.00",
    );
    antonioModel = NpcModel(
      "Antônio",
      "Quiz sobres investimentos",
      "2",
      "200.00",
    );
    saraModel = NpcModel(
      "Sara",
      "descobrir os próximos movimentos de preço",
      "2",
      "200.00",
    );
    marcosModel = NpcModel(
      "Marcos",
      "Jogo da Memória",
      "2",
      "200.00",
    );
    esterMoel = NpcModel(
      "Estér",
      "descobrir os próximos movimentos do preço",
      "3",
      "500.00",
    );

    lsNpcsModel.addAll([
      mariaModel,
      george,
      joaquimModel,
      sofiaModel,
      antonioModel,
      saraModel,
      marcosModel,
      esterMoel
    ]);

    _personagem_widget = Personagem_widget(_personagemModel);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Sounds.resumeBackgroundSound();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        Sounds.pauseBackgroundSound();
        break;
      case AppLifecycleState.detached:
        Sounds.stopBackgroundSound();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    Sounds.stopBackgroundSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initGame) {
      return buildTelaAber();
    } else
      return buildGame();
  }

  Widget buildGame() {
    Size sizeScreen = MediaQuery.of(context).size;

    tileSize = max(sizeScreen.height, sizeScreen.width) / 15;

    return Material(
      color: Colors.transparent,
      child: BonfireTiledWidget(
        gameController: _controller,
        joystick: Joystick(
          keyboardConfig: KeyboardConfig(
            keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows,
            acceptedKeys: [
              LogicalKeyboardKey.space,
            ],
          ),
          directional: JoystickDirectional(
            spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
            spriteKnobDirectional: Sprite.load('joystick_knob.png'),
            size: 100,
            isFixed: false,
          ),
        ),
        map: TiledWorldMap(
          'tiled/map.json',
          forceTileSize: Size(tileSize, tileSize),
          objectsBuilder: {
            'player': (p) {
              _personagemModel.nome = _nomeP;
              _personagem_widget.position = p.position;

              return _personagem_widget;
            },
            'porta_academia': (p) => PortaUniversidadde(p.position, p.size,
                context, george, _personagemModel), // objetos ou itens
            'porta_bolca': (p) =>
                PortaSimulador(p.position, p.size, context, _personagemModel),
            'prefeito': (p) => WizardNPC(
                p.position, _nomeP!, lsNpcsModel, _personagemModel), //npc
            'npc1': (p) {
              maria = Npc(
                  p.position,
                  NpcSpriteSheet.npc1(),
                  NpcSpriteSheet.npc1P(),
                  () => MaterialPageRoute(
                      builder: (context) => new SimuladorConhecido(
                            player: _personagemModel,
                            contDesaf: 1,
                            npcModel: mariaModel,
                          )),
                  mariaModel);
              if (!lsNpcs.contains(maria))
                setState(() {
                  lsNpcs.add(maria);
                });
              // setState(() {});
              return maria;
            },
            'npc2': (p) {
              joaquim = Npc(
                  p.position,
                  NpcSpriteSheet.npc2(),
                  NpcSpriteSheet.npc2P(),
                  () => MaterialPageRoute(
                      builder: (context) => new HomeQuiz(
                            totalQuest: 3,
                            player: _personagemModel,
                            totalChances: 2,
                            recompensaQuest: 50.00,
                            npcModel: joaquimModel,
                          )),
                  joaquimModel);
              if (!lsNpcs.contains(joaquim))
                setState(() {
                  lsNpcs.add(joaquim);
                });
              // setState(() {});
              return joaquim;
            },
            'npc3': (p) {
              sofia = Npc(
                  p.position,
                  NpcSpriteSheet.npc3(),
                  NpcSpriteSheet.npc3P(),
                  () => MaterialPageRoute(
                      builder: (context) => new GameMemoriaPage(
                            difficulty: 0,
                            player: _personagemModel,
                            totalAjuda: 2,
                            recompensaPar: 50.00,
                            npcModel: sofiaModel,
                          )),
                  sofiaModel);
              if (!lsNpcs.contains(sofia))
                setState(() {
                  lsNpcs.add(sofia);
                });
              // setState(() {});
              return sofia;
            },
            'npc4': (p) {
              antonio = Npc(
                  p.position,
                  NpcSpriteSheet.npc4(),
                  NpcSpriteSheet.npc4P(),
                  () => MaterialPageRoute(
                      builder: (context) => new HomeQuiz(
                            totalQuest: 5,
                            player: _personagemModel,
                            totalChances: 3,
                            recompensaQuest: 100.00,
                            npcModel: antonioModel,
                          )),
                  antonioModel);
              if (!lsNpcs.contains(antonio))
                setState(() {
                  lsNpcs.add(antonio);
                });
              // setState(() {});
              return antonio;
            },
            'npc5': (p) {
              sara = Npc(
                  p.position,
                  NpcSpriteSheet.npc5(),
                  NpcSpriteSheet.npc5P(),
                  () => MaterialPageRoute(
                      builder: (context) => new SimuladorConhecido(
                            player: _personagemModel,
                            contDesaf: 4,
                            npcModel: saraModel,
                          )),
                  saraModel);
              if (!lsNpcs.contains(sara))
                setState(() {
                  lsNpcs.add(sara);
                });
              // setState(() {});
              return sara;
            },
            'npc6': (p) {
              marcos = Npc(
                  p.position,
                  NpcSpriteSheet.npc6(),
                  NpcSpriteSheet.npc6P(),
                  () => MaterialPageRoute(
                      builder: (context) => new GameMemoriaPage(
                            difficulty: 1,
                            player: _personagemModel,
                            totalAjuda: 2,
                            recompensaPar: 100.00,
                            npcModel: marcosModel,
                          )),
                  marcosModel);
              if (!lsNpcs.contains(marcos))
                setState(() {
                  lsNpcs.add(marcos);
                });
              // setState(() {});
              return marcos;
            },
            'npc7': (p) {
              ester = Npc(
                  p.position,
                  NpcSpriteSheet.npc8(),
                  NpcSpriteSheet.npc8P(),
                  () => MaterialPageRoute(
                      builder: (context) => new SimuladorConhecido(
                            player: _personagemModel,
                            contDesaf: 6,
                            npcModel: esterMoel,
                          )),
                  esterMoel);
              if (!lsNpcs.contains(ester))
                setState(() {
                  lsNpcs.add(ester);
                });
              // setState(() {});
              return ester;
            },
          },
        ),
        interface: KnightInterface(lsNpcs, _personagem_widget),
        player: _personagem_widget,
        background: BackgroundColorGame(Colors.grey[900]!),
        progress: Container(
          padding: EdgeInsets.fromLTRB(0, sizeScreen.height / 2, 0, 0),
          color: Colors.black,
          child: Center(
              child: Column(children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            Text(
              "Carregando...",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Normal',
                fontSize: 20.0,
              ),
            ),
          ])),
        ),
      ),
    );
  }

  Widget buildTelaAber() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xffaaffee),
        child: Image.asset("assets/images/City-sunset.png"),
      ),
      Center(
        child: SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: Size(150, 40),
            ),
            child: Text(
              showDialIn
                  ? 'CONVERSAR'
                  : (Dialogs.diall('')["menu"] as Map)["go"],
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Normal',
                fontSize: 17.0,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (showDialIn) {
                showDialog(
                    context: context,
                    builder: ((BuildContext context) => _showInitiDial()));
              }
              if (_initGame && !showDialIn) {
                showDialog(
                    context: context,
                    builder: (BuildContext c) {
                      return AnimatedSwitcher(
                          duration: Duration(milliseconds: 2500),
                          child: _initGame
                              ? AlertDialog(
                                  title: const Text("Digite seu nome:"),
                                  content: TextField(
                                    controller: _textEditingController,
                                    maxLines: 1,
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Nome'),
                                    onSubmitted: (String value) async {
                                      _nomeP = value;
                                      await showDialog<void>(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Seja bem vindo ${_nomeP}. Bom jogo!'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _initGame = false;
                                                    });

                                                    Navigator.pop(c);
                                                  },
                                                  child: const Text("Ok"),
                                                ),
                                              ],
                                            );
                                          });
                                      Navigator.pop(c);
                                    },
                                  ),
                                )
                              : null);
                    });
              }
            },
          ),
        ),
      ),
    ]);
  }

  Widget _showInitiDial() {
    return TalkDialog(
      says: [
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_1"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_2"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onFinish: () => setState(() {
        showDialIn = false;
      }),
    );
  }

  void _showDialogGameOver() {
    setState(() {
      showGameOver = true;
    });

    Dialogs.showGameOver(
      context,
      () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Game()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (_controller.player != null && _controller.player?.isDead == true) {
      if (!showGameOver) {
        showGameOver = true;
        _showDialogGameOver();
      }
    }
  }
}
