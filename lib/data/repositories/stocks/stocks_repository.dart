import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/stocks/stocks_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class StocksRepository {
  final StocksDao stocksDao;

  const StocksRepository(this.stocksDao);

  Future<List<Stock>> getAll() => stocksDao.getAll();

  Future<Stock?> getById(int id) => stocksDao.getById(id);

  Future<Stock?> getByItemAndLocation(int itemId, LocationsEnum location) => stocksDao.getByItemAndLocation(itemId, location);

  Future<List<Stock>> getByItem(int itemId) => stocksDao.getByItem(itemId);

  Future<List<Stock>> getByLocation(LocationsEnum location) => stocksDao.getByLocation(location);

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

  Future<void> updateQuantity(int id, double quantity) => stocksDao.updateQuantity(id, quantity);

  Future<void> incrementQuantity(int id, double amount) => stocksDao.incrementQuantity(id, amount);

  Future<void> decrementQuantity(int id, double amount) => stocksDao.decrementQuantity(id, amount);

  Future delete(int id) => stocksDao.deleteStock(id);
}
