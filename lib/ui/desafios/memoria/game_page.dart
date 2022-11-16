import 'dart:async';

import 'package:bonfire/util/talk/say.dart';
import 'package:bonfire/util/talk/talk_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:game_tcc/ui/desafios/memoria/ajuta_widget.dart';
import 'package:game_tcc/ui/desafios/memoria/game_model.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/globalKeys.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';

class GameMemoriaPage extends StatefulWidget {
  final int difficulty;
  final PersonagemModel player;
  final double recompensaPar;
  final int totalAjuda;
  NpcModel npcModel;

  bool dialIni = true;

  GameMemoriaPage(
      {required this.difficulty,
      required this.player,
      required this.recompensaPar,
      required this.totalAjuda,
      required this.npcModel});

  @override
  _GameMPageState createState() =>
      _GameMPageState(player, recompensaPar, totalAjuda, npcModel);
}

class _GameMPageState extends State<GameMemoriaPage> {
  late GameMemoria game;
  late Timer? timer;
  NpcModel npcModel;
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  int previousIndex = -1;
  bool flip = false;

  int totalajuda;
  bool pausa = false;
  late MyGlobals _myGlobals;

  PersonagemModel _player;
  double recompensaPar, valorAjuda = 50.0;
  bool orientation = true;

  _GameMPageState(
      this._player, this.recompensaPar, this.totalajuda, this.npcModel);
  @override
  void initState() {
    super.initState();

    _myGlobals = MyGlobals();

    this.game = new GameMemoria(widget.difficulty);

    cardStateKeys =
        game.cards.map((_) => new GlobalKey<FlipCardState>()).toList();

    // startTimer();
  }

