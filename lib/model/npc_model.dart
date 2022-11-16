class NpcModel {
  bool testResolvido = false;
  bool desafioAtivo;
  String nome_npc;
  String nome_problema;
  String nivel;
  String recompensa;

  NpcModel(this.nome_npc, this.nome_problema, this.nivel, this.recompensa,
      {this.desafioAtivo = false});
}
