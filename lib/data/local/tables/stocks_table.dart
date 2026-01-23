import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/local/tables/items_table.dart';

class Stocks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get itemId => integer().references(Items, #id)();

  TextColumn get location => textEnum<LocationsEnum>()();

  RealColumn get quantity => real().withDefault(const Constant(0))();
}
