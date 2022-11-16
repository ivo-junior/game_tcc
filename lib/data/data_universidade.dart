// import 'dart:html';

import 'package:game_tcc/data/cursos.dart';
import 'package:path/path.dart';
import 'package:game_tcc/model/curso_model.dart';
import 'package:game_tcc/model/video_model.dart';

class Data {
  Future<List<CursoModel>> findAllCursos() async {
    List list = [];
    List<CursoModel> listCursos = [];
    List<VideoModel> listVideos = [];

    CursoModel curso;

    list = CURSOS;

    list.forEach((element) {
      element['videos'].forEach((v) {
        listVideos.add(VideoModel(v['titulo'], v['url']));
      });

      curso = new CursoModel(
          nome_curso: element['nome_curso'],
          responsavel: element['responsavel'],
          area: element['area'],
          duracao: element['duracao'].toString(),
          valor: element['comprado'] == true
              ? 'Adquirido'
              : element['valor'].toString(),
          videos: listVideos);
      curso.id = element['id'].toString();
      curso.comprado = element['comprado'];

      listCursos.add(curso);
      listVideos = [];
    });

    return listCursos;
  }

  // Future<List<CursoModel>> findAllCursosComprados() async {
  //   List list = [];
  //   List<CursoModel> listCursos = [];
  //   CursoModel curso;

  //   List res = _response.data['cursos'];

  //   for (var i = 0; i < res.length; i++) {
  //     var csid = await this
  //         ._dio
  //         .get(Urls.FIND_CURSO_ID, queryParameters: {'id': res[i]['curso_id']});
  //     list.add(csid.data['cursos']);
  //   }

  //   list.forEach((element) {
  //     curso = new CursoModel(
  //         nome_curso: element['nome_curso'],
  //         responsavel: element['responsavel'],
  //         area: 'Investimentos',
  //         duracao: element['duracao'].toString(),
  //         valor: element['comprado'] == true ? 'Adquirido' : element['valor']);
  //     curso.comprado = element['comprado'];
  //     curso.id = element['id'].toString();

  //     listCursos.add(curso);
  //   });

  //   return listCursos;
  // }

  // Future<String> updateCurso(CursoModel cursoModel) async {
  //   try {
  //     _response = await this
  //         ._dio
  //         .get(Urls.UPDATE_CURSO, queryParameters: {"id": cursoModel.id});
  //     return "Susses";
  //   } catch (e) {
  //     return e.toString();
  //     print(e);
  //   }
  // }
}
