import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/monthly_trend.dart';

class MonthlyLineChart extends StatelessWidget {
  final List<MonthlyTrend> trends;

  const MonthlyLineChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Không có dữ liệu')),
      );
    }

    final maxY = trends
        .map((e) => e.totalAmount)
        .reduce((a, b) => a > b ? a : b);
    final minY = trends
        .map((e) => e.totalAmount)
        .reduce((a, b) => a < b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: (maxY - minY) / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.3),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        NumberFormat.compact(locale: 'vi_VN').format(value),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < trends.length) {
                        final trend = trends[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/yy').format(trend.month),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              minX: 0,
              maxX: (trends.length - 1).toDouble(),
              minY: minY > 0 ? 0 : minY,
              maxY: maxY * 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: trends
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.totalAmount))
                      .toList(),
                  isCurved: true,
                  color: Theme.of(context).primaryColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final trend = trends[spot.x.toInt()];
                      return LineTooltipItem(
                        '${DateFormat('MM/yyyy').format(trend.month)}\n${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(spot.y)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Xu hướng chi tiêu ${trends.length} tháng gần nhất',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
