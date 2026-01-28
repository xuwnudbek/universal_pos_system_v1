import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/models/procurement_item_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';

class ProcurementItemsRepository {
  final ProcurementItemsDao procurementItemsDao;
  final ItemsRepository itemsRepository;

  const ProcurementItemsRepository(
    this.procurementItemsDao,
    this.itemsRepository,
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
  }) => procurementItemsDao.insertProcurementItem(procurementId, itemId, quantity, purchasePrice);

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
