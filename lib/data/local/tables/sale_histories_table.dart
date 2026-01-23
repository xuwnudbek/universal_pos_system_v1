import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/carts_table.dart';

class SaleHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cartId => integer().references(Carts, #id)();
  RealColumn get total => real().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
