import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables/cart_items_table.dart';

part 'cart_items_dao.g.dart';

@DriftAccessor(tables: [CartItems])
class CartItemsDao extends DatabaseAccessor<AppDatabase> with _$CartItemsDaoMixin {
  CartItemsDao(super.db);

  Future<List<CartItem>> getAllByCartId(int cartId) =>
      (select(cartItems)..where(
            (ci) => ci.cartId.equals(cartId),
          ))
          .get();

  Future<int> insertCartItem(CartItemsCompanion data) {
    return into(cartItems).insert(data);
  }

  Future<int> updateCartItem(
    int id,
    int? cartId,
    int? itemId,
    int? quantity,
  ) {
    final query = update(cartItems)..where((c) => c.id.equals(id));

    return query.write(
      CartItemsCompanion(
        cartId: cartId != null ? Value(cartId) : Value.absent(),
        itemId: itemId != null ? Value(itemId) : Value.absent(),
        quantity: quantity != null ? Value(quantity) : Value.absent(),
      ),
    );
  }

  Future deleteCartItem(int id) {
    return (delete(cartItems)..where((c) => c.id.equals(id))).go();
  }
}
