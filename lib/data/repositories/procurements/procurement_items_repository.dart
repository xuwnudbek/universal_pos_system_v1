import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/models/procurement_item_full.dart';

class ProcurementItemsRepository {
  final ProcurementItemsDao procurementItemsDao;

  const ProcurementItemsRepository(this.procurementItemsDao);

  Future<List<ProcurementItemFull>> getAll() => procurementItemsDao.getAll();

  Future<ProcurementItemFull?> getById(int id) => procurementItemsDao.getById(id);

  Future<List<ProcurementItemFull>> getByProcurementId(int procurementId) => procurementItemsDao.getByProcurementId(procurementId);

  Future<List<ProcurementItemFull>> getByItemId(int itemId) => procurementItemsDao.getByItemId(itemId);

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
