import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/app_colors.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;
  final bool isDark;

  const ExpenseChart({
    super.key,
    required this.expensesByCategory,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (expensesByCategory.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    final total = expensesByCategory.values.fold<double>(0, (a, b) => a + b);
    final colors = [
      Colors.red, Colors.blue, Colors.green, Colors.orange,
      Colors.purple, Colors.teal, Colors.pink, Colors.amber,
      Colors.indigo, Colors.cyan,
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: expensesByCategory.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value.key;
                final amount = entry.value.value;
                final percentage = (amount / total * 100).toStringAsFixed(1);
                
                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: amount,
                  title: '$percentage%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Leyenda
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: expensesByCategory.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value.key;
            final amount = entry.value.value;
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$category: \$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}