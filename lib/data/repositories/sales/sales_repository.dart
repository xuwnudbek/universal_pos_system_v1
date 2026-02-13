import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/debts/debts_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/items/items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/payment_types/payment_types_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sale_items/sale_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sale_payments/sale_payments_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/sales/sales_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_item_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_payment_full.dart';

class SalesRepository {
  final SalesDao salesDao;
  final SaleItemsDao saleItemsDao;
  final ItemsDao itemsDao;
  final SalePaymentsDao salePaymentsDao;
  final PaymentTypesDao paymentTypesDao;
  final DebtsDao debtsDao;

  const SalesRepository(
    this.salesDao,
    this.saleItemsDao,
    this.itemsDao,
    this.salePaymentsDao,
    this.paymentTypesDao,
    this.debtsDao,
  );

  Future<List<SaleFull>> getAll() async {
    final sales = await salesDao.getAll();
    final saleItems = await saleItemsDao.getBySaleIds(sales.map((s) => s.id).toList());
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());
    final salePayments = await salePaymentsDao.getBySaleIds(sales.map((s) => s.id).toList());
    final paymentTypes = await paymentTypesDao.getAll();
    final debts = await debtsDao.getAllDebts();

    final enrichedSales = sales.map((sale) {
      final itemsForSale = saleItems.where((si) => si.saleId == sale.id).toList();

      final salePaymentFull = salePayments.where((sp) => sp.saleId == sale.id).map((sp) {
        final paymentType = paymentTypes.firstWhere((pt) => pt.id == sp.paymentTypeId);

        Debt? debt;

        if (paymentType.name == PaymentTypesEnum.debt) {
          debt = debts.firstWhere((d) => d.salePaymentId == sp.id);
        }

        return SalePaymentFull.from(
          salePayment: sp,
          paymentType: paymentType,
          debtAddition: debt,
        );
      }).toList();

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
        payments: salePaymentFull,
      );
    }).toList();

    return enrichedSales;
  }

  Future<SaleFull?> getBySaleId(int id) async {
    final sale = await salesDao.getById(id);

    if (sale == null) {
      throw Exception('No sale found with ID $id');
    }

    final paymentsForSales = await salePaymentsDao.getBySaleId(id);

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
      payments: paymentsForSales,
    );
  }

  // Get sales by enum status
  Future<List<SaleFull>> getByStatus(SaleStatusEnum status) async {
    final sales = await salesDao.getByStatus(status);
    final saleItems = await saleItemsDao.getBySaleIds(sales.map((s) => s.id).toList());
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());
    final payments = await salePaymentsDao.getBySaleIds(sales.map((s) => s.id).toList());
    final paymentTypes = await paymentTypesDao.getAll();
    final debts = await debtsDao.getAllDebts();

    final enrichedSales = sales.map((sale) {
      final itemsForSale = saleItems.where((si) => si.saleId == sale.id).toList();

      final paymentsForSale = payments.where((sp) => sp.saleId == sale.id).map((sp) {
        final paymentType = paymentTypes.firstWhere((pt) => pt.id == sp.paymentTypeId);
        final debt = debts.firstWhere((d) => d.salePaymentId == sp.id);

        final salePaymentFull = SalePaymentFull.from(
          salePayment: sp,
          paymentType: paymentType,
          debtAddition: debt,
        );

        return salePaymentFull;
      }).toList();

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

  Future<SaleFull?> getById(int id) => getBySaleId(id);

  Future<SaleFull?> getDraftByUserId(int userId) async {
    final sale = await salesDao.getDraftByUserId(userId);

    // If sale is null, return null
    if (sale == null) return null;

    // Else fetch the sale items & return SaleFull
    final saleItems = await saleItemsDao.getBySaleId(sale.id);
    final items = await itemsDao.getByIds(saleItems.map((si) => si.itemId).toList());

    final salePayments = await salePaymentsDao.getBySaleId(sale.id);

    final enrichedSaleItems = saleItems.map((si) {
      final item = items.firstWhere((i) => i.id == si.itemId);
      return SaleItemFull.from(
        saleItem: si,
        item: item,
      );
    }).toList();

    final saleFull = SaleFull.from(
      sale: sale,
      payments: salePayments,
      items: enrichedSaleItems,
    );

    return saleFull;
  }

  Future<SaleFull> create({
    required int userId,
    SaleStatusEnum? status,
  }) async {
    final saleId = await salesDao.insertSale(userId, status);
    final sale = await getById(saleId);

    return Future.value(sale!);
  }

  Future<void> updateStatus({
    required int id,
    required SaleStatusEnum status,
  }) => salesDao.updateStatus(id, status);

  Future delete(int id) => salesDao.deleteSale(id);
}
