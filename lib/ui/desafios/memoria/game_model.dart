class GameMemoria {
  int difficulty;
  late int time;
  List<CardGame> cards = [];
  List<String> padroes = [
    'bandeiraAlta',
    'bandeiraBaixa',
    'flamulaAlta',
    'flamulaBaixa',
    'fundoDuplo',
    'retanguloAlta',
    'retanguloBaixa',
    'topoDuplo',
    'trianguloAAlta',
    'trianguloAscend',
    'trianguloCabecaOmb',
    'trianguloCabecaOmbRev',
    'trianguloCorpoCalca',
    'trianguloCorpoCalcaRev',
    'trianguloDBaixa',
    'trianguloDescend',
    'trianguloDescendNeutro',
    'trianguloSAlta',
    'trianguloSBaixa',
    'trianguloSimExp'
  ];
  late int cardsForRow;

  GameMemoria(this.difficulty) {
    List<CardGame> cardsTemp = [];
    late int n;
    padroes.shuffle();
    switch (difficulty) {
      case 0:
        time = 60;
        n = 3;
        cardsForRow = 3;
        break; // Easy: 3 padrões, 6 cards
      case 1:
        time = 90;
        n = 8;
        cardsForRow = 4;
        break; // Normal: 8 padrões, 16 cards
      case 2:
        time = 120;
        n = 15;
        cardsForRow = 5;
        break;
      // Hard: 15 padrões, 30 cards
      case 3:
        time = 240;
        n = 20;
        cardsForRow = 5;
        break; // Very Hard: 15 padrões, 30 cards
    }
    cardsTemp = new List<CardGame>.generate(n, (index) {
      return CardGame(
          index, true, 'assets/images/padroes/${padroes[index]}.svg');
    });

    cards.addAll(cardsTemp);
    cards.addAll(cardsTemp); // duplicate cards for match
    cards.shuffle();
  }
}

class CardGame {
  int index;
  bool flip;
  String assetImagePath;

  CardGame(this.index, this.flip, this.assetImagePath);
}
