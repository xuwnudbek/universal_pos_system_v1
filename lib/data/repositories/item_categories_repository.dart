import 'package:universal_pos_system_v1/data/local/dao/colors/category_colors_dao.dart';
import 'package:universal_pos_system_v1/data/local/dao/item_categories/item_categories_dao.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';

class ItemCategoriesRepository {
  final ItemCategoriesDao _categoriesDao;
  final CategoryColorsDao _colorsDao;

  ItemCategoriesRepository(this._categoriesDao, this._colorsDao);

  Future<List<ItemCategoryFull>> getAll() async {
    final categories = await _categoriesDao.getAll();
    final colors = await _colorsDao.getAll();

    List<ItemCategoryFull> result = [];

    for (var category in categories) {
      result.add(
        ItemCategoryFull.from(
          category: category,
          color: colors.where((color) => color.id == category.colorId).firstOrNull,
        ),
      );
    }

    return result;
  }

  Future<int> create(String name, int? color) => _categoriesDao.insertItemCategory(name, color);

  Future update(int id, String name, int? color) => _categoriesDao.updateItemCategory(id, name, color);

  Future delete(int id) => _categoriesDao.deleteItemCategory(id);
}
