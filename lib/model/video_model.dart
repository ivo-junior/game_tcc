import 'dart:io';

import 'package:flutter/cupertino.dart';

class VideoModel {
  late int id;
  late String titulo, url;
  late File video_file;
  late String imagem;

  VideoModel(this.titulo, this.url);

  VideoModel.fromJson(this.id, this.titulo);
}
