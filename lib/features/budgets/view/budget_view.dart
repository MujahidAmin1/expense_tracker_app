import 'package:expense_tracker_app/features/budgets/controller/budget_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';

import 'package:expense_tracker_app/features/budgets/view/allocation_screen.dart';
import 'package:expense_tracker_app/features/budgets/widgets/category_budget_tile.dart';
import 'package:expense_tracker_app/features/budgets/widgets/spending_velocity_chart.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';
import 'package:expense_tracker_app/utils/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetsView extends ConsumerWidget {
  const BudgetsView({super.key});

  IconData _iconForCategory(CategoryType category) => switch (category) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetListProvider);
    final service = ref.watch(budgetServiceProvider);
    final totalLimit = service.getTotalBudgetLimit();
    final totalSpent = service.getTotalSpent();
    final totalRemaining = service.getTotalRemaining();
    final spentPct = service.getSpentPercentage();
    final dailySpending = service.getDailySpendingForWeek();
    final velocityChange = service.getSpendingVelocityChange();

    final onTrack = spentPct < 0.85;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance,
                        color: AppColors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Sovereign Ledger',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: AppColors.darkText, size: 26),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF002952), Color(0xFF004080)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MONTHLY BURN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white.withValues(alpha: .7),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: onTrack
                                ? const Color(0xFF43A047)
                                : const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            onTrack ? 'ON TRACK' : 'OVER',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppFormatter.currency(totalSpent),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: spentPct,
                        minHeight: 6,
                        backgroundColor: AppColors.white.withValues(alpha: .2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF64B5F6)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(spentPct * 100).toStringAsFixed(0)}% of ${AppFormatter.currency(totalLimit)} limit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: .7),
                          ),
                        ),
                        Text(
                          '${AppFormatter.currency(totalRemaining)} left',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SpendingVelocityChart(
                dailySpending: dailySpending,
                velocityChange: velocityChange,
                budgetRemaining: totalRemaining,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const AllocationScreen()),
                    );
                    ref.read(budgetListProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text(
                    'Update Budget',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (budgets.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.categoryBorder),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          size: 48, color: AppColors.symbolGrey),
                      const SizedBox(height: 12),
                      Text(
                        'No budgets yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Update Budget" to get started',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...budgets.map((budget) {
                  final spent = service.getSpentForCategory(budget.category);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CategoryBudgetTile(
                      category: budget.category,
                      icon: _iconForCategory(budget.category),
                      spent: spent,
                      limit: budget.limit,
                    ),
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}