import 'package:expense_tracker_app/core/boxes/hiveboxes.dart';
import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:hive_ce/hive.dart';

class TransactionService {
  Box<TransactionModel> get _box => Hive.box<TransactionModel>(MyHiveBoxes.transactionBoxName);

  static Future<void> init() async {
    await Hive.openBox<TransactionModel>(MyHiveBoxes.transactionBoxName);
  }

  Future<void> add(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> update(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
   List<TransactionModel> getAll() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  TransactionModel? getById(String id) => _box.get(id);

  List<TransactionModel> getByType(TransactionType type) {
    return _box.values.where((t) => t.type == type).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getByCategory(CategoryType category) {
    return _box.values.where((t) => t.category == category).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
   double getTotalIncome() {
    return _box.values
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses() {
    return _box.values
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getBalance() => getTotalIncome() - getTotalExpenses();
  
}