import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';

class PaymentTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => textEnum<PaymentTypesEnum>()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
