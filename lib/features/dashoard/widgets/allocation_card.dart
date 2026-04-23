import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';

class AllocationCard extends StatelessWidget {
  const AllocationCard({
    super.key,
    required this.category,
    required this.limit,
    required this.spent,
  });

  final CategoryType category;
  final double limit;
  final double spent;

  IconData get _icon => switch (category) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  Color get _progressColor => switch (category) {
        CategoryType.food => const Color(0xFFE53935),
        CategoryType.travel => AppColors.primaryBlue,
        CategoryType.subscription => const Color(0xFF7B1FA2),
        CategoryType.shop => const Color(0xFFFF8F00),
        CategoryType.utility => const Color(0xFF1565C0),
        CategoryType.other => AppColors.textGrey,
      };

  @override
  Widget build(BuildContext context) {
    final remaining = (limit - spent).clamp(0.0, limit);
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              size: 20,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            category.name[0].toUpperCase() + category.name.substring(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            AppFormatter.currency(spent, decimalDigits: 0),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlue,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inactiveBackground,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _progressColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${AppFormatter.currency(remaining, decimalDigits: 0)} LEFT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: remaining > 0 ? AppColors.textGrey : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}
