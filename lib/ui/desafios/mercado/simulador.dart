import 'dart:async';

import 'package:bonfire/background/background_color_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_tcc/main.dart';
import 'package:game_tcc/model/charts.dart';
import 'package:game_tcc/model/npc_model.dart';
import 'package:game_tcc/model/personagem_model.dart';
import 'package:game_tcc/ui/personagens/personagem_widget.dart';
import 'package:game_tcc/network/api_reques.dart';
import 'package:game_tcc/util/functions.dart';
import 'package:game_tcc/util/globalKeys.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Simulador extends StatefulWidget {
  Simulador({Key? key, required this.player}) : super(key: key);
  final PersonagemModel player;

  @override
  _SimuladorState createState() => _SimuladorState(player);
}

class _SimuladorState extends State<Simulador> {
  ChartModel? _chartModel;

  late Timer timer;

  int _initiTimerCont = 300;

  late int _timerCont;

  late TrackballBehavior _trackballBehavior;

  late SelectionBehavior _selectionBehavior;

  late ZoomPanBehavior _zoomPanBehavior;

  late TooltipBehavior _tooltipBehavior;

  late double _min = 0, _max = 0, _intervalo = 0;

  late ApiReques api;

  static const ativos = <String>['GOOG', 'msft'];
  String _btnSelect = ativos[1];

  Map<String, dynamic> comprasEfetuadas = {"valores": [], "resultados": []};

  PersonagemModel player;
  List compras = [];

  String dirCompra = "";

  double _valorCompra = 0.00;
  int _currentIndexCompra = 0;
  bool encerrarOp = false, compraEfetuada = false;
  MyGlobals myGlobals = MyGlobals();

  _SimuladorState(this.player);

  @override
  void initState() {
    api = ApiReques.getInstance();

    _timerCont = _initiTimerCont;

    _updateData(_btnSelect);

    // _chartData = getChartData().length >= 40
    //     ? getChartData().skip(getChartData().length - 40).toList()
    //     : getChartData();
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    _selectionBehavior = SelectionBehavior(enable: true);

    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _startTimer();
    timer.cancel();

    super.dispose();
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: appBarElevation,
        backgroundColor: Color.fromARGB(255, 168, 200, 245),
        title: Text("Simulador"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
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
                  color: player.saldo > 0.0 ? Colors.blue[400] : Colors.black),
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
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  borderWidth: 1,
                  // legend: Legend(isVisible: true),
                  trackballBehavior: _trackballBehavior,
                  tooltipBehavior: _tooltipBehavior,
                  zoomPanBehavior: _zoomPanBehavior,
                  series: <CandleSeries>[
                    CandleSeries<CandleStick, DateTime>(
                      dataSource: _chartModel!.chartData,
                      xValueMapper: (CandleStick sales, _) => sales.date,
                      lowValueMapper: (CandleStick sales, _) => sales.low,
                      highValueMapper: (CandleStick sales, _) => sales.high,
                      openValueMapper: (CandleStick sales, _) => sales.open,
                      closeValueMapper: (CandleStick sales, _) => sales.close,
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
                      numberFormat:
                          NumberFormat.simpleCurrency(decimalDigits: 2)),
                  // indicators: [
                  //   RsiIndicator(
                  //       dataSource: _chartData, isVisible: true, period: 10)
                  // ],
                  // isTransposed: true,
                  loadMoreIndicatorBuilder:
                      (BuildContext context, ChartSwipeDirection direction) =>
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
                        style: Theme.of(context).textTheme.headline4,
                        // maxLength: 1000,
                        decoration: InputDecoration(
                          labelText: "Valor",
                          labelStyle: TextStyle(fontSize: 12),
                          errorText: player.saldo <= 0.00 ? "Valor" : null,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        onSubmitted: (val) {
                          if (val != null && val != "" && val != '') {
                            _valorCompra = double.parse(val.toString());
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          onPressed: player.saldo > 0 && compraEfetuada == false
                              // &&
                              // _chartModel != null
                              ? () {
                                  if (_valorCompra > 0 &&
                                      _valorCompra <= player.saldo) {
                                    // print("call");
                                    setState(() {
                                      compras.add(_compra(player, _chartModel!,
                                          _valorCompra, "call"));

                                      somaSaldo(2, _valorCompra);

                                      comprasEfetuadas["valores"]
                                          .add(_valorCompra);
                                      comprasEfetuadas["resultados"].add(0.00);
                                    });
                                    compraEfetuada = true;
                                    _startTimer();
                                  } else {
                                    mgsAlertSnakBar(
                                        _valorCompra == 0
                                            ? "Insira um valor!"
                                            : "Saldo Insuficiente",
                                        context);
                                  }
                                }
                              : null,
                          child:
                              Icon(Icons.arrow_circle_up, color: Colors.black),
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: player.saldo > 0 && compraEfetuada == false
                              // &&
                              // _chartModel != null

                              ? () {
                                  if (_valorCompra > 0 &&
                                      _valorCompra <= player.saldo) {
                                    // print('put');
                                    setState(() {
                                      compras.add(_compra(player, _chartModel!,
                                          _valorCompra, "put"));

                                      comprasEfetuadas["valores"]
                                          .add(_valorCompra);
                                      comprasEfetuadas["resultados"].add(0.00);
                                      somaSaldo(2, _valorCompra);
                                    });
                                    compraEfetuada = true;
                                    _startTimer();
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
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Operações abertas: ",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(
                      height: 65.0,
                      width: 145,
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: listCompras(comprasEfetuadas).isNotEmpty
                            ? listCompras(comprasEfetuadas)
                            : [Text("---")],
                      ))
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: encerrarOp
                        ? () {
                            // contDesafio--;
                            setState(() {
                              var res = encerraOp(compras.last, _chartModel!);

                              somaSaldo(1, res);

                              comprasEfetuadas["resultados"]
                                  [_currentIndexCompra] = res;
                              compraEfetuada = false;
                              encerrarOp = false;
                              _timerCont = _initiTimerCont;
                            });

                            _currentIndexCompra++;
                          }
                        : null,
                    child: Text(
                      encerrarOp ? "Encerrar operação!" : '${_timerCont}',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
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

  void somaSaldo(int op, double num1) {
    if (op == 1) player.saldo += num1;
    if (op == 2) player.saldo -= num1;
  }

  Map<String, dynamic> _compra(PersonagemModel perso, ChartModel chart,
      double montante, String direcao) {
    double _price_compra;
    double _qtd_comprada = 0.00;

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

  Future<bool> _updateData(String ativo) async =>
      Future.wait([api.getChartData(ativo, 5, ChartDurations.ONE_DAY)])
          .then((value) {
        value.forEach((element) {
          _chartModel = element;
          // print(element);
        });
        _intervalo =
            getMinMaxChart(_chartModel!.chartData)["interv"]!.toDouble();

        _min = getMinMaxChart(_chartModel!.chartData)["min"]!.toDouble() * 1.01;
        _max = getMinMaxChart(_chartModel!.chartData)["max"]!.toDouble() / 1.02;

        print(_chartModel!.chartData);

        return true;
      });

  _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _timerCont--;
        if (_timerCont == 0) {
          encerrarOp = true;
          timer.cancel();
        }
      });
    });
  }
}
