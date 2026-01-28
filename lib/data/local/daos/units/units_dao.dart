import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../tables/units_table.dart';

part 'units_dao.g.dart';

@DriftAccessor(tables: [Units])
class UnitsDao extends DatabaseAccessor<AppDatabase> with _$UnitsDaoMixin {
  UnitsDao(super.db);

  // Get All Units
  Future<List<Unit>> getAll() => (select(units)..orderBy([(u) => OrderingTerm.desc(u.createdAt)])).get();

  // Get Cart By Id
  Future<Unit> getById(int id) =>
      (select(units)..where(
            (c) => c.id.equals(id),
          ))
          .getSingle();

  // Insert Unit
  Future<int> insertUnit(
    String name,
    String shortName,
    bool isActive,
  ) {
    return into(units).insert(
      UnitsCompanion(
        name: Value(name),
        shortName: Value(shortName),
        isActive: Value(isActive),
      ),
    );
  }

  Future<int> updateUnit(
    int id,
    String name,
    String shortName,
    bool isActive,
  ) {
    final query = update(units)..where((u) => u.id.equals(id));

    return query.write(
      UnitsCompanion(
        name: Value(name),
        shortName: Value(shortName),
        isActive: Value(isActive),
      ),
    );
  }

  Future deleteUnit(int id) {
    return (delete(units)..where((u) => u.id.equals(id))).go();
  }
}
