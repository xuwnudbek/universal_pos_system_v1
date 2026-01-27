import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/units_table.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/models/procurement_item_full.dart';

import '../../app_database.dart';
import '../../tables/procurement_items_table.dart';
import '../../tables/procurements_table.dart';
import '../../tables/items_table.dart';

part 'procurement_items_dao.g.dart';

@DriftAccessor(tables: [ProcurementItems, Procurements, Items, Units])
class ProcurementItemsDao extends DatabaseAccessor<AppDatabase> with _$ProcurementItemsDaoMixin {
  ProcurementItemsDao(super.db);

  ProcurementItemFull _mapProcurementItemFull(TypedResult row) {
    final procurementItem = row.readTable(procurementItems);
    final item = row.readTableOrNull(items);
    final unit = row.readTableOrNull(units);

    return ProcurementItemFull.from(
      procurementItem: procurementItem,
      item: item != null && unit != null ? ItemFull.from(item: item, unit: unit) : null,
    );
  }

  // Get All Procurement Items
  Future<List<ProcurementItemFull>> getAll() => getAllWithItems();

  // Get All Procurement Items With Items
  Future<List<ProcurementItemFull>> getAllWithItems() {
    final query = select(procurementItems).join(
      [
        leftOuterJoin(items, items.id.equalsExp(procurementItems.itemId)),
        leftOuterJoin(units, units.id.equalsExp(items.unitId)),
      ],
    );

    return query.map(_mapProcurementItemFull).get();
  }

  // Get Procurement Item By Id
  Future<ProcurementItemFull?> getById(int id) {
    final query = select(procurementItems).join(
      [
        leftOuterJoin(items, items.id.equalsExp(procurementItems.itemId)),
        leftOuterJoin(units, units.id.equalsExp(items.unitId)),
      ],
    )..where(procurementItems.id.equals(id));

    return query.map(_mapProcurementItemFull).getSingleOrNull();
  }

  // Get Procurement Items By Procurement Id
  Future<List<ProcurementItemFull>> getByProcurementId(int procurementId) {
    final query = select(procurementItems).join(
      [
        leftOuterJoin(items, items.id.equalsExp(procurementItems.itemId)),
        leftOuterJoin(units, units.id.equalsExp(items.unitId)),
      ],
    )..where(procurementItems.procurementId.equals(procurementId));

    return query.map(_mapProcurementItemFull).get();
  }

  // Get Procurement Items By Item Id
  Future<List<ProcurementItemFull>> getByItemId(int itemId) {
    final query = select(procurementItems).join(
      [
        leftOuterJoin(items, items.id.equalsExp(procurementItems.itemId)),
        leftOuterJoin(units, units.id.equalsExp(items.unitId)),
      ],
    )..where(procurementItems.itemId.equals(itemId));

    return query.map(_mapProcurementItemFull).get();
  }

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
