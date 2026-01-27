import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

import '../../app_database.dart';
import '../../tables/stocks_table.dart';
import '../../tables/items_table.dart';

part 'stocks_dao.g.dart';

@DriftAccessor(tables: [Stocks, Items])
class StocksDao extends DatabaseAccessor<AppDatabase> with _$StocksDaoMixin {
  StocksDao(super.db);

  // Get All Stocks
  Future<List<Stock>> getAll() => select(stocks).get();

  // Get Stock By Id
  Future<Stock?> getById(int id) => (select(stocks)..where((s) => s.id.equals(id))).getSingleOrNull();

  // Get Stock By Item and Location
  Future<Stock?> getByItemAndLocation(int itemId, LocationsEnum location) => (select(stocks)..where((s) => s.itemId.equals(itemId) & s.location.equalsValue(location))).getSingleOrNull();

  // Get Stocks By Item
  Future<List<Stock>> getByItem(int itemId) => (select(stocks)..where((s) => s.itemId.equals(itemId))).get();

  // Get Stocks By Location
  Future<List<Stock>> getByLocation(LocationsEnum location) => (select(stocks)..where((s) => s.location.equalsValue(location))).get();

  // Insert Stock
  Future<int> insertStock(
    int itemId,
    LocationsEnum location,
    double quantity,
  ) {
    return into(stocks).insert(
      StocksCompanion(
        itemId: Value(itemId),
        location: Value(location),
        quantity: Value(quantity),
      ),
    );
  }

  // Update Stock
  Future<int> updateStock(
    int id,
    int itemId,
    LocationsEnum location,
    double quantity,
  ) {
    final query = update(stocks)..where((s) => s.id.equals(id));

    return query.write(
      StocksCompanion(
        itemId: Value(itemId),
        location: Value(location),
        quantity: Value(quantity),
      ),
    );
  }

  // Update Stock Quantity
  Future<int> updateQuantity(int id, double quantity) {
    final query = update(stocks)..where((s) => s.id.equals(id));
    return query.write(StocksCompanion(quantity: Value(quantity)));
  }

  // Increment Stock Quantity
  Future<void> incrementQuantity(int id, double amount) async {
    final stock = await getById(id);
    if (stock != null) {
      await updateQuantity(id, stock.quantity + amount);
    }
  }

  // Decrement Stock Quantity
  Future<void> decrementQuantity(int id, double amount) async {
    final stock = await getById(id);
    if (stock != null) {
      await updateQuantity(id, stock.quantity - amount);
    }
  }

  // Delete Stock
  Future deleteStock(int id) {
    return (delete(stocks)..where((s) => s.id.equals(id))).go();
  }
}
