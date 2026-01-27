import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';

class ProcurementItemFull {
  final int id;
  final int procurementId;
  final double quantity;
  final double purchasePrice;
  final ItemFull? item;

  ProcurementItemFull({
    required this.id,
    required this.procurementId,
    required this.quantity,
    required this.purchasePrice,
    required this.item,
  });

  factory ProcurementItemFull.from({
    required ProcurementItem procurementItem,
    required ItemFull? item,
  }) {
    return ProcurementItemFull(
      id: procurementItem.id,
      procurementId: procurementItem.procurementId,
      quantity: procurementItem.quantity,
      purchasePrice: procurementItem.purchasePrice,
      item: item,
    );
  }
}
