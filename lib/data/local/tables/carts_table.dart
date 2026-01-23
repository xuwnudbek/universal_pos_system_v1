import 'package:drift/drift.dart';

class Carts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
