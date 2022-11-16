import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class Creditos extends StatefulWidget {
  @override
  _CreditosState createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            // color: Color(0xffaaffee),
            child: Image.asset("assets/images/City-night.png"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                // color: Color(0xffaaffee),
                child: Image.asset("assets/images/logoUFRPE.png"),
              ),
              Text(
                (Dialogs.diall('')["menu"] as Map)["credits_cap"],
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 100,
                height: 100,
                // color: Color(0xffaaffee),
                child: Image.asset("assets/images/logoUAST.png"),
              ),
            ],
          ),
          TalkDialog(
            says: [
              Say(
                padding: EdgeInsets.all(20),
                text: [
                  TextSpan(text: (Dialogs.diall('')["menu"] as Map)["thanks"]),
                  TextSpan(
                    text: "\n(Clique para continuar)",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
                person: CustomSpriteAnimationWidget(
                  animation: NpcSpriteSheet.gameADM(),
                ),
                // personSayDirection: PersonSayDirection.LEFT,
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 20,
          margin: EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      (Dialogs.diall('')["menu"] as Map)["powered_by"],
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 12.0),
                    ),
                    InkWell(
                      onTap: () {
                        _launchURL('https://github.com/ivo-junior');
                      },
                      child: Text(
                        'IvoSouza',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: 'Normal',
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      (Dialogs.diall('')["menu"] as Map)["built_with"],
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 12.0),
                    ),
                    InkWell(
                      onTap: () {
                        _launchURL('https://github.com/ivo-junior');
                      },
                      child: Text(
                        'BomFire | Flame',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: 'Normal',
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
