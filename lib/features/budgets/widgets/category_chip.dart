import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    this.size = 28,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final CategoryType category;
  final double size;
  final bool isSelected;
  final bool isDisabled;

  IconData get _icon => switch (category) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.categorySelectedBg : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.categorySelectedBorder
              : AppColors.categoryBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              size: size,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
            const SizedBox(height: 6),
            Text(
              category.name[0].toUpperCase() + category.name.substring(1),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
