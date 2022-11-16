import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:bonfire/background/background_color_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/model/charts.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:game_tcc/network/api_reques.dart';
import 'package:game_tcc/util/custom_sprite_animation_widget.dart';
import 'package:game_tcc/util/dialogs.dart';
import 'package:game_tcc/util/functions.dart';
import 'package:game_tcc/util/globalKeys.dart';
import 'package:game_tcc/util/npc_sprite_sheet.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SimuladorConhecido extends StatefulWidget {
  SimuladorConhecido({
    Key? key,
    required this.player,
    required this.contDesaf,
    required this.npcModel,
  }) : super(key: key);

  int contDesaf;
  PersonagemModel player;
  bool dialIni = true;
  NpcModel npcModel;

  @override
  _SimuladorState createState() => _SimuladorState(player, contDesaf, npcModel);
}

class _SimuladorState extends State<SimuladorConhecido> {
  late ChartModel? _chartModel;
  late TrackballBehavior _trackballBehavior;

  late SelectionBehavior _selectionBehavior;

  late ZoomPanBehavior _zoomPanBehavior;

  late TooltipBehavior _tooltipBehavior;

  late double _min = 0, _max = 0, _intervalo = 0;

  late ApiReques api;

  static const ativos = <String>['Microsoft'];
  String _btnSelect = ativos[0];

  late int contDesafio, contAux = 0;
  PersonagemModel player;

  bool proxVela = false, encerrarOp = false;

  Map<String, dynamic> comprasEfetuadas = {"valores": [], "resultados": []};

  List compras = [];

  String dirCompra = "";

  NpcModel npcModel;

  _SimuladorState(this.player, this.contDesafio, this.npcModel);

  // bool _initiMsg = false;
  double _valorCompra = 0.00;
  int _currentIndexCompra = 0;

  MyGlobals myGlobals = MyGlobals();

