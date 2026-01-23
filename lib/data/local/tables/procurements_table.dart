import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class Procurements extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get supplierName => text()();

  DateTimeColumn get procurementDate => dateTime()();

  TextColumn get location => textEnum<LocationsEnum>()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
