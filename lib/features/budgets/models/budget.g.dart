// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final typeId = 1;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      category: fields[0] as CategoryType,
      limit: (fields[1] as num).toDouble(),
      startDate: fields[2] as DateTime,
      budgetedAmount: (fields[3] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.limit)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.budgetedAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryTypeAdapter extends TypeAdapter<CategoryType> {
  @override
  final typeId = 2;

  @override
  CategoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CategoryType.food;
      case 1:
        return CategoryType.travel;
      case 2:
        return CategoryType.subscription;
      case 3:
        return CategoryType.shop;
      case 4:
        return CategoryType.utility;
      case 5:
        return CategoryType.other;
      default:
        return CategoryType.food;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryType obj) {
    switch (obj) {
      case CategoryType.food:
        writer.writeByte(0);
      case CategoryType.travel:
        writer.writeByte(1);
      case CategoryType.subscription:
        writer.writeByte(2);
      case CategoryType.shop:
        writer.writeByte(3);
      case CategoryType.utility:
        writer.writeByte(4);
      case CategoryType.other:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
