import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/tables/sales_table.dart';
import 'package:universal_pos_system_v1/data/local/tables/payment_types_table.dart';

class SalePayments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get paymentTypeId => integer().references(PaymentTypes, #id)();
  RealColumn get amount => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
