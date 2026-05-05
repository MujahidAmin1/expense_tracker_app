import 'package:expense_tracker_app/features/budgets/controller/budget_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/budgets/view/allocation_screen.dart';
import 'package:expense_tracker_app/features/budgets/widgets/category_budget_tile.dart';
import 'package:expense_tracker_app/features/budgets/widgets/monthly_burn_card.dart';
import 'package:expense_tracker_app/features/budgets/widgets/spending_velocity_chart.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/animated_item.dart';
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
    final isDesktop = context.isDesktop;

    Widget leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDesktop) ...[
          _buildHeader(),
          const SizedBox(height: 20),
        ],

        AnimatedItem(
          index: 0,
          child: MonthlyBurnCard(
            totalSpent: totalSpent,
            spentPct: spentPct,
            totalLimit: totalLimit,
            totalRemaining: totalRemaining,
            onTrack: onTrack,
          ),
        ),
        const SizedBox(height: 20),

        AnimatedItem(
          index: 1,
          child: SpendingVelocityChart(
            dailySpending: dailySpending,
            velocityChange: velocityChange,
            budgetRemaining: totalRemaining,
          ),
        ),
        const SizedBox(height: 20),

        AnimatedItem(
          index: 2,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllocationScreen()),
                );
                ref.read(budgetListProvider.notifier).refresh();
              },
              icon: const Icon(Icons.edit_outlined, size: 20),
              label: const Text('Update Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );

    Widget rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedItem(
          index: isDesktop ? 0 : 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.darkText)),
              TextButton(
                onPressed: () {},
                child: const Text('VIEW ALL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryBlue, letterSpacing: 0.5)),
              ),
            ],
          ),
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
            child: const Column(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 48, color: AppColors.symbolGrey),
                SizedBox(height: 12),
                Text('No budgets yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
                SizedBox(height: 4),
                Text('Tap "Update Budget" to get started', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          )
        else
          ...budgets.asMap().entries.map((entry) {
            final index = entry.key;
            final budget = entry.value;
            final spent = service.getSpentForCategory(budget.category);
            return AnimatedItem(
              index: (isDesktop ? 1 : 4) + index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CategoryBudgetTile(
                  category: budget.category,
                  icon: _iconForCategory(budget.category),
                  spent: spent,
                  limit: budget.limit,
                ),
              ),
            );
          }),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : (context.isTablet ? 24 : 20), vertical: 16),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 55, child: leftColumn),
                        const SizedBox(width: 32),
                        Expanded(flex: 45, child: rightColumn),
                      ],
                    )
                  : Column(
                      children: [
                        leftColumn,
                        rightColumn,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.account_balance, color: AppColors.white, size: 18),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Sovereign Ledger', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.darkText)),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.darkText, size: 26),
        ),
      ],
    );
  }

}