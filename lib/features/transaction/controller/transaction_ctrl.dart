import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:expense_tracker_app/features/transaction/service/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});

final transactionListProvider =
    NotifierProvider<TransactionListNotifier, List<TransactionModel>>(
  TransactionListNotifier.new,
);

class TransactionListNotifier extends Notifier<List<TransactionModel>> {
  late final TransactionService _repository;

  @override
  List<TransactionModel> build() {
    _repository = ref.watch(transactionRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _repository.add(transaction);
    state = _repository.getAll();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.update(transaction);
    state = _repository.getAll();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.delete(id);
    state = _repository.getAll();
  }

  List<TransactionModel> getByType(TransactionType type) {
    return _repository.getByType(type);
  }
}
