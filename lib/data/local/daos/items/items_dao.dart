import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/category_colors_table.dart';
import 'package:universal_pos_system_v1/data/local/tables/item_categories_table.dart';
import '../../app_database.dart';
import '../../tables/items_table.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [Items, ItemCategories, CategoryColors])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  Future<List<Item>> getAll() => (select(items)..orderBy([(i) => OrderingTerm.desc(i.createdAt)])).get();

  Future<Item> getById(int id) {
    return (select(items)..where((c) => c.id.equals(id))).getSingle();
  }

  Future<List<Item>> getByIds(List<int> ids) {
    return (select(items)..where((c) => c.id.isIn(ids))).get();
  }

  Future<int> insertItem(
    String name,
    String barcode,
    int unitId,
    double salePrice,
    int? categoryId,
  ) {
    return into(items).insert(
      ItemsCompanion.insert(
        name: name,
        barcode: barcode,
        unitId: unitId,
        salePrice: salePrice,
        categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      ),
    );
  }

  Future<int> updateItem(
    int id,
    String name,
    String barcode,
    int unitId,
    double salePrice,
    int? categoryId,
  ) {
    final query = update(items)..where((c) => c.id.equals(id));

    return query.write(
      ItemsCompanion(
        name: Value(name),
        barcode: Value(barcode),
        unitId: Value(unitId),
        salePrice: Value(salePrice),
        categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      ),
    );
  }

  Future deleteItem(int id) {
    return (delete(items)..where((c) => c.id.equals(id))).go();
  }
}
