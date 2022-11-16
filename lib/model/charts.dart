enum ChartDurations {
  ONE_MONTH,
  FIVE_DAYS,
  ONE_DAY,
}

class ChartModel {
  final String tickerSymbol;
  final ChartDurations? tickerDuration;
  final int? chartInterval;
  final List<CandleStick> chartData;

  ChartModel(this.tickerSymbol, this.tickerDuration, this.chartInterval,
      this.chartData);
}

class CandleStick {
  final double? high;
  final double? low;
  final double? volume;
  // final double changeOverTime;
  final DateTime? date;
  final double? open;
  final double? close;
  // final String label;

  CandleStick(
      this.high, this.low, this.volume, this.date, this.open, this.close);

  static List<CandleStick> fromJson(List chartJsonDataResponse) {
    return chartJsonDataResponse
        .map((chartJsonData) => CandleStick.fromJsonKV(chartJsonData))
        .toList();
  }

  CandleStick.fromJsonKV(Map chartJsonDataResponse)
      : this.high = chartJsonDataResponse['high']?.toDouble(),
        this.low = chartJsonDataResponse['low']?.toDouble(),
        this.volume = chartJsonDataResponse['volume']?.toDouble(),
        this.date = DateTime.parse(chartJsonDataResponse['date']),
        this.open = chartJsonDataResponse['open']?.toDouble(),
        this.close = chartJsonDataResponse['close']?.toDouble();

  @override
  String toString() {
    // TODO: implement toString
    return "Data from $date with volume: $volume high: $high, low: $low \n";
  }
}
