import 'package:universal_pos_system_v1/data/local/app_database.dart';

class SaleItemFull {
  final int id;
  final int quantity;
  final Item item;

  SaleItemFull({
    required this.id,
    required this.quantity,
    required this.item,
  });

  factory SaleItemFull.from({
    required SaleItem saleItem,
    required Item item,
  }) {
    return SaleItemFull(
      id: saleItem.id,
      quantity: saleItem.quantity,
      item: item,
    );
  }
}
