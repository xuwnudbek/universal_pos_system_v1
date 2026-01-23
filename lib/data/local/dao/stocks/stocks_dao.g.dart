// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stocks_dao.dart';

// ignore_for_file: type=lint
mixin _$StocksDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $StocksTable get stocks => attachedDatabase.stocks;
  StocksDaoManager get managers => StocksDaoManager(this);
}

class StocksDaoManager {
  final _$StocksDaoMixin _db;
  StocksDaoManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$StocksTableTableManager get stocks =>
      $$StocksTableTableManager(_db.attachedDatabase, _db.stocks);
}
