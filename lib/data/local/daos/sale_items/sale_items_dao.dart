import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';

import '../../app_database.dart';
import '../../tables/items_table.dart';
import '../../tables/sale_items_table.dart';

part 'sale_items_dao.g.dart';

@DriftAccessor(tables: [SaleItems, Items])
class SaleItemsDao extends DatabaseAccessor<AppDatabase> with _$SaleItemsDaoMixin {
  SaleItemsDao(super.db);

  // Get Sale Items By Sale Id
  Future<List<SaleItem>> getBySaleId(int saleId) async {
    final query = select(saleItems)..where((s) => s.saleId.equals(saleId));
    return query.get();
  }

  // Get Sale Items By Multiple Sale Ids
  Future<List<SaleItem>> getBySaleIds(List<int> saleIds) async {
    final query = select(saleItems)..where((s) => s.saleId.isIn(saleIds));
    return query.get();
  }

  // Insert Sale Item
  Future<int> insertSaleItem(int saleId, int itemId, int quantity) {
    return into(saleItems).insert(
      SaleItemsCompanion(
        saleId: Value(saleId),
        itemId: Value(itemId),
        quantity: Value(quantity),
      ),
    );
  }

  // Update Sale Item Quantity
  Future<int> updateQuantity(int id, int quantity) {
    final query = update(saleItems)..where((s) => s.id.equals(id));

    return query.write(
      SaleItemsCompanion(
        quantity: Value(quantity),
      ),
    );
  }

  // Delete Sale Item
  Future deleteSaleItem(int id) {
    return (delete(saleItems)..where((s) => s.id.equals(id))).go();
  }

  // Delete Sale Items By Sale Id
  Future deleteBySaleId(int saleId) {
    return (delete(saleItems)..where((s) => s.saleId.equals(saleId))).go();
  }
}
