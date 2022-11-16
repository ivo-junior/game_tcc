import 'package:bonfire/bonfire.dart';
import 'package:game_tcc/main.dart';

class PersonagemModel {
  double attack = 25;
  double stamina = 0;
  double initSpeed = tileSize * tileSize;
  bool msgIniQuiz = true, msgIniSimulador = true, msgIniMemoria = true;
  String currentDesafio = 'Falar com Alberto';
  bool updateCurso = false;

  double saldo;
  List<String> ls_compras;
  String? nome;
  late Vector2 position = Vector2(0, 0);

  PersonagemModel({this.nome, required this.saldo, required this.ls_compras}) {}
}
