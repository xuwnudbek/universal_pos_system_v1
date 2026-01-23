import 'package:drift/drift.dart';

class SavedCarts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
