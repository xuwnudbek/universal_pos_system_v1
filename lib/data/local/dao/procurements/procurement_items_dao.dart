import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../tables/procurement_items_table.dart';
import '../../tables/procurements_table.dart';
import '../../tables/items_table.dart';

part 'procurement_items_dao.g.dart';

@DriftAccessor(tables: [ProcurementItems, Procurements, Items])
class ProcurementItemsDao extends DatabaseAccessor<AppDatabase> with _$ProcurementItemsDaoMixin {
  ProcurementItemsDao(super.db);

  // Get All Procurement Items
  Future<List<ProcurementItem>> getAll() => select(procurementItems).get();

  // Get Procurement Item By Id
  Future<ProcurementItem?> getById(int id) => (select(procurementItems)..where((pi) => pi.id.equals(id))).getSingleOrNull();

  // Get Procurement Items By Procurement Id
  Future<List<ProcurementItem>> getByProcurementId(int procurementId) => (select(procurementItems)..where((pi) => pi.procurementId.equals(procurementId))).get();

  // Get Procurement Items By Item Id
  Future<List<ProcurementItem>> getByItemId(int itemId) => (select(procurementItems)..where((pi) => pi.itemId.equals(itemId))).get();

  // Insert Procurement Item
  Future<int> insertProcurementItem(
    int procurementId,
    int itemId,
    double quantity,
    double purchasePrice,
  ) {
    return into(procurementItems).insert(
      ProcurementItemsCompanion(
        procurementId: Value(procurementId),
        itemId: Value(itemId),
        quantity: Value(quantity),
        purchasePrice: Value(purchasePrice),
      ),
    );
  }

  // Update Procurement Item
  Future<int> updateProcurementItem(
    int id,
    int procurementId,
    int itemId,
    double quantity,
    double purchasePrice,
  ) {
    final query = update(procurementItems)..where((pi) => pi.id.equals(id));

    return query.write(
      ProcurementItemsCompanion(
        procurementId: Value(procurementId),
        itemId: Value(itemId),
        quantity: Value(quantity),
        purchasePrice: Value(purchasePrice),
      ),
    );
  }

  // Delete Procurement Item
  Future deleteProcurementItem(int id) {
    return (delete(procurementItems)..where((pi) => pi.id.equals(id))).go();
  }

  // Delete All Procurement Items By Procurement Id
  Future deleteByProcurementId(int procurementId) {
    return (delete(procurementItems)..where((pi) => pi.procurementId.equals(procurementId))).go();
  }
}
