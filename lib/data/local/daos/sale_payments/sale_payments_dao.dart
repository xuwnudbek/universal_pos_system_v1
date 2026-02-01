import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables/sale_payments_table.dart';
import '../../tables/sales_table.dart';
import '../../tables/payment_types_table.dart';

part 'sale_payments_dao.g.dart';

@DriftAccessor(tables: [SalePayments, Sales, PaymentTypes])
class SalePaymentsDao extends DatabaseAccessor<AppDatabase> with _$SalePaymentsDaoMixin {
  SalePaymentsDao(super.db);

  // Get all sale payments
  Future<List<SalePayment>> getAll() => (select(salePayments)..orderBy([(sp) => OrderingTerm.desc(sp.createdAt)])).get();

  // Get sale payment by ID
  Future<SalePayment?> getById(int id) => (select(salePayments)..where((sp) => sp.id.equals(id))).getSingleOrNull();

  // Get sale payments by sale ID
  Future<List<SalePayment>> getBySaleId(int saleId) {
    final query = select(salePayments)..where((sp) => sp.saleId.equals(saleId));
    return query.get();
  }

  // Get sale payments by multiple sale IDs
  Future<List<SalePayment>> getBySaleIds(List<int> saleIds) {
    final query = select(salePayments)..where((sp) => sp.saleId.isIn(saleIds));
    return query.get();
  }

  // Get total payment amount for a sale
  Future<double> getTotalBySaleId(int saleId) async {
    final payments = await getBySaleId(saleId);
    return payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
  }

  // Insert sale payment
  Future<int> insertSalePayment({
    required int saleId,
    required int paymentTypeId,
    required double amount,
  }) {
    return into(salePayments).insert(
      SalePaymentsCompanion(
        saleId: Value(saleId),
        paymentTypeId: Value(paymentTypeId),
        amount: Value(amount),
      ),
    );
  }

  // Update sale payment
  Future<int> updateSalePayment({
    required int id,
    required int saleId,
    required int paymentTypeId,
    required double amount,
  }) {
    final query = update(salePayments)..where((sp) => sp.id.equals(id));

    return query.write(
      SalePaymentsCompanion(
        saleId: Value(saleId),
        paymentTypeId: Value(paymentTypeId),
        amount: Value(amount),
      ),
    );
  }

  // Delete sale payment
  Future deleteSalePayment(int id) {
    return (delete(salePayments)..where((sp) => sp.id.equals(id))).go();
  }

  // Delete all payments for a sale
  Future deleteBySaleId(int saleId) {
    return (delete(salePayments)..where((sp) => sp.saleId.equals(saleId))).go();
  }
}
