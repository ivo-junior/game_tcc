import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/ui/game.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/player_sprite_sheet.dart';
import 'package:game_tcc/util/sounds.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool showSplash = true;
  int currentPosition = 0;
  late async.Timer _timer;

  List<Future<SpriteAnimation>> sprites = [
    PlayerSpriteSheet.idleRight(),
  ];

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      // child: showSplash ? buildSplash() : buildMenu(),
      child: buildMenu(),
    );
  }

  Widget buildMenu() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "InvestCity",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Normal', fontSize: 30.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            if (sprites.isNotEmpty)
              Container(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CustomSpriteAnimationWidget(
                    // animation: sprites[currentPosition],
                    animation: sprites[0],
                  ),
                ),
              ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                child: Text(
                  (Dialogs.diall('')["menu"] as Map)["play_cap"],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                child: Text(
                  (Dialogs.diall('')["menu"] as Map)["credits_cap"],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/creditos');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildSplash() {
  //   return FlameSplashScreen(
  //     theme: FlameSplashTheme.dark,
  //     onFinish: (BuildContext context) {
  //       setState(() {
  //         showSplash = false;
  //       });
  //       startTimer();
  //     },
  //   );
  // }

  // void startTimer() {
  //   _timer = async.Timer.periodic(Duration(seconds: 2), (timer) {});
  //   setState(() {
  //     currentPosition++;
  //     if (currentPosition > sprites.length - 1) {
  //       currentPosition = 0;
  //     }
  //   });
  // }
}
