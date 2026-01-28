import 'package:universal_pos_system_v1/data/models/items_full.dart';

class WarehouseItem {
  final ItemFull item;
  final double warehouseQuantity;
  final double shopQuantity;
  final double totalQuantity;

  WarehouseItem({
    required this.item,
    required this.warehouseQuantity,
    required this.shopQuantity,
    required this.totalQuantity,
  });
}
