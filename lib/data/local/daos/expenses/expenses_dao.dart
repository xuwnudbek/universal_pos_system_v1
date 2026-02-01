import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables/expenses_table.dart';
import '../../tables/expense_categories_table.dart';

part 'expenses_dao.g.dart';

@DriftAccessor(tables: [Expenses, ExpenseCategories])
class ExpensesDao extends DatabaseAccessor<AppDatabase> with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  // Get All Expenses with Category
  Future<List<ExpenseWithCategory>> getAllWithCategory() async {
    final query = select(expenses).join([
      leftOuterJoin(expenseCategories, expenseCategories.id.equalsExp(expenses.categoryId)),
    ])..orderBy([OrderingTerm.desc(expenses.expenseDate)]);

    final rows = await query.get();

    return rows.map((row) {
      return ExpenseWithCategory(
        expense: row.readTable(expenses),
        category: row.readTable(expenseCategories),
      );
    }).toList();
  }

  // Get All Expenses
  Future<List<Expense>> getAll() => (select(expenses)..orderBy([(e) => OrderingTerm.desc(e.expenseDate)])).get();

  // Get Expense By Id
  Future<Expense?> getById(int id) => (select(expenses)..where((e) => e.id.equals(id))).getSingleOrNull();

  // Get Expenses By Category
  Future<List<Expense>> getByCategory(int categoryId) =>
      (select(expenses)
            ..where((e) => e.categoryId.equals(categoryId))
            ..orderBy([(e) => OrderingTerm.desc(e.expenseDate)]))
          .get();

  // Get Expenses By Date Range
  Future<List<ExpenseWithCategory>> getByDateRange(DateTime start, DateTime end) async {
    final query =
        select(expenses).join([
            leftOuterJoin(expenseCategories, expenseCategories.id.equalsExp(expenses.categoryId)),
          ])
          ..where(expenses.expenseDate.isBiggerOrEqualValue(start) & expenses.expenseDate.isSmallerOrEqualValue(end))
          ..orderBy([OrderingTerm.desc(expenses.expenseDate)]);

    final rows = await query.get();

    return rows.map((row) {
      return ExpenseWithCategory(
        expense: row.readTable(expenses),
        category: row.readTable(expenseCategories),
      );
    }).toList();
  }

  // Insert Expense
  Future<int> insertExpense({
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) {
    return into(expenses).insert(
      ExpensesCompanion(
        categoryId: Value(categoryId),
        amount: Value(amount),
        expenseDate: Value(expenseDate),
        note: Value(note),
      ),
    );
  }

  // Update Expense
  Future<int> updateExpense({
    required int id,
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) {
    final query = update(expenses)..where((e) => e.id.equals(id));

    return query.write(
      ExpensesCompanion(
        categoryId: Value(categoryId),
        amount: Value(amount),
        expenseDate: Value(expenseDate),
        note: Value(note),
      ),
    );
  }

  // Delete Expense
  Future deleteExpense(int id) {
    return (delete(expenses)..where((e) => e.id.equals(id))).go();
  }
}

class ExpenseWithCategory {
  final Expense expense;
  final ExpenseCategory category;

  ExpenseWithCategory({
    required this.expense,
    required this.category,
  });
}
