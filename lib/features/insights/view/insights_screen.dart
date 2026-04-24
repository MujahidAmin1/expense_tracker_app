import 'package:expense_tracker_app/features/insights/view/controller/insight_controller.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/allocation_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/smart_allocation_banner.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/smart_suggestions_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/spending_velocity_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/top_expense_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/total_spent_card.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(insightControllerProvider);
    final period = ref.watch(insightPeriodProvider);
    final monthName = DateFormat('MMMM').format(DateTime.now());
    final usedPct = (state.utilizationPct * 100).round();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PERFORMANCE ANALYTICS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textGrey,
                letterSpacing: 1.2,
              ),
            ),
            const Text(
              'Financial Insights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
        actions: [
          // Period toggle
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.inactiveBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: InsightPeriod.values.map((p) {
                final isSelected = p == period;
                final label = p.name[0].toUpperCase() + p.name.substring(1);
                return GestureDetector(
                  onTap: () => ref.read(insightPeriodProvider.notifier).state = p,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.white : AppColors.textGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Spending Velocity ──
              SpendingVelocityCard(
                dailySpending: state.dailySpending,
                velocityChange: state.velocityChange,
                budgetRemaining: state.totalRemaining,
              ),
              const SizedBox(height: 20),

              // ── Monthly Overview ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${period.name.toUpperCase()} OVERVIEW',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textGrey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$monthName Budgets',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.totalBudget > 0
                          ? 'You\'ve utilized $usedPct% of your total ${period.name} allowance. '
                            'Your trajectory suggests you\'ll remain within limits by month end.'
                          : 'No budget allocated yet. Add budgets to start tracking here.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(state.totalSpent),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    if (state.totalBudget > 0)
                      Text(
                        'of ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(state.totalBudget)} total budget',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Total Spent progress card ──
              TotalSpentCard(
                totalSpent: state.totalSpent,
                totalBudget: state.totalBudget,
              ),
              const SizedBox(height: 20),

              // ── Allocation donut ──
              AllocationCard(
                totalSpent: state.totalSpent,
                categorySpending: state.categorySpending,
              ),
              const SizedBox(height: 20),

              // ── Top Expense ──
              TopExpenseCard(categorySpending: state.categorySpending),
              if (state.categorySpending.isNotEmpty) const SizedBox(height: 20),

              // ── Smart Suggestions ──
              SmartSuggestionsCard(
                categorySpending: state.categorySpending,
                topOverspentCategory: state.topOverspentCategory,
              ),
              const SizedBox(height: 20),

              // ── Smart Allocation Banner ──
              SmartAllocationBanner(
                utilizationPct: state.utilizationPct,
                totalBudget: state.totalBudget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}