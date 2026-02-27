import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../tables/debts_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<List<Debt>> getAllDebts() => select(debts).get();

  Future<Debt?> getDebtById(int id) => (select(debts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertDebt({
    required String title,
    required String description,
    required String phone,
    required int salePaymentId,
  }) => into(debts).insert(
    DebtsCompanion.insert(
      title: title,
      description: description,
      phone: phone,
      salePaymentId: Value(salePaymentId),
    ),
  );

  Future<int> updateDebt(
    int id,
    String title,
    String description,
    String phone,
  ) {
    final query = update(debts)..where((tbl) => tbl.id.equals(id));

    return query.write(
      DebtsCompanion(
        title: Value(title),
        description: Value(description),
        phone: Value(phone),
      ),
    );
  }

  Future<int> deleteDebt(int id) => (delete(debts)..where((debt) => debt.id.equals(id))).go();

  Future<List<Debt>> getDebtsByDateRange(DateTime start, DateTime end) =>
      (select(debts)
            ..where((d) => d.createdAt.isBetweenValues(start, end))
            ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
          .get();

  Future<int> markAsPaid(int id) {
    final query = update(debts)..where((tbl) => tbl.id.equals(id));

    return query.write(
      DebtsCompanion(
        isPaid: Value(true),
      ),
    );
  }
}
