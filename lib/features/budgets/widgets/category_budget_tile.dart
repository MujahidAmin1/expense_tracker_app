import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/budgets/view/category_transactions_screen.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';

class CategoryBudgetTile extends StatelessWidget {
  const CategoryBudgetTile({
    super.key,
    required this.category,
    required this.icon,
    required this.spent,
    required this.limit,
  });

  final CategoryType category;
  final IconData icon;
  final double spent;
  final double limit;

  Color get _progressColor => switch (category) {
        CategoryType.food => const Color(0xFFE53935),
        CategoryType.travel => AppColors.primaryBlue,
        CategoryType.subscription => const Color(0xFF7B1FA2),
        CategoryType.shop => const Color(0xFFFF8F00),
        CategoryType.utility => const Color(0xFF1565C0),
        CategoryType.other => AppColors.textGrey,
      };

  Color get _iconBackgroundColor => switch (category) {
        CategoryType.food => const Color(0xFFFFEBEE),
        CategoryType.travel => const Color(0xFFE3F2FD),
        CategoryType.subscription => const Color(0xFFF3E5F5),
        CategoryType.shop => const Color(0xFFFFF3E0),
        CategoryType.utility => const Color(0xFFE1F5FE),
        CategoryType.other => const Color(0xFFF5F5F5),
      };

  @override
  Widget build(BuildContext context) {
    final remaining = (limit - spent).clamp(0.0, limit);
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppColors.primaryBlue.withValues(alpha: 0.12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CategoryTransactionsScreen(category: category),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.categoryBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Hero(
                tag: 'cat_icon_${category.name}',
                child: Icon(icon, size: 24, color: _progressColor),
              ),
            ),
            const SizedBox(height: 16),
            
            // Category Name
            Text(
              category.name[0].toUpperCase() + category.name.substring(1),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.inactiveBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: _progressColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Amount and Remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppFormatter.currency(spent, decimalDigits: 0),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _progressColor,
                  ),
                ),
                Text(
                  '${AppFormatter.currency(remaining, decimalDigits: 0)} LEFT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
