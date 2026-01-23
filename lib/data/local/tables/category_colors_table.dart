import 'package:drift/drift.dart';

class CategoryColors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get hex => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
