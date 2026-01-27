import 'package:drift/drift.dart';

import '../../tables/category_colors_table.dart';
import '../../app_database.dart';

part 'category_colors_dao.g.dart';

@DriftAccessor(tables: [CategoryColors])
class CategoryColorsDao extends DatabaseAccessor<AppDatabase> with _$CategoryColorsDaoMixin {
  CategoryColorsDao(super.db);

  Future<List<CategoryColor>> getAll() => select(categoryColors).get();

  Future<int> insertColor(String hex) {
    return into(categoryColors).insert(
      CategoryColorsCompanion.insert(hex: hex),
    );
  }

  Future<int> updateColor(int id, String hex) {
    final query = update(categoryColors)..where((c) => c.id.equals(id));

    return query.write(
      CategoryColorsCompanion(
        hex: Value(hex),
      ),
    );
  }

  Future deleteColor(int id) {
    return (delete(categoryColors)..where((c) => c.id.equals(id))).go();
  }
}
