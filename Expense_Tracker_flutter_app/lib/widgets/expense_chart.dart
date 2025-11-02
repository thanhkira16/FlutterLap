import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;
  final Map<String, double> categoryTotals;

  const ExpenseChart({
    Key? key,
    required this.expenses,
    required this.categoryTotals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_down, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No expenses yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pie Chart for Category Distribution
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending by Category',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieSections(),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Category Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Breakdown',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ..._buildCategoryListItems(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final colors = _getCategoryColors();
    final sections = <PieChartSectionData>[];

    categoryTotals.forEach((category, total) {
      final totalSum = categoryTotals.values.reduce((a, b) => a + b);
      final percentage = (total / totalSum) * 100;

      sections.add(
        PieChartSectionData(
          color: colors[category] ?? Colors.grey,
          value: total,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  List<Widget> _buildCategoryListItems(BuildContext context) {
    return categoryTotals.entries.map((entry) {
      final color = _getCategoryColors()[entry.key] ?? Colors.grey;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '\$${entry.value.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }).toList();
  }

  Map<String, Color> _getCategoryColors() {
    return {
      'Food & Dining': const Color(0xFFFF6B6B),
      'Transportation': const Color(0xFF4ECDC4),
      'Shopping': const Color(0xFFFFE66D),
      'Entertainment': const Color(0xFF95E1D3),
      'Bills & Utilities': const Color(0xFFC7CEEA),
      'Healthcare': const Color(0xFFFF8B94),
      'Education': const Color(0xFF74B9FF),
      'Travel': const Color(0xFFA29BFE),
      'Other': const Color(0xFFDFE6E9),
    };
  }
}
