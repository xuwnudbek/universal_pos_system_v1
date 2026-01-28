import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables/carts_table.dart';

part 'carts_dao.g.dart';

@DriftAccessor(tables: [Carts])
class CartsDao extends DatabaseAccessor<AppDatabase> with _$CartsDaoMixin {
  CartsDao(super.db);

  // Get All Carts
  Future<List<Cart>> getAll() => (select(carts)..orderBy([(c) => OrderingTerm.desc(c.createdAt)])).get();

  // Get Cart By Id
  Future<Cart?> getById(int id) =>
      (select(carts)..where(
            (c) => c.id.equals(id),
          ))
          .getSingleOrNull();

  // Get Carts as Stream
  Stream<List<Cart>> watchAll() => (select(carts)..orderBy([(c) => OrderingTerm.desc(c.createdAt)])).watch();

  // Insert Cart
  Future<int> insertCart(CartsCompanion data) {
    return into(carts).insert(data);
  }

  Future<int> updateCart(int id) {
    final query = update(carts)..where((c) => c.id.equals(id));

    return query.write(CartsCompanion());
  }

  Future deleteCart(int id) {
    return (delete(carts)..where((c) => c.id.equals(id))).go();
  }
}