  @override
  void dispose() {
    // game = null;
    timer!.cancel();
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (!pausa) game.time--;
        if (game.time == 0) {
          // you lost
          startTimer();
          timer!.cancel();
          showResult(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!npcModel.testResolvido && npcModel.desafioAtivo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    return npcModel.desafioAtivo && game.time > 0
        ? Scaffold(
            key: _myGlobals.scaffoldKey,
            body: Stack(
              children: <Widget>[
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                  Text(
                                    "Saldo: ",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    "R\$ ${_player.saldo}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: _player.saldo > 0.0
                                            ? Colors.blue[400]
                                            : Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.question_mark,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        if (totalajuda > 0) {
                                          setState(() {
                                            pausa = true;
                                            totalajuda--;
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext c) {
                                                return Scaffold(
                                                    body: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Center(
                                                          child: IconButton(
                                                            iconSize: 45,
                                                            icon: Icon(
                                                              Icons.arrow_back,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    c),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  80, 0, 00, 0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Ajuda',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      25.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Ajuda(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.zoom_in_sharp,
                                                          color: Colors.black,
                                                        ),
                                                        Text(
                                                          'Inspecione a imagem',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(Icons.zoom_out,
                                                            color:
                                                                Colors.black),
                                                      ],
                                                    )
                                                    // Row(children: [],),
                                                  ],
                                                ));
                                              }).then((value) => setState(() {
                                                pausa = false;
                                              }));
                                        } else {
                                          ScaffoldMessenger.maybeOf(_myGlobals
                                                      .scaffoldKey
                                                      .currentContext
                                                  as BuildContext)!
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Você não tem mais ajudas disponíveis!',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                              action: SnackBarAction(
                                                  label: 'OK',
                                                  onPressed: () {}),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Ajudas: $totalajuda",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pausa = true;
                                        });
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext c) =>
                                                AlertDialog(
                                                  title: const Center(
                                                    child: Text(
                                                      "Ajudas",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  content: Container(
                                                    height: 100,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Comprar 1 ajuda!",
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Valor: R\$$valorAjuda",
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      onPressed: () {
                                                        if (_player.saldo >=
                                                            valorAjuda) {
                                                          setState(() {
                                                            _player.saldo -=
                                                                valorAjuda;
                                                            valorAjuda *= 2;
                                                            totalajuda++;
                                                          });

                                                          Navigator.pop(
                                                              c, null);
                                                        } else
                                                          Navigator.pop(c,
                                                              "Saldo induficiente");
                                                      },
                                                      child: Text(
                                                        "Comprar",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      color: Colors.green[800],
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(c);
                                                        },
                                                        child: const Text(
                                                            "Cancelar"))
                                                  ],
                                                )).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              pausa = false;
                                            });
                                            // print(value);
                                            ScaffoldMessenger.maybeOf(_myGlobals
                                                        .scaffoldKey
                                                        .currentContext
                                                    as BuildContext)!
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  value,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                                action: SnackBarAction(
                                                    label: 'OK',
                                                    onPressed: () {}),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              pausa = false;
                                            });
                                          }
                                        });
                                      },
                                      // color: Color.fromARGB(255, 0, 0, 0),
                                      // color: Colors.lightBlue[800],
                                    ),
                                  ),
                                  // const SizedBox(width: 5)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${game.time}',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: game.time > 10
                                      ? Colors.grey
                                      : Colors.red)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "(Recompensa R\$$recompensaPar por cada acerto!)",
                              style:
                                  TextStyle(fontSize: 9, color: Colors.black),
                            )
                          ],
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: game.cardsForRow,
                          ),
                          itemBuilder: (context, index) => FlipCard(
                            key: cardStateKeys[index],
                            onFlip: () {
                              if (!flip) {
                                flip = true;
                                previousIndex = index;
                              } else {
                                flip = false;
                                if (previousIndex != index) {
                                  if (game.cards[previousIndex].index !=
                                      game.cards[index].index) {
                                    //  Quando ele clica no segundo
                                    cardStateKeys[previousIndex]
                                        .currentState!
                                        .toggleCard();
                                    previousIndex = index;
                                  } else {
                                    game.cards[previousIndex].flip = false;
                                    game.cards[index].flip = false;
                                    setState(() {
                                      _player.saldo += recompensaPar;
                                    });
                                    if (game.cards
                                        .every((card) => card.flip == false)) {
                                      // Quando acerta td e vence o Jogo
                                      timer!.cancel();
                                      showResult(true);
                                    }
                                  }
                                }
                              }
                            },
                            direction: FlipDirection.HORIZONTAL,
                            flipOnTouch: game.cards[index].flip,
                            front: Card(
                              elevation: 4,
                              color: Colors.blueAccent,
                              margin: EdgeInsets.all(4),
                              child: Icon(Icons.grade,
                                  size: 60, color: Colors.white),
                            ),
                            back: Card(
                                elevation: 4,
                                color: Colors.white,
                                margin: EdgeInsets.all(4),
                                child: SvgPicture.asset(
                                    game.cards[index].assetImagePath)),
                          ),
                          itemCount: game.cards.length,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_player.msgIniMemoria && widget.dialIni)
                  GestureDetector(onTap: () {
                    setState(() {
                      widget.dialIni = false;
                    });

                    showDialog(
                        context: context,
                        builder: ((BuildContext context) => showInitiDial()));
                  }),
              ],
            ))
        : Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: OutlinedButton(
                  child: Row(children: [
                    Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text('Voltar ao Jogo')
                  ]),
                  onPressed: () {
                    startTimer();
                    timer!.cancel();
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
  }

  Widget showInitiDial() {
    return TalkDialog(
      says: [
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_9"]),
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
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_10"]),
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
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_11"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
          // bottom: TextButton(
          //   onPressed: () {},
          //   child: Row(
          //     children: [
          //       Checkbox(
          //         onChanged: (bool? value) {
          //           if (value != null)
          //             setState(() {
          //               _player.msgIniMemoria = value;
          //               // this._initiMsg = value;
          //             });
          //         },
          //         value: _player.msgIniMemoria,
          //       ),
          //       Text(
          //         " Não exibir mesnsagem novamente!",
          //         style: TextStyle(fontSize: 12, color: Colors.white),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ],
      onFinish: () => startTimer(),
    );
  }

  showResult(bool matched) {
    String messageCustom = game.time >= 30
        ? 'Show🙌'
        : game.time >= 15
            ? 'Excelente memória! 👏'
            : 'Muito bem 👍';
    String message = matched ? messageCustom : 'Tempo acabado! ⌛️';
    String content = matched
        ? 'Parabéns! Você conseguiu! 😎'
        : 'Não foi dessa vez! 😫\nNão desanime, volte depois e tente novamente 😉';
    if (game.time >= 15) {
      setState(() {
        npcModel.desafioAtivo = false;
        npcModel.testResolvido = true;

        if (game.time >= 30) {
          _player.saldo += 1000.0;
        }
      });
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Column(
          children: <Widget>[
            if (game.time > 0)
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ZoomIn(
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                            game.time > 0 ? Icons.star : Icons.star_border,
                            size: 40,
                            color: Colors.yellow)),
                    ZoomIn(
                        delay: Duration(milliseconds: 250),
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                            game.time >= 15 ? Icons.star : Icons.star_border,
                            size: 50,
                            color: Colors.yellow)),
                    ZoomIn(
                        delay: Duration(milliseconds: 500),
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                            game.time >= 30 ? Icons.star : Icons.star_border,
                            size: 40,
                            color: Colors.yellow)),
                  ]),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        content: Text(content, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.blueAccent),
            // textColor: Colors.blueAccent,
            onPressed: () => Navigator.pop(context),
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (BuildContext context) => GameMemoriaPage(
            //               difficulty: widget.difficulty,
            //               player: _player,
            //               recompensaPar: recompensaPar,
            //               totalAjuda: totalajuda, npcModel: npcModel,
            //             ))),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
