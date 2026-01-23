import 'package:universal_pos_system_v1/data/local/dao/carts/carts_dao.dart';
import 'package:universal_pos_system_v1/data/local/dao/cart_items/cart_items_dao.dart';
// import 'package:universal_pos_system_v1/data/models/cart_full.dart';

class CartsRepository {
  final CartsDao cartsDao;
  final CartItemsDao cartItemsDao;

  CartsRepository({
    required this.cartsDao,
    required this.cartItemsDao,
  });

  // Future<CartWithItems?> getCartWithItemsById(int cartId) async {
  //   final cart = await cartsDao.getById(cartId);

  //   if (cart == null) return null;

  //   final cartItems = await cartItemsDao.getAllByCartId(cartId);

  //   return CartWithItems(
  //     cart: cart,
  //     cartItems: cartItems,
  //   );
  // }
}
