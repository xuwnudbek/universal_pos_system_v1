import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/models/procurement_item_full.dart';

import '../../tables/procurement_items_table.dart';

part 'procurement_items_dao.g.dart';

@DriftAccessor(tables: [ProcurementItems])
class ProcurementItemsDao extends DatabaseAccessor<AppDatabase> with _$ProcurementItemsDaoMixin {
  ProcurementItemsDao(super.db);

  // Get Procurement Items By Procurement Id with Item[Unit] via JOIN
  Future<List<ProcurementItemFull>> getByProcurementId(int procurementId) async {
    final query =
        select(procurementItems).join([
            innerJoin(
              db.items,
              db.items.id.equalsExp(procurementItems.itemId),
            ),
            innerJoin(
              db.units,
              db.units.id.equalsExp(db.items.unitId),
            ),
          ])
          ..where(procurementItems.procurementId.equals(procurementId))
          ..orderBy(
            [OrderingTerm.asc(db.items.name)],
          );

    final results = await query.get();

    return results.map((row) {
      final procurementItem = row.readTable(procurementItems);
      final item = row.readTable(db.items);
      final unit = row.readTable(db.units);

      return ProcurementItemFull.from(
        procurementItem: procurementItem,
        item: ItemFull.from(item: item, unit: unit),
      );
    }).toList();
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
