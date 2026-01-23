import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';

class SalesHistoryProvider extends ChangeNotifier {
  List<SaleHistory> _saleHistories = [];
  List<SaleHistory> get saleHistories => _saleHistories;

  void addToSaleHistory() {}

  void removeFromSaleHistory(SaleHistory saleHistory) {
    int index = saleHistories.indexOf(saleHistory);

    if (index == -1) return;

    _saleHistories = [..._saleHistories.sublist(0, index), ..._saleHistories.sublist(index + 1)];
    notifyListeners();
  }

  void clearSaleHistory() {
    _saleHistories = [];
    notifyListeners();
  }
}
