import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:hive_ce/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
enum TransactionType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income,
}
@HiveType(typeId: 4)
enum RecurrenceType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
}

@HiveType(typeId: 5)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final TransactionType type;

  @HiveField(4)
  final CategoryType category;

  @HiveField(5)
  final bool isRecurring;

  @HiveField(6)
  final RecurrenceType? recurrence;

  @HiveField(7)
  final String? note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.isRecurring = false,
    this.recurrence,
    this.note,
  });
}