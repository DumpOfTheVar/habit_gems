import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../domain/entity/statistics_day.dart';

class StatisticsChart extends StatelessWidget {
  StatisticsChart({super.key, required this.data, required this.legend});

  final List<StatisticsDay> data;
  final Map<int, Map<String, dynamic>> legend;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Statistics'),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: 1,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
        series: _getLineSeries(),
      ),
    );
  }

  List _getLineSeries() {
    final Set<int> gemIds = {};
    for (final day in data) {
      gemIds.addAll(day.gemCounts.keys);
    }
    return gemIds.map((int gemId) {
      return StackedAreaSeries<StatisticsDay, String>(
        dataSource: data,
        xValueMapper: (StatisticsDay day, _) => day.date,
        yValueMapper: (StatisticsDay day, _) => day.gemCounts[gemId] ?? 0,
        name: legend[gemId]!['title'],
        color: legend[gemId]!['color'],
        borderColor: Colors.grey,
        borderWidth: 3,
        borderDrawMode: BorderDrawMode.top,
        markerSettings: const MarkerSettings(isVisible: true),
      );
    }).toList();
  }
}