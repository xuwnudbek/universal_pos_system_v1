import 'package:drift/drift.dart';

import 'items_table.dart';
import 'sales_table.dart';

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get saleId => integer().references(Sales, #id, onDelete: KeyAction.cascade)();

  IntColumn get itemId => integer().references(Items, #id, onDelete: KeyAction.restrict)();

  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
