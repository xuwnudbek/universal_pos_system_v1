// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurements_dao.dart';

// ignore_for_file: type=lint
mixin _$ProcurementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProcurementsTable get procurements => attachedDatabase.procurements;
  ProcurementsDaoManager get managers => ProcurementsDaoManager(this);
}

class ProcurementsDaoManager {
  final _$ProcurementsDaoMixin _db;
  ProcurementsDaoManager(this._db);
  $$ProcurementsTableTableManager get procurements =>
      $$ProcurementsTableTableManager(_db.attachedDatabase, _db.procurements);
}
