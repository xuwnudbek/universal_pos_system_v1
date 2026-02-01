import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';

import '../../app_database.dart';
import '../../tables/items_table.dart';
import '../../tables/procurement_items_table.dart';
import '../../tables/procurements_table.dart';
import '../../tables/units_table.dart';

part 'procurements_dao.g.dart';

@DriftAccessor(tables: [Procurements, ProcurementItems, Items, Units])
class ProcurementsDao extends DatabaseAccessor<AppDatabase> with _$ProcurementsDaoMixin {
  ProcurementsDao(super.db);

  // Get All Procurements with Items Count via sql
  Future<List<ProcurementFull>> getAll() async {
    final query = customSelect(
      '''
    SELECT 
      p.*,
      COUNT(pi.id) AS items_count,
      COALESCE(SUM(pi.quantity * pi.purchase_price), 0) AS total_cost
    FROM procurements p
    LEFT JOIN procurement_items pi 
      ON pi.procurement_id = p.id
    GROUP BY p.id
    ORDER BY p.procurement_date DESC
    ''',
      readsFrom: {procurements, procurementItems},
    );

    final rows = await query.get();

    return rows.map((row) {
      return ProcurementFull.from(
        procurement: procurements.map(row.data),
        itemsCount: row.read<int>('items_count'),
        totalCost: row.read<double>('total_cost'),
      );
    }).toList();
  }

  // Get Procurement By Id
  Future<ProcurementFull?> getById(int id) async {
    final query = customSelect(
      '''
    SELECT 
      p.*,
      COUNT(pi.id) AS items_count,
      COALESCE(SUM(pi.quantity * pi.purchase_price), 0) AS total_cost
    FROM procurements p
    LEFT JOIN procurement_items pi 
      ON pi.procurement_id = p.id
    WHERE p.id = ?
    GROUP BY p.id
    ''',
      variables: [Variable<int>(id)],
      readsFrom: {procurements, procurementItems},
    );

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return ProcurementFull.from(
      procurement: procurements.map(row.data),
      itemsCount: row.read<int>('items_count'),
      totalCost: row.read<double>('total_cost'),
    );
  }

  // Get Procurements By Location
  Future<List<ProcurementFull>> getByLocation(LocationsEnum location) async {
    final query = customSelect(
      '''
    SELECT 
      p.*,
      COUNT(pi.id) AS items_count,
      COALESCE(SUM(pi.quantity * pi.purchase_price), 0) AS total_cost
    FROM procurements p
    LEFT JOIN procurement_items pi 
      ON pi.procurement_id = p.id
    WHERE p.location = ?
    GROUP BY p.id
    ORDER BY p.procurement_date DESC
    ''',
      variables: [Variable<LocationsEnum>(location)],
      readsFrom: {procurements, procurementItems},
    );

    final rows = await query.get();

    return rows.map((row) {
      return ProcurementFull.from(
        procurement: procurements.map(row.data),
        itemsCount: row.read<int>('items_count'),
        totalCost: row.read<double>('total_cost'),
      );
    }).toList();
  }

  // Get Procurements By Date Range
  Future<List<ProcurementFull>> getByDateRange(DateTime start, DateTime end) async {
    final query = customSelect(
      '''
    SELECT 
      p.*,
      COUNT(pi.id) AS items_count,
      COALESCE(SUM(pi.quantity * pi.purchase_price), 0) AS total_cost
    FROM procurements p
    LEFT JOIN procurement_items pi 
      ON pi.procurement_id = p.id
    WHERE p.procurement_date BETWEEN ? AND ?
    GROUP BY p.id
    ORDER BY p.procurement_date DESC
    ''',
      variables: [
        Variable<DateTime>(start),
        Variable<DateTime>(end),
      ],
      readsFrom: {procurements, procurementItems},
    );

    final rows = await query.get();

    return rows.map((row) {
      return ProcurementFull.from(
        procurement: procurements.map(row.data),
        itemsCount: row.read<int>('items_count'),
        totalCost: row.read<double>('total_cost'),
      );
    }).toList();
  }

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
  Future deleteProcurement(int id) async {
    // Then delete the procurement
    return (delete(procurements)..where((p) => p.id.equals(id))).go();
  }
}
