// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_dao.dart';

// ignore_for_file: type=lint
mixin _$DebtsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SalesTable get sales => attachedDatabase.sales;
  $PaymentTypesTable get paymentTypes => attachedDatabase.paymentTypes;
  $SalePaymentsTable get salePayments => attachedDatabase.salePayments;
  $DebtsTable get debts => attachedDatabase.debts;
  DebtsDaoManager get managers => DebtsDaoManager(this);
}

class DebtsDaoManager {
  final _$DebtsDaoMixin _db;
  DebtsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db.attachedDatabase, _db.sales);
  $$PaymentTypesTableTableManager get paymentTypes =>
      $$PaymentTypesTableTableManager(_db.attachedDatabase, _db.paymentTypes);
  $$SalePaymentsTableTableManager get salePayments =>
      $$SalePaymentsTableTableManager(_db.attachedDatabase, _db.salePayments);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db.attachedDatabase, _db.debts);
}
