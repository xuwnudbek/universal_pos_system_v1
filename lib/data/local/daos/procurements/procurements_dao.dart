import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';

import '../../app_database.dart';
import '../../tables/procurements_table.dart';

part 'procurements_dao.g.dart';

@DriftAccessor(tables: [Procurements])
class ProcurementsDao extends DatabaseAccessor<AppDatabase> with _$ProcurementsDaoMixin {
  ProcurementsDao(super.db);

  // Get All Procurements
  Future<List<ProcurementFull>> getAll() => (select(procurements)..orderBy([(p) => OrderingTerm.desc(p.createdAt)])).get();

  // Get Procurement By Id
  Future<ProcurementFull?> getById(int id) => (select(procurements)..where((p) => p.id.equals(id))).getSingleOrNull();

  // Get Procurements By Location
  Future<List<ProcurementFull>> getByLocation(LocationsEnum location) =>
      (select(procurements)
            ..where((p) => p.location.equalsValue(location))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();

  // Get Procurements By Date Range
  Future<List<ProcurementFull>> getByDateRange(DateTime start, DateTime end) =>
      (select(procurements)
            ..where((p) => p.procurementDate.isBiggerOrEqualValue(start) & p.procurementDate.isSmallerOrEqualValue(end))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();

  // Insert Procurement
  Future<int> insertProcurement(
    String supplierName,
    DateTime procurementDate,
    LocationsEnum location,
    String? note,
  ) {
    return into(procurements).insert(
      ProcurementsCompanion(
        supplierName: Value(supplierName),
        procurementDate: Value(procurementDate),
        location: Value(location),
        note: Value(note),
      ),
    );
  }

  // Update Procurement
  Future<int> updateProcurement(
    int id,
    String supplierName,
    DateTime procurementDate,
    LocationsEnum location,
    String? note,
  ) {
    final query = update(procurements)..where((p) => p.id.equals(id));

    return query.write(
      ProcurementsCompanion(
        supplierName: Value(supplierName),
        procurementDate: Value(procurementDate),
        location: Value(location),
        note: Value(note),
      ),
    );
  }

  // Delete Procurement
  Future deleteProcurement(int id) {
    return (delete(procurements)..where((p) => p.id.equals(id))).go();
  }
}
