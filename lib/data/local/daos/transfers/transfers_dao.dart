import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

import '../../app_database.dart';
import '../../tables/transfers_table.dart';
import '../../tables/items_table.dart';

part 'transfers_dao.g.dart';

@DriftAccessor(tables: [Transfers, Items])
class TransfersDao extends DatabaseAccessor<AppDatabase> with _$TransfersDaoMixin {
  TransfersDao(super.db);

  // Get All Transfers
  Future<List<Transfer>> getAll() => (select(transfers)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  // Get Transfer By Id
  Future<Transfer?> getById(int id) => (select(transfers)..where((t) => t.id.equals(id))).getSingleOrNull();

  // Get Transfers By Item
  Future<List<Transfer>> getByItem(int itemId) =>
      (select(transfers)
            ..where((t) => t.itemId.equals(itemId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  // Get Transfers By From Location
  Future<List<Transfer>> getByFromLocation(LocationsEnum location) =>
      (select(transfers)
            ..where((t) => t.fromLocation.equalsValue(location))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  // Get Transfers By To Location
  Future<List<Transfer>> getByToLocation(LocationsEnum location) =>
      (select(transfers)
            ..where((t) => t.toLocation.equalsValue(location))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  // Get Transfers By Date Range
  Future<List<Transfer>> getByDateRange(DateTime start, DateTime end) =>
      (select(transfers)
            ..where((t) => t.createdAt.isBiggerOrEqualValue(start) & t.createdAt.isSmallerOrEqualValue(end))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  // Insert Transfer
  Future<int> insertTransfer(
    int itemId,
    LocationsEnum fromLocation,
    LocationsEnum toLocation,
    double quantity,
    String? note,
  ) {
    return into(transfers).insert(
      TransfersCompanion(
        itemId: Value(itemId),
        fromLocation: Value(fromLocation),
        toLocation: Value(toLocation),
        quantity: Value(quantity),
        note: Value(note),
      ),
    );
  }

  // Update Transfer
  Future<int> updateTransfer(
    int id,
    int itemId,
    LocationsEnum fromLocation,
    LocationsEnum toLocation,
    double quantity,
    String? note,
  ) {
    final query = update(transfers)..where((t) => t.id.equals(id));

    return query.write(
      TransfersCompanion(
        itemId: Value(itemId),
        fromLocation: Value(fromLocation),
        toLocation: Value(toLocation),
        quantity: Value(quantity),
        note: Value(note),
      ),
    );
  }

  // Delete Transfer
  Future deleteTransfer(int id) {
    return (delete(transfers)..where((t) => t.id.equals(id))).go();
  }
}
