import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllocationCard extends StatelessWidget {
  final double totalSpent;
  final Map<CategoryType, double> categorySpending;

  const AllocationCard({
    super.key,
    required this.totalSpent,
    required this.categorySpending,
  });

  Color _getCategoryColor(CategoryType type) {
    switch (type) {
      case CategoryType.food:
        return const Color(0xFF003366);
      case CategoryType.travel:
        return const Color(0xFF1565C0);
      case CategoryType.subscription:
        return const Color(0xFF4DB6AC);
      case CategoryType.shop:
        return const Color(0xFF81C784);
      case CategoryType.utility:
        return const Color(0xFF0D47A1);
      case CategoryType.other:
        return const Color(0xFF78909C);
    }
  }

  String _formatCategoryName(CategoryType type) {
    final name = type.name;
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1);
    
    // Calculate percentages and prepare chart data
    final List<PieChartSectionData> sections = [];
    final List<Widget> legendItems = [];

    // Sort categories by spending (descending)
    final sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedEntries) {
      if (entry.value <= 0) continue;
      
      final percentage = totalSpent > 0 ? (entry.value / totalSpent) * 100 : 0.0;
      final color = _getCategoryColor(entry.key);

      sections.add(
        PieChartSectionData(
          color: color,
          value: entry.value,
          title: '', // Don't show titles on the chart slices
          radius: 16, // Thickness of the donut ring
        ),
      );

      legendItems.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatCategoryName(entry.key),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default empty state section if no spending
    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          color: AppColors.switchTrackInactive,
          value: 1,
          title: '',
          radius: 16,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Allocation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Donut Chart
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40, // Inner hole radius
                        sections: sections,
                        startDegreeOffset: -90, // Start from top
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalSpent > 0 ? currencyFormatter.format(totalSpent).toLowerCase() : '\$0',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Legend
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: legendItems.isEmpty
                      ? [
                          const Text(
                            'No expenses yet',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          )
                        ]
                      : legendItems,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
