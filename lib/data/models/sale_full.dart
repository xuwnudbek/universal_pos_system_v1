import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';

class SaleFull {
  final int id;
  User? user;
  final SaleStatusEnum status;
  final List<SalePayment> payments;
  final List<SaleItemFull> items;
  final DateTime createdAt;

  SaleFull({
    required this.id,
    this.user,
    required this.status,
    required this.payments,
    required this.items,
    required this.createdAt,
  });

  factory SaleFull.from({
    required Sale sale,
    User? user,
    required List<SalePayment> payments,
    required List<SaleItemFull> items,
  }) {
    return SaleFull(
      id: sale.id,
      user: user,
      status: sale.status,
      payments: payments,
      items: items,
      createdAt: sale.createdAt,
    );
  }
}
