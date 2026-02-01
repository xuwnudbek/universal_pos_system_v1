import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expenses_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expense_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expenses_repository.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';

enum ExpenseFilter { yesterday, today, week, month, custom }

class ExpensesProvider extends ChangeNotifier {
  final ExpensesRepository expensesRepository;
  final ExpenseCategoriesRepository categoriesRepository;

  ExpensesProvider(
    this.expensesRepository,
    this.categoriesRepository,
  ) {
    _initialize();
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<ExpenseWithCategory> _allExpenses = [];
  List<ExpenseWithCategory> _filteredExpenses = [];
  List<ExpenseCategory> _categories = [];

  List<ExpenseWithCategory> get expenses => _filteredExpenses;
  List<ExpenseCategory> get categories => _categories;

  ExpenseFilter _selectedFilter = ExpenseFilter.today;
  ExpenseFilter get selectedFilter => _selectedFilter;

  DateTimeRange? _customDateRange;
  DateTimeRange? get customDateRange => _customDateRange;

  double get totalAmount {
    return _filteredExpenses.fold(0.0, (sum, item) => sum + item.expense.amount);
  }

  Future<void> _initialize() async {
    try {
      _categories = await categoriesRepository.getAll();
      _allExpenses = await expensesRepository.getAllWithCategory();
      _applyFilter();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing expenses: $e');
    }
  }

  void setFilter(ExpenseFilter filter) {
    _selectedFilter = filter;
    _customDateRange = null;
    _applyFilter();
    notifyListeners();
  }

  void setCustomDateRange(DateTimeRange? range) {
    _customDateRange = range;
    if (range != null) {
      _selectedFilter = ExpenseFilter.custom;
    }
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (_selectedFilter) {
      case ExpenseFilter.yesterday:
        startDate = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case ExpenseFilter.today:
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        break;
      case ExpenseFilter.week:
        startDate = DateTime(now.year, now.month, now.day - 7, 0, 0, 0);
        break;
      case ExpenseFilter.month:
        startDate = DateTime(now.year, now.month - 1, now.day, 0, 0, 0);
        break;
      case ExpenseFilter.custom:
        if (_customDateRange != null) {
          startDate = DateTime(
            _customDateRange!.start.year,
            _customDateRange!.start.month,
            _customDateRange!.start.day,
            0,
            0,
            0,
          );
          endDate = DateTime(
            _customDateRange!.end.year,
            _customDateRange!.end.month,
            _customDateRange!.end.day,
            23,
            59,
            59,
          );
        } else {
          _filteredExpenses = _allExpenses;
          return;
        }
        break;
    }

    _filteredExpenses = _allExpenses.where((expenseWithCategory) {
      final expenseDate = expenseWithCategory.expense.expenseDate;
      return expenseDate.isAfter(startDate.subtract(Duration(seconds: 1))) && expenseDate.isBefore(endDate.add(Duration(seconds: 1)));
    }).toList();
  }

  Future<void> addExpense({
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) async {
    await expensesRepository.create(
      categoryId: categoryId,
      amount: amount,
      expenseDate: expenseDate,
      note: note,
    );
    await refresh();
  }

  Future<void> updateExpense({
    required int id,
    required int categoryId,
    required double amount,
    required DateTime expenseDate,
    String? note,
  }) async {
    await expensesRepository.update(
      id: id,
      categoryId: categoryId,
      amount: amount,
      expenseDate: expenseDate,
      note: note,
    );
    await refresh();
  }

  Future<void> deleteExpense(int id) async {
    await expensesRepository.delete(id);
    await refresh();
  }

  Future<void> refresh() async {
    try {
      _allExpenses = await expensesRepository.getAllWithCategory();
      _categories = await categoriesRepository.getAll();
      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing expenses: $e');
    }
  }
}
