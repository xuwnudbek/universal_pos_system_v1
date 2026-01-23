import 'package:drift/drift.dart';
import 'carts_table.dart';
import 'items_table.dart';

class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cartId => integer().references(Carts, #id)();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
