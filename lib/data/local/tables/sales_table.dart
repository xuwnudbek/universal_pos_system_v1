import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/local/tables/users_table.dart';

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();

  TextColumn get status => textEnum<SaleStatusEnum>()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
}
