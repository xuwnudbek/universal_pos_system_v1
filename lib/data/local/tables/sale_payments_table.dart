import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/sale_histories_table.dart';

class SalePayments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get saleHistoryId => integer().references(SaleHistories, #id)();
  TextColumn get paymentType => text()();
  RealColumn get amount => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
