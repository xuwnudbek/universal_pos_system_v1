import 'package:drift/drift.dart';

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
