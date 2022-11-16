import 'package:bonfire/bonfire.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:flutter/material.dart';

import '../personagens/npcs.dart';

class MiniMapaComponent extends InterfaceComponent {
  double padding = 20;
  double widthBar = 90;
  double strokeWidth = 12;
  List<Npc> npcs;
  Personagem_widget _personagem_widget;

  bool? tap = false;

  late Sprite miniMapa;

  MiniMapaComponent(this.npcs, this._personagem_widget)
      : super(
          id: 1,
          position: Vector2(450, 270),
          // sprite: Sprite.load('health_ui.png'),
          size: Vector2(176, 80),
          selectable: true,
          onTapComponent: (bool c) => c = false,
        );

  @override
  Future<void> onLoad() async {
    // miniMapa = await Sprite.load('miniMapa.png');
    miniMapa = await Sprite.load('mapa.png');

    return super.onLoad();
  }

  // @override
  // void update(double t) {
  //   if (this.gameRef.player != null) {
  //     onTap();
  //     // if (this.gameRef.player is Personagem_widget) {
  //     //   if()
  //     // }
  //   }
  //   super.update(t);
  // }

  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    double _width = MediaQuery.of(context).size.width * 0.9;
    double _height = MediaQuery.of(context).size.height * 0.733;

    // print('W:${_width} H:${_height}');

    showDialog(
        context: this.gameRef.context,
        builder: (BuildContext cont) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: _width,
                height: _height,
                child: Scaffold(
                  body: Stack(
                    children: [
                      SvgPicture.asset('assets/images/mapa.svg'),
                      Container(
                        padding: EdgeInsets.all(1),
                        child:
                            Stack(children: getIconsQuestions(_width, height)),
                      ),
                      CustomPaint(
                        size: Size(30, 30),
                        painter: _MyPainterPerson(
                            ((_personagem_widget.x / 2.6) / 3.23),
                            ((_personagem_widget.y / 2.6) / 3.75),
                            // 10,
                            // 10,
                            _personagem_widget.personagemModel.nome as String),
                      ),
                      Row(
                        // padding: EdgeInsets.fromLTRB(0, 0, _width, _height),
                        children: [
                          Container(
                            // width: 50,
                            // height: 50,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, _height - 20),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(cont),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  List<Widget> getIconsQuestions(double x, double y) {
    List<Widget> questionsNpcs = [];
    // print('W:${_width} H:${_height}');

    npcs.forEach((element) {
      // print('W:${element.x} H:${element.y}');

      // if (!element.npcModel.testResolvido) {
      questionsNpcs.add(Center(
        child: CustomPaint(
          size: Size(30, 30),
          painter: _MyPainterNpcs(((element.x / 2.66) / 3.05) - x / 2,
              ((element.y / 2.66) / 3.04) - y * 1.733, element.npcModel),
        ),
      ));
      // }
    });

    return questionsNpcs;
  }

  // Widget buildPositions(Npc npc, int index) {
  //   return Center(
  //       child: IconButton(
  //     onPressed: () {
  //       // selected = true;
  //       if (selected) Fluttertoast.showToast(msg: npc.npcModel.nome_npc);
  //     },
  //     icon: Icon(
  //       Icons.question_mark,
  //       size: 30,
  //       color: Colors.red,
  //     ),
  //   ));
  // }

  @override
  void onTapCancel() {
    selected = false;
    super.onTapCancel();
  }

  @override
  void render(Canvas c) {
    try {
      miniMapa.renderRect(c, Rect.fromLTWH(450, 270, 176, 80));
      // _drawLife(c);
      // _drawStamina(c);
    } catch (e) {}
    super.render(c);
  }
}

class _MyPainterNpcs extends CustomPainter {
  late final iconPerson;

  double x, y;
  NpcModel npcModel;
  // String nomeNpc;

  _MyPainterNpcs(this.x, this.y, this.npcModel) {
    if (!npcModel.testResolvido)
      iconPerson = Icons.question_mark;
    else
      iconPerson = Icons.done;
  }

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter icon = TextPainter(textDirection: TextDirection.rtl);
    icon.text = TextSpan(
        text: String.fromCharCode(iconPerson.codePoint),
        style: TextStyle(
            fontSize: 30.0,
            fontFamily: iconPerson.fontFamily,
            color: !npcModel.testResolvido ? Colors.red : Colors.blue[800],
            fontWeight: FontWeight.bold));
    icon.layout();
    icon.paint(canvas, Offset(x, y));

    TextSpan span = new TextSpan(
      style: new TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      text: npcModel.nome_npc,
    );
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(x, y + 30));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class _MyPainterPerson extends CustomPainter {
  final iconPerson = Icons.location_history;

  double x, y;
  String nomeP;

  _MyPainterPerson(this.x, this.y, this.nomeP);

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter icon = TextPainter(textDirection: TextDirection.rtl);
    icon.text = TextSpan(
        text: String.fromCharCode(iconPerson.codePoint),
        style: TextStyle(
            fontSize: 30.0,
            fontFamily: iconPerson.fontFamily,
            color: Colors.blue[800],
            fontWeight: FontWeight.bold));
    icon.layout();
    icon.paint(canvas, Offset(x, y));

    TextSpan nomePerso = new TextSpan(
      style: new TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      text: nomeP,
    );
    TextPainter tpNomePerso = new TextPainter(
        text: nomePerso,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tpNomePerso.layout();
    tpNomePerso.paint(canvas, new Offset(x, y + 30));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
