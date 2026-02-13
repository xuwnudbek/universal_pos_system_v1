import 'package:drift/drift.dart';

import 'sale_payments_table.dart';

class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();

  IntColumn get salePaymentId => integer().references(SalePayments, #id, onDelete: KeyAction.cascade).nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
