import 'package:universal_pos_system_v1/data/models/cart_item_full.dart';

class CartFull {
  final int id;
  final List<CartItemFull> cartItems;

  CartFull({
    required this.id,
    required this.cartItems,
  });
}
