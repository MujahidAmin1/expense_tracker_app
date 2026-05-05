import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/budgets/service/budget_service.dart';
import 'package:expense_tracker_app/features/budgets/view/category_transactions_screen.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/allocation_card.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AllocationsSection extends StatelessWidget {
  final List<Budget> budgets;
  final BudgetService budgetService;

  /// If [horizontal] is true, renders a horizontal scrollable row (mobile).
  /// If false, renders a vertical stacked column (desktop right panel).
  final bool horizontal;

  const AllocationsSection({
    super.key,
    required this.budgets,
    required this.budgetService,
    this.horizontal = true,
  });

  void _navigateToCategory(BuildContext context, CategoryType category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryTransactionsScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline, size: 40, color: AppColors.symbolGrey),
            const SizedBox(height: 12),
            const Text(
              'No allocations yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    if (horizontal) {
      return SizedBox(
        height: 175,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: budgets.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, i) {
            final budget = budgets[i];
            final spent = budgetService.getSpentForCategory(budget.category);
            return AllocationCard(
              category: budget.category,
              limit: budget.limit,
              spent: spent,
              onTap: () => _navigateToCategory(context, budget.category),
            );
          },
        ),
      );
    }

    // Vertical (desktop)
    return Column(
      children: budgets.map<Widget>((budget) {
        final spent = budgetService.getSpentForCategory(budget.category);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AllocationCard(
            category: budget.category,
            limit: budget.limit,
            spent: spent,
            onTap: () => _navigateToCategory(context, budget.category),
          ),
        );
      }).toList(),
    );
  }
}
