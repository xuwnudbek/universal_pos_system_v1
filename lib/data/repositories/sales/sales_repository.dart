import 'package:universal_pos_system_v1/data/local/daos/items/items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sale_items/sale_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sale_payments/sale_payments_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sales/sales_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';

class SalesRepository {
  final SalesDao salesDao;
  final SaleItemsDao saleItemsDao;
  final ItemsDao itemsDao;
  final SalePaymentsDao salePaymentsDao;

  const SalesRepository(
    this.salesDao,
    this.saleItemsDao,
    this.itemsDao,
    this.salePaymentsDao,
  );

  Future<List<SaleFull>> getAll() async {
    final sales = await salesDao.getAll();
    final saleItems = await saleItemsDao.getBySaleIds(sales.map((s) => s.id).toList());
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());
    final payments = await salePaymentsDao.getBySaleIds(sales.map((s) => s.id).toList());

    final enrichedSales = sales.map((sale) {
      final itemsForSale = saleItems.where((si) => si.saleId == sale.id).toList();
      final paymentsForSale = payments.where((sp) => sp.saleId == sale.id).toList();

      final enrichedSaleItems = itemsForSale.map((si) {
        final item = items.firstWhere((i) => i.id == si.itemId);
        return SaleItemFull.from(
          saleItem: si,
          item: item,
        );
      }).toList();

      return SaleFull.from(
        sale: sale,
        items: enrichedSaleItems,
        payments: paymentsForSale,
      );
    }).toList();

    return enrichedSales;
  }

  Future<SaleFull?> getBySaleId(int id) async {
    final sale = await salesDao.getById(id);

    if (sale == null) {
      throw Exception('No sale found with ID $id');
    }

    final paymentsForSale = await salePaymentsDao.getBySaleId(id);

    final saleItems = await saleItemsDao.getBySaleId(sale.id);
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());
    final enrichedSaleItems = saleItems.map((si) {
      final item = items.firstWhere((i) => i.id == si.itemId);

      return SaleItemFull.from(
        saleItem: si,
        item: item,
      );
    }).toList();

    return SaleFull.from(
      sale: sale,
      items: enrichedSaleItems,
      payments: paymentsForSale,
    );
  }

  Future<SaleFull?> getDraftByUserId(int userId) async {
    final sale = await salesDao.getDraftByUserId(userId);

    if (sale == null) {
      throw Exception('No draft sale found for user with ID $userId');
    }

    final saleItems = await saleItemsDao.getBySaleId(sale.id);
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());
    final enrichedSaleItems = saleItems.map((si) {
      final item = items.firstWhere((i) => i.id == si.itemId);

      return SaleItemFull.from(
        saleItem: si,
        item: item,
      );
    }).toList();

    final saleFull = SaleFull.from(
      sale: sale,
      payments: [],
      items: enrichedSaleItems,
    );

    return saleFull;
  }

  Future<SaleFull> create({
    required int userId,
    SaleStatusEnum? status,
  }) async {
    int saleId = await salesDao.insertSale(userId, status);

    final sale = await salesDao.getById(saleId);

    // final saleFull = SaleFull.from(
    //   user: null,
    //   sale: sale!,
    //   items: [],
    // );

    return Future.value();
  }

  Future<void> updateStatus({
    required int id,
    required SaleStatusEnum status,
  }) => salesDao.updateStatus(id, status);

  Future delete(int id) => salesDao.deleteSale(id);
}
