import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/model/curso_model.dart';
import 'package:game_tcc/data/data_universidade.dart';
import 'package:game_tcc/ui/universidade/media_player/landscap_player.dart';
import 'package:game_tcc/util/custom_avatar.dart';

// import 'add_videos_view.dart';
import '../../main.dart';
import '../../model/video_model.dart';

class CursoView extends StatefulWidget {
  CursoModel curso;
  Data data;
  int tab;

  CursoView({
    required this.curso,
    required this.data,
    required this.tab,
  });

  @override
  CursoViewState createState() => new CursoViewState();
}

class CursoViewState extends State<CursoView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<VideoModel> videos = [];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          titleSpacing: 0.0,
          elevation: appBarElevation,
          title: new Text("Video Aulas",
              style: Theme.of(context).textTheme.titleMedium),
          bottom: new PreferredSize(
              preferredSize: const Size.fromHeight(25.0),
              child: new Container(height: 30.0, child: null)),
        ),
      ),
      body: new Container(
        child: FutureBuilder(
            // future: update(),
            builder: (cont, snapshot) {
          try {
            return videosWidigetList(widget.curso.videos.toList(), context);
          } catch (e) {
            print(e);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  Widget videosWidigetList(List<VideoModel> videos, BuildContext context) {
    return videos.isNotEmpty
        ? ListView.builder(
            itemCount: videos.length,
            itemBuilder: (BuildContext c, int i) {
              VideoModel index;
              index = videos[i];
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 160,
                  minWidth: 160,
                ),
                child: Container(
                  width: 300,
                  margin: EdgeInsets.only(right: 8.0, bottom: 4.0, top: 4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white70, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: VideoWidget(allowPushRoute: true, index: index),
                ),
              );
            },
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 25.0, right: 15, top: 15),
            scrollDirection: Axis.vertical,
          )
        : new Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: new Text("As video aulas não estão disponíveis no momento!",
                style: Theme.of(context).textTheme.caption));
  }
}

class VideoWidget extends StatelessWidget {
  final VideoModel index;
  final FocusNode? focusNode;
  final bool allowPushRoute;

  const VideoWidget({
    Key? key,
    required this.allowPushRoute,
    required this.index,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new LandscapePlayer(videoUrl: index.url)));
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
                    width: 130.0,
                    height: 100.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color: Colors.white70
                    ),
                    child: Icon(
                      Icons.video_library,
                      size: 90,
                      color: Colors.black54,
                    ),
                  ),
                  const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Text('${index.id}.${index.titulo}',
                        Text('${index.titulo}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
