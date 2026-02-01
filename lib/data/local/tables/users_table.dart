import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fullName => text()();

  TextColumn get username => text().unique()();

  TextColumn get passwordHash => text()();

  TextColumn get role => textEnum<UserRolesEnum>()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
