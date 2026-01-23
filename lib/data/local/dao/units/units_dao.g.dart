// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'units_dao.dart';

// ignore_for_file: type=lint
mixin _$UnitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnitsTable get units => attachedDatabase.units;
  UnitsDaoManager get managers => UnitsDaoManager(this);
}

class UnitsDaoManager {
  final _$UnitsDaoMixin _db;
  UnitsDaoManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
}
