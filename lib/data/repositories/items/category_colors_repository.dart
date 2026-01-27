import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/colors/category_colors_dao.dart';

class CategoryColorsRepository {
  final CategoryColorsDao dao;

  CategoryColorsRepository(this.dao);

  Future<List<CategoryColor>> getAll() => dao.getAll();

  Future<int> create(String hex) => dao.insertColor(hex);

  Future update(int id, String hex) => dao.updateColor(id, hex);

  Future delete(int id) => dao.deleteColor(id);
}
