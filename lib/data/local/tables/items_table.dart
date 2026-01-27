import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/units_table.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  TextColumn get barcode => text()();
  IntColumn get unitId => integer().references(Units, #id)();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  IntColumn get categoryId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
