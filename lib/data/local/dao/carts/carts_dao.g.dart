// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carts_dao.dart';

// ignore_for_file: type=lint
mixin _$CartsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CartsTable get carts => attachedDatabase.carts;
  CartsDaoManager get managers => CartsDaoManager(this);
}

class CartsDaoManager {
  final _$CartsDaoMixin _db;
  CartsDaoManager(this._db);
  $$CartsTableTableManager get carts =>
      $$CartsTableTableManager(_db.attachedDatabase, _db.carts);
}
