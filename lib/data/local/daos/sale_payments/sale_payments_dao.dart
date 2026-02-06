import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/models/sale_payment_full.dart';
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
  Future<List<SalePaymentFull>> getBySaleId(int saleId) async {
    final query = select(salePayments).join([
      innerJoin(paymentTypes, paymentTypes.id.equalsExp(salePayments.paymentTypeId)),
    ])..where(salePayments.saleId.equals(saleId));

    final results = await query.get();

    return results.map((row) {
      final salePayment = row.readTable(salePayments);
      final paymentType = row.readTable(paymentTypes);

      return SalePaymentFull.from(
        salePayment: salePayment,
        paymentType: paymentType,
      );
    }).toList();
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

  // Get payment statistics by payment type
  Future<List<Map<String, dynamic>>> getPaymentStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = selectOnly(salePayments)
      ..addColumns([
        salePayments.paymentTypeId,
        salePayments.amount.sum(),
      ])
      ..groupBy([salePayments.paymentTypeId]);

    // Join with sales table for date filtering
    query.join([
      innerJoin(
        sales,
        sales.id.equalsExp(salePayments.saleId),
      ),
    ]);

    // Apply date filters if provided
    if (startDate != null) {
      query.where(sales.createdAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where(sales.createdAt.isSmallerOrEqualValue(endDate));
    }

    final results = await query.get();

    return results.map((row) {
      return {
        'paymentTypeId': row.read(salePayments.paymentTypeId),
        'totalAmount': row.read(salePayments.amount.sum()) ?? 0.0,
      };
    }).toList();
  }
}
