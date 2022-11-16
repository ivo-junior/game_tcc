import 'package:game_tcc/ui/menu.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static void showGameOver(BuildContext context, VoidCallback playAgain) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/game_over.png',
                height: 100,
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: playAgain,
                child: Text(
                  (diall('')["menu"] as Map)["play_again_cap"].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 20.0),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Map<String, String> desafio(String npc, String problema) {
    return {
      "talk_npcs_1":
          "Olá meu nome é ${npc}, sou um(a) cliente-investidor(a) de InvestCapital! Preciso que você resolva o desafio (${problema}). Você receberá um valor caso seja bem sucedido.",
      "talk_npcs_2": "Aceita o desafio?"
    };
  }

  static diall(String nomePerso) {
    return {
      "menu": {
        "play_cap": "JOGAR",
        "go": "INICIAR JOGO",
        "credits_cap": "CRÉDITOS",
        "powered_by": "Desenvolvido por ",
        "built_with": "Construido com ",
        "play_again_cap": "JOGAR NOVAMENTE",
        "congratulations": "PARABÊNS!",
        "thanks":
            "Universidade Federal Rural de Pernambuco.\nUnidade Acadêmica de Serra Talhada.\n\nProjeto de Conclusão de Curso:\nInvestCity: um jogo sério baseado em Role-playing Game para exercitar técnicas de negociação para o Mercado Financeiro\n\nOrientador: Richarlyson Alves D'Emery\nAutor: Ivo Ireneu de Souza Júnior",
      },
      "talk_game": {
        "talk_game_1":
            "Você acabou de chegar em InvestCity: “uma cidade de investidores”. Deseja ter uma experiência em que possa aprender sobre investimentos? Se é curioso e destemido e adora desafios continue no game...",
        "talk_game_2":
            "Vá à companhia InvestCapital e converse com o CEO Alberto. Ele lhe dará mais detalhes de como prosseguir.",
        "talk_game_3":
            "Clique aqui a qualquer momento para encontrar os desafios e monumentos da cidade, bem como para você se localizar.",
        "talk_game_4":
            "Aqui você poderá colocar seus conhecimentos em prática. Responda variadas questões de diversos assuntos sobre investimentos no mercado financeiro e se ponha a prova.",
        "talk_game_5":
            "Cada questão possui uma recompensa. Suas respostas podem ser do tipo múltipla escolha ou verdadeiro e falso. Boa sorte!",
        "talk_game_6":
            "Bem vindo a nossa bolsa de investimentos! Invista seu dinheiro e tente multiplicá-lo. Acerte os próximos movimentos de velas e seja recompensado.",
        "talk_game_7":
            "A cada rodada você poderá colocar o valor que quiser e ganhar 100% do valor investido. Mas muito cuidado! Caso você erre estará compromentendo o saldo da sua conta! Boa sorte!",
        "talk_game_8":
            "Suas chances acabaram. Compre novas chances ou retorne ao jogo e tente mais tarde.",
        "talk_game_9":
            "Teste a sua memória enquanto aprende novos padrões de velas e se diverte. Encontre o par correspondente de cada padrão e seja recompensado com cada par que formar. Mas cuidado: O tempo não está ao seu lado!",
        "talk_game_10":
            "Ao clicar na '?' pode-se ver um resumo dos padrões gráficos disponíveis. Poderá comprar novas ajudas se quiser e se tiver dinheiro para isso. Boa sorte!",
        "talk_game_11":
            "Receba um bônus de R\$ 1000,00 por completar o desafio com nota máxima.",
        "talk_game_12":
            "Consulte monumentos e localidades a qualquer momento, acessando o mini mapa no canto inferior direito da sua tela.",
      },
      "talk_npcs": {
        // Desafio 1
        "talk_alberto_1":
            "Olá ${nomePerso}! Você está na mais rica empresa de investimentos dessa cidade. Meu nome é Alberto, sou o CEO de InvestCapital, principal especialista em Investimentos.",
        "talk_alberto_2":
            "Nossa cidade é conhecida por reunir grandes empresas de investimento, como InvestCapital, e colocar grandes investidores no mercado. Em que posso lhe ajudar?",
        "talk_alberto_3":
            "Vá até Universidade Invest para aprender sobre investimentos. Ela pode ser encontrada na parte Oeste da cidade e também pode ser localizada através do seu minimapa.",
        "talk_alberto_4":
            " Muito bem se é de desafios que você gosta talvez tenhamos uma oportunidade pra você. Procuramos alguém que possa solucionar problemas de vários clientes- investidores.",
        "talk_alberto_5":
            "Você deverá encontrá-los andando por InvestCity e resolver seus problemas.",
        "talk_alberto_7":
            "Você será recompensado por cada problema resolvido e ganhará experiência. Com o tempo você poderá ser promovido para outros cargos em InvestCapital. Pronto para começar?",
        "talk_alberto_8":
            "O jogo será finalizado, se desejar problemas desafiadores que o ajudarão a se tornar um verdadeiro investidor, volte aqui a qualquer momento.",
        "talk_alberto_9":
            "Vamos iniciar com um pequeno teste. Você deve operar na bolsa de valores. Estamos te presenteando com R\$ 1.000,00 (mil reais) para que você possa investir. Mas não se preocupe se o resultado do investimento não for satisfatório.",
        "talk_alberto_10":
            "Para isso você deverá encontrar o NPC Maria andando pela cidade, consulte a qualquer momento o local designado em seu minimapa no canto inferior direito da tela. Boa sorte!",
        // end Desasfio 1 start Dsafio 2
        "talk_alberto_11": "Muito bem! Você concluiu o primeiro desafio.",
        "talk_alberto_12":
            "Ficamos muito felizes com seu desempenho  e gostaríamos que iniciasse o trabalho imediatamente.",
        "talk_alberto_13":
            "Por isso, InvestCapital está te presenteando com um curso básico sobre investimentos na Universidade Invest.",
        "talk_alberto_14":
            "Vá até a Universidade Invest e realize o curso agora mesmo. Tenha isso já como um trabalho, pois você será recompensado após sua conclusão.",
        "talk_alberto_15":
            "Você poderá ver a localização da Universidade Invest em seu minimapa. Boa sorte!",
        // end Desafio 2 start allDesafios
        "talk_alberto_16":
            "Vejo que concluiu o Curso, parabéns! Acredito que você está capacitado para os próximos desafios.",
        "talk_alberto_17":
            "A partir de agora você será avaliado por seu desempenho. Mas não se preocupe, sempre que não tiver um bom desempenho, você poderá retornar a Universidade, acumular mais conhecimento e tentar solucionar o desafio novamente.",
        "talk_alberto_18":
            "Agora você deverá resolver os desafios dos clientes-investidores de InvestCity.",
        "talk_alberto_19":
            "Novos clientes-investidores possuem o ícone “?”.Encontre-os e continue a resolver os desafios. Você poderá localizá-los em seu minimapa. ",
        "talk_alberto_20":
            "Lembre-se: você está em uma jornada para ser um investidor de sucesso. Boa Sorte!",
        // end allDesafios start msg baixo desembenho
        "talk_alberto_loos":
            "${nomePerso}, clientes-investidores me ligaram falando que você não obteve um bom resultado em seu desafio.",
        "talk_alberto_loos_1":
            "Dessa forma preciso que vá a Universidade Invest para melhorar suas habilidades. Mas não se preocupe, assim que voltar deverá solucionar o desafio novamente!",
        "talk_alberto_des":
            "Você tem certeza que vai desistir do desafio? Como você pretende me mostrar que será um bom investidor?",
        "talk_alberto_des_1":
            "Repense sua decisão, recomendo que você volte a falar com o(a) cliente-investidor(a). Mas se não desejar, procure outro desafio.",
        "talk_George_1":
            "Olá ${nomePerso}, seja bem-vindo. Sou George o Reitor da Universidade Invest.",
        "talk_George_2":
            "Nós temos vários cursos gratuitos e pagos sobre investimentos, se deseja conhecê-los clique em entrar.",
        "talk_George_3":
            "Aqui você poderá aprender através de diversos Cursos disponíveis sobre investimentos. Selecione o curso que desejar e o assista quando quiser.",
        "talk_George_4": "Selecione o curso que deseja e o veja quando quiser.",
      }
    };
  }
}
