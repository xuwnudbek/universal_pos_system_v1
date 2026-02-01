import 'package:universal_pos_system_v1/data/local/daos/stocks/stocks_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/stock_full.dart';

class StocksRepository {
  final StocksDao stocksDao;

  const StocksRepository(this.stocksDao);

  Future<List<StockFull>> getAll() => stocksDao.getAll();

  Future<StockFull?> getById(int id) => stocksDao.getById(id);

  Future<StockFull?> getByItemAndLocation(int itemId, LocationsEnum location) => stocksDao.getByItemAndLocation(itemId, location);

  Future<List<StockFull>> getByLocation(LocationsEnum location) => stocksDao.getByLocation(location);

  Future<int> create({
    required int itemId,
    required LocationsEnum location,
    required double quantity,
  }) => stocksDao.insertStock(itemId, location, quantity);

  Future<void> update({
    required int id,
    required int itemId,
    required LocationsEnum location,
    required double quantity,
  }) => stocksDao.updateStock(id, itemId, location, quantity);

  Future<void> updateQuantity(
    int itemId,
    LocationsEnum fromLocation,
    LocationsEnum toLocation,
    double quantity,
  ) => stocksDao.updateQuantity(
    itemId,
    fromLocation,
    toLocation,
    quantity,
  );

  Future delete(int id) => stocksDao.deleteStock(id);
}
