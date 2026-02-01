// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_items_dao.dart';

// ignore_for_file: type=lint
mixin _$SaleItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SalesTable get sales => attachedDatabase.sales;
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $SaleItemsTable get saleItems => attachedDatabase.saleItems;
  SaleItemsDaoManager get managers => SaleItemsDaoManager(this);
}

class SaleItemsDaoManager {
  final _$SaleItemsDaoMixin _db;
  SaleItemsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db.attachedDatabase, _db.sales);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db.attachedDatabase, _db.saleItems);
}
