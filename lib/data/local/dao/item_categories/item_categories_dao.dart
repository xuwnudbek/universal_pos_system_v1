import 'package:drift/drift.dart';

import '../../tables/item_categories_table.dart';
import '../../tables/items_table.dart';
import '../../app_database.dart';
import '../../tables/category_colors_table.dart';

part 'item_categories_dao.g.dart';

@DriftAccessor(tables: [ItemCategories, CategoryColors, Items])
class ItemCategoriesDao extends DatabaseAccessor<AppDatabase> with _$ItemCategoriesDaoMixin {
  ItemCategoriesDao(super.db);

  Future<List<ItemCategory>> getAll() => select(itemCategories).get();
  Stream<List<ItemCategory>> streamAll() => select(itemCategories).watch();

  Future<int> insertItemCategory(String name, int? colorId) {
    return into(itemCategories).insert(
      ItemCategoriesCompanion.insert(
        name: name,
        colorId: colorId != null ? Value(colorId) : const Value.absent(),
      ),
    );
  }

  Future<int> updateItemCategory(int id, String name, int? colorId) {
    final query = update(itemCategories)..where((c) => c.id.equals(id));

    return query.write(
      ItemCategoriesCompanion(
        name: Value(name),
        colorId: colorId != null ? Value(colorId) : const Value.absent(),
      ),
    );
  }

  // write referance method that can take itemCategory's color

  Future deleteItemCategory(int id) {
    return (delete(itemCategories)..where((c) => c.id.equals(id))).go();
  }
}
