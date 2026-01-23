// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_items_dao.dart';

// ignore_for_file: type=lint
mixin _$CartItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CartsTable get carts => attachedDatabase.carts;
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $CartItemsTable get cartItems => attachedDatabase.cartItems;
  CartItemsDaoManager get managers => CartItemsDaoManager(this);
}

class CartItemsDaoManager {
  final _$CartItemsDaoMixin _db;
  CartItemsDaoManager(this._db);
  $$CartsTableTableManager get carts =>
      $$CartsTableTableManager(_db.attachedDatabase, _db.carts);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db.attachedDatabase, _db.cartItems);
}
