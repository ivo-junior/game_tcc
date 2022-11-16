import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_tcc/ui/desafios/memoria/game_model.dart';
import 'package:game_tcc/ui/desafios/memoria/game_page.dart';
import 'package:game_tcc/ui/desafios/mercado/simulador.dart';
import 'package:game_tcc/ui/desafios/mercado/simulador_conhecido.dart';
import 'package:game_tcc/ui/desafios/quiz/home_quiz.dart';
import 'package:game_tcc/ui/game.dart';
import 'package:game_tcc/ui/menu.dart';
import 'package:game_tcc/model/charts.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/network/api_reques.dart';
import 'package:game_tcc/ui/creditos.dart';
import 'package:game_tcc/ui/universidade/universidadde.dart';

import 'util/sounds.dart';

const double appBarHeight = 48.0;
const double appBarElevation = 1.0;

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

double tileSize = 16;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  await Sounds.initialize();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Normal',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Menu(),
        '/game': (context) => Game(),
        '/creditos': (context) => Creditos(),
      },
    ),
  );
}
