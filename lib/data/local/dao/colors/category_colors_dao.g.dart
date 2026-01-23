// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_colors_dao.dart';

// ignore_for_file: type=lint
mixin _$CategoryColorsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryColorsTable get categoryColors => attachedDatabase.categoryColors;
  CategoryColorsDaoManager get managers => CategoryColorsDaoManager(this);
}

class CategoryColorsDaoManager {
  final _$CategoryColorsDaoMixin _db;
  CategoryColorsDaoManager(this._db);
  $$CategoryColorsTableTableManager get categoryColors =>
      $$CategoryColorsTableTableManager(
        _db.attachedDatabase,
        _db.categoryColors,
      );
}
