// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_items_dao.dart';

// ignore_for_file: type=lint
mixin _$ProcurementItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProcurementsTable get procurements => attachedDatabase.procurements;
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $ProcurementItemsTable get procurementItems =>
      attachedDatabase.procurementItems;
  ProcurementItemsDaoManager get managers => ProcurementItemsDaoManager(this);
}

class ProcurementItemsDaoManager {
  final _$ProcurementItemsDaoMixin _db;
  ProcurementItemsDaoManager(this._db);
  $$ProcurementsTableTableManager get procurements =>
      $$ProcurementsTableTableManager(_db.attachedDatabase, _db.procurements);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$ProcurementItemsTableTableManager get procurementItems =>
      $$ProcurementItemsTableTableManager(
        _db.attachedDatabase,
        _db.procurementItems,
      );
}
