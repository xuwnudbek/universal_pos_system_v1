import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

// Tables
import 'tables/cart_items_table.dart';
import 'tables/carts_table.dart';
import 'tables/item_categories_table.dart';
import 'tables/items_table.dart';
import 'tables/category_colors_table.dart';
import 'tables/procurement_items_table.dart';
import 'tables/procurements_table.dart';
import 'tables/sale_histories_table.dart';
import 'tables/stocks_table.dart';
import 'tables/transfers_table.dart';
import 'tables/units_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Items,
    ItemCategories,
    CartItems,
    Carts,
    SaleHistories,
    CategoryColors,
    Units,
    Stocks,
    Transfers,
    Procurements,
    ProcurementItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
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
