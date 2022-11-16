// import 'dart:async';
// import 'dart:convert' as Convert;
// import 'dart:io';

// import 'package:http/http.dart' as Http;

// import 'package:game_tcc/model/charts.dart' as Charts;

import 'package:yahoofin/src/models/stock_chart.dart';
import 'package:yahoofin/yahoofin.dart';

import '../model/charts.dart';

class ApiReques {
  static ApiReques? _sIexApiProxyInstance;

  ApiReques() {
    print('Instantiating instance!!');
  }

  static getInstance() {
    if (_sIexApiProxyInstance == null) {
      _sIexApiProxyInstance = ApiReques();
    }
    return _sIexApiProxyInstance;
  }

  dispose() {
    _sIexApiProxyInstance = null;
  }

  Future<List<Map<String, double>>?> _getData(
      String ativo, int? intervalo, ChartDurations? periodo) async {
    var yfin = YahooFin();
    List<Map<String, double>> charts = [];
    try {
      StockHistory hist = yfin.initStockHistory(ticker: ativo);
      StockChart chart = await yfin.getChartQuotes(
          stockHistory: hist,
          interval: intervalo == 1
              ? StockInterval.oneMinute
              : intervalo == 5
                  ? StockInterval.fiveMinute
                  : intervalo == 30
                      ? StockInterval.thirtyMinute
                      : intervalo == 15
                          ? StockInterval.fifteenMinute
                          : StockInterval.sixtyMinute,
          period: periodo == ChartDurations.ONE_DAY
              ? StockRange.oneDay
              : periodo == ChartDurations.FIVE_DAYS
                  ? StockRange.fiveDay
                  : periodo == ChartDurations.ONE_MONTH
                      ? StockRange.oneMonth
                      // : StockRange.threeMonth);
                      : StockRange.threeMonth);
      int i = 0;
      if (chart != null) {
        chart.chartQuotes?.timestamp?.forEach((element) {
          charts.add({
            "open": chart.chartQuotes!.open![i].toDouble(),
            "close": chart.chartQuotes!.close![i].toDouble(),
            "high": chart.chartQuotes!.high![i].toDouble(),
            "low": chart.chartQuotes!.low![i].toDouble(),
            "timestamp": element.toDouble(),
            "volume": chart.chartQuotes!.volume![i].toDouble()
          });
          i++;
        });
        return charts;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ChartModel> getChartData(
      String ativo, int? intervalo, ChartDurations? periodo) async {
    List<CandleStick> charts = [];

    var data = _getData(ativo, intervalo, periodo);

    try {
      await data.then((value) => value!.forEach((element) {
            // print(element);
            charts.add(new CandleStick(
                element['high'],
                element['low'],
                element['volume'],
                //       "Timestamp EDT"
                DateTime.fromMillisecondsSinceEpoch(
                    element['timestamp']!.toInt() * 1000 as int),
                element['open'],
                element['close']));
            // print('123$value');
          }));
    } catch (e) {
      print('Erro candle${e}');
    }

    ChartModel chart = ChartModel(ativo, periodo, intervalo, charts);

    return chart;
  }
}
