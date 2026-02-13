import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

import '../../app_database.dart';
import '../../enums/sale_status_enum.dart';
import '../../tables/sales_table.dart';

part 'sales_dao.g.dart';

@DriftAccessor(tables: [Sales])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  int get userId => LocalStorage.getUserId() ?? 0;

  // Get All Sales
  Future<List<Sale>> getAll() =>
      (select(sales)
            ..where((sale) => sale.userId.equals(userId))
            ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
          .get();

  // Get Sale By Id
  Future<Sale?> getById(int id) =>
      (select(sales)..where(
            (s) => s.id.equals(id),
          ))
          .getSingleOrNull();

  // Get Sale By User
  Future<Sale?> getByUserId(int userId) =>
      (select(sales)..where(
            (s) => s.userId.equals(userId),
          ))
          .getSingleOrNull();

  // Get Draft Sale By User
  Future<Sale?> getDraftByUserId(int userId) {
    return (select(sales)
          ..where(
            (s) => s.userId.equals(userId) & s.status.equalsValue(SaleStatusEnum.draft),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  // Get Sales By Status
  Future<List<Sale>> getByStatus(SaleStatusEnum status) {
    final query = select(sales)
      ..where(
        (s) => s.status.equalsValue(status) & s.userId.equals(userId),
      );
    return query.get();
  }

  // Insert Sale
  Future<int> insertSale(int userId, SaleStatusEnum? status) {
    return into(sales).insert(
      SalesCompanion(
        userId: Value(userId),
        status: Value(status ?? SaleStatusEnum.draft),
      ),
    );
  }

  // Update Sale Status
  Future<int> updateStatus(int id, SaleStatusEnum status) {
    final query = update(sales)..where((s) => s.id.equals(id));

    return query.write(
      SalesCompanion(
        status: Value(status),
      ),
    );
  }

  // Delete Sale
  Future deleteSale(int id) {
    return (delete(sales)..where((s) => s.id.equals(id))).go();
  }
}
