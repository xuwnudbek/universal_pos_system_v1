import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/procurements_table.dart';
import 'package:universal_pos_system_v1/data/local/tables/items_table.dart';

class ProcurementItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get procurementId => integer().references(Procurements, #id, onDelete: KeyAction.cascade)();

  IntColumn get itemId => integer().references(Items, #id)();

  RealColumn get quantity => real()();

  RealColumn get purchasePrice => real()();
}
