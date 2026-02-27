import 'package:drift/drift.dart';

class StoreSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storeName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get barcodePrinter => text().withDefault(const Constant(''))();
  TextColumn get receiptPrinter => text().withDefault(const Constant(''))();
  BoolColumn get autoPrint => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
