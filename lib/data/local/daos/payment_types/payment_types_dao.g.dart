// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_types_dao.dart';

// ignore_for_file: type=lint
mixin _$PaymentTypesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PaymentTypesTable get paymentTypes => attachedDatabase.paymentTypes;
  PaymentTypesDaoManager get managers => PaymentTypesDaoManager(this);
}

class PaymentTypesDaoManager {
  final _$PaymentTypesDaoMixin _db;
  PaymentTypesDaoManager(this._db);
  $$PaymentTypesTableTableManager get paymentTypes =>
      $$PaymentTypesTableTableManager(_db.attachedDatabase, _db.paymentTypes);
}
