import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expenses_dao.dart';

class ExpensesRepository {
  final ExpensesDao expensesDao;

  const ExpensesRepository(this.expensesDao);

  Future<List<ExpenseWithCategory>> getAllWithCategory() => expensesDao.getAllWithCategory();

  Future<List<Expense>> getAll() => expensesDao.getAll();

  Future<Expense?> getById(int id) => expensesDao.getById(id);

  Future<List<Expense>> getByCategory(int categoryId) => expensesDao.getByCategory(categoryId);

  Future<List<ExpenseWithCategory>> getByDateRange(DateTime start, DateTime end) => expensesDao.getByDateRange(start, end);

  Future<int> create({
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) => expensesDao.insertExpense(
    categoryId: categoryId,
    amount: amount,
    expenseDate: expenseDate,
    note: note,
  );

  Future<void> update({
    required int id,
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) => expensesDao.updateExpense(
    id: id,
    categoryId: categoryId,
    amount: amount,
    expenseDate: expenseDate,
    note: note,
  );

  Future delete(int id) => expensesDao.deleteExpense(id);
}
