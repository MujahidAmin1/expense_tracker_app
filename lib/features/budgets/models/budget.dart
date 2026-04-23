import 'package:hive_ce/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  final CategoryType category;

  @HiveField(1)
  final double limit;

  @HiveField(2)
  final DateTime startDate;
  
  @HiveField(3)
  final double budgetedAmount;

  Budget({
    required this.category,
    required this.limit,
    required this.startDate,
    required this.budgetedAmount,
  });
}

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  food,
  @HiveField(1)
  travel,
  @HiveField(2)
  subscription,
  @HiveField(3)
  shop,
  @HiveField(4)
  utility,
  @HiveField(5)
  other,

}