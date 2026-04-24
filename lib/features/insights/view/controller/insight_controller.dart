import 'package:expense_tracker_app/features/budgets/controller/budget_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/controller/transaction_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum InsightPeriod { daily, weekly, monthly }

final insightPeriodProvider = StateProvider<InsightPeriod>((ref) => InsightPeriod.monthly);

class InsightState {
  final double totalSpent;
  final double totalBudget;
  final double totalRemaining;
  final double utilizationPct;
  final Map<CategoryType, double> categorySpending;
  final Map<int, double> dailySpending;
  final double velocityChange;
  final CategoryType? topOverspentCategory;

  InsightState({
    required this.totalSpent,
    required this.totalBudget,
    required this.totalRemaining,
    required this.utilizationPct,
    required this.categorySpending,
    required this.dailySpending,
    required this.velocityChange,
    this.topOverspentCategory,
  });
}

final insightControllerProvider = Provider<InsightState>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final budgets = ref.watch(budgetListProvider);
  final period = ref.watch(insightPeriodProvider);
  final service = ref.read(budgetServiceProvider);

  final now = DateTime.now();

  bool inPeriod(DateTime date) {
    switch (period) {
      case InsightPeriod.daily:
        return date.year == now.year && date.month == now.month && date.day == now.day;
      case InsightPeriod.weekly:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final weekStart = DateTime(monday.year, monday.month, monday.day);
        final weekEnd = weekStart.add(const Duration(days: 7));
        return !date.isBefore(weekStart) && date.isBefore(weekEnd);
      case InsightPeriod.monthly:
        return date.year == now.year && date.month == now.month;
    }
  }

  double totalSpent = 0;
  double totalBudget = 0;
  final Map<CategoryType, double> categorySpending = {};

  for (var budget in budgets) {
    totalBudget += budget.limit;
  }

  for (var t in transactions) {
    if (t.type == TransactionType.expense && inPeriod(t.date)) {
      totalSpent += t.amount;
      categorySpending[t.category] = (categorySpending[t.category] ?? 0) + t.amount;
    }
  }

  final totalRemaining = (totalBudget - totalSpent).clamp(0.0, double.infinity);
  final utilizationPct = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;

  CategoryType? topOverspent;
  double maxOverrun = 0;
  for (final entry in categorySpending.entries) {
    final budget = service.getByCategory(entry.key);
    if (budget != null) {
      final overrun = entry.value - budget.limit;
      if (overrun > maxOverrun) {
        maxOverrun = overrun;
        topOverspent = entry.key;
      }
    }
  }

  return InsightState(
    totalSpent: totalSpent,
    totalBudget: totalBudget,
    totalRemaining: totalRemaining,
    utilizationPct: utilizationPct,
    categorySpending: categorySpending,
    dailySpending: service.getDailySpendingForWeek(),
    velocityChange: service.getSpendingVelocityChange(),
    topOverspentCategory: topOverspent,
  );
});
