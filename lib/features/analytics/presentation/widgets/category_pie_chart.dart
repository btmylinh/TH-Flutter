import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/category_stats.dart';

class CategoryPieChart extends StatelessWidget {
  final List<CategoryStats> stats;

  const CategoryPieChart({super.key, required this.stats});

  Color _getCategoryColor(int index) {
    const colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.green,
      Colors.indigo,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: stats
                  .asMap()
                  .entries
                  .map(
                    (entry) => PieChartSectionData(
                      value: entry.value.totalAmount,
                      title: '${entry.value.percentage.toStringAsFixed(1)}%',
                      color: _getCategoryColor(entry.key),
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                  .toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...stats.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value.category,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '₫',
                  ).format(entry.value.totalAmount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(entry.key),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
