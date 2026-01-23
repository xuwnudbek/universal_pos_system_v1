import '../../local/dao/colors/category_colors_dao.dart';
import '../../local/dao/item_categories/item_categories_dao.dart';
import '../../local/dao/items/items_dao.dart';
import '../../local/dao/units/units_dao.dart';
import '../../models/item_category_full.dart';
import '../../models/items_full.dart';

class ItemsRepository {
  final ItemsDao itemsDao;
  final ItemCategoriesDao categoriesDao;
  final CategoryColorsDao colorsDao;
  final UnitsDao unitsDao;

  const ItemsRepository(
    this.itemsDao,
    this.categoriesDao,
    this.colorsDao,
    this.unitsDao,
  );

  Future<List<ItemFull>> getAll() async {
    final items = await itemsDao.getAll();
    final categories = await categoriesDao.getAll();
    final colors = await colorsDao.getAll();
    final units = await unitsDao.getAll();

    List<ItemFull> itemsFull = [];

    for (var item in items) {
      final itemCategory = categories.where((c) => c.id == item.categoryId).firstOrNull;
      final categoryColor = colors.where((c) => c.id == itemCategory?.colorId).firstOrNull;
      final unit = units.where((u) => u.id == item.unitId).firstOrNull;

      var itemFull = ItemFull.from(
        item: item,
        unit: unit!,
        category: itemCategory != null
            ? ItemCategoryFull.from(
                category: itemCategory,
                color: categoryColor,
              )
            : null,
      );

      itemsFull.add(itemFull);
    }

    return itemsFull;
  }

  Future<int> create({
    required String name,
    required double price,
    required String barcode,
    required int unitId,
    required double stock,
    required int categoryId,
  }) => itemsDao.insertItem(name, price, barcode, unitId, stock, categoryId);

  Future<void> update({
    required int id,
    required String name,
    required double price,
    required String barcode,
    required int unitId,
    required double stock,
    required int categoryId,
  }) => itemsDao.updateItem(id, name, price, barcode, unitId, stock, categoryId);

  Future delete(int id) => itemsDao.deleteItem(id);
}
