import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/stocks/stocks_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/procurement_item_full.dart';

class ProcurementItemsRepository {
  final ProcurementItemsDao procurementItemsDao;
  final StocksDao stocksDao;

  const ProcurementItemsRepository(
    this.procurementItemsDao,
    this.stocksDao,
  );

  Future<List<ProcurementItemFull>> getByProcurementId(int procurementId) async {
    final items = await procurementItemsDao.getByProcurementId(procurementId);
    return items;
  }

  Future<int> create({
    required int procurementId,
    required int itemId,
    required double quantity,
    required double purchasePrice,
  }) async {
    var res = await procurementItemsDao.insertProcurementItem(procurementId, itemId, quantity, purchasePrice);
    var maybeStock = await stocksDao.getByItem(itemId);

    if (maybeStock != null) {
      // Update existing stock
      await stocksDao.updateStock(
        maybeStock.id,
        itemId,
        maybeStock.location,
        maybeStock.quantity + quantity,
      );
    } else {
      // Create new stock entry
      await stocksDao.insertStock(
        itemId,
        LocationsEnum.warehouse,
        quantity,
      );
    }

    return res;
  }

  Future<void> update({
    required int id,
    required int procurementId,
    required int itemId,
    required double quantity,
    required double purchasePrice,
  }) => procurementItemsDao.updateProcurementItem(id, procurementId, itemId, quantity, purchasePrice);

  Future delete(int id) => procurementItemsDao.deleteProcurementItem(id);

  Future deleteByProcurementId(int procurementId) => procurementItemsDao.deleteByProcurementId(procurementId);
}
