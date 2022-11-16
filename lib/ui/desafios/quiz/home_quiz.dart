import 'dart:math';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/ui/desafios/quiz/components/AnswerButton.dart';
import 'package:game_tcc/ui/desafios/quiz/components/HeadingText.dart';
import 'package:game_tcc/ui/desafios/quiz/components/QuestionText.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/globalKeys.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';

import 'ques.dart';

//APP CONSTANTS
var _THEME_COLOUR_ = const Color(0xff0A3D62);

class HomeQuiz extends StatefulWidget {
  int totalQuest, totalChances;
  PersonagemModel player;
  NpcModel npcModel;
  double recompensaQuest;
  bool dialIni = true;
  HomeQuiz(
      {Key? key,
      required this.totalQuest,
      required this.player,
      required this.totalChances,
      required this.recompensaQuest,
      required this.npcModel})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState(
      totalQues: totalQuest,
      player: player,
      totalChances: totalChances,
      recompensaQuest: recompensaQuest,
      npcModel: npcModel);
}

class _HomeState extends State<HomeQuiz> {
  int totalQues;

  int totalChances;
  // int contBuyChance = 1;
  double valorChance = 50.00;
  double recompensaQuest;

  String quiz_status = "";
  bool showBTTCance = false;
  PersonagemModel player;
  int solvedQues = 1;
  String nextQue = "";
  String score = "";
  String? op1, op2, op3, op4, answer;
  int finalScore = 1;
  List<int> solvedQuesIndexes = [];
  List lsScores = [];

  double mediaScore = 0, somaScores = 0;

  bool _initMsg = false;
  bool telaVoltar = false;

  NpcModel npcModel;

  MyGlobals myGlobals = MyGlobals();

  _HomeState(
      {required this.totalQues,
      required this.player,
      required this.totalChances,
      required this.recompensaQuest,
      required this.npcModel});

  @override
  void initState() {
    start_quiz(context);
    super.initState();
  }

  void check_ans(String value) {
    // print(value);
    setState(() {
      solvedQues += 1;
      if (value == answer) {
        finalScore += 1;
        player.saldo += recompensaQuest;
      }
      if (solvedQues == totalQues) {
        score = "SCORE: $finalScore/$totalQues";
        quiz_status = "RESTART";
        showBTTCance = true;
        nextQue = "";
        op1 = "";
        op2 = "";
        op3 = "";
        op4 = "";
        lsScores.add(finalScore / totalQues);
      } else {
        var index = Random().nextInt(QUES.length);
        while (solvedQuesIndexes.contains(index)) {
          index = Random().nextInt(QUES.length);
        }
        solvedQuesIndexes.add(index);
        List<String> ans = QUES[index]['answers'] as List<String>;
        nextQue = QUES[index]['question'].toString();
        if (ans.length >= 4) {
          op1 = ans[0];
          op2 = ans[1];
          op3 = ans[2];
          op4 = ans[3];
        } else {
          op1 = ans[0];
          op2 = ans[1];
          op3 = "";
          op4 = "";
        }

        answer = ans[QUES[index]['correctIndex'] as int];
      }
    });
  }

  void start_quiz(BuildContext cont) {
    print("In");
    if (totalChances > 0) {
      setState(() {
        finalScore = 0;
        solvedQues = 0;
        score = "";
        quiz_status = "";
        totalChances--;
        showBTTCance = false;
        solvedQuesIndexes = [];
        var index = Random().nextInt(QUES.length);
        while (solvedQuesIndexes.contains(index)) {
          index = Random().nextInt(QUES.length);
        }
        solvedQuesIndexes.add(index);
        List<String> ans = QUES[index]['answers'] as List<String>;
        nextQue = QUES[index]['question'].toString();
        if (ans.length >= 4) {
          op1 = ans[0];
          op2 = ans[1];
          op3 = ans[2];
          op4 = ans[3];
        } else {
          op1 = ans[0];
          op2 = ans[1];
          op3 = "";
          op4 = "";
        }
        answer = ans[QUES[index]['correctIndex'] as int];
      });
    } else if (totalChances <= 0) {
      ScaffoldMessenger.of(cont).showSnackBar(
        SnackBar(
          content: Text(
            (Dialogs.diall('')["talk_game"] as Map)["talk_game_8"],
            style: TextStyle(fontSize: 15),
          ),
          action: SnackBarAction(
              label: 'VOLTAR AO GAME',
              onPressed: () {
                setState(() {
                  telaVoltar = true;
                });
                showResult(cont);

                // start_quiz(cont);

                // totalChances = 1;
                // Navigator.pop(cont);
              }),
        ),
      );
    }
  }

