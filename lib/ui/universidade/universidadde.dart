import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:path/path.dart';
// import 'package:game_tcc/add_curso_view.dart';
// import 'package:game_tcc/add_videos_view.dart';
import 'package:game_tcc/ui/universidade/comprar_curso.dart';
import 'package:game_tcc/model/curso_model.dart';
import 'package:game_tcc/util/custom_avatar.dart';

import 'curso_view.dart';
import '../../data/data_universidade.dart';
import '../../main.dart';

const double kOverlayBoxWidth = 160.0;
const double kOverlayBoxHeight = 160.0;
const double kOverlayCardWidth = 296.0;
const int kColorMin = 127;

class Universidade extends StatefulWidget {
  final PersonagemModel _personagemModel;
  bool dialIni = true;
  Universidade(this._personagemModel);
  @override
  UnivesidadeState createState() => new UnivesidadeState(_personagemModel);
}

class UnivesidadeState extends State<Universidade>
    with SingleTickerProviderStateMixin {
  late Data data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _editFocusNode = FocusNode();
  late TabController _tabController;
  late List<CursoModel> _cursosList;
  // late List<CursoModel> _cursosCompradosList;
  // late List<CursoModel> _userCursosList;

  PersonagemModel _personagemModel;

  UnivesidadeState(this._personagemModel);

  bool primeiraOpen = true;

  Future<bool> update(Data dt) async => await Future.wait([
        dt.findAllCursos(),
      ]).then((value) {
        limpaListas();

        _cursosList.addAll(value[0]);

        return true;
      });

  void limpaListas() {
    _cursosList = [];
  }

  @override
  void initState() {
    super.initState();

    limpaListas();

    _tabController = new TabController(length: 1, vsync: this);
    data = Data();
  }

  void dispose() {
    _tabController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return Stack(children: [
      Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            titleSpacing: 0.0,
            elevation: appBarElevation,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Universidade",
                    style: Theme.of(context).textTheme.titleMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo: ",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      "R\$ ${_personagemModel.saldo}",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
            bottom: new PreferredSize(
                preferredSize: const Size.fromHeight(25.0),
                child: new Container(
                    height: 32.0,
                    child: new TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).accentIconTheme.color,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      labelColor: Theme.of(context).primaryIconTheme.color,
                      tabs: <Widget>[
                        new Tab(
                          text: "Todos os Cursos",
                        ),
                      ],
                    ))),
          ),
        ),
        body: !_personagemModel.updateCurso
            ? buildCursos(context)
            : FutureBuilder<bool>(
                future: await1Sec(),
                // duration: Duration(milliseconds: 500),
                builder: (BuildContext c, AsyncSnapshot<bool> snapshot) {
                  setState(() {
                    _personagemModel.updateCurso = false;
                  });
                  return const CircularProgressIndicator();
                },
              ),
      ),
      if (widget.dialIni)
        GestureDetector(
          onTap: () {
            setState(() {
              widget.dialIni = false;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) => showInitDialog());
          },
        )
    ]);
  }

  Future<bool> await1Sec() async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Widget buildCursos(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: update(data),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _cursos(_cursosList, context, data, 1),
                ],
              );
            } else {
              // if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
              // }
            }
          }),
    );
  }

  Widget showInitDialog() {
    return TalkDialog(
      says: [
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_George_3"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.reitor(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_npcs"] as Map)["talk_George_4"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.reitor(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
    );
  }

  late CursoModel index;

  Widget _cursos(List<CursoModel> cursosList, BuildContext context, Data data,
      int tpCurso) {
    return cursosList.isNotEmpty
        ? ListView.builder(
            itemCount: cursosList.length,
            itemBuilder: (BuildContext c, int i) {
              index = cursosList[i];
              return GradientColorCard(
                  kColora: cursosList[i].kColora,
                  kColorb: cursosList[i].kColorb,
                  child: CursoWidget(
                    _personagemModel,
                    index: index,
                    allowPushRoute: true,
                    focusNode: _editFocusNode,
                    data: data,
                    tpCurso: tpCurso,
                  ));
            },
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 25.0, right: 15, top: 15),
            scrollDirection: Axis.vertical,
          )
        : new Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: new Text("Não há cursos disponíveis no momento!",
                style: Theme.of(context).textTheme.caption));
  }
}

class CursoWidget extends StatelessWidget {
  final CursoModel index;
  final FocusNode? focusNode;
  final bool allowPushRoute;
  final Data data;
  final int tpCurso;
  final PersonagemModel _personagemModel;

  const CursoWidget(
    this._personagemModel, {
    Key? key,
    required this.allowPushRoute,
    required this.index,
    required this.data,
    required this.tpCurso,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UnivesidadeState(_personagemModel).update(data);
    return InkWell(
      onTap: () {
        if (!index.comprado && tpCurso == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ComprarCurso(
                        cursoModel: index,
                        player: _personagemModel,
                      )));
        }
        if (index.comprado || tpCurso == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new CursoView(
                curso: index,
                data: data,
                tab: 1,
              ),
            ),
          );
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      width: 38.0,
                      height: 38.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.white70
                      ),
                      // radius: 16.0,
                      child: CustomCircleAvatar(
                        myImage: NetworkImage(
                          "",
                        ),
                        initials: index.nome_curso.substring(0, 1),
                      )),
                  const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${index.nome_curso}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Duração: ${index.duracao}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (!index.comprado)
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Valor: ${index.valor == "0.00" ? "Grátis" : ("R\$" + index.valor)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0),
                      ),
                    ),
                  if (index.comprado)
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "${index.valor}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0),
                      ),
                    ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "${index.area}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Responsável: ${index.responsavel}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          linhas_estrela(index.nota_avaliacao)
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "(${index.num_avaliacoes == '' ? "0" : index.num_avaliacoes})",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget linhas_estrela(nota) {
    if (nota == 5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
        ],
      );
    }
    if (nota == 4.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
        ],
      );
    }
    if (nota == 4) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 3.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 3) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 2.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(
            Icons.star_half,
            color: Colors.black,
          ),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 2) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 1.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 1) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 0 || nota == null) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
        ],
      );
    }
  }
}

class GradientColorCard extends StatelessWidget {
  final CursoWidget child;
  final Color kColora;
  final Color kColorb;

  GradientColorCard(
      {required this.child, required this.kColora, required this.kColorb});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: child.index.nome_curso,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: kOverlayBoxHeight,
            minWidth: kOverlayBoxWidth,
          ),
          child: Container(
            width: kOverlayCardWidth,
            margin: EdgeInsets.only(right: 8.0, bottom: 4.0, top: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [kColora, kColorb],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 8.0),
              ],
            ),
            child: child,
          ),
        ));
  }
}
