import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/carts_table.dart';
import 'package:universal_pos_system_v1/data/local/tables/saved_carts_table.dart';

class SavedCartsItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get savedCartId => integer().references(SavedCarts, #id)();
  IntColumn get cartId => integer().references(Carts, #id)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
