import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Enums
import './enums/locations_enum.dart';
import './enums/payment_types_enum.dart';
import './enums/sale_status_enum.dart';
import './enums/user_roles_enum.dart';

// Tables
import './tables/sale_items_table.dart';
import './tables/item_categories_table.dart';
import './tables/items_table.dart';
import './tables/category_colors_table.dart';
import './tables/payment_types_table.dart';
import './tables/procurement_items_table.dart';
import './tables/procurements_table.dart';
import './tables/sale_payments_table.dart';
import './tables/sales_table.dart';
import './tables/stocks_table.dart';
import './tables/transfers_table.dart';
import './tables/units_table.dart';
import './tables/expenses_table.dart';
import './tables/expense_categories_table.dart';
import './tables/users_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CategoryColors,
    ExpenseCategories,
    Expenses,
    ItemCategories,
    Items,
    PaymentTypes,
    ProcurementItems,
    Procurements,
    SalePayments,
    SaleItems,
    Sales,
    Stocks,
    Transfers,
    Units,
    Users,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));

    // if (kDebugMode) {
    //   await deleteDatabaseFile(file);
    // }

    return NativeDatabase(file);
  });
}

Future<void> deleteDatabaseFile(File file) async {
  await file.delete();
}
