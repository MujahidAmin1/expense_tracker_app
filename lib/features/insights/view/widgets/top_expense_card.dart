import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopExpenseCard extends StatelessWidget {
  final Map<CategoryType, double> categorySpending;

  const TopExpenseCard({super.key, required this.categorySpending});

  @override
  Widget build(BuildContext context) {
    if (categorySpending.isEmpty) return const SizedBox.shrink();

    final topCategory = categorySpending.entries.reduce((a, b) => a.value > b.value ? a : b);
    if (topCategory.value <= 0) return const SizedBox.shrink();

    final currencyFormatter = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 2);
    final name = topCategory.key.name;
    final formattedName = "${name[0].toUpperCase()}${name.substring(1)}";

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.activeLightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Expense',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormatter.format(topCategory.value),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
