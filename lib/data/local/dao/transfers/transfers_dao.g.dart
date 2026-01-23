// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers_dao.dart';

// ignore_for_file: type=lint
mixin _$TransfersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $TransfersTable get transfers => attachedDatabase.transfers;
  TransfersDaoManager get managers => TransfersDaoManager(this);
}

class TransfersDaoManager {
  final _$TransfersDaoMixin _db;
  TransfersDaoManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db.attachedDatabase, _db.transfers);
}
