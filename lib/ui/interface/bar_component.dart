import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:flutter/material.dart';

class BarComponent extends InterfaceComponent {
  double padding = 20;
  double widthBar = 90;
  double strokeWidth = 12;

  // Contratar Robô
  double maxStamina = 0;
  double stamina = 0;
  PersonagemModel personagemModel;

  BarComponent(this.personagemModel)
      : super(
          id: 1,
          position: Vector2(40, 40),
          // sprite: Sprite.load('health_ui.png'),
          size: Vector2(120, 40),
        );

  @override
  void update(double t) {
    if (this.gameRef.player != null) {
      if (this.gameRef.player is Personagem_widget) {
        stamina =
            (this.gameRef.player as Personagem_widget).personagemModel.stamina;
      }
    }
    super.update(t);
  }

  @override
  void render(Canvas c) {
    try {
      // _drawLife(c);
      _drawStamina(c);
      _drawElements(c, personagemModel);
    } catch (e) {}
    super.render(c);
  }

  // void _drawLife(Canvas canvas) {
  //   double xBar = 48;
  //   double yBar = 31.5;
  //   canvas.drawLine(
  //       Offset(xBar, yBar),
  //       Offset(xBar + widthBar, yBar),
  //       Paint()
  //         ..color = Colors.blueGrey[800]!
  //         ..strokeWidth = strokeWidth
  //         ..style = PaintingStyle.fill);

  //   canvas.drawLine(
  //       Offset(xBar, yBar),
  //       Offset(xBar + currentBarLife, yBar),
  //       Paint()
  //         ..color = _getColorLife(currentBarLife)
  //         ..strokeWidth = strokeWidth
  //         ..style = PaintingStyle.fill);
  // }

  void _drawStamina(Canvas canvas) {
    double xBar = 48;
    double yBar = 55;

    double currentBarStamina = (stamina * widthBar) / maxStamina;

    canvas.drawLine(
        Offset(xBar, yBar),
        Offset(xBar + currentBarStamina, yBar),
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill);
  }

  void _drawElements(Canvas canvas, PersonagemModel p) {
    final iconPerson = Icons.person;

    double xBar = 55;
    double yBar = 25;
    double xBarI = 10;
    double yBarI = 15;
    double xDes = 10;
    double yDes = 65;

    double saldo = p.saldo;

    TextSpan tSaldo = new TextSpan(
      style: new TextStyle(
          color: saldo > 0 ? Colors.blue[800] : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold),
      text: 'R\$${saldo}',
    );
    TextPainter tpSaldo = new TextPainter(
        text: tSaldo,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tpSaldo.layout();
    tpSaldo.paint(canvas, new Offset(xBar, yBar));

    TextSpan currentDes = new TextSpan(
      style: new TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      text: 'Objetivo: ${p.currentDesafio}',
    );
    TextPainter tpCurrentDes = new TextPainter(
        text: currentDes,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tpCurrentDes.layout();
    tpCurrentDes.paint(canvas, new Offset(xDes, yDes));

    TextPainter icon = TextPainter(textDirection: TextDirection.rtl);
    icon.text = TextSpan(
        text: String.fromCharCode(iconPerson.codePoint),
        style: TextStyle(
            fontSize: 50.0,
            fontFamily: iconPerson.fontFamily,
            color: Colors.black));
    icon.layout();
    icon.paint(canvas, Offset(xBarI, yBarI));
  }
}
