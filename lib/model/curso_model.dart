import 'dart:ffi';
import 'dart:math' as Math;

import 'dart:ui';

import 'package:game_tcc/model/video_model.dart';

const int kColorMin = 127;

class CursoModel {
  String nome_curso, responsavel, area, duracao, valor;
  late String num_avaliacoes = '', id;
  double? nota_avaliacao;
  bool comprado = false;
  List<VideoModel> videos = [];
  // Float ;

  final Color kColora = Color.fromRGBO(
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      1.0);
  final Color kColorb = Color.fromRGBO(
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      1.0);

  CursoModel(
      {required this.nome_curso,
      required this.responsavel,
      required this.area,
      required this.duracao,
      required this.valor,
      required this.videos});

  // CursoModel.fromJson(
  //     this.nome_curso, this.responsavel, this.area, this.duracao, this.valor);
}
