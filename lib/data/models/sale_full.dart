import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_payment_full.dart';

class SaleFull {
  final int id;
  User? user;
  final SaleStatusEnum status;
  final List<SalePaymentFull> payments;
  final List<SaleItemFull> items;
  final DateTime createdAt;

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.quantity * item.item.salePrice);
  }

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
    required List<SalePaymentFull> payments,
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

  // Add payment method
  SaleFull copyWith({
    int? id,
    User? user,
    SaleStatusEnum? status,
    List<SalePaymentFull>? payments,
    List<SaleItemFull>? items,
    DateTime? createdAt,
  }) {
    return SaleFull(
      id: id ?? this.id,
      user: user ?? this.user,
      status: status ?? this.status,
      payments: payments ?? this.payments,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
