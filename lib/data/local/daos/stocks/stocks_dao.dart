import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/stock_full.dart';

import '../../app_database.dart';
import '../../tables/stocks_table.dart';
import '../../tables/items_table.dart';

part 'stocks_dao.g.dart';

@DriftAccessor(tables: [Stocks, Items])
class StocksDao extends DatabaseAccessor<AppDatabase> with _$StocksDaoMixin {
  StocksDao(super.db);

  // Get All Stocks
  Future<List<StockFull>> getAll() {
    final query = select(stocks).join([
      leftOuterJoin(items, items.id.equalsExp(stocks.itemId)),
    ]);

    return query.map((row) {
      final stock = row.readTable(stocks);
      final item = row.readTable(items);

      return StockFull.from(
        stock: stock,
        item: item,
      );
    }).get();
  }

  // Get Stock By Id
  Future<StockFull?> getById(int id) async {
    final query = select(stocks).join([
      leftOuterJoin(items, items.id.equalsExp(stocks.itemId)),
    ])..where(stocks.id.equals(id));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    final stock = result.readTable(stocks);
    final item = result.readTable(items);

    return StockFull.from(
      stock: stock,
      item: item,
    );
  }

  // Get Stock By Item and Location
  Future<StockFull?> getByItemAndLocation(int itemId, LocationsEnum location) async {
    final query = select(stocks).join([
      leftOuterJoin(items, items.id.equalsExp(stocks.itemId)),
    ])..where(stocks.itemId.equals(itemId) & stocks.location.equalsValue(location));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    final stock = result.readTable(stocks);
    final item = result.readTable(items);

    return StockFull.from(
      stock: stock,
      item: item,
    );
  }

  // Get Stocks By Item
  Future<StockFull?> getByItem(int itemId) async {
    final query =
        select(stocks).join([
            leftOuterJoin(items, items.id.equalsExp(stocks.itemId)),
          ])
          ..where(stocks.itemId.equals(itemId))
          ..limit(1);

    final row = await query.getSingleOrNull();

    return row == null
        ? null
        : StockFull.from(
            stock: row.readTable(stocks),
            item: row.readTable(items),
          );
  }

  // Get Stocks By Location
  Future<List<StockFull>> getByLocation(LocationsEnum location) {
    final query = select(stocks).join([
      leftOuterJoin(items, items.id.equalsExp(stocks.itemId)),
    ])..where(stocks.location.equalsValue(location));

    return query.map((row) {
      final stock = row.readTable(stocks);
      final item = row.readTable(items);

      return StockFull.from(
        stock: stock,
        item: item,
      );
    }).get();
  }

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
  Future<int> updateQuantity(
    int itemId,
    LocationsEnum fromLocation,
    LocationsEnum toLocation,
    double quantity,
  ) {
    return transaction(() async {
      final fromStock = await getByItemAndLocation(itemId, fromLocation);
      final toStock = await getByItemAndLocation(itemId, toLocation);

      if (fromStock != null) {
        // Decrease quantity from the source location
        await updateStock(fromStock.id, itemId, fromLocation, fromStock.quantity - quantity);
      }

      if (toStock != null) {
        // Increase quantity at the destination location
        await updateStock(toStock.id, itemId, toLocation, toStock.quantity + quantity);
      } else {
        await insertStock(itemId, toLocation, quantity);
      }

      return Future.value(0);
    });
  }

  // Delete Stock
  Future deleteStock(int id) {
    return (delete(stocks)..where((s) => s.id.equals(id))).go();
  }
}
