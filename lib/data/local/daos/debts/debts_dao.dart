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
    required bool isPaid,
    required int salePaymentId,
  }) => into(debts).insert(
    DebtsCompanion.insert(
      title: title,
      description: description,
      isPaid: Value(isPaid),
      salePaymentId: Value(salePaymentId),
    ),
  );

  Future<int> updateDebt(
    int id,
    String title,
    String description,
    bool isPaid,
  ) {
    final query = update(debts)..where((tbl) => tbl.id.equals(id));

    return query.write(
      DebtsCompanion(
        title: Value(title),
        description: Value(description),
        isPaid: Value(isPaid),
      ),
    );
  }

  Future<int> deleteDebt(int id) => (delete(debts)..where((debt) => debt.id.equals(id))).go();
}
