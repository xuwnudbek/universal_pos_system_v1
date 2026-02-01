import 'package:drift/drift.dart';

import 'items_table.dart';
import 'sales_table.dart';

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
