import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSpentCard extends StatelessWidget {
  final double totalSpent;
  final double totalBudget;

  const TotalSpentCard({
    super.key,
    required this.totalSpent,
    required this.totalBudget,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    double progress = totalBudget > 0 ? totalSpent / totalBudget : 0.0;
    // Clamp progress between 0 and 1
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Spent',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormatter.format(totalSpent),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.switchTrackInactive,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'of ${currencyFormatter.format(totalBudget)} total budget',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
