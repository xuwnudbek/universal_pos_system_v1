import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables/expense_categories_table.dart';

part 'expense_categories_dao.g.dart';

@DriftAccessor(tables: [ExpenseCategories])
class ExpenseCategoriesDao extends DatabaseAccessor<AppDatabase> with _$ExpenseCategoriesDaoMixin {
  ExpenseCategoriesDao(super.db);

  // Get All Active Categories
  Future<List<ExpenseCategory>> getAllActive() => (select(expenseCategories)..where((c) => c.isActive.equals(true))).get();

  // Get All Categories
  Future<List<ExpenseCategory>> getAll() => select(expenseCategories).get();

  // Get Category By Id
  Future<ExpenseCategory?> getById(int id) => (select(expenseCategories)..where((c) => c.id.equals(id))).getSingleOrNull();

  // Insert Category
  Future<int> insertCategory(String name) {
    return into(expenseCategories).insert(
      ExpenseCategoriesCompanion(
        name: Value(name),
      ),
    );
  }

  // Update Category
  Future<int> updateCategory(int id, String name, bool isActive) {
    final query = update(expenseCategories)..where((c) => c.id.equals(id));

    return query.write(
      ExpenseCategoriesCompanion(
        name: Value(name),
        isActive: Value(isActive),
      ),
    );
  }

  // Delete Category
  Future deleteCategory(int id) {
    return (delete(expenseCategories)..where((c) => c.id.equals(id))).go();
  }
}