  @override
  void initState() {
    api = ApiReques.getInstance();

    _updateData(_btnSelect);

    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    _selectionBehavior = SelectionBehavior(enable: true);

    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  final List<DropdownMenuItem<String>> _dropDownMenuItems = ativos
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return npcModel.desafioAtivo && contDesafio > 0
        ? Scaffold(
            key: myGlobals.scaffoldKey,
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            size: 50,
                          ),
                          Text(
                            "Saldo: ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "R\$ ${player.saldo}",
                            style: TextStyle(
                                fontSize: 15,
                                color: player.saldo > 0.0
                                    ? Colors.blue[400]
                                    : Colors.black),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            value: _btnSelect,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _btnSelect = newValue);
                              }
                            },
                            items: _dropDownMenuItems,
                          ),
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<dynamic>(
                          future: _updateData(_btnSelect),

                          /// Adding data by updateDataSource method
                          builder: (futureContext, snapShot) {
                            if (snapShot.hasData && _chartModel != null) {
                              return SfCartesianChart(
                                backgroundColor: Colors.white,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 20),
                                borderWidth: 1,
                                // legend: Legend(isVisible: true),
                                trackballBehavior: _trackballBehavior,
                                tooltipBehavior: _tooltipBehavior,
                                zoomPanBehavior: _zoomPanBehavior,
                                series: <CandleSeries>[
                                  CandleSeries<CandleStick, DateTime>(
                                    dataSource: _chartModel!.chartData,
                                    xValueMapper: (CandleStick sales, _) =>
                                        sales.date,
                                    lowValueMapper: (CandleStick sales, _) =>
                                        sales.low,
                                    highValueMapper: (CandleStick sales, _) =>
                                        sales.high,
                                    openValueMapper: (CandleStick sales, _) =>
                                        sales.open,
                                    closeValueMapper: (CandleStick sales, _) =>
                                        sales.close,
                                    // showIndicationForSameValues: true, //Indicador de Volume
                                    initialSelectedDataIndexes: <int>[2, 0],
                                    selectionBehavior: _selectionBehavior,
                                    animationDuration: 1,
                                  ),
                                ],
                                primaryXAxis: DateTimeAxis(
                                    dateFormat: DateFormat.Hm(),
                                    majorGridLines: MajorGridLines(width: 1)),
                                primaryYAxis: NumericAxis(
                                    minimum: _min != 0 ? _min : 150,
                                    maximum: _max != 0 ? _max : 60,
                                    // interval: getMinMaxChart(_chartData)["max"]?.toDouble(),
                                    interval: _intervalo,
                                    numberFormat: NumberFormat.simpleCurrency(
                                        decimalDigits: 2)),
                                // indicators: [
                                //   RsiIndicator(
                                //       dataSource: _chartData, isVisible: true, period: 10)
                                // ],
                                // isTransposed: true,
                                loadMoreIndicatorBuilder: (BuildContext context,
                                        ChartSwipeDirection direction) =>
                                    getLoadMoreViewBuilder(context, direction),
                              );
                            } else
                              return Center(
                                child: const CircularProgressIndicator(),
                              );

                            // Timer.periodic(const Duration(seconds: 3), (timer) {});
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Divider(),
                            SizedBox(
                              height: 50,
                              // height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    "R\$",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      // maxLength: 1000,
                                      decoration: InputDecoration(
                                        labelText: "Valor",
                                        labelStyle: TextStyle(fontSize: 12),
                                        errorText: player.saldo <= 0.00
                                            ? "Valor"
                                            : null,
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                      onSubmitted: (val) {
                                        if (val != null &&
                                            val != "" &&
                                            val != '') {
                                          _valorCompra =
                                              double.parse(val.toString());
                                        }
                                        // setState(() {});
                                      },
                                      onChanged: (String val) {
                                        // double v = double.parse(val);
                                        if (val == null || val == "") {
                                          _valorCompra = 0.00;
                                        }
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green)),
                                        onPressed: player.saldo > 0 &&
                                                encerrarOp == false
                                            ? () {
                                                if (_valorCompra > 0 &&
                                                    _valorCompra <=
                                                        player.saldo) {
                                                  // print("call");
                                                  setState(() {
                                                    compras.add(_compra(
                                                        player,
                                                        _chartModel!,
                                                        _valorCompra,
                                                        "call"));

                                                    somaSaldo(2, _valorCompra);

                                                    comprasEfetuadas["valores"]
                                                        .add(_valorCompra);
                                                    comprasEfetuadas[
                                                            "resultados"]
                                                        .add(0.00);
                                                  });
                                                  proxVela = true;
                                                } else {
                                                  mgsAlertSnakBar(
                                                      _valorCompra == 0
                                                          ? "Insira um valor!"
                                                          : "Saldo Insuficiente",
                                                      context);
                                                }
                                              }
                                            : null,
                                        child: Icon(Icons.arrow_circle_up,
                                            color: Colors.black),
                                      ),
                                      OutlinedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red)),
                                        onPressed: player.saldo > 0 &&
                                                encerrarOp == false
                                            // &&
                                            // _valorCompra > 0
                                            ? () {
                                                if (_valorCompra > 0 &&
                                                    _valorCompra <=
                                                        player.saldo) {
                                                  // print('put');
                                                  setState(() {
                                                    compras.add(_compra(
                                                        player,
                                                        _chartModel!,
                                                        _valorCompra,
                                                        "put"));

                                                    comprasEfetuadas["valores"]
                                                        .add(_valorCompra);
                                                    comprasEfetuadas[
                                                            "resultados"]
                                                        .add(0.00);
                                                    somaSaldo(2, _valorCompra);
                                                  });
                                                  proxVela = true;
                                                } else {
                                                  mgsAlertSnakBar(
                                                      _valorCompra == 0
                                                          ? "Insira um valor!"
                                                          : "Saldo Insuficiente",
                                                      context);
                                                }
                                              }
                                            : null,
                                        child: Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Operações abertas: ",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      SizedBox(
                                          height: 90,
                                          width: 145,
                                          child: ListView(
                                            padding: const EdgeInsets.all(8),
                                            children: listCompras(
                                                        comprasEfetuadas)
                                                    .isNotEmpty
                                                ? listCompras(comprasEfetuadas)
                                                : [Text("---")],
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: encerrarOp
                                      ? () {
                                          contDesafio--;
                                          setState(() {
                                            var res = encerraOp(
                                                compras.last, _chartModel!);

                                            somaSaldo(1, res);

                                            comprasEfetuadas["resultados"]
                                                [_currentIndexCompra] = res;
                                          });
                                          encerrarOp = false;
                                          proxVela = false;
                                          _currentIndexCompra++;

                                          if (contDesafio <= 0) {
                                            showResult(context);

                                            // Navigator.pop(context);
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    "Encerrar operação!",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                OutlinedButton(
                                  onPressed: proxVela
                                      ? () {
                                          setState(() {
                                            dataM.add(dataMaux[contAux]);
                                            proxVela = false;
                                            encerrarOp = true;
                                          });
                                          contAux++;
                                        }
                                      : null,
                                  child: Text(
                                    "Próxima vela!",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                if (player.msgIniSimulador && widget.dialIni)
                  GestureDetector(onTap: () {
                    setState(() {
                      widget.dialIni = false;
                    });

                    showDialog(
                        context: context,
                        builder: ((BuildContext context) => _showInitiDial()));
                  }),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: OutlinedButton(
                  child: Row(children: [
                    Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text('Voltar ao Jogo')
                  ]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ));
  }

  List<Widget> listCompras(Map<String, dynamic> mapLs) {
    List<Widget> list = [];
    int i = 0;
    mapLs["valores"].forEach((element) {
      list.add(
        Container(
            child: Row(
          children: [
            const Divider(),
            Container(
              width: 35,
              height: 30,
              child: Center(
                child: Text(
                  "${i + 1}",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 35,
              height: 30,
              child: Center(
                child: Text(
                  mapLs["valores"][i].toString(),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 45,
              height: 30,
              child: Center(
                child: Text(
                  "${mapLs["resultados"][i] >= 0 ? "+" : ""} ${mapLs["resultados"][i]}",
                  style: TextStyle(
                      fontSize: 10,
                      color: mapLs["resultados"][i] >= 0
                          ? Colors.blue
                          : Colors.red),
                ),
              ),
            )
          ],
        )),
      );
      i++;
    });

    return list;
  }

  Widget _showInitiDial() {
    return TalkDialog(
      says: [
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_6"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_7"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
                text: (Dialogs.diall('')["talk_game"] as Map)["talk_game_11"]),
            TextSpan(
                text: "\n(Clique para continuar)",
                style: TextStyle(fontSize: 14)),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.gameADM(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
          // bottom: TextButton(
          //   onPressed: () {},
          //   child: Row(
          //     children: [
          //       Checkbox(
          //         onChanged: (bool? value) {
          //           if (value != null)
          //             setState(() {
          //               player.msgIniSimulador = value;
          //               // this._initiMsg = value;
          //             });
          //         },
          //         value: player.msgIniSimulador,
          //       ),
          //       Text(
          //         " Não exibir mesnsagem novamente!",
          //         style: TextStyle(fontSize: 12, color: Colors.white),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ],
    );
  }

  void somaSaldo(int op, double num1) {
    if (op == 1) player.saldo += num1;
    if (op == 2) player.saldo -= num1;
  }

  Widget getLoadMoreViewBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder(
        future: _updateData(_btnSelect),

        /// Adding data by updateDataSource method
        builder: (futureContext, snapShot) {
          return snapShot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : SizedBox.fromSize(size: Size.zero);
          // Timer.periodic(const Duration(seconds: 3), (timer) {});
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }

  Map<String, num> getMinMaxChart(List<CandleStick> _list) {
    num min = 0;
    num max = 0;

    num dif = 0;

    _list.forEach((element) {
      element.high! > max ? max = element.high! : max = max;
      element.low! > min ? min = element.low! : min = min;
    });

    dif = max - min;

    return {"min": min, "max": max, "interv": dif};
  }

  Future<bool> _updateData(String ativo) async {
    List<CandleStick> _lsCand = [];
    Future<bool> ret = Future.value(true);
    dataM.forEach((element) {
      _lsCand.add(new CandleStick(
          element['high'],
          element['low'],
          element['volume'],
          //       "Timestamp EDT"
          DateTime.fromMillisecondsSinceEpoch(
              element['timestamp']!.toInt() * 1000 as int),
          element['open'],
          element['close']));
    });
    _chartModel = ChartModel(ativo, ChartDurations.ONE_DAY, 1, _lsCand);

    var ultimaData = DateTime.parse(_chartModel!
            .chartData[_chartModel!.chartData.length - 1].date
            .toString())
        .millisecondsSinceEpoch;
    var penData = DateTime.parse(_chartModel!
            .chartData[_chartModel!.chartData.length - 2].date
            .toString())
        .millisecondsSinceEpoch;
    var difDate = ultimaData - penData;

    _chartModel!.chartData.add(new CandleStick(0.00, 0.00, 0.00,
        DateTime.fromMillisecondsSinceEpoch(ultimaData + difDate), 0.00, 0.00));
    _intervalo = getMinMaxChart(_chartModel!.chartData)["interv"]!.toDouble();

    _min = getMinMaxChart(_chartModel!.chartData)["min"]!.toDouble() * 1.01;
    _max = getMinMaxChart(_chartModel!.chartData)["max"]!.toDouble() / 1.02;

    return ret;
  }

  Map<String, dynamic> _compra(PersonagemModel perso, ChartModel chart,
      double montante, String direcao) {
    double _price_compra;
    double _qtd_comprada = 0.00;

    proxVela = true;

    _price_compra =
        chart.chartData[chart.chartData.length - 2].close!.toDouble();

    // perso.saldo -= montante;

    _qtd_comprada = montante / _price_compra;

    perso.ls_compras.add("Compra ${perso.ls_compras.length}");

    setState(() {});

    return {
      "pessoa": perso,
      "montante": montante,
      "qtd_comprada": _qtd_comprada,
      "preco": _price_compra,
      "direcao": direcao,
      "finalizada": false
    };
  }

  double encerraOp(
    var compra,
    ChartModel chart,
  ) {
    double precoAtual =
        chart.chartData[chart.chartData.length - 2].close!.toDouble();
    double lucro = 0.00;
    // double difLucro = compra["preco"] - precoAtual;

    if (compra["preco"] <= precoAtual && compra["direcao"] == "call") {
      // print("Ganha");
      lucro = compra["montante"] * 2;
    } else if (compra["preco"] > precoAtual && compra["direcao"] == "call") {
      lucro = -(compra["montante"]);
      // print("Perde");
    } else if (compra["preco"] > precoAtual && compra["direcao"] == "put") {
      lucro = compra["montante"] * 2;
      // print("Ganha");
    } else if (compra["preco"] < precoAtual && compra["direcao"] == "put") {
      // lucro = -(compra["montante"]);
      // print("Perde");
    }
    compra["finalizada"] = true;

    (compra["pessoa"] as PersonagemModel)
        .ls_compras
        .remove((compra["pessoa"] as PersonagemModel).ls_compras.last);

    return lucro;
  }

  showResult(BuildContext con) {
    bool suces;

    int acert = 0, err = 0;

    List results = comprasEfetuadas["resultados"];

    results.forEach((element) => element > 0 ? acert++ : err++);

    suces = acert > err ? true : false;

    String message = suces ? 'Show🙌' : 'Quase lá 👍';
    String content = suces
        ? 'Parabéns! Você conseguiu! 😎'
        : 'Não foi dessa vez! 😫\nNão desanime, volte depois e tente novamente 😉';

    if (acert == results.length) {
      setState(() {
        npcModel.desafioAtivo = false;
        npcModel.testResolvido = true;
        if (acert == results.length) {
          player.saldo += 1000.0;
        }
      });
    }

    showDialog(
      context: con,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ZoomIn(
                  duration: Duration(milliseconds: 500),
                  child: Icon(
                      acert >= (0.5 * results.length)
                          ? Icons.star
                          : Icons.star_border,
                      size: 40,
                      color: Colors.yellow)),
              ZoomIn(
                  delay: Duration(milliseconds: 250),
                  duration: Duration(milliseconds: 500),
                  child: Icon(
                      acert >= (0.70 * results.length)
                          ? Icons.star
                          : Icons.star_border,
                      size: 50,
                      color: Colors.yellow)),
              ZoomIn(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Icon(
                      acert >= results.length ? Icons.star : Icons.star_border,
                      size: 40,
                      color: Colors.yellow)),
            ]),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        content: Text(content, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.blueAccent),
            // textColor: Colors.blueAccent,
            onPressed: () => Navigator.of(con).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  var dataM = [
    {
      "open": 287.4100036621094,
      "close": 287.2099914550781,
      "high": 287.4513854980469,
      "low": 287.20001220703125,
      "timestamp": 1660920300.0,
      "volume": 147406.0
    },
    {
      "open": 287.2200012207031,
      "close": 286.8299865722656,
      "high": 287.2427062988281,
      "low": 286.72100830078125,
      "timestamp": 1660920600.0,
      "volume": 148646.0
    },
    {
      "open": 286.82000732421875,
      "close": 286.2699890136719,
      "high": 286.8900146484375,
      "low": 286.2699890136719,
      "timestamp": 1660920900.0,
      "volume": 186559.0
    },
    {
      "open": 286.2749938964844,
      "close": 286.4811096191406,
      "high": 286.6499938964844,
      "low": 286.2749938964844,
      "timestamp": 1660921200.0,
      "volume": 164419.0
    },
    {
      "open": 286.4800109863281,
      "close": 286.04998779296875,
      "high": 286.71990966796875,
      "low": 285.94000244140625,
      "timestamp": 1660921500.0,
      "volume": 226638.0
    },
    {
      "open": 286.0285949707031,
      "close": 286.3599853515625,
      "high": 286.3900146484375,
      "low": 285.9200134277344,
      "timestamp": 1660921800.0,
      "volume": 155344.0
    },
    {
      "open": 286.3500061035156,
      "close": 286.2699890136719,
      "high": 286.4700012207031,
      "low": 286.1400146484375,
      "timestamp": 1660922100.0,
      "volume": 140859.0
    },
    {
      "open": 286.2699890136719,
      "close": 286.1400146484375,
      "high": 286.3399963378906,
      "low": 285.94000244140625,
      "timestamp": 1660922400.0,
      "volume": 126315.0
    },
    {
      "open": 286.1300048828125,
      "close": 286.3599853515625,
      "high": 286.3999938964844,
      "low": 285.95001220703125,
      "timestamp": 1660922700.0,
      "volume": 205511.0
    },
    {
      "open": 286.3699951171875,
      "close": 286.43499755859375,
      "high": 286.4599914550781,
      "low": 286.1099853515625,
      "timestamp": 1660923000.0,
      "volume": 165461.0
    },
    {
      "open": 288.8999938964844,
      "close": 288.4200134277344,
      "high": 288.8999938964844,
      "low": 287.2099914550781,
      "timestamp": 1660915800.0,
      "volume": 2992309.0
    },
    {
      "open": 288.5,
      "close": 288.3399963378906,
      "high": 288.7699890136719,
      "low": 287.8699951171875,
      "timestamp": 1660916100.0,
      "volume": 296523.0
    },
    {
      "open": 288.0469970703125,
      "close": 287.4648132324219,
      "high": 288.0469970703125,
      "low": 287.2799987792969,
      "timestamp": 1660916400.0,
      "volume": 303433.0
    },
    {
      "open": 287.42999267578125,
      "close": 286.86700439453125,
      "high": 287.5799865722656,
      "low": 286.8316955566406,
      "timestamp": 1660916700.0,
      "volume": 309345.0
    },
    {
      "open": 287.0,
      "close": 286.4599914550781,
      "high": 287.04998779296875,
      "low": 286.3800048828125,
      "timestamp": 1660917000.0,
      "volume": 331690.0
    },
    {
      "open": 286.5,
      "close": 286.55999755859375,
      "high": 287.0,
      "low": 286.32000732421875,
      "timestamp": 1660917300.0,
      "volume": 232375.0
    },
    {
      "open": 287.20001220703125,
      "close": 287.3800048828125,
      "high": 287.54998779296875,
      "low": 287.1700134277344,
      "timestamp": 1660918800.0,
      "volume": 177069.0
    },
    {
      "open": 287.3599853515625,
      "close": 287.2099914550781,
      "high": 287.3900146484375,
      "low": 286.82000732421875,
      "timestamp": 1660919100.0,
      "volume": 174417.0
    },
    {
      "open": 287.2099914550781,
      "close": 287.4800109863281,
      "high": 287.54998779296875,
      "low": 287.0799865722656,
      "timestamp": 1660919400.0,
      "volume": 249582.0
    },
    {
      "open": 287.4599914550781,
      "close": 287.32501220703125,
      "high": 287.6499938964844,
      "low": 287.2799987792969,
      "timestamp": 1660919700.0,
      "volume": 206840.0
    },
    {
      "open": 287.30999755859375,
      "close": 287.42999267578125,
      "high": 287.49169921875,
      "low": 286.9700012207031,
      "timestamp": 1660920000.0,
      "volume": 164649.0
    },
    {
      "open": 287.4100036621094,
      "close": 287.2099914550781,
      "high": 287.4513854980469,
      "low": 287.20001220703125,
      "timestamp": 1660920300.0,
      "volume": 147406.0
    },
    {
      "open": 287.2200012207031,
      "close": 286.8299865722656,
      "high": 287.2427062988281,
      "low": 286.72100830078125,
      "timestamp": 1660920600.0,
      "volume": 148646.0
    },
  ];

  var dataMaux = [
    {
      "open": 289.30999755859375,
      "close": 287.42999267578125,
      "high": 287.49169921875,
      "low": 286.9700012207031,
      "timestamp": 1660923300.0,
      "volume": 148646.0
    },
    {
      "open": 287.4599914550781,
      "close": 287.32501220703125,
      "high": 287.6499938964844,
      "low": 287.2799987792969,
      "timestamp": 1660923600.0,
      "volume": 148646.0
    },
    {
      "open": 287.2200012207031,
      "close": 286.8299865722656,
      "high": 287.2427062988281,
      "low": 286.72100830078125,
      "timestamp": 1660923900.0,
      "volume": 148646.0
    },
    {
      "open": 287.42999267578125,
      "close": 286.86700439453125,
      "high": 287.5799865722656,
      "low": 286.8316955566406,
      "timestamp": 1660924200.0,
      "volume": 148646.0
    },
    {
      "open": 286.5,
      "close": 286.55999755859375,
      "high": 287.0,
      "low": 286.32000732421875,
      "timestamp": 1660924500.0,
      "volume": 148646.0
    },
    {
      "open": 287.4100036621094,
      "close": 287.2099914550781,
      "high": 287.4513854980469,
      "low": 287.20001220703125,
      "timestamp": 1660924800.0,
      "volume": 147406.0
    },
    {
      "open": 286.2749938964844,
      "close": 286.4811096191406,
      "high": 286.6499938964844,
      "low": 286.2749938964844,
      "timestamp": 1660925100.0,
      "volume": 164419.0
    },
  ];
}
