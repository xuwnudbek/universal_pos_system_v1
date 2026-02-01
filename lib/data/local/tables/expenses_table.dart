import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/expense_categories_table.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId => integer().references(ExpenseCategories, #id)();

  RealColumn get amount => real()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get expenseDate => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
