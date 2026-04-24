import 'package:expense_tracker_app/features/budgets/controller/budget_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/controller/transaction_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightState {
  final double totalSpent;
  final double totalBudget;
  final Map<CategoryType, double> categorySpending;

  InsightState({
    required this.totalSpent,
    required this.totalBudget,
    required this.categorySpending,
  });
}

final insightControllerProvider = Provider<InsightState>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final budgets = ref.watch(budgetListProvider);

  double totalSpent = 0;
  double totalBudget = 0;
  Map<CategoryType, double> categorySpending = {};

  for (var budget in budgets) {
    totalBudget += budget.limit; // Using limit as the total budget
  }

  for (var transaction in transactions) {
    if (transaction.type == TransactionType.expense) {
      totalSpent += transaction.amount;
      categorySpending[transaction.category] =
          (categorySpending[transaction.category] ?? 0) + transaction.amount;
    }
  }

  return InsightState(
    totalSpent: totalSpent,
    totalBudget: totalBudget,
    categorySpending: categorySpending,
  );
});
