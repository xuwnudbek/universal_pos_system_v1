// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_dao.dart';

// ignore_for_file: type=lint
mixin _$ItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  $CategoryColorsTable get categoryColors => attachedDatabase.categoryColors;
  $ItemCategoriesTable get itemCategories => attachedDatabase.itemCategories;
  ItemsDaoManager get managers => ItemsDaoManager(this);
}

class ItemsDaoManager {
  final _$ItemsDaoMixin _db;
  ItemsDaoManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$CategoryColorsTableTableManager get categoryColors =>
      $$CategoryColorsTableTableManager(
        _db.attachedDatabase,
        _db.categoryColors,
      );
  $$ItemCategoriesTableTableManager get itemCategories =>
      $$ItemCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.itemCategories,
      );
}
