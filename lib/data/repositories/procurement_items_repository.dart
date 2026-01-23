import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/dao/procurements/procurement_items_dao.dart';

class ProcurementItemsRepository {
  final ProcurementItemsDao procurementItemsDao;

  const ProcurementItemsRepository(this.procurementItemsDao);

  Future<List<ProcurementItem>> getAll() => procurementItemsDao.getAll();

  Future<ProcurementItem?> getById(int id) => procurementItemsDao.getById(id);

  Future<List<ProcurementItem>> getByProcurementId(int procurementId) => procurementItemsDao.getByProcurementId(procurementId);

  Future<List<ProcurementItem>> getByItemId(int itemId) => procurementItemsDao.getByItemId(itemId);

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
