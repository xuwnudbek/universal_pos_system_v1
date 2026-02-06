import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../enums/payment_types_enum.dart';
import '../../tables/payment_types_table.dart';

part 'payment_types_dao.g.dart';

@DriftAccessor(tables: [PaymentTypes])
class PaymentTypesDao extends DatabaseAccessor<AppDatabase> with _$PaymentTypesDaoMixin {
  PaymentTypesDao(super.db);

  // Get All Active Payment Types
  Future<List<PaymentType>> getAllActive() => (select(paymentTypes)..where((p) => p.isActive.equals(true))).get();

  // Get All Payment Types
  Future<List<PaymentType>> getAll() => select(paymentTypes).get();

  // Get Payment Type By Id
  Future<PaymentType?> getById(int id) => (select(paymentTypes)..where((p) => p.id.equals(id))).getSingleOrNull();

  // Get Payment Types By Ids
  Future<List<PaymentType>> getByIds(List<int> ids) {
    final query = select(paymentTypes)..where((p) => p.id.isIn(ids));
    return query.get();
  }

  // Insert Payment Type
  Future<int> insertPaymentType(PaymentTypesEnum name, bool isActive) {
    return into(paymentTypes).insert(
      PaymentTypesCompanion(
        name: Value(name),
        isActive: Value(isActive),
      ),
    );
  }

  // Update Payment Type
  Future<int> updatePaymentType(int id, PaymentTypesEnum name, bool isActive) {
    final query = update(paymentTypes)..where((p) => p.id.equals(id));

    return query.write(
      PaymentTypesCompanion(
        name: Value(name),
        isActive: Value(isActive),
      ),
    );
  }

  // Delete Payment Type
  Future deletePaymentType(int id) {
    return (delete(paymentTypes)..where((p) => p.id.equals(id))).go();
  }
}
