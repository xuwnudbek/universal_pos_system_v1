import 'package:universal_pos_system_v1/data/local/daos/items/items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sale_items/sale_items_dao.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';

class SaleItemsRepository {
  final SaleItemsDao saleItemsDao;
  final ItemsDao itemsDao;

  const SaleItemsRepository(
    this.saleItemsDao,
    this.itemsDao,
  );

  Future<List<SaleItemFull>> getBySaleId(int saleId) async {
    final saleItems = await saleItemsDao.getBySaleId(saleId);
    final items = await itemsDao.getByIds(saleItems.map((e) => e.itemId).toList());

    return saleItems.map((saleItem) {
      final item = items.where((i) => i.id == saleItem.itemId).first;

      return SaleItemFull.from(
        saleItem: saleItem,
        item: item,
      );
    }).toList();
  }

  Future<int> create({
    required int saleId,
    required int itemId,
    required int quantity,
  }) => saleItemsDao.insertSaleItem(saleId, itemId, quantity);

  Future<void> updateQuantity({
    required int id,
    required int quantity,
  }) => saleItemsDao.updateQuantity(id, quantity);

  Future delete(int id) => saleItemsDao.deleteSaleItem(id);

  Future deleteBySaleId(int saleId) => saleItemsDao.deleteBySaleId(saleId);

  Future<List<Map<String, dynamic>>> getTopSellingProducts({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 10,
  }) async {
    final topProducts = await saleItemsDao.getTopSellingProducts(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );

    if (topProducts.isEmpty) return [];

    final itemIds = topProducts.map((p) => p['itemId'] as int).toList();
    final items = await itemsDao.getByIds(itemIds);

    return topProducts.map((product) {
      final itemId = product['itemId'] as int;
      final item = items.firstWhere((i) => i.id == itemId);

      return {
        'item': item,
        'quantity': product['totalQuantity'] as int,
        'amount': (product['totalQuantity'] as int) * item.salePrice,
      };
    }).toList();
  }
}
