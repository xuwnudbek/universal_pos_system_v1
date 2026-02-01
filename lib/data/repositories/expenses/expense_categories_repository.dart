import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expense_categories_dao.dart';

class ExpenseCategoriesRepository {
  final ExpenseCategoriesDao expenseCategoriesDao;

  const ExpenseCategoriesRepository(this.expenseCategoriesDao);

  Future<List<ExpenseCategory>> getAllActive() => expenseCategoriesDao.getAllActive();

  Future<List<ExpenseCategory>> getAll() => expenseCategoriesDao.getAll();

  Future<ExpenseCategory?> getById(int id) => expenseCategoriesDao.getById(id);

  Future<int> create(String name) => expenseCategoriesDao.insertCategory(name);

  Future<void> update({
    required int id,
    required String name,
    required bool isActive,
  }) => expenseCategoriesDao.updateCategory(id, name, isActive);

  Future delete(int id) => expenseCategoriesDao.deleteCategory(id);
}
