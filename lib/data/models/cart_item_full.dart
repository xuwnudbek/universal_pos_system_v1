import 'package:universal_pos_system_v1/data/models/items_full.dart';

class CartItemFull {
  final int id;
  final ItemFull item;
  int quantity;

  CartItemFull({
    required this.id,
    required this.item,
    required this.quantity,
  });
}
