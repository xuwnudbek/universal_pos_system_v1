import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/category_colors_table.dart';

class ItemCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get colorId => integer().nullable().references(CategoryColors, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
