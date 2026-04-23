import 'package:expense_tracker_app/core/boxes/hiveboxes.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:expense_tracker_app/features/transaction/service/transaction_service.dart';
import 'package:hive_ce/hive.dart';

class BudgetService {
  Box<Budget> get _box => Hive.box<Budget>(MyHiveBoxes.budgetBoxName);

  final TransactionService _transactionService = TransactionService();

  static Future<void> init() async {
    await Hive.openBox<Budget>(MyHiveBoxes.budgetBoxName);
  }

  Future<void> add(Budget budget) async {
    await _box.put(budget.category.name, budget);
  }

  Future<void> update(Budget budget) async {
    await _box.put(budget.category.name, budget);
  }

  Future<void> delete(CategoryType category) async {
    await _box.delete(category.name);
  }

  List<Budget> getAll() => _box.values.toList();

  Budget? getByCategory(CategoryType category) => _box.get(category.name);

  double getTotalBudgetLimit() {
    return _box.values.fold(0.0, (sum, b) => sum + b.limit);
  }

  double getTotalIncome() {
    return _transactionService.getTotalIncome();
  }

  double getTotalAllocatedExcluding(CategoryType category) {
    return _box.values
        .where((b) => b.category != category)
        .fold(0.0, (sum, b) => sum + b.limit);
  }

  double getTotalSpent() {
    return _transactionService.getTotalExpenses();
  }

  double getTotalRemaining() {
    return getTotalBudgetLimit() - getTotalSpent();
  }

  double getSpentPercentage() {
    final limit = getTotalBudgetLimit();
    if (limit <= 0) return 0;
    return (getTotalSpent() / limit).clamp(0.0, 1.0);
  }

  double getSpentForCategory(CategoryType category) {
    final transactions = _transactionService.getByCategory(category);
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getRemainingForCategory(CategoryType category) {
    final budget = getByCategory(category);
    if (budget == null) return 0;
    return budget.limit - getSpentForCategory(category);
  }

  double getSpentPercentageForCategory(CategoryType category) {
    final budget = getByCategory(category);
    if (budget == null || budget.limit <= 0) return 0;
    return (getSpentForCategory(category) / budget.limit).clamp(0.0, 1.0);
  }

  Map<int, double> getDailySpendingForWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final dailySpending = <int, double>{};

    for (var i = 0; i < 7; i++) {
      final day = DateTime(monday.year, monday.month, monday.day + i);
      dailySpending[i] = 0;
      final transactions = _transactionService.getAll();
      for (final t in transactions) {
        if (t.type == TransactionType.expense &&
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day) {
          dailySpending[i] = (dailySpending[i] ?? 0) + t.amount;
        }
      }
    }
    return dailySpending;
  }

  double getSpendingVelocityChange() {
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    final transactions = _transactionService.getAll();
    double thisWeek = 0;
    double lastWeek = 0;

    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (!t.date.isBefore(thisWeekStart) && !t.date.isAfter(now)) {
        thisWeek += t.amount;
      } else if (!t.date.isBefore(lastWeekStart) &&
          t.date.isBefore(thisWeekStart)) {
        lastWeek += t.amount;
      }
    }

    if (lastWeek == 0) return 0;
    return ((thisWeek - lastWeek) / lastWeek) * 100;
  }
}