  // String nextque = "Whats is the scientific name of a butterfly?";
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width * 0.6;
    return npcModel.desafioAtivo &&
            player.saldo != 0 &&
            !telaVoltar &&
            !npcModel.testResolvido
        ? Scaffold(
            key: myGlobals.scaffoldKey,
            body: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                "R\$ ${player.saldo}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: player.saldo > 0.0
                                        ? Colors.blue
                                        : Colors.black),
                              )
                            ],
                          ),
                          if (!showBTTCance)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HeadingText(
                                  "Questão ${solvedQues + 1}/${totalQues}"
                                      .toUpperCase(),
                                ),
                              ],
                            ),
                          if (!showBTTCance)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Recompensa R\$$recompensaQuest",
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.black),
                                )
                              ],
                            ),

                          QuestionText("$nextQue", screen_width),
                          //Answer Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      if (op1 != "" && op1 != null)
                                        AnswerButton(
                                            op1, check_ans, screen_width),
                                      if (op2 != "" && op2 != null)
                                        AnswerButton(
                                            op2, check_ans, screen_width),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (op3 != "" && op3 != null)
                                        AnswerButton(
                                            op3, check_ans, screen_width),
                                      if (op4 != "" && op4 != null)
                                        AnswerButton(
                                            op4, check_ans, screen_width),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          HeadingText("$score".toUpperCase()),
                          if (showBTTCance)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Acertividade até o momento: ${((finalScore / totalQues) * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: mediaScore > 0.5
                                          ? Colors.blue[800]
                                          : Colors.red),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      showResult(myGlobals.scaffoldKey
                                          .currentContext as BuildContext);
                                      setState(() {
                                        telaVoltar = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (showBTTCance)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chances: $totalChances",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Center(
                                                  child: Text(
                                                    "Chances",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                content: Container(
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
                                                            "Comprar 1 chance!",
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
                                                            "Valor: R\$$valorChance",
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () {
                                                      if (player.saldo >=
                                                          valorChance) {
                                                        setState(() {
                                                          player.saldo -=
                                                              valorChance;
                                                          valorChance *= 2;
                                                          totalChances++;
                                                        });
                                                        Navigator.pop(
                                                            context, null);
                                                      } else
                                                        Navigator.pop(context,
                                                            "Saldo induficiente");
                                                    },
                                                    child: Text(
                                                      "Comprar",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                    color: Colors.green[800],
                                                  ),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                          "Cancelar"))
                                                ],
                                              )).then((value) {
                                        if (value != null) {
                                          // print(value);
                                          ScaffoldMessenger.maybeOf(myGlobals
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
                                        }
                                      });
                                    },
                                    // color: Color.fromARGB(255, 0, 0, 0),
                                    // color: Colors.lightBlue[800],
                                  ),
                                ),
                              ],
                            ),
                          if (quiz_status != "")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                onPressed: () => start_quiz(myGlobals
                                    .scaffoldKey
                                    .currentContext as BuildContext),
                                color: Colors.green[800],
                                minWidth: screen_width,
                                height: 50.0,
                                child: Text(
                                  "$quiz_status",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (player.msgIniQuiz && widget.dialIni)
                  GestureDetector(onTap: () {
                    setState(() {
                      widget.dialIni = false;
                    });

                    showDialog(
                        context: context,
                        builder: ((BuildContext context) => showInitiDial()));
                  }),
              ],
            ),
          )
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
                    Text('VOLTAR AO GAME')
                  ]),
                  onPressed: () {
                    // showResult(
                    //     myGlobals.scaffoldKey.currentContext as BuildContext);
                    // totalChances = 1;
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
  }

  showResult(BuildContext con) {
    bool suces;

    lsScores.forEach((element) {
      somaScores += element;
    });
    mediaScore = somaScores / lsScores.length;

    suces = mediaScore > 0.5 ? true : false;

    String message = suces ? 'Show🙌' : 'Quase lá 👍';
    String content = suces
        ? 'Parabéns! Você conseguiu! 😎'
        : 'Não foi dessa vez! 😫\nNão desanime, volte depois e tente novamente 😉';
    if (mediaScore > 0.5) {
      setState(() {
        npcModel.desafioAtivo = false;
        npcModel.testResolvido = true;

        if (mediaScore >= 1) {
          player.saldo += 1000.0;
        }
      });
    }

    showDialog(
      context: con,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ZoomIn(
                  duration: Duration(milliseconds: 500),
                  child: Icon(mediaScore > 0.3 ? Icons.star : Icons.star_border,
                      size: 40, color: Colors.yellow)),
              ZoomIn(
                  delay: Duration(milliseconds: 250),
                  duration: Duration(milliseconds: 500),
                  child: Icon(mediaScore > 0.5 ? Icons.star : Icons.star_border,
                      size: 50, color: Colors.yellow)),
              ZoomIn(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Icon(mediaScore >= 1 ? Icons.star : Icons.star_border,
                      size: 40, color: Colors.yellow)),
            ]),
            Text(
                '${(mediaScore * 100).toStringAsFixed(2)}% de acertividade!\n$message',
                textAlign: TextAlign.center),
          ],
        ),
        content: Text(content, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.blueAccent),
            // textColor: Colors.blueAccent,
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget showInitiDial() {
    return TalkDialog(
      says: [
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_4"]),
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
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_5"]),
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
          //               player.msgIniQuiz = value;
          //               // this._initiMsg = value;
          //             });
          //         },
          //         value: player.msgIniQuiz,
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
    );
  }
}
