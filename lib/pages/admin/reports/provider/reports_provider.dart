import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sale_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';

enum ReportFilter { yesterday, today, week, month, custom }

class ReportsProvider extends ChangeNotifier {
  final SaleItemsRepository saleItemsRepository;
  final SalePaymentsRepository salePaymentsRepository;

  ReportsProvider(
    this.saleItemsRepository,
    this.salePaymentsRepository,
  ) {
    // Initialize with today's data
    _updateDateFilter();
  }

  List<Map<String, dynamic>> _topSellingProducts = [];
  List<Map<String, dynamic>> _paymentStatistics = [];
  ReportFilter _selectedFilter = ReportFilter.today;
  DateTimeRange? _customDateRange;
  bool _isLoading = false;

  List<Map<String, dynamic>> get topSellingProducts => _topSellingProducts;
  List<Map<String, dynamic>> get paymentStatistics => _paymentStatistics;

  // Get only debt statistics
  double get debtAmount {
    final debtPayment = _paymentStatistics.firstWhere(
      (payment) {
        final paymentType = payment['paymentType'];
        return paymentType.name == PaymentTypesEnum.debt;
      },
      orElse: () => {'totalAmount': 0.0},
    );
    return debtPayment['totalAmount'] as double;
  }

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
}
