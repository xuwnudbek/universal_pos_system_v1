import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';
import 'package:universal_pos_system_v1/data/repositories/debts/debts_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expenses_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sale_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';

enum ReportFilter { yesterday, today, week, month, custom }

class ReportsProvider extends ChangeNotifier {
  final SaleItemsRepository saleItemsRepository;
  final SalePaymentsRepository salePaymentsRepository;
  final ExpensesRepository expensesRepository;
  final DebtsRepository debtsRepository;

  ReportsProvider(
    this.saleItemsRepository,
    this.salePaymentsRepository,
    this.expensesRepository,
    this.debtsRepository,
  ) {
    // Initialize with today's data
    _updateDateFilter();
  }

  List<Map<String, dynamic>> _topSellingProducts = [];
  List<Map<String, dynamic>> _paymentStatistics = [];
  List<Map<String, dynamic>> _debtsList = [];
  double _totalExpenses = 0.0;
  ReportFilter _selectedFilter = ReportFilter.today;
  DateTimeRange? _customDateRange;
  bool _isLoading = false;

  List<Map<String, dynamic>> get topSellingProducts => _topSellingProducts;
  List<Map<String, dynamic>> get paymentStatistics => _paymentStatistics;
  List<Map<String, dynamic>> get debtsList => _debtsList;

  // Total sales amount (sum of all payments)
  double get totalSalesAmount {
    double total = 0.0;
    for (final payment in _paymentStatistics) {
      total += payment['totalAmount'] as double;
    }
    return total;
  }

  // Get only debt statistics
  double get debtAmount {
    final debtPayment = _paymentStatistics.where(
      (payment) {
        final paymentType = payment['paymentType'] as PaymentType;
        return paymentType.name == PaymentTypesEnum.debt;
      },
    ).firstOrNull;

    if (debtPayment == null) {
      return 0.0;
    }

    return debtPayment['totalAmount'] as double;
  }

  // Total expenses
  double get totalExpenses => _totalExpenses;

  bool get isLoading => _isLoading;
  ReportFilter get selectedFilter => _selectedFilter;
  DateTimeRange? get customDateRange => _customDateRange;

  DateTimeRange _getDateRangeForFilter(ReportFilter filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case ReportFilter.yesterday:
        final yesterday = today.subtract(Duration(days: 1));
        return DateTimeRange(
          start: yesterday,
          end: yesterday.add(Duration(days: 1)),
        );
      case ReportFilter.today:
        return DateTimeRange(
          start: today,
          end: today.add(Duration(days: 1)),
        );
      case ReportFilter.week:
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(
          start: weekStart,
          end: today.add(Duration(days: 1)),
        );
      case ReportFilter.month:
        final monthStart = DateTime(today.year, today.month, 1);
        return DateTimeRange(
          start: monthStart,
          end: today.add(Duration(days: 1)),
        );
      case ReportFilter.custom:
        return _customDateRange ?? DateTimeRange(start: today, end: today.add(Duration(days: 1)));
    }
  }

  void _updateDateFilter() {
    final dateRange = _getDateRangeForFilter(_selectedFilter);
    _fetchTopSellingProducts(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
    _fetchPaymentStatistics(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
    _fetchExpensesTotal(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
    _fetchDebtsList(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
  }

  Future<void> _fetchTopSellingProducts({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _topSellingProducts = await saleItemsRepository.getTopSellingProducts(
        startDate: startDate,
        endDate: endDate,
        limit: 10,
      );
    } catch (e) {
      debugPrint('Error fetching top selling products: $e');
      _topSellingProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPaymentStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _paymentStatistics = await salePaymentsRepository.getPaymentStatistics(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      debugPrint('Error fetching payment statistics: $e');
      _paymentStatistics = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetchExpensesTotal({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (startDate != null && endDate != null) {
        final expenses = await expensesRepository.getByDateRange(startDate, endDate);
        _totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.expense.amount);
      } else {
        final expenses = await expensesRepository.getAll();
        _totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
      }
    } catch (e) {
      debugPrint('Error fetching expenses total: $e');
      _totalExpenses = 0.0;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetchDebtsList({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final debts = (startDate != null && endDate != null) ? await debtsRepository.getByDateRange(startDate, endDate) : await debtsRepository.getAll();
      final List<Map<String, dynamic>> debtsWithAmount = [];

      for (final debt in debts) {
        double amount = 0.0;
        if (debt.salePaymentId != null) {
          final payment = await salePaymentsRepository.getById(debt.salePaymentId!);
          if (payment != null) {
            amount = payment.amount;
          }
        }
        debtsWithAmount.add({
          'debt': debt,
          'amount': amount,
        });
      }

      _debtsList = debtsWithAmount;
    } catch (e) {
      debugPrint('Error fetching debts list: $e');
      _debtsList = [];
    } finally {
      notifyListeners();
    }
  }

  void setFilter(ReportFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
    _updateDateFilter();
  }

  void setCustomDateRange(DateTimeRange dateRange) {
    _customDateRange = dateRange;
    _selectedFilter = ReportFilter.custom;
    notifyListeners();
    _updateDateFilter();
  }

  Future<void> markDebtAsPaid(int debtId) async {
    try {
      await debtsRepository.markAsPaid(debtId);
      // Refresh the debts list
      _updateDateFilter();
    } catch (e) {
      debugPrint('Error marking debt as paid: $e');
      rethrow;
    }
  }
}
