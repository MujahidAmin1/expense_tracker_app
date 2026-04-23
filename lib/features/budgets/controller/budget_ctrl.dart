import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/budgets/service/budget_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetServiceProvider = Provider<BudgetService>((ref) {
  return BudgetService();
});

final budgetListProvider =
    NotifierProvider<BudgetListNotifier, List<Budget>>(
  BudgetListNotifier.new,
);

class BudgetListNotifier extends Notifier<List<Budget>> {
  late final BudgetService _service;

  @override
  List<Budget> build() {
    _service = ref.watch(budgetServiceProvider);
    return _service.getAll();
  }

  Future<void> addBudget(Budget budget) async {
    await _service.add(budget);
    state = _service.getAll();
  }

  Future<void> updateBudget(Budget budget) async {
    await _service.update(budget);
    state = _service.getAll();
  }

  Future<void> deleteBudget(CategoryType category) async {
    await _service.delete(category);
    state = _service.getAll();
  }

  void refresh() {
    state = _service.getAll();
  }
}
