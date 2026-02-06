import 'package:universal_pos_system_v1/data/local/daos/sale_payments/sale_payments_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/payment_types/payment_types_dao.dart';
import 'package:universal_pos_system_v1/data/models/sale_payment_full.dart';

class SalePaymentsRepository {
  final SalePaymentsDao salePaymentsDao;
  final PaymentTypesDao paymentTypesDao;

  const SalePaymentsRepository(
    this.salePaymentsDao,
    this.paymentTypesDao,
  );

  // Get all sale payments
  Future<List<SalePaymentFull>> getAll() async {
    final payments = await salePaymentsDao.getAll();
    final paymentTypes = await paymentTypesDao.getAll();

    return payments.map((payment) {
      final paymentType = paymentTypes.firstWhere(
        (pt) => pt.id == payment.paymentTypeId,
      );

      return SalePaymentFull.from(
        salePayment: payment,
        paymentType: paymentType,
      );
    }).toList();
  }

  // Get sale payments by sale ID
  Future<List<SalePaymentFull>> getBySaleId(int saleId) {
    return salePaymentsDao.getBySaleId(saleId);
  }

  // Get sale payment by id
  Future<SalePaymentFull?> getById(int salePaymentId) async {
    final payment = await salePaymentsDao.getById(salePaymentId);

    if (payment == null) {
      throw Exception('Sale Payment not found for ID: $salePaymentId');
    }

    final paymentType = await paymentTypesDao.getById(payment.paymentTypeId);

    if (paymentType == null) {
      throw Exception('Payment type not found for ID: $salePaymentId');
    }

    return SalePaymentFull.from(
      salePayment: payment,
      paymentType: paymentType,
    );
  }

  // Get total payment for a sale
  Future<double> getTotalBySaleId(int saleId) {
    return salePaymentsDao.getTotalBySaleId(saleId);
  }

  // Create new sale payment
  Future<int> create({
    required int saleId,
    required int paymentTypeId,
    required double amount,
  }) {
    return salePaymentsDao.insertSalePayment(
      saleId: saleId,
      paymentTypeId: paymentTypeId,
      amount: amount,
    );
  }

  // Update sale payment
  Future<void> update({
    required int id,
    required int saleId,
    required int paymentTypeId,
    required double amount,
  }) {
    return salePaymentsDao.updateSalePayment(
      id: id,
      saleId: saleId,
      paymentTypeId: paymentTypeId,
      amount: amount,
    );
  }

  // Delete sale payment
  Future<void> delete(int id) => salePaymentsDao.deleteSalePayment(id);

  // Delete all payments for a sale
  Future<void> deleteBySaleId(int saleId) => salePaymentsDao.deleteBySaleId(saleId);

  // Get payment statistics
  Future<List<Map<String, dynamic>>> getPaymentStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final statistics = await salePaymentsDao.getPaymentStatistics(
      startDate: startDate,
      endDate: endDate,
    );

    if (statistics.isEmpty) return [];

    final paymentTypeIds = statistics.map((s) => s['paymentTypeId'] as int).toList();
    final paymentTypes = await paymentTypesDao.getByIds(paymentTypeIds);

    return statistics.map((stat) {
      final paymentTypeId = stat['paymentTypeId'] as int;
      final paymentType = paymentTypes.firstWhere((pt) => pt.id == paymentTypeId);

      return {
        'paymentType': paymentType,
        'totalAmount': stat['totalAmount'] as double,
      };
    }).toList();
  }
}
