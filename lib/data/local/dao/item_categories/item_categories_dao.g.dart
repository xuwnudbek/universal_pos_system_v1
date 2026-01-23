// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_categories_dao.dart';

// ignore_for_file: type=lint
mixin _$ItemCategoriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryColorsTable get categoryColors => attachedDatabase.categoryColors;
  $ItemCategoriesTable get itemCategories => attachedDatabase.itemCategories;
  $UnitsTable get units => attachedDatabase.units;
  $ItemsTable get items => attachedDatabase.items;
  ItemCategoriesDaoManager get managers => ItemCategoriesDaoManager(this);
}

class ItemCategoriesDaoManager {
  final _$ItemCategoriesDaoMixin _db;
  ItemCategoriesDaoManager(this._db);
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
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
}
